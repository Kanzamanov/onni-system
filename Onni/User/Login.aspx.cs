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
    public partial class Login : System.Web.UI.Page
    {
        // Объекты для работы с базой данных
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        // Хэш-функция SHA-256 для безопасного хранения паролей
        private string GetHash(string input)
        {
            using (var sha = System.Security.Cryptography.SHA256.Create())
            {
                var bytes = System.Text.Encoding.UTF8.GetBytes(input);
                var hash = sha.ComputeHash(bytes);
                return BitConverter.ToString(hash).Replace("-", "").ToLower(); // преобразуем в hex-строку
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Если пользователь уже вошёл, перенаправляем на главную страницу
            if (Session["userId"] != null)
            {
                Response.Redirect("Default.aspx");
            }
        }

        // Обработчик кнопки входа
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // Простейшая «бэкдор»-проверка для менеджера (админ-панель)
            if (txtUsername.Text.Trim() == "Manager" && txtPassword.Text.Trim() == "2025")
            {
                Session["Manager"] = txtUsername.Text.Trim();
                Response.Redirect("../Admin/Dashboard.aspx");
                return; // выходим, не проверяя БД
            }

            // Подготовка запроса к хранимой процедуре для обычных пользователей
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("User_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "SELECT4LOGIN");
            cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
            cmd.Parameters.AddWithValue("@Password", GetHash(txtPassword.Text.Trim())); // передаём хэш пароля
            cmd.CommandType = CommandType.StoredProcedure;

            // Получаем результат
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            if (dt.Rows.Count == 1) // найден ровно один пользователь
            {
                bool isBlocked = Convert.ToBoolean(dt.Rows[0]["IsBlocked"]); // флаг блокировки
                if (isBlocked)
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Ваш аккаунт заблокирован или удален.";
                    lblMsg.CssClass = "alert alert-danger";
                }
                else
                {
                    // Сохраняем данные пользователя в сессии
                    Session["username"] = txtUsername.Text.Trim();
                    Session["userId"] = dt.Rows[0]["UserId"];
                    Response.Redirect("Default.aspx");
                }
            }
            else
            {
                // Неверные учётные данные
                lblMsg.Visible = true;
                lblMsg.Text = "Неверный логин или пароль.";
                lblMsg.CssClass = "alert alert-danger";
            }
        }
    }
}
