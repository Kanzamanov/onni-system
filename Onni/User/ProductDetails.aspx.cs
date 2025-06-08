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
    public partial class ProductDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["id"] != null)
            {
                int productId = Convert.ToInt32(Request.QueryString["id"]);
                loadProductDetails(productId);
            }
        }

        private void loadProductDetails(int productId)
        {
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                SqlCommand cmd = new SqlCommand("Product_Crud", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", "GETBYID");
                cmd.Parameters.AddWithValue("@ProductId", productId);

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    string productName = dt.Rows[0]["Name"].ToString();
                    lblProductName.Text = productName;
                    lblProductNameBreadcrumb.Text = productName;
                    lblPrice.Text = dt.Rows[0]["Price"].ToString();
                    lblDescription.Text = dt.Rows[0]["Description"].ToString();
                    imgProduct.ImageUrl = Utils.GetImageUrl(dt.Rows[0]["ImageUrl"]);
                }
            }
        }
        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int productId = Convert.ToInt32(Request.QueryString["id"]);
            int userId = Convert.ToInt32(Session["userId"]);

            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                SqlCommand cmd = new SqlCommand("Cart_Crud", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", "INSERT");
                cmd.Parameters.AddWithValue("@ProductId", productId);
                cmd.Parameters.AddWithValue("@Quantity", 1);
                cmd.Parameters.AddWithValue("@UserId", userId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMsg.Text = "Товар успешно добавлен в корзину!";
            lblMsg.Visible = true;
            Response.AddHeader("REFRESH", "2;URL=Cart.aspx");

        }

    }
}