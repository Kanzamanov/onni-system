using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnitTestProject1
{
    [TestClass]
    public class OrderStatusTest
    {
        private readonly string connectionString = "Data Source=.\\SQLEXPRESS; Initial Catalog=OnniDB; User ID=sa; Password=12345";
        [TestMethod]
        public void UpdateOrderStatus_ShouldChangeStatus()
        {
            int testOrderItemId = 74;
            string newStatus = "Dispatched";

            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 1. Выполняем UPDATE через процедуру
                var updateCmd = new SqlCommand("Invoice", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                updateCmd.Parameters.AddWithValue("@Action", "UPDTSTATUS");
                updateCmd.Parameters.AddWithValue("@OrderItemId", testOrderItemId);
                updateCmd.Parameters.AddWithValue("@Status", newStatus);
                updateCmd.ExecuteNonQuery();

                // 2. Проверяем, изменился ли статус
                var checkCmd = new SqlCommand("SELECT Status FROM OrderItem WHERE OrderItemId = @id", conn);
                checkCmd.Parameters.AddWithValue("@id", testOrderItemId);

                string updatedStatus = (string)checkCmd.ExecuteScalar();

                Assert.AreEqual(newStatus, updatedStatus, "Статус заказа не был обновлён.");
            }
        }

    }

}
