using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace UnitTestProject1
{
    [TestClass]
    public class UserLoginTest
    {
        private readonly string connectionString = "Data Source=.\\SQLEXPRESS; Initial Catalog=OnniDB; User ID=sa; Password=12345";

        [TestMethod]
        public void UserLogin_ExistingUser_ShouldReturnUser()
        {
            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();

                var loginCmd = new SqlCommand("User_Crud", conn);
                loginCmd.CommandType = CommandType.StoredProcedure;

                loginCmd.Parameters.AddWithValue("@Action", "SELECT4LOGIN");
                loginCmd.Parameters.AddWithValue("@Username", "Chika");     
                loginCmd.Parameters.AddWithValue("@Password", "12345");  

                var adapter = new SqlDataAdapter(loginCmd);
                var dt = new DataTable();
                adapter.Fill(dt);

                Assert.AreEqual(1, dt.Rows.Count, "User not found or invalid credentials.");

                bool isBlocked = Convert.ToBoolean(dt.Rows[0]["IsBlocked"]);
                Assert.IsFalse(isBlocked, "User is blocked.");
            }
        }
    }
}
