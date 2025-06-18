using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Onni.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Выполняем только при первой загрузке страницы,
            // чтобы не пересчитывать показатели на каждом PostBack
            if (!IsPostBack)
            {
                // Хлебная крошка для главной админ-страницы пуста
                Session["breadCrum"] = "";

                // Проверяем, вошёл ли менеджер в систему
                if (Session["Manager"] == null)
                {
                    // Если нет — отправляем на страницу логина
                    Response.Redirect("../User/Login.aspx");
                }
                else
                {
                    // Экземпляр вспомогательного класса, который
                    // обращается к БД и считает нужные агрегаты
                    DashboardCount dashboard = new DashboardCount();

                    // Сохраняем полученные значения в Session,
                    // чтобы их могли прочитать элементы ASPX-страницы
                    Session["category"] = dashboard.Count("CATEGORY");     // Всего категорий
                    Session["brand"] = dashboard.Count("BRAND");        // Всего брендов
                    Session["product"] = dashboard.Count("PRODUCT");      // Всего товаров
                    Session["order"] = dashboard.Count("ORDER");        // Всего заказов
                    Session["delivered"] = dashboard.Count("DELIVERED");    // Доставленные заказы
                    Session["pending"] = dashboard.Count("PENDING");      // Ожидающие/в процессе
                    Session["user"] = dashboard.Count("USER");         // Кол-во зарегистр. пользователей
                    Session["soldAmount"] = dashboard.Count("SOLDAMOUNT");   // Сумма всех продаж 
                    Session["contact"] = dashboard.Count("CONTACT");      // Кол-во обращений пользователей
                }
            }
        }
    }
}
