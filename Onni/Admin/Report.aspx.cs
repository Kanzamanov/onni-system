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
    public partial class Report : System.Web.UI.Page
    {
        // Глобальные объекты ADO.NET
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        // Загрузка страницы
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Устанавливаем хлебную крошку для навигации
                Session["breadCrum"] = "Отчёт о продажах";

                // Только для авторизованных менеджеров
                if (Session["Manager"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
            }
        }

        // Метод загрузки данных отчёта по выбранным датам
        private void getReportData(DateTime fromDate, DateTime toDate)
        {
            decimal grandTotal = 0m; // Общая сумма продаж

            // Подключение и выполнение хранимой процедуры SellingReport
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            using (SqlCommand cmd = new SqlCommand("SellingReport", con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FromDate", fromDate);
                cmd.Parameters.AddWithValue("@ToDate", toDate);

                DataTable dt = new DataTable();
                da.Fill(dt); // Загружаем данные в таблицу

                if (dt.Rows.Count > 0)
                {
                    // Считаем общую сумму продаж по колонке LineTotal
                    grandTotal = dt.AsEnumerable()
                                   .Sum(r => r.Field<decimal>("LineTotal"));

                    // Отображаем общую сумму
                    lblTotal.Text = $"Общая сумма продаж: {grandTotal:n2} сом";
                    lblTotal.CssClass = "badge badge-primary";
                }
                else
                {
                    // Если продаж нет в выбранный период
                    lblTotal.Text = "За выбранный период продаж нет.";
                    lblTotal.CssClass = "badge badge-warning";
                }

                // Привязываем результат к Repeater'у
                rReport.DataSource = dt;
                rReport.DataBind();
            }
        }

        // Обработка кнопки "Поиск"
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // Преобразуем даты из текстовых полей
            DateTime fromDate = Convert.ToDateTime(txtFromDate.Text);
            DateTime toDate = Convert.ToDateTime(txtToDate.Text);

            // Проверка на корректность периода
            if (toDate > DateTime.Now)
            {
                // Дата "по" не может быть в будущем
                Response.Write("<script>alert('Дата «по» не может быть позже текущей даты!');</script>");
            }
            else if (fromDate > toDate)
            {
                // Дата "с" не может быть позже "по"
                Response.Write("<script>alert('Дата «с» не может быть позже даты «по»!');</script>");
            }
            else
            {
                // Загружаем данные отчёта
                getReportData(fromDate, toDate);
            }
        }

    }
}
