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
    public partial class OrderStatus : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;
        static readonly Dictionary<string, List<string>> allowedTransitions = new Dictionary<string, List<string>>
        {
            { "Pending", new List<string> { "Dispatched", "Cancelled" } },
            { "Dispatched", new List<string> { "Delivered" } },
            { "Delivered", new List<string> { "Returned" } },
            { "Returned", new List<string>() },
            { "Cancelled", new List<string>() }
        };
        private string TranslateStatus(string status)
        {
            switch (status)
            {
                case "Pending": return "В ожидании";
                case "Dispatched": return "Отправлен";
                case "Delivered": return "Доставлен";
                case "Returned": return "Возврат";
                case "Cancelled": return "Отменён";
                default: return status;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["breadCrum"] = "Статус заказов";
                if (Session["Manager"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
                else
                {
                    getOrderStatus();
                }
            }
            lblMsg.Visible = false;
            pUpdateOrderStatus.Visible = false;
        }
        private void getOrderStatus()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Invoice", con);
            cmd.Parameters.AddWithValue("@Action", "GETSTATUS");
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            rOrderStatus.DataSource = dt;
            rOrderStatus.DataBind();

        }
        protected void rOrderStatus_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblMsg.Visible = false;

            if (e.CommandName == "edit")
            {
                con = new SqlConnection(Connection.GetConnectionString());
                cmd = new SqlCommand("Invoice", con);
                cmd.Parameters.AddWithValue("@Action", "STATUSBYID");
                cmd.Parameters.AddWithValue("@OrderItemId", e.CommandArgument);
                cmd.CommandType = CommandType.StoredProcedure;
                sda = new SqlDataAdapter(cmd);
                dt = new DataTable();
                sda.Fill(dt);

                string status = dt.Rows[0]["Status"].ToString();
                hdnOrderItemId.Value = dt.Rows[0]["OrderItemId"].ToString();

                // Проверяем, существует ли статус в выпадающем списке
                if (ddlOrderStatus.Items.FindByValue(status) != null)
                {
                    ddlOrderStatus.SelectedValue = status;
                    pUpdateOrderStatus.Visible = true;
                }
                else
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = $"Статус '{status}' не может быть изменён.";
                    lblMsg.CssClass = "alert alert-danger";
                    pUpdateOrderStatus.Visible = false;
                    return;
                }

                LinkButton btn = e.Item.FindControl("lnkEdit") as LinkButton;
                btn.CssClass = "badge badge-warning";
            }
        }


        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int orderItemId = Convert.ToInt32(hdnOrderItemId.Value);
            string newStatus = ddlOrderStatus.SelectedValue;
            string currentStatus = "";
            // Получаем текущий статус
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Invoice", con);
            cmd.Parameters.AddWithValue("@Action", "STATUSBYID");
            cmd.Parameters.AddWithValue("@OrderItemId", orderItemId);
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            if (dt.Rows.Count > 0)
            {
                currentStatus = dt.Rows[0]["Status"].ToString();
            }
            if (currentStatus == "Cancelled" || currentStatus == "Returned")
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Этот заказ уже завершён. Статус нельзя изменить.";
                lblMsg.CssClass = "alert alert-warning";
                return;
            }

            // Проверяем допустимость перехода
            if (!allowedTransitions.ContainsKey(currentStatus) ||
                !allowedTransitions[currentStatus].Contains(newStatus))
            {
                lblMsg.Visible = true;
                lblMsg.Text = $"Нельзя изменить статус с «{TranslateStatus(currentStatus)}» на «{TranslateStatus(newStatus)}».";
                lblMsg.CssClass = "alert alert-danger";
                return;
            }

            // Обновляем статус
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Invoice", con);
            cmd.Parameters.AddWithValue("@Action", "UPDTSTATUS");
            cmd.Parameters.AddWithValue("@OrderItemId", orderItemId);
            cmd.Parameters.AddWithValue("@Status", newStatus);
            cmd.CommandType = CommandType.StoredProcedure;

            try
            {
                con.Open();
                cmd.ExecuteNonQuery();
                lblMsg.Visible = true;
                lblMsg.Text = "Статус заказа успешно обновлён!";
                lblMsg.CssClass = "alert alert-success";
                getOrderStatus();
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
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pUpdateOrderStatus.Visible = false;
        }
    }
}