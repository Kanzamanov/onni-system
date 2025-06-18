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
        private string GetHash(string input)
        {
            using (var sha = System.Security.Cryptography.SHA256.Create())
            {
                var bytes = System.Text.Encoding.UTF8.GetBytes(input);
                var hash = sha.ComputeHash(bytes);
                return BitConverter.ToString(hash).Replace("-", "").ToLower();
            }
        }

        [TestMethod]
        public void UserLogin_ExistingUser_ShouldReturnUser()
        {
            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();

                var loginCmd = new SqlCommand("User_Crud", conn);
                loginCmd.CommandType = CommandType.StoredProcedure;

                loginCmd.Parameters.AddWithValue("@Action", "SELECT4LOGIN");
                loginCmd.Parameters.AddWithValue("@Username", "aibek");
                loginCmd.Parameters.AddWithValue("@Password", GetHash("12345"));

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
