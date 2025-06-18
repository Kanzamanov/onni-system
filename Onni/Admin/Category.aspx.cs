using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

namespace Onni.Admin
{
    public partial class Category : System.Web.UI.Page
    {
        // Объявление объектов ADO.NET
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        // Выполняется при загрузке страницы
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) // Только при первом открытии страницы
            {
                // Устанавливаем хлебную крошку
                Session["breadCrum"] = "Категории";

                // Проверка авторизации (только менеджер)
                if (Session["Manager"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
                else
                {
                    // Загрузка списка категорий из БД
                    getCategories();
                }
            }

            // Скрываем сообщение об ошибках/успехах
            lblMsg.Visible = false;
        }

        // Обработка кнопки "Добавить/Обновить"
        protected void btnAddOrUpdate_Click(object sender, EventArgs e)
        {
            string actionName = string.Empty;
            bool isValidToExecute = true;

            // Получаем ID из скрытого поля: 0 — добавление, иначе обновление
            int categoryId = Convert.ToInt32(hdnId.Value);

            // Настройка SQL-команды
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Category_Crud", con);
            cmd.Parameters.AddWithValue("@Action", categoryId == 0 ? "INSERT" : "UPDATE");
            cmd.Parameters.AddWithValue("@CategoryId", categoryId);
            cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
            cmd.Parameters.AddWithValue("@IsActive", cbIsActive.Checked);

            if (isValidToExecute)
            {
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();

                    // Показываем сообщение об успешной операции
                    actionName = categoryId == 0 ? "добавлена" : "обновлена";
                    lblMsg.Visible = true;
                    lblMsg.Text = "Категория " + actionName + " успешно!";
                    lblMsg.CssClass = "alert alert-success";

                    // Обновляем таблицу и очищаем форму
                    getCategories();
                    clear();
                }
                catch (Exception ex)
                {
                    // Обработка ошибок
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

        // Получение всех категорий из базы и отображение в Repeater
        private void getCategories()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Category_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "SELECT");
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            rCategory.DataSource = dt;
            rCategory.DataBind();
        }

        // Очистка формы после добавления или по нажатию кнопки "Очистить"
        private void clear()
        {
            txtName.Text = string.Empty;
            cbIsActive.Checked = false;
            hdnId.Value = "0"; // Сброс ID
            btnAddOrUpdate.Text = "Добавить";
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            clear(); // Явный вызов метода очистки
        }

        // Обработка команд Repeater: редактирование и удаление
        protected void rCategory_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblMsg.Visible = false;
            con = new SqlConnection(Connection.GetConnectionString());

            if (e.CommandName == "edit")
            {
                // Получение данных категории по ID для редактирования
                cmd = new SqlCommand("Category_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "GETBYID");
                cmd.Parameters.AddWithValue("@CategoryId", e.CommandArgument);
                cmd.CommandType = CommandType.StoredProcedure;
                sda = new SqlDataAdapter(cmd);
                dt = new DataTable();
                sda.Fill(dt);

                // Заполнение формы для редактирования
                txtName.Text = dt.Rows[0]["Name"].ToString();
                cbIsActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"]);
                hdnId.Value = dt.Rows[0]["CategoryId"].ToString();
                btnAddOrUpdate.Text = "Обновить";

                // Визуально выделяем кнопку редактирования
                LinkButton btn = e.Item.FindControl("lnkEdit") as LinkButton;
                btn.CssClass = "badge badge-warning";
            }
            else if (e.CommandName == "delete")
            {
                // Удаление категории
                cmd = new SqlCommand("Category_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "DELETE");
                cmd.Parameters.AddWithValue("@CategoryId", e.CommandArgument);
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    lblMsg.Visible = true;
                    lblMsg.Text = "Категория успешно удалена!";
                    lblMsg.CssClass = "alert alert-success";

                    // Обновляем таблицу
                    getCategories();
                }
                catch (SqlException ex)
                {
                    lblMsg.Visible = true;

                    // Обработка ошибок при ограничениях (например, FK с продуктами)
                    if (ex.Class == 16)
                    {
                        lblMsg.Text = "Ошибка: " + ex.Message;
                    }
                    else
                    {
                        lblMsg.Text = "Ошибка при удалении категории. Попробуйте позже.";
                    }

                    lblMsg.CssClass = "alert alert-danger";
                }
                finally
                {
                    con.Close();
                }
            }
        }

        // Отображение статуса активности в виде метки с цветом
        protected void rCategory_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Label lbl = e.Item.FindControl("lblIsActive") as Label;
                if (lbl.Text == "True")
                {
                    lbl.Text = "Активен";
                    lbl.CssClass = "badge badge-success";
                }
                else
                {
                    lbl.Text = "Неактивен";
                    lbl.CssClass = "badge badge-danger";
                }
            }
        }
    }
}
