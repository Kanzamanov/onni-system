using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Onni.Admin
{
    public partial class Analytics : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Устанавливаем хлебную крошку навигации
                Session["breadCrum"] = "Аналитика";

                // Проверка, авторизован ли менеджер
                if (Session["Manager"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                    return;
                }
            }

            // Скрываем сообщение при первой загрузке
            lblMsg.Visible = false;
        }

        // ▼ Обработка изменения выбранного отчёта в выпадающем списке
        protected void ddlReport_SelectedIndexChanged(object sender, EventArgs e)
        {
            string action = ddlReport.SelectedValue;
            if (string.IsNullOrEmpty(action)) return;

            try
            {
                using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
                using (SqlCommand cmd = new SqlCommand("Analytics", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Передаём выбранное действие в процедуру Analytics
                    cmd.Parameters.AddWithValue("@Action", action);

                    // Если отчёт — ТОП-продажи или ТОП-клиенты — указываем лимит
                    bool needTop = action == "TOP_SELL" || action == "LEASTSELL" || action == "TOP_CUSTOMERS";
                    cmd.Parameters.Add("@Limit", SqlDbType.Int).Value = needTop ? 5 : (object)DBNull.Value;

                    // Получаем данные из БД
                    DataTable dt = new DataTable();
                    new SqlDataAdapter(cmd).Fill(dt);

                    // Очищаем старые столбцы перед добавлением новых
                    gvReport.Columns.Clear();

                    if (dt.Rows.Count > 0)
                    {
                        // Динамически создаём столбцы для GridView на основе DataTable
                        foreach (DataColumn col in dt.Columns)
                        {
                            string colNameLower = col.ColumnName.ToLower();

                            // Пропускаем скрытые поля (ID, статус, флаги активности)
                            if (colNameLower.EndsWith("id") || colNameLower == "status" || colNameLower == "isactive")
                                continue;

                            // Создаём новый столбец
                            BoundField bf = new BoundField
                            {
                                DataField = col.ColumnName,
                                HeaderText = TranslateHeader(col.ColumnName)
                            };
                            bf.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
                            bf.ItemStyle.HorizontalAlign = HorizontalAlign.Center;

                            // Форматируем числовые значения как деньги (доход, сумма)
                            if (colNameLower == "totalrevenue" || colNameLower == "revenue" || colNameLower == "totalspent")
                                bf.DataFormatString = "{0:N2}";

                            gvReport.Columns.Add(bf);
                        }

                        // Привязываем данные к GridView
                        gvReport.DataSource = dt;
                        gvReport.DataBind();
                    }
                    else
                    {
                        // Если данных нет — очищаем таблицу
                        gvReport.DataSource = null;
                        gvReport.DataBind();
                    }

                    // Показываем сообщение, если нет данных
                    lblMsg.Visible = dt.Rows.Count == 0;
                    lblMsg.Text = dt.Rows.Count == 0 ? "Данных нет." : "";
                }
            }
            catch (Exception ex)
            {
                // Обработка исключений — показываем сообщение об ошибке
                lblMsg.Visible = true;
                lblMsg.Text = "Ошибка: " + ex.Message;
                lblMsg.CssClass = "alert alert-danger";
            }
        }

        // ▼ Перевод названий колонок из БД в понятные заголовки для таблицы
        private static string TranslateHeader(string column)
        {
            switch (column.ToLower())
            {
                case "productname": return "Товар";
                case "totalsold": return "Продано, шт";
                case "totalrevenue":
                case "revenue": return "Доход";
                case "categoryname": return "Категория";
                case "brandname": return "Бренд";
                case "period": return "Период";
                case "year": return "Год";
                case "week": return "Неделя";
                case "username": return "Покупатель";
                case "totalspent": return "Сумма покупок";
                default: return column; // по умолчанию оставляем оригинальное имя
            }
        }
    }
}
