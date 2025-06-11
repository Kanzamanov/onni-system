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
    public class ProductTest
    {
        private readonly string connectionString = "Data Source=.\\SQLEXPRESS; Initial Catalog=OnniDB; User ID=sa; Password=12345";

        [TestMethod]
        public void ProductInsertion_ShouldInsertProduct()
        {
            int insertedProductId = 0;

            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 1. Вставка
                var insertCmd = new SqlCommand("Product_Crud", conn);
                insertCmd.CommandType = CommandType.StoredProcedure;
                insertCmd.Parameters.AddWithValue("@Action", "INSERT");
                insertCmd.Parameters.AddWithValue("@ProductId", 0);
                insertCmd.Parameters.AddWithValue("@Name", "TestProductXYZ");
                insertCmd.Parameters.AddWithValue("@Description", "text");
                insertCmd.Parameters.AddWithValue("@Price", 99.99);
                insertCmd.Parameters.AddWithValue("@Quantity", 5);
                insertCmd.Parameters.AddWithValue("@ImageUrl", "temp.jpg");
                insertCmd.Parameters.AddWithValue("@BrandId", 1);        // убедись, что такие Brand и Category существуют
                insertCmd.Parameters.AddWithValue("@CategoryId", 9);
                insertCmd.Parameters.AddWithValue("@IsActive", true);
                insertCmd.Parameters.AddWithValue("@ExpirationDate", DateTime.Now.AddDays(30));

                object result = insertCmd.ExecuteScalar();
                insertedProductId = Convert.ToInt32(result);

                // 2. Проверка
                var checkCmd = new SqlCommand("SELECT COUNT(*) FROM Products WHERE ProductId = @ProductId", conn);
                checkCmd.Parameters.AddWithValue("@ProductId", insertedProductId);
                int count = (int)checkCmd.ExecuteScalar();

                Assert.IsTrue(count > 0, "Product was not inserted.");

                // 3. Удаление
                var deleteCmd = new SqlCommand("Product_Crud", conn);
                deleteCmd.CommandType = CommandType.StoredProcedure;
                deleteCmd.Parameters.AddWithValue("@Action", "DELETE");
                deleteCmd.Parameters.AddWithValue("@ProductId", insertedProductId);
                deleteCmd.ExecuteNonQuery();
            }
        }
    }

}
