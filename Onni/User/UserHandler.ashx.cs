using System;
using System.Web;
using System.Data.SqlClient;
using System.Data;

namespace Onni.User
{
    public class UserHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            string action = context.Request["Action"];
            string username = context.Request["Username"];
            string password = context.Request["Password"];

            if (action == "SELECT4LOGIN")
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
                    using (SqlCommand cmd = new SqlCommand("User_Crud", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@Action", "SELECT4LOGIN");
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Password", password);

                        con.Open();
                        SqlDataReader rdr = cmd.ExecuteReader();

                        if (rdr.HasRows)
                            context.Response.Write("OK");
                        else
                            context.Response.Write("FAIL");
                    }
                }
                catch (Exception ex)
                {
                    context.Response.Write("ERROR: " + ex.Message);
                }
            }
            else
            {
                context.Response.Write("Invalid action");
            }
        }

        public bool IsReusable => false;
    }
}
