﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Onni.User
{
    public partial class Cart : System.Web.UI.Page
    {
        // Переменные для подключения к БД и хранения данных
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;
        decimal grandTotal = 0; // общая сумма всех товаров в корзине

        // Загрузка страницы
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Если пользователь не авторизован — перенаправляем на логин
                if (Session["userId"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                else
                {
                    // Загрузка корзины из базы данных
                    getCartItems();
                }
            }
        }

        // Загрузка товаров пользователя из корзины
        void getCartItems()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Cart_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "SELECT");
            cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
            cmd.CommandType = CommandType.StoredProcedure;

            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            rCartItem.DataSource = dt;

            // Если корзина пуста — показываем специальный шаблон
            if (dt.Rows.Count == 0)
            {
                rCartItem.FooterTemplate = null;
                rCartItem.FooterTemplate = new CustomTemplate(ListItemType.Footer);
            }

            rCartItem.DataBind();
        }

        // Обработка команд в Repeater'е: удалить товар или обновить количество
        protected void rCartItem_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Utils utils = new Utils(); // Вспомогательные методы

            if (e.CommandName == "remove")
            {
                // Удаление товара из корзины
                con = new SqlConnection(Connection.GetConnectionString());
                cmd = new SqlCommand("Cart_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "DELETE");
                cmd.Parameters.AddWithValue("@ProductId", e.CommandArgument);
                cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();

                    // Обновляем отображение корзины и счётчик
                    getCartItems();
                    Session["cartCount"] = utils.cartCount(Convert.ToInt32(Session["userId"]));
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Ошибка: " + ex.Message + " ');</script>");
                }
                finally
                {
                    con.Close();
                }
            }

            if (e.CommandName == "updateCart")
            {
                // Обновление количества товаров в корзине
                for (int item = 0; item < rCartItem.Items.Count; item++)
                {
                    if (rCartItem.Items[item].ItemType == ListItemType.Item || rCartItem.Items[item].ItemType == ListItemType.AlternatingItem)
                    {
                        TextBox quantity = rCartItem.Items[item].FindControl("txtQuantity") as TextBox;
                        HiddenField _productId = rCartItem.Items[item].FindControl("hdnProductId") as HiddenField;
                        HiddenField _quantity = rCartItem.Items[item].FindControl("hdnQuantity") as HiddenField;

                        int quantityFromCart = Convert.ToInt32(quantity.Text);
                        int productId = Convert.ToInt32(_productId.Value);
                        int quantityFromDB = Convert.ToInt32(_quantity.Value);

                        if (quantityFromCart != quantityFromDB)
                        {
                            // Обновляем количество только если оно изменилось
                            utils.updateCartQuantity(quantityFromCart, productId, Convert.ToInt32(Session["userId"]));
                        }
                    }
                }
                getCartItems(); // Перезагружаем корзину
            }
        }

        // Обработка оформления заказа
        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;
            List<CartItem> cartRows = new List<CartItem>();

            // Считываем данные из Repeater
            foreach (RepeaterItem item in rCartItem.Items)
            {
                if (item.ItemType != ListItemType.Item && item.ItemType != ListItemType.AlternatingItem)
                    continue;

                int productId = int.Parse(((HiddenField)item.FindControl("hdnProductId")).Value);
                int orderQty = int.Parse(((TextBox)item.FindControl("txtQuantity")).Text);
                decimal price = decimal.Parse(((Label)item.FindControl("lblPrice")).Text);
                string name = ((Label)item.FindControl("lblName")).Text;

                cartRows.Add(new CartItem
                {
                    ProductId = productId,
                    OrderQty = orderQty,
                    Price = price,
                    Name = name
                });
            }

            // Проверка: пустая корзина
            if (cartRows.Count == 0)
            {
                lblMsg.Visible = true;
                lblMsg.Text = "В корзине нет товаров.";
                lblMsg.CssClass = "alert alert-warning";
                return;
            }

            // Получение остатков на складе
            Dictionary<int, int> stock = new Dictionary<int, int>();

            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                con.Open();
                string idList = string.Join(",", cartRows.ConvertAll(r => r.ProductId.ToString()));
                string sql = $"SELECT ProductId, Quantity FROM Products WHERE ProductId IN ({idList})";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                using (SqlDataReader rdr = cmd.ExecuteReader())
                    while (rdr.Read())
                        stock[rdr.GetInt32(0)] = rdr.GetInt32(1);
            }

            // Проверка наличия на складе
            string lackingName = null;
            foreach (CartItem r in cartRows)
            {
                int available = stock.ContainsKey(r.ProductId) ? stock[r.ProductId] : 0;
                if (r.OrderQty > available)
                {
                    lackingName = r.Name;
                    break;
                }
            }

            if (lackingName != null)
            {
                // Если товара не хватает — выводим предупреждение
                lblMsg.Visible = true;
                lblMsg.Text = $"Недостаточно товара <b>{lackingName}</b> на складе!";
                lblMsg.CssClass = "alert alert-warning";
                return;
            }

            // Подготовка данных заказа для передачи на Payment.aspx
            DataTable dtItems = new DataTable();
            dtItems.Columns.Add("ProductId", typeof(int));
            dtItems.Columns.Add("Quantity", typeof(int));
            dtItems.Columns.Add("PriceAtPurchase", typeof(decimal));
            dtItems.Columns.Add("Status", typeof(string));

            foreach (CartItem r in cartRows)
            {
                DataRow dr = dtItems.NewRow();
                dr["ProductId"] = r.ProductId;
                dr["Quantity"] = r.OrderQty;
                dr["PriceAtPurchase"] = r.Price;
                dr["Status"] = "Pending"; // по умолчанию
                dtItems.Rows.Add(dr);
            }

            // Сохраняем в сессии
            Session["orderItems"] = dtItems;
            Session["grandTotalPrice"] = cartRows.Sum(x => x.Price * x.OrderQty);
            Response.Redirect("Payment.aspx");
        }

        // Класс для представления строки корзины
        private sealed class CartItem
        {
            public int ProductId { get; set; }
            public int OrderQty { get; set; }
            public decimal Price { get; set; }
            public string Name { get; set; }
        }

        // Считаем сумму по каждой строке и общую сумму
        protected void rCartItem_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Label totalPrice = e.Item.FindControl("lblTotalPrice") as Label;
                Label productPrice = e.Item.FindControl("lblPrice") as Label;
                TextBox quantity = e.Item.FindControl("txtQuantity") as TextBox;

                decimal calTotalPrice = Convert.ToDecimal(productPrice.Text) * Convert.ToDecimal(quantity.Text);
                totalPrice.Text = calTotalPrice.ToString();
                grandTotal += calTotalPrice;
            }

            // Сохраняем итоговую сумму в сессию
            Session["grandTotalPrice"] = grandTotal;
        }

        // Кастомный шаблон футера Repeater'а, если корзина пуста
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
                    var footer = new LiteralControl("<tr><td colspan='5'><b>Ваша корзина пуста.</b><a href='Catalog.aspx' class='badge badge-info ml-2'>Продолжить покупки</a></td></tr></tbody></table>");
                    container.Controls.Add(footer);
                }
            }
        }
    }
}
