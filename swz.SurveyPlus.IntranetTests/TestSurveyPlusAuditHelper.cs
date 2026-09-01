using Newtonsoft.Json;
using swz.SurveyPlus.IntranetApplication;
using System;
using System.Collections.Generic;
using System.Data;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestSurveyPlusAuditHelper
    {
        [Fact]
        public void SerialiseDataTableToJson_Returns_Null_For_Null()
        {
            string actual = SurveyPlusAuditHelper.SerialiseDataTableToJson(null);
            Assert.Null(actual);
        }

        [Fact]
        public void SerialiseDataTableToJson_Works()
        {
            DateTime testDate = DateTime.Now;

            Guid fourtechId = Guid.NewGuid();
            Guid threetechId = Guid.NewGuid();

            DataTable table = TestTable();

            table.Rows.Add(fourtechId, true, "Fourtech", testDate, 0, null);
            table.Rows.Add(Guid.NewGuid(), true, "Hello", testDate, 1, null);
            table.Rows.Add(Guid.NewGuid(), true, "Testco", testDate, 2, "hello world");
            table.Rows.Add(threetechId, true, "ThreeCorp", testDate, 3, DBNull.Value);

            string actual = SurveyPlusAuditHelper.SerialiseDataTableToJson(table);

            Assert.NotNull(actual);

            List<dynamic> items = JsonConvert.DeserializeObject<List<dynamic>>(actual);
            Assert.Equal(4, items.Count);
            {
                dynamic fourtech = items[0];
                Assert.Equal(fourtechId, (Guid)fourtech.Id);
                Assert.Equal("Fourtech", (string)fourtech.UID);
                Assert.Equal(testDate, (DateTime)fourtech.CreatedDate);
                Assert.Equal(0, (int)fourtech.NumRetry);
                Assert.Null((string)fourtech.AnotherField);
            }

            {
                dynamic testco = items[2];
                Assert.Equal("hello world", (string)testco.AnotherField);
            }

            {
                dynamic threecorp = items[3];
                Assert.Equal(threetechId, (Guid)threecorp.Id);
                Assert.Equal("ThreeCorp", (string)threecorp.UID);
                Assert.Equal(testDate, (DateTime)threecorp.CreatedDate);
                Assert.Equal(3, (int)threecorp.NumRetry);
                Assert.Null((string)threecorp.AnotherField);
            }
        }

        [Fact]
        public void SerialiseDataTableToJson_Returns_EmptyJsonArray_For_Empty_Table()
        {
            DataTable table = TestTable();
            string actual = SurveyPlusAuditHelper.SerialiseDataTableToJson(table);
            Assert.NotNull(actual);
            List<dynamic> items = JsonConvert.DeserializeObject<List<dynamic>>(actual);
            Assert.Empty(items);
        }

        private DataTable TestTable()
        {
            DataTable table = new DataTable("test_table");
            table.Columns.Add("Id", typeof(Guid));
            table.Columns.Add("ActiveYN", typeof(bool));
            table.Columns.Add("UID", typeof(string));
            table.Columns.Add("CreatedDate", typeof(DateTime));
            table.Columns.Add("NumRetry", typeof(int));
            table.Columns.Add("AnotherField", typeof(string));
            return table;
        }
    }
}
