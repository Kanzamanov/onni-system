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
    public class SellingReportTest
    {
        private readonly string connectionString = "Data Source=.\\SQLEXPRESS; Initial Catalog=OnniDB; User ID=sa; Password=12345";

        [TestMethod]
        public void SellingReport_ShouldNotError_WhenCalledWithValidDates()
        {
            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();

                var cmd = new SqlCommand("SellingReport", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                // Используем диапазон за последние 6 месяцев
                cmd.Parameters.AddWithValue("@FromDate", DateTime.Now.AddMonths(-6));
                cmd.Parameters.AddWithValue("@ToDate", DateTime.Now);

                var adapter = new SqlDataAdapter(cmd);
                var dt = new DataTable();
                adapter.Fill(dt);

                // Мы не знаем, есть ли данные, но сам вызов должен отработать без ошибки
                Assert.IsNotNull(dt, "Result table is null.");
            }
        }
    }


}
