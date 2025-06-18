using System;
using System.Web;
using System.Data.SqlClient;
using System.Data;

namespace Onni.User
{
    // UserHandler — HTTP-обработчик (обычный .ashx)
    // Используется для фоновых AJAX-запросов
    public class UserHandler : IHttpHandler
    {
        // Главный метод: обрабатывает входящий HTTP-запрос
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain"; // ответ — простой текст

            // Получаем параметры из запроса (например, из AJAX)
            string action = context.Request["Action"];
            string username = context.Request["Username"];
            string password = context.Request["Password"];

            // Проверка входа по логину и паролю
            if (action == "SELECT4LOGIN")
            {
                try
                {
                    // Подключение к базе данных и вызов процедуры
                    using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
                    using (SqlCommand cmd = new SqlCommand("User_Crud", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@Action", "SELECT4LOGIN");
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Password", password); // предполагается, что уже захеширован

                        con.Open();
                        SqlDataReader rdr = cmd.ExecuteReader();

                        // Если есть хотя бы одна строка — вход успешен
                        if (rdr.HasRows)
                            context.Response.Write("OK");
                        else
                            context.Response.Write("FAIL");
                    }
                }
                catch (Exception ex)
                {
                    // Если ошибка — возвращаем текст ошибки
                    context.Response.Write("ERROR: " + ex.Message);
                }
            }
            else
            {
                // Если запрос с неизвестным действием
                context.Response.Write("Invalid action");
            }
        }

        // Указывает, можно ли переиспользовать этот обработчик
        public bool IsReusable => false;
    }
}
