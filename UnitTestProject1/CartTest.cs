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
        // Строка подключения к тестовой базе данных
        // Убедись, что логин/пароль и имя БД корректны в тестовой среде
        private readonly string connectionString = "Data Source=.\\SQLEXPRESS; Initial Catalog=OnniDB; User ID=sa; Password=12345";

        [TestMethod]
        public void Cart_InsertAndDelete_ShouldWorkCorrectly()
        {        
            // 1. Тестовые данные: существующий пользователь и товар
            int testUserId = 160;  // Убедись, что такой пользователь есть в OnniDB
            int testProductId = 11;   // И что ProductId = 11 существует
            int testQty = 1;    // Кол-во, которое будем добавлять

            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 2. Добавление товара в корзину (Cart_Crud → INSERT)
                var insertCmd = new SqlCommand("Cart_Crud", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                insertCmd.Parameters.AddWithValue("@Action", "INSERT");
                insertCmd.Parameters.AddWithValue("@ProductId", testProductId);
                insertCmd.Parameters.AddWithValue("@Quantity", testQty);
                insertCmd.Parameters.AddWithValue("@UserId", testUserId);

                insertCmd.ExecuteNonQuery();

                // 3. Проверяем, что запись действительно создана
                //    (Cart_Crud → GETBYID)
                var checkCmd = new SqlCommand("Cart_Crud", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                checkCmd.Parameters.AddWithValue("@Action", "GETBYID");
                checkCmd.Parameters.AddWithValue("@ProductId", testProductId);
                checkCmd.Parameters.AddWithValue("@UserId", testUserId);

                using (var reader = checkCmd.ExecuteReader())
                {
                    // Ждём хотя бы одну строку → товар найден
                    Assert.IsTrue(reader.HasRows, "Товар не добавился в корзину.");
                }

                // 4. Удаляем товар из корзины (Cart_Crud → DELETE)
                var deleteCmd = new SqlCommand("Cart_Crud", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                deleteCmd.Parameters.AddWithValue("@Action", "DELETE");
                deleteCmd.Parameters.AddWithValue("@ProductId", testProductId);
                deleteCmd.Parameters.AddWithValue("@UserId", testUserId);

                deleteCmd.ExecuteNonQuery();

                // 5. Повторная проверка: товар должен исчезнуть
                var recheckCmd = new SqlCommand("Cart_Crud", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                recheckCmd.Parameters.AddWithValue("@Action", "GETBYID");
                recheckCmd.Parameters.AddWithValue("@ProductId", testProductId);
                recheckCmd.Parameters.AddWithValue("@UserId", testUserId);

                using (var reader2 = recheckCmd.ExecuteReader())
                {
                    // Ожидаем, что строк нет → товар успешно удалён
                    Assert.IsFalse(reader2.HasRows, "Товар не удалился из корзины.");
                }
            }
        }
    }
}
