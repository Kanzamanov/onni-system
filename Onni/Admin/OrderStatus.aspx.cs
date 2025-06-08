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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["breadCrum"] = "Статус заказов";
                if (Session["Admin"] == null)
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

                ddlOrderStatus.SelectedValue = dt.Rows[0]["Status"].ToString();
                hdnOrderItemId.Value = dt.Rows[0]["OrderItemId"].ToString(); 

                pUpdateOrderStatus.Visible = true;

                LinkButton btn = e.Item.FindControl("lnkEdit") as LinkButton;
                btn.CssClass = "badge badge-warning";
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int orderItemId = Convert.ToInt32(hdnOrderItemId.Value); 
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Invoice", con);
            cmd.Parameters.AddWithValue("@Action", "UPDTSTATUS");
            cmd.Parameters.AddWithValue("@OrderItemId", orderItemId);
            cmd.Parameters.AddWithValue("@Status", ddlOrderStatus.SelectedValue);
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