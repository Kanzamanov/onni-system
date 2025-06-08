using System;
using System.Data;
using System.Data.SqlClient;

namespace Onni.User
{
    public partial class Brands : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBrands();
            }
        }

        private void LoadBrands()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Brand_Crud", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Action", "ACTIVEBRA"); // только активные бренды
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            rptBrands.DataSource = dt;
            rptBrands.DataBind();
        }
    }
}
