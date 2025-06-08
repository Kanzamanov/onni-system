using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Onni.User
{
    public partial class Profile : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userId"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                else
                {
                    getUserDetails();
                    getPurchaseHistory();
                }
            }
        }
        void getUserDetails()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("User_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "SELECT4PROFILE");
            cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            rUserProfile.DataSource = dt;
            rUserProfile.DataBind();
            if (dt.Rows.Count == 1)
            {
                Session["name"] = dt.Rows[0]["Name"].ToString();
                Session["email"] = dt.Rows[0]["Email"].ToString();
                Session["createdDate"] = dt.Rows[0]["CreatedDate"].ToString();
            }
        }

        void getPurchaseHistory()
        {
            int sr = 1;
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Invoice", con);
            cmd.Parameters.AddWithValue("@Action", "ORDHISTORY");
            cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            dt.Columns.Add("SrNo", typeof(Int32));
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dataRow in dt.Rows)
                {
                    dataRow["SrNo"] = sr;
                    sr++;
                }
            }
            if (dt.Rows.Count == 0)
            {
                rPurchaseHistory.FooterTemplate = null;
                rPurchaseHistory.FooterTemplate = new CustomTemplate(ListItemType.Footer);
            }
            rPurchaseHistory.DataSource = dt;
            rPurchaseHistory.DataBind();
        }
        protected void rPurchaseHistory_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField paymentId = e.Item.FindControl("hdnPaymentId") as HiddenField;
                Repeater repOrders = e.Item.FindControl("rOrders") as Repeater;

                con = new SqlConnection(Connection.GetConnectionString());
                cmd = new SqlCommand("Invoice", con);
                cmd.Parameters.AddWithValue("@Action", "INVOICBYID");
                cmd.Parameters.AddWithValue("@PaymentId", Convert.ToInt32(paymentId.Value));
                cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
                cmd.CommandType = CommandType.StoredProcedure;

                sda = new SqlDataAdapter(cmd);
                dt = new DataTable();
                sda.Fill(dt);

                repOrders.DataSource = dt;
                repOrders.DataBind();
            }
        }

        protected void btnDeactivate_Click(object sender, EventArgs e)
        {
            if (Session["userId"] == null) return;

            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            using (SqlCommand cmd = new SqlCommand(
                @"UPDATE Users SET IsBlocked = 1 WHERE UserId = @id", con))
            {
                cmd.Parameters.AddWithValue("@id", Session["userId"]);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            // разрываем сессию и уводим на заглушку
            Session.Abandon();
            Response.Redirect("Goodbye.aspx");   // простая страница «Аккаунт удалён»
        }

        protected void rOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "cancel")
            {
                int orderItemId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
                using (SqlCommand cmd = new SqlCommand("Invoice", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Action", "CANCEL");
                    cmd.Parameters.AddWithValue("@OrderItemId", orderItemId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                // перерисовать историю
                getPurchaseHistory();
            }
        }

        // Custom template class to add controls to the repeater's header, item and footer sections.
        private sealed class CustomTemplate : ITemplate
        {
            private ListItemType ListItemType { get; set; }

            public CustomTemplate(ListItemType type)
            {
                ListItemType = type;
            }

            public void InstantiateIn(Control container)
            {
                if (ListItemType == ListItemType.Footer)
                {
                    var footer = new LiteralControl("<tr><td><b>Пока что у вас нет покупок.</b> <a href='Catalog.aspx' class='badge badge-info ml-2'>Посмотреть каталог</a></td></tr></tbody></table>");
                    container.Controls.Add(footer);
                }
            }
        }
    }
}