using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Onni.User
{
    public partial class Contact : System.Web.UI.Page
    {
        // Объекты ADO.NET
        SqlConnection con;
        SqlCommand cmd;

        //  ЗАГРУЗКА СТРАНИЦЫ 
        protected void Page_Load(object sender, EventArgs e)
        {
            // Здесь ничего не выполняем — форма проста:
            // пользователь заполняет поля и нажимает «Отправить».
        }

        //  ОБРАБОТКА КНОПКИ «ОТПРАВИТЬ» 
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                // 1. Подготовка подключения к базе
                con = new SqlConnection(Connection.GetConnectionString());

                // 2. Настройка вызова хранимой процедуры ContactSp
                cmd = new SqlCommand("ContactSp", con);
                cmd.CommandType = CommandType.StoredProcedure;

                // 3. Передаём параметры: действие + данные из формы
                cmd.Parameters.AddWithValue("@Action", "INSERT");            // Тип операции
                cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim()); // Имя
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());// Email
                cmd.Parameters.AddWithValue("@Subject", txtSubject.Text.Trim());// Тема
                cmd.Parameters.AddWithValue("@Message", txtMessage.Text.Trim());// Сообщение

                // 4. Выполняем запрос
                con.Open();
                cmd.ExecuteNonQuery();

                // 5. Показываем сообщение об успешной отправке
                lblMsg.Visible = true;
                lblMsg.Text = "Спасибо за обращение! Мы рассмотрим ваш запрос.";
                lblMsg.CssClass = "alert alert-success";

                // 6. Очищаем форму
                clear();
            }
            catch (Exception ex)
            {
                // В случае ошибки выводим alert-сообщение в браузер
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
            finally
            {
                // Гарантированно закрываем соединение
                con.Close();
            }
        }

        // ОЧИСТКА ПОЛЕЙ ФОРМЫ 
        private void clear()
        {
            txtName.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtSubject.Text = string.Empty;
            txtMessage.Text = string.Empty;
        }
    }
}
