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
    public partial class Contacts : System.Web.UI.Page
    {
        // Объекты ADO.NET для работы с БД
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        // При загрузке страницы
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) // Только при первом открытии страницы
            {
                // Устанавливаем хлебную крошку навигации
                Session["breadCrum"] = "Обращения пользователей";

                // Проверка авторизации (доступ только для менеджера)
                if (Session["Manager"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
                else
                {
                    // Загружаем список обращений
                    getContacts();
                }
            }
        }

        // Метод получения всех обращений из БД
        private void getContacts()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("ContactSp", con); // Вызываем хранимую процедуру ContactSp
            cmd.Parameters.AddWithValue("@Action", "SELECT"); // Задаём действие
            cmd.CommandType = CommandType.StoredProcedure;

            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt); // Загружаем данные в таблицу

            // Привязываем данные к Repeater для отображения
            rContacts.DataSource = dt;
            rContacts.DataBind();
        }

        // Обработка команды Repeater'а — удаление обращения
        protected void rContacts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "delete")
            {
                // Подключение и настройка команды удаления
                con = new SqlConnection(Connection.GetConnectionString());
                cmd = new SqlCommand("ContactSp", con);
                cmd.Parameters.AddWithValue("@Action", "DELETE");
                cmd.Parameters.AddWithValue("@ContactId", e.CommandArgument); // ID удаляемой записи
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery(); // Выполняем удаление

                    // Показываем сообщение об успехе
                    lblMsg.Visible = true;
                    lblMsg.Text = "Запись успешно удалена!";
                    lblMsg.CssClass = "alert alert-success";

                    // Перезагружаем список обращений
                    getContacts();
                }
                catch (Exception ex)
                {
                    // Ошибка при удалении
                    lblMsg.Visible = true;
                    lblMsg.Text = "Ошибка: " + ex.Message;
                    lblMsg.CssClass = "alert alert-danger";
                }
                finally
                {
                    con.Close(); // Закрываем соединение
                }
            }
        }
    }
}
