// Пространства имён: для работы с БД, файлами, строками и ASP.NET
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Globalization;
using System.Web.Configuration;

namespace Onni.Admin
{
    public partial class Product : System.Web.UI.Page
    {
        // Глобальные объекты для подключения и работы с SQL
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        // Загрузка страницы
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Хлебная крошка
                Session["breadCrum"] = "Товары";

                // Проверка входа менеджера
                if (Session["Manager"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
                else
                {
                    // Загрузка списка товаров
                    getProducts();
                }
            }

            // Сообщение об ошибках или успехах скрыто
            lblMsg.Visible = false;
        }

        // Кнопка Добавить / Обновить / Продать товар
        protected void btnAddOrUpdate_Click(object sender, EventArgs e)
        {
            int productId = Convert.ToInt32(hdnId.Value);
            string mode = hdnMode.Value;

            // ==== Режим продажи товара через кнопку "Продать" ====
            if (mode == "SELL")
            {
                int qtyToSell = Convert.ToInt32(txtQuantity.Text.Trim());

                // Получаем текущие данные товара
                con = new SqlConnection(Connection.GetConnectionString());
                SqlCommand getCmd = new SqlCommand("Product_Crud", con);
                getCmd.Parameters.AddWithValue("@Action", "GETBYID");
                getCmd.Parameters.AddWithValue("@ProductId", productId);
                getCmd.CommandType = CommandType.StoredProcedure;
                sda = new SqlDataAdapter(getCmd);
                dt = new DataTable();
                sda.Fill(dt);

                int currentQty = Convert.ToInt32(dt.Rows[0]["Quantity"]);
                decimal unitPrice = Convert.ToDecimal(dt.Rows[0]["Price"]);

                // Проверка: нельзя продать 0 или больше, чем в наличии
                if (qtyToSell <= 0 || qtyToSell > currentQty)
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Неверное количество для продажи.";
                    lblMsg.CssClass = "alert alert-danger";
                    return;
                }

                // Готовим обновление количества и регистрацию продажи
                SqlCommand updateCmd = new SqlCommand("Product_Crud", con);
                updateCmd.Parameters.AddWithValue("@Action", "QTYUPDATE");
                updateCmd.Parameters.AddWithValue("@ProductId", productId);
                updateCmd.Parameters.AddWithValue("@Quantity", currentQty - qtyToSell);
                updateCmd.CommandType = CommandType.StoredProcedure;

                SqlTransaction tran = null;
                try
                {
                    con.Open();
                    tran = con.BeginTransaction();

                    updateCmd.Transaction = tran;
                    updateCmd.ExecuteNonQuery();

                    // Фиксируем продажу в таблице продаж (Quick_POSSale)
                    using (SqlCommand saleCmd = new SqlCommand("Quick_POSSale", con, tran))
                    {
                        saleCmd.CommandType = CommandType.StoredProcedure;
                        saleCmd.Parameters.AddWithValue("@ProductId", productId);
                        saleCmd.Parameters.AddWithValue("@Qty", qtyToSell);
                        saleCmd.Parameters.AddWithValue("@UnitPrice", unitPrice);
                        saleCmd.ExecuteNonQuery();
                    }

                    tran.Commit();

                    lblMsg.Visible = true;
                    lblMsg.Text = "Продажа успешно зарегистрирована!";
                    lblMsg.CssClass = "alert alert-success";
                    getProducts();
                    clear();
                }
                catch (Exception ex)
                {
                    tran?.Rollback();
                    lblMsg.Visible = true;
                    lblMsg.Text = "Ошибка при продаже: " + ex.Message;
                    lblMsg.CssClass = "alert alert-danger";
                }
                finally { con.Close(); }

                return; // Завершаем метод, если была продажа
            }

            // ==== Режим добавления / редактирования ====
            string actionName = string.Empty, imagePath = string.Empty, fileExtension = string.Empty;
            bool isValidToExecute = false;

            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Product_Crud", con);
            cmd.Parameters.AddWithValue("@Action", productId == 0 ? "INSERT" : "UPDATE");
            cmd.Parameters.AddWithValue("@ProductId", productId);
            cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
            cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());

