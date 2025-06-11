using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace UnitTestProject1
{
    [TestClass]
    public class UserRegistrationTest
    {
        private readonly string connectionString = "Data Source=.\\SQLEXPRESS; Initial Catalog=OnniDB; User ID=sa; Password=12345";

        [TestMethod]
        public void UserRegistration_ShouldInsertUser()
        {
            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();

                var insertCmd = new SqlCommand("User_Crud", conn);
                insertCmd.CommandType = CommandType.StoredProcedure;

                insertCmd.Parameters.AddWithValue("@Action", "INSERT");
                insertCmd.Parameters.AddWithValue("@UserId", 0);
                insertCmd.Parameters.AddWithValue("@Name", "TestName");
                insertCmd.Parameters.AddWithValue("@Username", "testuser123");
                insertCmd.Parameters.AddWithValue("@PhoneNumber", "+996700000000");
                insertCmd.Parameters.AddWithValue("@Email", "testuser123@example.com");
                insertCmd.Parameters.AddWithValue("@Address", "г. Бишкек");
                insertCmd.Parameters.AddWithValue("@Password", "12345");

                insertCmd.ExecuteNonQuery(); 

                // проверяем факт вставки
                var checkCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Username = 'testuser123'", conn);
                int count = (int)checkCmd.ExecuteScalar();

                Assert.IsTrue(count > 0, "User was not inserted.");

                // очистка тестовых данных
                var deleteCmd = new SqlCommand("DELETE FROM Users WHERE Username = 'testuser123'", conn);
                deleteCmd.ExecuteNonQuery();
            }
        }

    }
}
