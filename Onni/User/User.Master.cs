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
    // Мастер-страница для клиентской части
    // Отвечает за шапку, авторизацию и меню
    public partial class User : System.Web.UI.MasterPage
    {
        // Загрузка страницы MasterPage
        protected void Page_Load(object sender, EventArgs e)
        {
            // Проверка авторизации
            if (Session["userId"] != null)
            {
                lbLoginOrLogout.Text = "Выйти"; // текст ссылки меняется

                // Обновляем количество товаров в корзине
                Utils utils = new Utils();
                Session["cartCount"] = utils.cartCount(Convert.ToInt32(Session["userId"])).ToString();
            }
            else
            {
                lbLoginOrLogout.Text = "Войти";
                Session["cartCount"] = "0";
            }

            // Загружаем бренды только при первой загрузке
            if (!IsPostBack)
            {
                LoadBrandsMenu();
            }
        }

        // Обработка клика по ссылке "Войти / Выйти"
        protected void lbLoginOrLogout_Click(object sender, EventArgs e)
        {
            // Если пользователь не авторизован — перенаправляем на вход
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                // Завершаем сессию и возвращаем на вход
                Session.Abandon();
                Response.Redirect("Login.aspx");
            }
        }

        // Обработка клика по ссылке "Регистрация / Профиль"
        protected void lbRegisterOrProfile_Click(object sender, EventArgs e)
        {
            if (Session["userId"] != null)
            {
                lbRegisterOrProfile.ToolTip = "User Profile";
                Response.Redirect("Profile.aspx");
            }
            else
            {
                lbRegisterOrProfile.ToolTip = "User Registration";
                Response.Redirect("Registration.aspx");
            }
        }

        // Загрузка списка брендов в выпадающее меню
        private void LoadBrandsMenu()
        {
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                using (SqlCommand cmd = new SqlCommand("Brand_Crud", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Action", "ACTIVEBRA"); // только активные бренды

                    SqlDataAdapter sda = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    sda.Fill(dt);

                    // Привязка к Repeater на мастере
                    rptBrandsMenu.DataSource = dt;
                    rptBrandsMenu.DataBind();
                }
            }
        }
    }
}
