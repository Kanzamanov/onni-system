using System;
using System.Data;
using System.Data.SqlClient;

namespace Onni.User
{
    public partial class Brands : System.Web.UI.Page
    {
        // Глобальные переменные ADO.NET
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        // Загрузка страницы
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) // только при первой загрузке
            {
                LoadBrands(); // загрузка списка брендов
            }
        }

        // Метод загрузки только активных брендов из БД
        private void LoadBrands()
        {
            con = new SqlConnection(Connection.GetConnectionString());

            // Вызываем хранимую процедуру Brand_Crud
            cmd = new SqlCommand("Brand_Crud", con);
            cmd.CommandType = CommandType.StoredProcedure;

            // Параметр: выбрать только активные бренды
            cmd.Parameters.AddWithValue("@Action", "ACTIVEBRA");

            // Выполняем запрос и заполняем таблицу
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            // Привязка к Repeater для отображения на сайте
            rptBrands.DataSource = dt;
            rptBrands.DataBind();
        }
    }
}
