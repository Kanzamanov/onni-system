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
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHeroCategories();
            }
        }

        private void LoadHeroCategories()
        {
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                SqlCommand cmd = new SqlCommand("Category_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "ACTIVECAT");
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);

                rHeroCategories.DataSource = dt;
                rHeroCategories.DataBind();
            }
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string keyword = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(keyword))
            {
                // Редирект на страницу каталога с параметром поиска
                Response.Redirect("Catalog.aspx?search=" + Server.UrlEncode(keyword));
            }
        }

    }
}