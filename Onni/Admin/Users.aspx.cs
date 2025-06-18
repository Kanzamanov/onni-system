using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Onni.Admin
{
    public partial class Users : System.Web.UI.Page
    {
        // ↳ Глобальные объекты ADO.NET (принадлежат странице)
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        // ЗАГРУЗКА СТРАНИЦЫ
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Хлебная крошка навигации
                Session["breadCrum"] = "Пользователи";

                // Доступ разрешён только авторизованному менеджеру
                if (Session["Manager"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
                else
                {
                    // Загружаем список пользователей
                    getUsers();
                }
            }
        }

        // ЧТЕНИЕ ПОЛЬЗОВАТЕЛЕЙ 
        private void getUsers()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("User_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "SELECT4ADMIN");   // отдельное действие для админ-панели
            cmd.CommandType = CommandType.StoredProcedure;

            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);                         // получаем DataTable из БД

            rUsers.DataSource = dt;               // привязываем к Repeater
            rUsers.DataBind();
        }

        // КОМАНДЫ REPEATER’а (блокировка/разблокировка)
        protected void rUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "toggleblock")   // кнопка «Заблокировать/Разблокировать»
            {
                con = new SqlConnection(Connection.GetConnectionString());
                cmd = new SqlCommand("User_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "BLOCKTOGGLE"); // переключатель блокировки
                cmd.Parameters.AddWithValue("@UserId", e.CommandArgument); // ID выбранного пользователя
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();        // выполняем изменение
                    lblMsg.Visible = true;
                    lblMsg.Text = "Статус блокировки обновлён!";
                    lblMsg.CssClass = "alert alert-info";

                    // Перезагружаем список для актуального состояния
                    getUsers();
                }
                catch (Exception ex)
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
        }
    }
}
