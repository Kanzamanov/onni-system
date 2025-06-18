using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

// Пространство имён для клиентской части сайта (страница по умолчанию)
namespace Onni.User
{
    public partial class Default : System.Web.UI.Page
    {
        // Метод вызывается при каждом открытии страницы
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) // Проверка: страница загружается впервые, а не после нажатия кнопки
            {
                LoadHeroCategories(); // Загрузка активных категорий для отображения на главной
            }
        }

        // Метод для получения списка активных категорий из БД
        private void LoadHeroCategories()
        {
            // Устанавливается подключение к базе данных
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                // Настройка SQL-команды на вызов хранимой процедуры
                SqlCommand cmd = new SqlCommand("Category_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "ACTIVECAT"); // Указываем действие: получить только активные категории
                cmd.CommandType = CommandType.StoredProcedure;

                // Создаём адаптер для получения результатов
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt); // Заполняем таблицу результатами запроса

                // Привязываем полученные категории к Repeater (визуальный компонент)
                rHeroCategories.DataSource = dt;
                rHeroCategories.DataBind();
            }
        }

        // Обработчик кнопки поиска
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string keyword = txtSearch.Text.Trim(); // Получаем введённый текст из поля поиска
            if (!string.IsNullOrEmpty(keyword))
            {
                // Переход на страницу каталога с передачей поискового запроса через URL
                Response.Redirect("Catalog.aspx?search=" + Server.UrlEncode(keyword));
            }
        }
    }
}
