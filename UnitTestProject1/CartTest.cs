using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnitTestProject1
{
    [TestClass]
    public class CartTest
    {
        private readonly string connectionString = "Data Source=.\\SQLEXPRESS; Initial Catalog=OnniDB; User ID=sa; Password=12345";

        [TestMethod]
        public void Cart_InsertAndDelete_ShouldWorkCorrectly()
        {
            int testUserId = 106;       // убедись, что этот пользователь существует
            int testProductId = 11;     // убедись, что такой товар точно есть
            int testQty = 1;

            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 1. Добавление товара в корзину
                var insertCmd = new SqlCommand("Cart_Crud", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                insertCmd.Parameters.AddWithValue("@Action", "INSERT");
                insertCmd.Parameters.AddWithValue("@ProductId", testProductId);
                insertCmd.Parameters.AddWithValue("@Quantity", testQty);
                insertCmd.Parameters.AddWithValue("@UserId", testUserId);
                insertCmd.ExecuteNonQuery();

                // 2. Проверка, что товар добавлен
                var checkCmd = new SqlCommand("Cart_Crud", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                checkCmd.Parameters.AddWithValue("@Action", "GETBYID");
                checkCmd.Parameters.AddWithValue("@ProductId", testProductId);
                checkCmd.Parameters.AddWithValue("@UserId", testUserId);

                using (var reader = checkCmd.ExecuteReader())
                {
                    Assert.IsTrue(reader.HasRows, "Товар не добавился в корзину.");
                }

                // 3. Удаление товара из корзины
                var deleteCmd = new SqlCommand("Cart_Crud", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                deleteCmd.Parameters.AddWithValue("@Action", "DELETE");
                deleteCmd.Parameters.AddWithValue("@ProductId", testProductId);
                deleteCmd.Parameters.AddWithValue("@UserId", testUserId);
                deleteCmd.ExecuteNonQuery();

                // 4. Проверка, что товар удалён
                var recheckCmd = new SqlCommand("Cart_Crud", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                recheckCmd.Parameters.AddWithValue("@Action", "GETBYID");
                recheckCmd.Parameters.AddWithValue("@ProductId", testProductId);
                recheckCmd.Parameters.AddWithValue("@UserId", testUserId);

                using (var reader2 = recheckCmd.ExecuteReader())
                {
                    Assert.IsFalse(reader2.HasRows, "Товар не удалился из корзины.");
                }
            }
        }
    }

}
