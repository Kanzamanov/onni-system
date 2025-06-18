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
        // Поля для работы с базой
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;
       
        // 1. Загрузка страницы профиля     
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Проверяем авторизацию
                if (Session["userId"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                else
                {
                    // Загружаем данные пользователя и историю покупок
                    getUserDetails();
                    getPurchaseHistory();
                }
            }
        }

        // 2. Детали пользователя (шапка профиля)
        //    SELECT4PROFILE   ➜  процедура User_Crud
        void getUserDetails()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("User_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "SELECT4PROFILE");   // действие
            cmd.Parameters.AddWithValue("@UserId", Session["userId"]);  // текущий пользователь
            cmd.CommandType = CommandType.StoredProcedure;

            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            // Привязываем Repeater rUserProfile
            rUserProfile.DataSource = dt;
            rUserProfile.DataBind();

            // Сохраняем полезные данные в сессию
            if (dt.Rows.Count == 1)
            {
                Session["name"] = dt.Rows[0]["Name"].ToString();
                Session["email"] = dt.Rows[0]["Email"].ToString();
                Session["createdDate"] = dt.Rows[0]["CreatedDate"].ToString();
            }
        }

        // 3. История покупок (список платежей + заказов внутри каждого)
        //    ORDHISTORY  ➜  процедура Invoice
        void getPurchaseHistory()
        {
            int sr = 1;      // счётчик «№»
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Invoice", con);
            cmd.Parameters.AddWithValue("@Action", "ORDHISTORY");
            cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
            cmd.CommandType = CommandType.StoredProcedure;

            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            // Добавляем колонку «SrNo», чтобы вывести порядковый номер
            dt.Columns.Add("SrNo", typeof(Int32));
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dataRow in dt.Rows)
                    dataRow["SrNo"] = sr++;
            }

            // Если покупок нет — показываем кастомный футер
            if (dt.Rows.Count == 0)
            {
                rPurchaseHistory.FooterTemplate = null;
                rPurchaseHistory.FooterTemplate = new CustomTemplate(ListItemType.Footer);
            }

            rPurchaseHistory.DataSource = dt;
            rPurchaseHistory.DataBind();
        }

        // 4. Вложенный Repeater rOrders внутри rPurchaseHistory
        //    Подгружаем товары конкретного платежа (INVOICBYID)
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

        // 5. Кнопка «Деактивировать аккаунт»
        //    Ставит флаг IsBlocked=1 и завершает сессию
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

            // Завершаем сессию и перенаправляем на страницу-подтверждение
            Session.Abandon();
            Response.Redirect("Goodbye.aspx");
        }

        // 6. Команда Repeater'а «Отменить» (кнопка Cancel в заказах)
        //    Вызывает процедуру Invoice с действием CANCEL
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

                // Перерисовываем историю после отмены
                getPurchaseHistory();
            }
        }

        // 7. CustomTemplate — вставка футера «Нет покупок»
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
                    var footer = new LiteralControl(
                        "<tr><td><b>Пока что у вас нет покупок.</b> " +
                        "<a href='Catalog.aspx' class='badge badge-info ml-2'>Посмотреть каталог</a></td></tr></tbody></table>");
                    container.Controls.Add(footer);
                }
            }
        }
    }
}
