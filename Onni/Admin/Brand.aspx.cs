using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

namespace Onni.Admin
{
    public partial class Brand : System.Web.UI.Page
    {
        // Глобальные объекты ADO.NET
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        protected void Page_Load(object sender, EventArgs e)
        {
            // При первой загрузке страницы
            if (!IsPostBack)
            {
                // Устанавливаем хлебную крошку
                Session["breadCrum"] = "Бренды";

                // Проверка авторизации (только менеджер)
                if (Session["Manager"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
                else
                {
                    // Загрузка списка брендов из БД
                    getBrands();
                }
            }

            // Сообщения по умолчанию скрыты
            lblMsg.Visible = false;
        }

        // Кнопка Добавить / Обновить бренд
        protected void btnAddOrUpdate_Click(object sender, EventArgs e)
        {
            string actionName = string.Empty, imagePath = string.Empty, fileExtension = string.Empty;
            bool isValidToExecute = false;

            // Получаем ID из скрытого поля (0 — новый бренд)
            int brandId = Convert.ToInt32(hdnId.Value);

            // Настраиваем команду для процедуры Brand_Crud
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Brand_Crud", con);
            cmd.Parameters.AddWithValue("@Action", brandId == 0 ? "INSERT" : "UPDATE");
            cmd.Parameters.AddWithValue("@BrandId", brandId);
            cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
            cmd.Parameters.AddWithValue("@IsActive", cbIsActive.Checked);

            // ▼ Обработка загрузки изображения бренда
            if (fuBrandImage.HasFile)
            {
                // Проверка расширения (разрешены .jpg, .jpeg, .png)
                if (Utils.IsValidExtension(fuBrandImage.FileName))
                {
                    // Генерируем уникальное имя файла
                    Guid obj = Guid.NewGuid();
                    fileExtension = Path.GetExtension(fuBrandImage.FileName);
                    imagePath = "Images/Brand/" + obj.ToString() + fileExtension;

                    // Сохраняем файл на сервер
                    fuBrandImage.PostedFile.SaveAs(Server.MapPath("~/Images/Brand/") + obj.ToString() + fileExtension);
                    cmd.Parameters.AddWithValue("@ImageUrl", imagePath);
                    isValidToExecute = true;
                }
                else
                {
                    // Ошибка при неверном расширении
                    lblMsg.Visible = true;
                    lblMsg.Text = "Пожалуйста, выберите изображение с расширением .jpg, .jpeg или .png";
                    lblMsg.CssClass = "alert alert-danger";
                    isValidToExecute = false;
                }
            }
            else
            {
                // Изображение необязательное при обновлении
                isValidToExecute = true;
            }

            // Если валидация прошла
            if (isValidToExecute)
            {
                cmd.CommandType = CommandType.StoredProcedure;
                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();

                    // Сообщение об успехе
                    actionName = brandId == 0 ? "добавлен" : "обновлен";
                    lblMsg.Visible = true;
                    lblMsg.Text = "Бренд успешно " + actionName + "!";
                    lblMsg.CssClass = "alert alert-success";

                    // Перезагрузка списка брендов и очистка формы
                    getBrands();
                    clear();
                }
                catch (Exception ex)
                {
                    // Ошибка при сохранении
                    lblMsg.Visible = true;
                    lblMsg.Text = "Ошибка - " + ex.Message;
                    lblMsg.CssClass = "alert alert-danger";
                }
                finally
                {
                    con.Close();
                }
            }
        }

        // Метод для получения всех брендов и привязки к Repeater
        private void getBrands()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Brand_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "SELECT");
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            rBrand.DataSource = dt;
            rBrand.DataBind();
        }

        // Очистка формы
        private void clear()
        {
            txtName.Text = string.Empty;
            cbIsActive.Checked = false;
            hdnId.Value = "0";
            btnAddOrUpdate.Text = "Добавить";
        }

        // Кнопка "Очистить" — сброс формы
        protected void btnClear_Click(object sender, EventArgs e)
        {
            clear();
        }

        // Обработка кнопок Repeater'а (Редактировать, Удалить)
        protected void rBrand_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblMsg.Visible = false;
            con = new SqlConnection(Connection.GetConnectionString());

            if (e.CommandName == "edit")
            {
                // Получение бренда по ID для редактирования
                cmd = new SqlCommand("Brand_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "GETBYID");
                cmd.Parameters.AddWithValue("@BrandId", e.CommandArgument);
                cmd.CommandType = CommandType.StoredProcedure;
                sda = new SqlDataAdapter(cmd);
                dt = new DataTable();
                sda.Fill(dt);

                // Заполнение полей формы
                txtName.Text = dt.Rows[0]["Name"].ToString();
                cbIsActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"]);
                hdnId.Value = dt.Rows[0]["BrandId"].ToString();
                btnAddOrUpdate.Text = "Обновить";

                // Меняем стиль кнопки
                LinkButton btn = e.Item.FindControl("lnkEdit") as LinkButton;
                btn.CssClass = "badge badge-warning";
            }
            else if (e.CommandName == "delete")
            {
                // Удаление бренда
                cmd = new SqlCommand("Brand_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "DELETE");
                cmd.Parameters.AddWithValue("@BrandId", e.CommandArgument);
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    lblMsg.Visible = true;
                    lblMsg.Text = "Бренд успешно удалён!";
                    lblMsg.CssClass = "alert alert-success";
                    getBrands(); // обновляем список
                }
                catch (SqlException ex)
                {
                    lblMsg.Visible = true;

                    // Классы 16 и ниже — пользовательская ошибка (например, FK constraint)
                    if (ex.Class == 16)
                    {
                        lblMsg.Text = "Ошибка - " + ex.Message;
                    }
                    else
                    {
                        lblMsg.Text = "Ошибка при удалении бренда. Пожалуйста, попробуйте позже.";
                    }

                    lblMsg.CssClass = "alert alert-danger";
                }
                finally
                {
                    con.Close();
                }
            }
        }

        // Подстановка статуса активности в красивый вид + цвет
        protected void rBrand_ItemDataBound(object sender, RepeaterItemEventArgs e)
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
