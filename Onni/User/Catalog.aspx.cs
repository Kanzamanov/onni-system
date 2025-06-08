using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Onni.User
{
    public partial class Catalog : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string keyword = Request.QueryString["search"];
                int catId = 0, brandId = 0;

                if (!string.IsNullOrEmpty(keyword))
                {
                    SearchProducts(keyword);
                }
                else if (int.TryParse(Request.QueryString["cat"], out catId) && catId > 0)
                {
                    getProductsByCategory(catId);
                }
                else if (int.TryParse(Request.QueryString["brand"], out brandId) && brandId > 0)
                {
                    getProductsByBrand(brandId);
                }
                else
                {
                    getAllProducts();
                }
            }
        }
        private void SearchProducts(string keyword)
        {
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                SqlCommand cmd = new SqlCommand("SELECT p.*, c.Name AS CategoryName " +
                    "FROM Products p INNER JOIN Categories c ON p.CategoryId = c.CategoryId " +
                    "WHERE p.IsActive = 1 AND p.Name LIKE @Keyword", con);
                cmd.Parameters.AddWithValue("@Keyword", "%" + keyword + "%");

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);

                rProducts.DataSource = dt;
                rProducts.DataBind();

                lblTitle.Text = "Результаты поиска: " + Server.HtmlEncode(keyword);
                lblBreadcrumb.Text = "Поиск";
                pnlNoData.Visible = (dt.Rows.Count == 0);
            }
        }

        private void getAllProducts()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Product_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "ACTIVEPROD");
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            rProducts.DataSource = dt;
            rProducts.DataBind();

            lblTitle.Text = "Все товары";
            lblBreadcrumb.Text = "Все товары";
            pnlNoData.Visible = (dt.Rows.Count == 0);
        }


        private void getProductsByCategory(int categoryId)
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Product_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "BYCATEGORY");
            cmd.Parameters.AddWithValue("@CategoryId", categoryId);
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            rProducts.DataSource = dt;
            rProducts.DataBind();

            string categoryName = "";

            if (dt.Rows.Count > 0)
            {
                categoryName = dt.Rows[0]["CategoryName"].ToString();
            }
            else
            {
                // Получить имя категории отдельно, если нет товаров
                using (SqlCommand cmd2 = new SqlCommand("SELECT Name FROM Categories WHERE CategoryId = @CategoryId", con))
                {
                    cmd2.Parameters.AddWithValue("@CategoryId", categoryId);
                    con.Open();
                    object result = cmd2.ExecuteScalar();
                    if (result != null)
                        categoryName = result.ToString();
                    else
                        categoryName = "Категория";
                    con.Close();
                }
            }

            lblTitle.Text = categoryName;
            lblBreadcrumb.Text = categoryName;
            pnlNoData.Visible = (dt.Rows.Count == 0);

        }


        private void getProductsByBrand(int brandId)
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Product_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "BYBRAND");
            cmd.Parameters.AddWithValue("@BrandId", brandId);
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            rProducts.DataSource = dt;
            rProducts.DataBind();

            string brandName = "";

            // если есть товары — берём имя бренда из первого товара
            if (dt.Rows.Count > 0)
            {
                brandName = dt.Rows[0]["BrandName"].ToString();
            }
            else
            {
                // если нет — берём имя бренда напрямую из таблицы Brands
                using (SqlCommand cmd2 = new SqlCommand("SELECT Name FROM Brands WHERE BrandId = @BrandId", con))
                {
                    cmd2.Parameters.AddWithValue("@BrandId", brandId);
                    con.Open();
                    object result = cmd2.ExecuteScalar();
                    if (result != null)
                        brandName = result.ToString();
                    else
                        brandName = "Бренд";
                    con.Close();
                }
            }

            lblTitle.Text = brandName;
            lblBreadcrumb.Text = brandName;
            pnlNoData.Visible = (dt.Rows.Count == 0);
        }

        protected void rProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (Session["userId"] != null)
            {
                bool isCartItemUpdated = false;
                int i = isItemExistInCart(Convert.ToInt32(e.CommandArgument));
                if (i == 0)
                {
                    // Adding new item in cart
                    con = new SqlConnection(Connection.GetConnectionString());
                    cmd = new SqlCommand("Cart_Crud", con);
                    cmd.Parameters.AddWithValue("@Action", "INSERT");
                    cmd.Parameters.AddWithValue("@ProductId", e.CommandArgument);
                    cmd.Parameters.AddWithValue("@Quantity", 1);
                    cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
                    cmd.CommandType = CommandType.StoredProcedure;
                    try
                    {
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Ошибка: " + ex.Message + "');</script>");
                    }
                    finally
                    {
                        con.Close();
                    }
                }
                else
                {
                    // Adding existing item into cart
                    Utils utils = new Utils();
                    isCartItemUpdated = utils.updateCartQuantity(i + 1, Convert.ToInt32(e.CommandArgument),
                        Convert.ToInt32(Session["userId"]));
                }
                lblMsg.Visible = true;
                lblMsg.Text = "Товар успешно добавлен в корзину!";
                lblMsg.CssClass = "alert alert-success";
                Response.AddHeader("REFRESH", "1;URL=Cart.aspx");
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }
        int isItemExistInCart(int productId)
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Cart_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "GETBYID");
            cmd.Parameters.AddWithValue("@ProductId", productId);
            cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            int quantity = 0;
            if (dt.Rows.Count > 0)
            {
                quantity = Convert.ToInt32(dt.Rows[0]["Quantity"]);
            }
            return quantity;
        }
    }
}