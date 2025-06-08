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
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["breadCrum"] = "Отчёт о продажах";
                if (Session["Manager"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
            }
        }
        private void getReportData(DateTime fromDate, DateTime toDate)
        {
            decimal grandTotal = 0m;

            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            using (SqlCommand cmd = new SqlCommand("SellingReport", con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FromDate", fromDate);
                cmd.Parameters.AddWithValue("@ToDate", toDate);

                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    grandTotal = dt.AsEnumerable()
                                   .Sum(r => r.Field<decimal>("LineTotal"));

                    lblTotal.Text = $"Общая сумма продаж: {grandTotal:n2} сом";
                    lblTotal.CssClass = "badge badge-primary";
                }
                else
                {
                    lblTotal.Text = "За выбранный период продаж нет.";
                    lblTotal.CssClass = "badge badge-warning";
                }

                rReport.DataSource = dt;
                rReport.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            DateTime fromDate = Convert.ToDateTime(txtFromDate.Text);
            DateTime toDate = Convert.ToDateTime(txtToDate.Text);

            if (toDate > DateTime.Now)
            {
                Response.Write("<script>alert('Дата «по» не может быть позже текущей даты!');</script>");
            }
            else if (fromDate > toDate)
            {
                Response.Write("<script>alert('Дата «с» не может быть позже даты «по»!');</script>");
            }
            else
            {
                getReportData(fromDate, toDate);
            }
        }

    }
}