            // Цена — с точкой как разделителем (унификация для SQL)
            string priceText = txtPrice.Text.Replace(",", ".");
            decimal price = Convert.ToDecimal(priceText, CultureInfo.InvariantCulture);
            cmd.Parameters.AddWithValue("@Price", price);
            cmd.Parameters.AddWithValue("@Quantity", txtQuantity.Text.Trim());
            cmd.Parameters.AddWithValue("@CategoryId", ddlCategories.SelectedValue);
            cmd.Parameters.AddWithValue("@BrandId", ddlBrands.SelectedValue);
            cmd.Parameters.AddWithValue("@ExpirationDate",
                string.IsNullOrEmpty(txtExpirationDate.Text)
                ? (object)DBNull.Value
                : DateTime.ParseExact(txtExpirationDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture));
            cmd.Parameters.AddWithValue("@IsActive", cbIsActive.Checked);

            // Загрузка изображения
            if (fuProductImage.HasFile)
            {
                if (Utils.IsValidExtension(fuProductImage.FileName))
                {
                    Guid obj = Guid.NewGuid();
                    fileExtension = Path.GetExtension(fuProductImage.FileName);
                    imagePath = "Images/Product/" + obj.ToString() + fileExtension;

                    fuProductImage.PostedFile.SaveAs(Server.MapPath("~/Images/Product/") + obj.ToString() + fileExtension);
                    cmd.Parameters.AddWithValue("@ImageUrl", imagePath);
                    isValidToExecute = true;
                }
                else
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Пожалуйста, выберите изображение в формате .jpg, .jpeg или .png";
                    lblMsg.CssClass = "alert alert-danger";
                    isValidToExecute = false;
                }
            }
            else
            {
                // Обновление без смены изображения
                isValidToExecute = true;
            }

            // Выполнение INSERT/UPDATE
            if (isValidToExecute)
            {
                cmd.CommandType = CommandType.StoredProcedure;
                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    actionName = productId == 0 ? "добавлен" : "обновлён";
                    lblMsg.Visible = true;
                    lblMsg.Text = "Товар успешно " + actionName + "!";
                    lblMsg.CssClass = "alert alert-success";
                    getProducts();
                    clear();
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
        }

        // Загрузка всех товаров
        private void getProducts()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Product_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "SELECT");
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            rProduct.DataSource = dt;
            rProduct.DataBind();
        }

        // Очистка формы и переключение в обычный режим
        private void clear()
        {
            txtName.Text = string.Empty;
            txtDescription.Text = string.Empty;
            txtQuantity.Text = string.Empty;
            txtPrice.Text = string.Empty;
            ddlCategories.ClearSelection();
            ddlBrands.ClearSelection();
            cbIsActive.Checked = false;
            hdnId.Value = "0";
            btnAddOrUpdate.Text = "Добавить";
            txtExpirationDate.Text = string.Empty;

            hdnMode.Value = "NORMAL";

            // Восстанавливаем доступность полей
            txtName.Enabled = true;
            txtDescription.Enabled = true;
            txtPrice.Enabled = true;
            ddlCategories.Enabled = true;
            ddlBrands.Enabled = true;
            cbIsActive.Enabled = true;
            txtExpirationDate.Enabled = true;
            fuProductImage.Enabled = true;
        }

        // Усечение текста (например, описания товара) при отображении
        public string Truncate(object value, int maxLength)
        {
            string input = value?.ToString();
            if (string.IsNullOrEmpty(input)) return string.Empty;
            return input.Length <= maxLength ? input : input.Substring(0, maxLength) + "...";
        }

        // Кнопка "Очистить"
        protected void btnClear_Click(object sender, EventArgs e)
        {
            clear();
        }

        // Обработка кнопок в Repeater: редактировать, удалить, продать
        protected void rProduct_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblMsg.Visible = false;
            con = new SqlConnection(Connection.GetConnectionString());

            if (e.CommandName == "edit")
            {
                // Загрузка товара для редактирования
                cmd = new SqlCommand("Product_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "GETBYID");
                cmd.Parameters.AddWithValue("@ProductId", e.CommandArgument);
                cmd.CommandType = CommandType.StoredProcedure;
                sda = new SqlDataAdapter(cmd);
                dt = new DataTable();
                sda.Fill(dt);

                // Заполнение формы
                txtName.Text = dt.Rows[0]["Name"].ToString();
                txtDescription.Text = dt.Rows[0]["Description"].ToString();
                txtPrice.Text = dt.Rows[0]["Price"].ToString();
                txtQuantity.Text = dt.Rows[0]["Quantity"].ToString();
                ddlCategories.SelectedValue = dt.Rows[0]["CategoryId"].ToString();
                ddlBrands.SelectedValue = dt.Rows[0]["BrandId"].ToString();
                cbIsActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"]);
                txtExpirationDate.Text = Convert.ToDateTime(dt.Rows[0]["ExpirationDate"]).ToString("yyyy-MM-dd");
                hdnId.Value = dt.Rows[0]["ProductId"].ToString();
                btnAddOrUpdate.Text = "Обновить";
            }
            else if (e.CommandName == "delete")
            {
                // Удаление товара
                cmd = new SqlCommand("Product_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "DELETE");
                cmd.Parameters.AddWithValue("@ProductId", e.CommandArgument);
                cmd.CommandType = CommandType.StoredProcedure;
                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    lblMsg.Visible = true;
                    lblMsg.Text = "Товар успешно удалён!";
                    lblMsg.CssClass = "alert alert-success";
                    getProducts();
                }
                catch (SqlException ex)
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = ex.Class == 16
                        ? "Ошибка: " + ex.Message
                        : "Произошла ошибка при удалении товара. Попробуйте позже.";
                    lblMsg.CssClass = "alert alert-danger";
                }
                finally { con.Close(); }
            }
            else if (e.CommandName == "sell")
            {
                // Продажа товара — подгружаем форму, переключаем режим
                cmd = new SqlCommand("Product_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "GETBYID");
                cmd.Parameters.AddWithValue("@ProductId", e.CommandArgument);
                cmd.CommandType = CommandType.StoredProcedure;
                sda = new SqlDataAdapter(cmd);
                dt = new DataTable();
                sda.Fill(dt);

                // Заполнение формы, но блокировка всех полей, кроме количества
                txtName.Text = dt.Rows[0]["Name"].ToString();
                txtDescription.Text = dt.Rows[0]["Description"].ToString();
                txtPrice.Text = dt.Rows[0]["Price"].ToString();
                txtQuantity.Text = "1";
                ddlCategories.SelectedValue = dt.Rows[0]["CategoryId"].ToString();
                ddlBrands.SelectedValue = dt.Rows[0]["BrandId"].ToString();
                cbIsActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"]);
                txtExpirationDate.Text = Convert.ToDateTime(dt.Rows[0]["ExpirationDate"]).ToString("yyyy-MM-dd");
                hdnId.Value = dt.Rows[0]["ProductId"].ToString();
                hdnMode.Value = "SELL";

                txtName.Enabled = false;
                txtDescription.Enabled = false;
                txtPrice.Enabled = false;
                ddlCategories.Enabled = false;
                ddlBrands.Enabled = false;
                cbIsActive.Enabled = false;
                txtExpirationDate.Enabled = false;
                fuProductImage.Enabled = false;

                btnAddOrUpdate.Text = "Продать";
            }
        }

        // Отображение значков (статуса, количества, срока годности)
        protected void rProduct_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Статус активности
                Label lblIsActive = e.Item.FindControl("lblIsActive") as Label;
                lblIsActive.Text = lblIsActive.Text == "True" ? "Активен" : "Неактивен";
                lblIsActive.CssClass = lblIsActive.Text == "Активен" ? "badge badge-success" : "badge badge-danger";

                // Остаток товара — красный, если <= 5
                Label lblQuantity = e.Item.FindControl("lblQuantity") as Label;
                if (Convert.ToInt32(lblQuantity.Text) <= 5)
                {
                    lblQuantity.CssClass = "badge badge-danger";
                    lblQuantity.ToolTip = "Низкий остаток товара";
                }

                // Срок годности — красный, если < 7 дней
                Label lblExpirationDate = e.Item.FindControl("lblExpirationDate") as Label;
                if (DateTime.TryParse(lblExpirationDate.Text, out DateTime expDate))
                {
                    if ((expDate - DateTime.Now).TotalDays <= 7)
                    {
                        lblExpirationDate.CssClass = "badge badge-danger";
                        lblExpirationDate.ToolTip = "Срок годности скоро истекает";
                    }
                }
            }
        }
    }
}
