// Подключение системных пространств имён, включая iTextSharp для генерации PDF
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing.Printing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

using iTextSharp.text.pdf;
using iTextSharp.text;
using System.IO;
using System.Net;
using iTextSharp.text.pdf.draw;

namespace Onni.User
{
    public partial class Invoice : System.Web.UI.Page
    {
        // Поля для подключения к БД
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        // Загрузка страницы
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) // Проверка: если страница загружается впервые
            {
                if (Session["userId"] != null) // Проверка: пользователь авторизован
                {
                    if (Request.QueryString["id"] != null) // Проверка: передан id оплаты
                    {
                        // Получение и привязка данных заказа
                        rOrderItem.DataSource = GetOrderDetails();
                        rOrderItem.DataBind();
                    }
                }
                else
                {
                    // Если не авторизован — перенаправляем на страницу входа
                    Response.Redirect("Login.aspx");
                }
            }
        }

        // Метод получения данных о заказе по ID оплаты
        DataTable GetOrderDetails()
        {
            double grandTotal = 0; // Общая сумма по заказу
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Invoice", con);
            cmd.Parameters.AddWithValue("@Action", "INVOICBYID"); // Указываем действие процедуры

            // Безопасно извлекаем ID оплаты из строки запроса
            if (int.TryParse(Request.QueryString["id"], out int paymentId))
            {
                cmd.Parameters.AddWithValue("@PaymentId", paymentId);
            }
            else
            {
                Response.Redirect("Profile.aspx");
                return null;
            }

            // Передаём ID пользователя в запрос
            cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
            cmd.CommandType = CommandType.StoredProcedure;

            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            // Считаем общую сумму по строкам
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow drow in dt.Rows)
                {
                    grandTotal += Convert.ToDouble(drow["TotalPrice"]);
                }
            }

            ViewState["GrandTotal"] = grandTotal.ToString("0.00"); // Сохраняем сумму для отображения
            return dt;
        }

        // Кнопка "Скачать чек"
        protected void lbDownloadInvoice_Click(object sender, EventArgs e)
        {
            try
            {
                DataTable dt = GetOrderDetails(); // Получаем данные о заказе
                if (dt == null || dt.Rows.Count == 0)
                {
                    // Вывод сообщения об ошибке, если нет данных
                    lblMsg.Visible = true;
                    lblMsg.Text = "Нет данных для генерации чека.";
                    return;
                }

                // Имя создаваемого PDF-файла
                string fileName = "Invoice_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".pdf";

                // Создаём PDF-файл в памяти
                using (MemoryStream ms = new MemoryStream())
                {
                    GenerateInvoicePdf(dt, ms, "Чек клиента");

                    // Отправка PDF в браузер для скачивания
                    Response.Clear();
                    Response.ContentType = "application/pdf";
                    Response.AddHeader("content-disposition", $"attachment; filename={fileName}");
                    Response.BinaryWrite(ms.ToArray());
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                // Обработка ошибок при генерации
                lblMsg.Visible = true;
                lblMsg.Text = "Ошибка при создании чека: " + ex.Message;
            }
        }

        // Метод генерации PDF-файла с чеком
        private void GenerateInvoicePdf(DataTable dt, Stream output, string title)
        {
            // Создаём документ A4 с отступами
            Document document = new Document(PageSize.A4, 25, 25, 30, 30);
            PdfWriter.GetInstance(document, output);
            document.Open();

            // Подключение шрифта Arial (обязательно для русских символов)
            string fontPath = Server.MapPath("~/TemplateFiles/fonts/arial.ttf");
            BaseFont baseFont = BaseFont.CreateFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

            // Определение стилей шрифтов
            Font titleFont = new Font(baseFont, 16, Font.BOLD, Color.DARK_GRAY);
            Font infoFont = new Font(baseFont, 9, Font.ITALIC, Color.GRAY);
            Font headerFont = new Font(baseFont, 10, Font.BOLD, Color.WHITE);
            Font dataFont = new Font(baseFont, 9, Font.NORMAL, Color.BLACK);

            // Заголовок чека
            Paragraph heading = new Paragraph(title.ToUpper(), titleFont)
            {
                Alignment = Element.ALIGN_CENTER
            };
            document.Add(heading);
            document.Add(new Chunk("\n"));

            // Информация о заказе (дата, магазин)
            Paragraph info = new Paragraph
            {
                Alignment = Element.ALIGN_RIGHT
            };
            info.Add(new Chunk("Магазин: Onni", infoFont));
            info.Add(new Chunk("\nДата заказа: " + dt.Rows[0]["OrderDate"].ToString(), infoFont));
            document.Add(info);

            // Линия-разделитель
            LineSeparator line = new LineSeparator(0.0f, 100.0f, Color.BLACK, Element.ALIGN_LEFT, 1);
            document.Add(new Chunk(line));
            document.Add(new Chunk("\n"));

            // Таблица с заказом
            PdfPTable table = new PdfPTable(6)
            {
                WidthPercentage = 100
            };

            // Заголовки таблицы
            string[] headers = { "№", "Номер заказа", "Товар", "Цена за ед.", "Кол-во", "Сумма" };
            foreach (var header in headers)
            {
                PdfPCell cell = new PdfPCell(new Phrase(header, headerFont))
                {
                    BackgroundColor = Color.GRAY,
                    HorizontalAlignment = Element.ALIGN_CENTER,
                    Padding = 5
                };
                table.AddCell(cell);
            }

            // Заполнение таблицы строками заказа
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                table.AddCell(new PdfPCell(new Phrase((i + 1).ToString(), dataFont)));
                table.AddCell(new PdfPCell(new Phrase(dt.Rows[i]["OrderNo"].ToString(), dataFont)));
                table.AddCell(new PdfPCell(new Phrase(dt.Rows[i]["Name"].ToString(), dataFont)));
                table.AddCell(new PdfPCell(new Phrase(dt.Rows[i]["Price"].ToString() + " сом", dataFont)) { HorizontalAlignment = Element.ALIGN_RIGHT });
                table.AddCell(new PdfPCell(new Phrase(dt.Rows[i]["Quantity"].ToString(), dataFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase(dt.Rows[i]["TotalPrice"].ToString() + " сом", dataFont)) { HorizontalAlignment = Element.ALIGN_RIGHT });
            }

            document.Add(table);

            // Общая сумма
            Paragraph total = new Paragraph("\nИтого: " + ViewState["GrandTotal"] + " сом", titleFont)
            {
                Alignment = Element.ALIGN_RIGHT
            };
            document.Add(total);

            document.Close(); // Завершаем создание документа
        }
    }
}
