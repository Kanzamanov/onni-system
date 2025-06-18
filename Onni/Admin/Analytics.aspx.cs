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
                Session["breadCrum"] = "Аналитика";

                if (Session["Manager"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                    return;              
                }

            }
            lblMsg.Visible = false;
        }

        // ▼ Заполняем отчёт
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
                    cmd.Parameters.AddWithValue("@Action", action);

                    bool needTop = action == "TOP_SELL" || action == "LEASTSELL" || action == "TOP_CUSTOMERS";
                    cmd.Parameters.Add("@Limit", SqlDbType.Int).Value = needTop ? 5 : (object)DBNull.Value;

                    DataTable dt = new DataTable();
                    new SqlDataAdapter(cmd).Fill(dt);

                    gvReport.Columns.Clear();

                    if (dt.Rows.Count > 0)
                    {
                        foreach (DataColumn col in dt.Columns)
                        {
                            string colNameLower = col.ColumnName.ToLower();

                            // скрываем ID, Status, IsActive
                            if (colNameLower.EndsWith("id") || colNameLower == "status" || colNameLower == "isactive")
                                continue;

                            BoundField bf = new BoundField
                            {
                                DataField = col.ColumnName,
                                HeaderText = TranslateHeader(col.ColumnName)
                            };
                            bf.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
                            bf.ItemStyle.HorizontalAlign = HorizontalAlign.Center;

                            // Формат денег
                            if (colNameLower == "totalrevenue" || colNameLower == "revenue" || colNameLower == "totalspent")
                                bf.DataFormatString = "{0:N2}";

                            gvReport.Columns.Add(bf);
                        }

                        gvReport.DataSource = dt;
                        gvReport.DataBind();
                    }
                    else
                    {
                        gvReport.DataSource = null;
                        gvReport.DataBind();
                    }

                    lblMsg.Visible = dt.Rows.Count == 0;
                    lblMsg.Text = dt.Rows.Count == 0 ? "Данных нет." : "";
                }
            }
            catch (Exception ex)
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Ошибка: " + ex.Message;
                lblMsg.CssClass = "alert alert-danger";
            }
        }

        // Перевод заголовков
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
                default: return column;
            }
        }

    }
}
