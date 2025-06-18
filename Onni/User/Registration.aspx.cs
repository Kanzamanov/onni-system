using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace Onni.User
{
    public partial class Registration : System.Web.UI.Page
    {
        // Поля для работы с БД
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        // Хэш-функция SHA-256: для безопасного хранения паролей
        private string GetHash(string input)
        {
            using (var sha = System.Security.Cryptography.SHA256.Create())
            {
                var bytes = System.Text.Encoding.UTF8.GetBytes(input);
                var hash = sha.ComputeHash(bytes);
                return BitConverter.ToString(hash).Replace("-", "").ToLower();
            }
        }

        // 1. Загрузка страницы регистрации / редактирования
        protected void Page_Load(object sender, EventArgs e)
        {
            int userId;
            int.TryParse(Request.QueryString["id"], out userId); // 0, если не передан

            // Включаем RequiredFieldValidator для пароля ТОЛЬКО при регистрации
            rfvPassword.Enabled = (userId == 0);

            if (!IsPostBack)
            {
                if (userId > 0)          // режим «Редактировать профиль»
                    getUserDetails();
                else if (Session["userId"] != null) // если уже залогинен — в обход
                    Response.Redirect("Default.aspx");
            }
        }

        // 2. Кнопка «Зарегистрироваться / Обновить»
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string actionName = string.Empty;
            string phone = "+996" + txtPhoneNumber.Text.Trim(); // стандартизируем номер
            int userId = 0;
            int.TryParse(Request.QueryString["id"], out userId);

            // При редактировании: если пароль пустой — не требуем и не изменяем
            if (userId > 0 && string.IsNullOrWhiteSpace(txtPassword.Text))
                rfvPassword.Enabled = false;

            if (!Page.IsValid) return; // клиентская + серверная валидация

            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("User_Crud", con)
            {
                CommandType = CommandType.StoredProcedure
            };

            // INSERT для новой учётки, UPDATE — для существующей
            cmd.Parameters.AddWithValue("@Action", userId == 0 ? "INSERT" : "UPDATE");
            cmd.Parameters.AddWithValue("@UserId", userId);
            cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
            cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
            cmd.Parameters.Add("@PhoneNumber", SqlDbType.NVarChar, 13).Value = phone;
            cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
            cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());

            // Хэшируем пароль, если он введён, иначе оставляем прежний
            if (string.IsNullOrWhiteSpace(txtPassword.Text) && userId > 0)
                cmd.Parameters.AddWithValue("@Password", DBNull.Value);
            else
                cmd.Parameters.AddWithValue("@Password", GetHash(txtPassword.Text.Trim()));

            try
            {
                con.Open();
                cmd.ExecuteNonQuery();

                // Сообщение об успехе
                actionName = userId == 0
                    ? "регистрация прошла успешно! <b><a href='Login.aspx'>Кликните сюда</a></b> чтобы войти"
                    : "данные успешно обновлены! <b><a href='Profile.aspx'>Просмотреть профиль</a></b>";

                lblMsg.Visible = true;
                lblMsg.Text = "<b>" + txtUsername.Text.Trim() + "</b> " + actionName;
                lblMsg.CssClass = "alert alert-success";

                // Автоматический редирект после обновления профиля
                if (userId != 0)
                    Response.AddHeader("REFRESH", "1;URL=Profile.aspx");

                clear(); // очистка формы
            }
            catch (SqlException ex) // ловим нарушения уникальности
            {
                if (ex.Message.Contains("Логин"))
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Пользователь с таким логином уже существует.";
                    lblMsg.CssClass = "alert alert-danger";
                }
                else if (ex.Message.Contains("Email"))
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Пользователь с таким Email уже существует.";
                    lblMsg.CssClass = "alert alert-danger";
                }
                else
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Ошибка базы данных: " + ex.Message;
                    lblMsg.CssClass = "alert alert-danger";
                }
            }
            catch (Exception ex) // общий обработчик
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Ошибка: " + ex.Message;
                lblMsg.CssClass = "alert alert-danger";
            }
            finally
            {
                con.Close();
            }
        }

        // 3. Загрузка данных юзера
        void getUserDetails()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("User_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "SELECT4PROFILE");
            cmd.Parameters.AddWithValue("@UserId", Request.QueryString["id"]);
            cmd.CommandType = CommandType.StoredProcedure;

            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                // Заполняем поля формы
                txtName.Text = dt.Rows[0]["Name"].ToString();
                txtUsername.Text = dt.Rows[0]["Username"].ToString();
                txtPhoneNumber.Text = dt.Rows[0]["PhoneNumber"].ToString().Replace("+996", "");
                txtEmail.Text = dt.Rows[0]["Email"].ToString();
                txtAddress.Text = dt.Rows[0]["Address"].ToString();

                // Подготовка поля пароля (опционно изменить)
                txtPassword.TextMode = TextBoxMode.Password;
                txtPassword.ReadOnly = false;
                txtPassword.Text = string.Empty;
                txtPassword.Attributes["placeholder"] = "Оставьте пустым, если не хотите менять пароль";

                lblHeaderMsg.Text = "<h2>Редактировать Профиль</h2>";
                btnRegister.Text = "Обновить";
                lblAlreadyUser.Text = "";
            }
        }

        // 4. Очистка формы
        private void clear()
        {
            txtName.Text = string.Empty;
            txtUsername.Text = string.Empty;
            txtPhoneNumber.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtAddress.Text = string.Empty;
            txtPassword.Text = string.Empty;
        }
    }
}
