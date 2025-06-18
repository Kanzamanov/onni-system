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
        // При первой загрузке страницы читаем id продукта из URL
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["id"] != null)
            {
                int productId = Convert.ToInt32(Request.QueryString["id"]);
                loadProductDetails(productId);   // выводим данные о товаре
            }
        }

        // Получение информации о товаре через хранимую процедуру Product_Crud
        private void loadProductDetails(int productId)
        {
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                SqlCommand cmd = new SqlCommand("Product_Crud", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", "GETBYID");   // действие процедуры
                cmd.Parameters.AddWithValue("@ProductId", productId);

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);

                if (dt.Rows.Count > 0)   // Заполняем контролы данными из БД
                {
                    string productName = dt.Rows[0]["Name"].ToString();
                    lblProductName.Text = productName;                // заголовок карточки
                    lblProductNameBreadcrumb.Text = productName;      // хлебные крошки
                    lblPrice.Text = dt.Rows[0]["Price"].ToString();   // цена
                    lblDescription.Text = dt.Rows[0]["Description"].ToString(); // описание
                    // Получаем абсолютный путь к картинке через вспомогательный метод
                    imgProduct.ImageUrl = Utils.GetImageUrl(dt.Rows[0]["ImageUrl"]);
                }
            }
        }

        // Добавление товара в корзину (1 шт.) при клике на кнопку
        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            // Проверяем авторизацию; если её нет — отправляем на страницу логина
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int productId = Convert.ToInt32(Request.QueryString["id"]);
            int userId = Convert.ToInt32(Session["userId"]);

            // Вызов хранимой процедуры Cart_Crud с действием INSERT
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                SqlCommand cmd = new SqlCommand("Cart_Crud", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", "INSERT");
                cmd.Parameters.AddWithValue("@ProductId", productId);
                cmd.Parameters.AddWithValue("@Quantity", 1);   // всегда добавляем одну штуку
                cmd.Parameters.AddWithValue("@UserId", userId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            // Сообщаем пользователю об успехе и через 2 секунды перенаправляем в корзину
            lblMsg.Text = "Товар успешно добавлен в корзину!";
            lblMsg.Visible = true;
            Response.AddHeader("REFRESH", "2;URL=Cart.aspx");
        }
    }
}
