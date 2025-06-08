using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Onni.User
{
    public partial class Payment : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataReader dr, dr1;
        DataTable dt;
        SqlTransaction transaction;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["userId"] == null)
                Response.Redirect("Login.aspx");

            ltGrandTotal.Text = Session["grandTotalPrice"]?.ToString() ?? "0";
        }
        protected void lbCardSubmit_Click(object sender, EventArgs e)
        {
            OrderPayment(
                name: txtName.Text.Trim(),
                cardNo: txtCardNo.Text.Trim(),
                expiryDate: txtExpMonth.Text.Trim() + "/" + txtExpYear.Text.Trim(),
                cvv: txtCvv.Text.Trim(),
                address: txtAddress.Text.Trim(),
                paymentMode: "card"
            );
        }
        protected void lbCodSubmit_Click(object sender, EventArgs e)
        {
            OrderPayment(
                name: null,      
                cardNo: null,
                expiryDate: null,
                cvv: null,
                address: txtCODAddress.Text.Trim(),
                paymentMode: "cod"
            );
        }
        void OrderPayment(string name, string cardNo, string expiryDate,
                          string cvv, string address, string paymentMode)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }        
            int? cvvInt = null;
            if (paymentMode == "card")
            {
                if (!int.TryParse(cvv, out int cvvParsed))
                { ShowError("CVV должен быть числом."); return; }

                if (cardNo.Length < 16)
                { ShowError("Номер карты должен содержать 16 цифр."); return; }

                cvvInt = cvvParsed;
                cardNo = "************" + cardNo.Substring(12, 4);
            }
            else    
            {
                name = null;  
                cardNo = null;
                expiryDate = null;
                cvvInt = null;
            }
            dt = new DataTable();
            dt.Columns.Add("ProductId", typeof(int));
            dt.Columns.Add("Quantity", typeof(int));
            dt.Columns.Add("PriceAtPurchase", typeof(decimal));
            dt.Columns.Add("Status", typeof(string));

            con = new SqlConnection(Connection.GetConnectionString());
            con.Open();
            transaction = con.BeginTransaction();

            try
            {
                cmd = new SqlCommand("Save_Payment", con, transaction)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@Name", (object)name ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@CardNo", (object)cardNo ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@ExpiryDate", (object)expiryDate ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Cvv", (object)cvvInt ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Address", address);
                cmd.Parameters.AddWithValue("@PaymentMode", paymentMode);
                cmd.Parameters.Add("@InsertedId", SqlDbType.Int).Direction = ParameterDirection.Output;

                cmd.ExecuteNonQuery();
                int paymentId = Convert.ToInt32(cmd.Parameters["@InsertedId"].Value);

                if (paymentId == 0)
                { transaction.Rollback(); ShowError("PaymentId не получен."); return; }

                cmd = new SqlCommand("Cart_Crud", con, transaction)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@Action", "SELECT");
                cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
                dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    int productId = (int)dr["ProductId"];
                    int quantity = (int)dr["Quantity"];
                    var price = (decimal)dr["Price"];

                    UpdateQuantity(productId, quantity, transaction, con);
                    DeleteCartItem(productId, transaction, con);

                    dt.Rows.Add(productId, quantity, price, "Pending");
                }
                dr.Close();

                if (dt.Rows.Count > 0)
                {
                    cmd = new SqlCommand("Save_Orders", con, transaction)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    string orderNo = Guid.NewGuid().ToString("N").Substring(0, 12);
                    cmd.Parameters.AddWithValue("@OrderNo", orderNo);
                    cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
                    cmd.Parameters.AddWithValue("@PaymentId", paymentId);
                    cmd.Parameters.AddWithValue("@OrderDate", DateTime.Now);

                    var tvp = cmd.Parameters.AddWithValue("@tblOrderItems", dt);
                    tvp.SqlDbType = SqlDbType.Structured;
                    tvp.TypeName = "OrderItemType";

                    cmd.ExecuteNonQuery();
                }

                transaction.Commit();
                Response.Redirect("Invoice.aspx?id=" + paymentId);
            }
            catch (Exception ex)
            {
                try { transaction.Rollback(); } catch { }
                ShowError(ex.Message);
            }
            finally { con.Close(); }
        }

        void UpdateQuantity(int productId, int qtySold,
                    SqlTransaction tran, SqlConnection cn)
        {
            const string sql =
                @"UPDATE Products
          SET Quantity = Quantity - @q
          WHERE ProductId = @id  AND Quantity >= @q";

            using (SqlCommand c = new SqlCommand(sql, cn, tran))
            {
                c.Parameters.AddWithValue("@q", qtySold);
                c.Parameters.AddWithValue("@id", productId);

                int rows = c.ExecuteNonQuery();      

                if (rows == 0)
                    throw new InvalidOperationException(
                        $"Недостаточно товара (ProductId = {productId})");
            }
        }


        void DeleteCartItem(int productId,
                            SqlTransaction tr, SqlConnection cn)
        {
            cmd = new SqlCommand("Cart_Crud", cn, tr)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Action", "DELETE");
            cmd.Parameters.AddWithValue("@ProductId", productId);
            cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
            cmd.ExecuteNonQuery();
        }

        void ShowError(string text)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Ошибка: " + text;
            lblMsg.CssClass = "alert alert-danger";
        }
    }
}
