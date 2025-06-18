using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Onni.User
{
    public partial class Payment : System.Web.UI.Page
    {
        // Объявление полей для подключения к БД и транзакций
        SqlConnection con;
        SqlCommand cmd;
        SqlDataReader dr, dr1;
        DataTable dt;
        SqlTransaction transaction;

        // Метод, вызываемый при загрузке страницы
        protected void Page_Load(object sender, EventArgs e)
        {
            // Проверка авторизации пользователя
            if (!IsPostBack && Session["userId"] == null)
                Response.Redirect("Login.aspx");

            // Отображение общей суммы заказа из сессии
            ltGrandTotal.Text = Session["grandTotalPrice"]?.ToString() ?? "0";
        }

        // Обработчик кнопки "Оплатить картой"
        protected void lbCardSubmit_Click(object sender, EventArgs e)
        {
            // Вызов метода оплаты с заполненными параметрами карты
            OrderPayment(
                name: txtName.Text.Trim(),
                cardNo: txtCardNo.Text.Trim(),
                expiryDate: txtExpMonth.Text.Trim() + "/" + txtExpYear.Text.Trim(),
                cvv: txtCvv.Text.Trim(),
                address: txtAddress.Text.Trim(),
                paymentMode: "card"
            );
        }

        // Обработчик кнопки "Оплата при получении"
        protected void lbCodSubmit_Click(object sender, EventArgs e)
        {
            // Вызов метода оплаты наложенным платежом (без карты)
            OrderPayment(
                name: null,
                cardNo: null,
                expiryDate: null,
                cvv: null,
                address: txtCODAddress.Text.Trim(),
                paymentMode: "cod"
            );
        }

        // Главный метод оплаты заказа (общий для карты и наложенного платежа)
        void OrderPayment(string name, string cardNo, string expiryDate,
                          string cvv, string address, string paymentMode)
        {
            // Проверка: если сессия утеряна, перенаправляем
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Валидация CVV и номера карты при оплате картой
            int? cvvInt = null;
            if (paymentMode == "card")
            {
                if (!int.TryParse(cvv, out int cvvParsed))
                { ShowError("CVV должен быть числом."); return; }

                if (cardNo.Length < 16)
                { ShowError("Номер карты должен содержать 16 цифр."); return; }

                cvvInt = cvvParsed;
                cardNo = "************" + cardNo.Substring(12, 4); // маскировка номера карты
            }
            else
            {
                // Если оплата не картой — очищаем поля карты
                name = null;
                cardNo = null;
                expiryDate = null;
                cvvInt = null;
            }

            // Создаём таблицу для хранения товаров из корзины
            dt = new DataTable();
            dt.Columns.Add("ProductId", typeof(int));
            dt.Columns.Add("Quantity", typeof(int));
            dt.Columns.Add("PriceAtPurchase", typeof(decimal));
            dt.Columns.Add("Status", typeof(string));

            // Открываем подключение и начинаем транзакцию
            con = new SqlConnection(Connection.GetConnectionString());
            con.Open();
            transaction = con.BeginTransaction();

            try
            {
                // Сохраняем данные оплаты (в таблицу Payment)
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
                int paymentId = Convert.ToInt32(cmd.Parameters["@InsertedId"].Value); // ID оплаты

                if (paymentId == 0)
                {
                    transaction.Rollback();
                    ShowError("PaymentId не получен.");
                    return;
                }

                // Получение товаров из корзины
                cmd = new SqlCommand("Cart_Crud", con, transaction)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@Action", "SELECT");
                cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
                dr = cmd.ExecuteReader();

                // Для каждого товара:
                while (dr.Read())
                {
                    int productId = (int)dr["ProductId"];
                    int quantity = (int)dr["Quantity"];
                    var price = (decimal)dr["Price"];

                    // Обновляем остаток
                    UpdateQuantity(productId, quantity, transaction, con);

                    // Удаляем товар из корзины
                    DeleteCartItem(productId, transaction, con);

                    // Добавляем в таблицу заказанных товаров
                    dt.Rows.Add(productId, quantity, price, "Pending");
                }
                dr.Close();

                if (dt.Rows.Count > 0)
                {
                    // Сохраняем заказ (в таблицу Orders и OrderItem)
                    cmd = new SqlCommand("Save_Orders", con, transaction)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    string orderNo = Guid.NewGuid().ToString("N").Substring(0, 12); // генерируем номер заказа

                    cmd.Parameters.AddWithValue("@OrderNo", orderNo);
                    cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
                    cmd.Parameters.AddWithValue("@PaymentId", paymentId);
                    cmd.Parameters.AddWithValue("@OrderDate", DateTime.Now);

                    var tvp = cmd.Parameters.AddWithValue("@tblOrderItems", dt);
                    tvp.SqlDbType = SqlDbType.Structured;
                    tvp.TypeName = "OrderItemType"; // это тип таблицы в SQL Server

                    cmd.ExecuteNonQuery();
                }

                // Подтверждаем транзакцию
                transaction.Commit();

                // Переход на страницу чека (Invoice.aspx?id=...)
                Response.Redirect("Invoice.aspx?id=" + paymentId);
            }
            catch (Exception ex)
            {
                try { transaction.Rollback(); } catch { }
                ShowError(ex.Message); // отображение ошибки
            }
            finally { con.Close(); }
        }

        // Обновляет количество товара на складе
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

        // Удаляет товар из корзины
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

        // Метод отображения ошибок на странице
        void ShowError(string text)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Ошибка: " + text;
            lblMsg.CssClass = "alert alert-danger";
        }
    }
}
