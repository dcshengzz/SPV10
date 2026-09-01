using System;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestConnectionStringUtils
    {
        [Fact]
        public void SplitDataSource_Rejects_Null()
        {
            Assert.Throws<ArgumentNullException>(() => ConnectionStringUtils.SplitDataSource(null));
        }

        [Fact]
        public void SplitDataSource_Rejects_Extra_Commasl()
        {
            Assert.Throws<ArgumentException>(() => ConnectionStringUtils.SplitDataSource("foo,bar,baz"));
        }

        [Theory]
        [InlineData("localhost,1433", "localhost", "1433")]
        [InlineData("localhost, 1433", "localhost", "1433")]
        [InlineData("localhost ,1433", "localhost", "1433")]
        [InlineData("localhost , 1433", "localhost", "1433")]
        [InlineData("localhost", "localhost", null)]
        [InlineData(", 1433", null, "1433")]
        [InlineData("    , 1433", null, "1433")]
        [InlineData("", null, null)]
        public void SplitDataSource_Works(string dataSource, string expectedHost, string expectedPort)
        {
            (string host, string port) = ConnectionStringUtils.SplitDataSource(dataSource);
            Assert.Equal(expectedHost, host);
            Assert.Equal(expectedPort, port);
        }

        [Fact]
        public void BuildConnectionStringFromAWSSecret_Rejects_Null_BaseString()
        {
            Assert.Throws<ArgumentNullException>(
                () => ConnectionStringUtils.BuildConnectionStringFromAWSSecret(null, new Dictionary<string, string>()));
        }

        [Fact]
        public void BuildConnectionStringFromAWSSecret_Rejects_Null_Secret()
        {
            Assert.Throws<ArgumentNullException>(
                () => ConnectionStringUtils.BuildConnectionStringFromAWSSecret("Data Source=localhost", null));
        }

        [Theory]
        [InlineData("Data Source=localhost,1433;Initial Catalog=sins;User ID=Cthon98;Password=12345;TrustServerCertificate=True;")]
        [InlineData("Data Source=localhost\\foobar")]
        [InlineData("")]
        public void BuildConnectionStringFromAWSSecret_SubsPasswordAndUserId_Correctly(string baseString)
        {
            Dictionary<string, string> secret = new Dictionary<string, string>();
            secret.Add("username", "AzureDiamond");
            secret.Add("password", "hunter2");

            string result = ConnectionStringUtils.BuildConnectionStringFromAWSSecret(baseString, secret);

            //minor differences in format would break roundtrippin the whole string (or make testing it like that to fragile)
            //so we use the builder ourselves to check the parts got modified or not as expected 
            SqlConnectionStringBuilder baseCsb = new SqlConnectionStringBuilder(result);
            SqlConnectionStringBuilder resultCsb = new SqlConnectionStringBuilder(result);
            Assert.Equal("AzureDiamond", resultCsb.UserID);
            Assert.Equal("hunter2", resultCsb.Password);
            //Following should be unchanged
            Assert.Equal(baseCsb.DataSource, resultCsb.DataSource);
            Assert.Equal(baseCsb.InitialCatalog, resultCsb.InitialCatalog);
            Assert.Equal(baseCsb.TrustServerCertificate, resultCsb.TrustServerCertificate);
        }

        [Theory]
        [InlineData("Data Source=localhost,1433;Initial Catalog=testdb;User ID=Cthon98;Password=foo;TrustServerCertificate=True;","myserver","1234","myserver, 1234")]
        [InlineData("Data Source=localhost,1433;Initial Catalog=testdb;User ID=Cthon98;Password=foo;TrustServerCertificate=True;", "myserver", null, "myserver, 1433")]
        [InlineData("Data Source=localhost,1433;Initial Catalog=testdb;User ID=Cthon98;Password=bar;TrustServerCertificate=True;", null, "1234", "localhost, 1234")]
        [InlineData("Data Source=localhost,1433;Initial Catalog=testdb;User ID=Cthon98;Password=baz;TrustServerCertificate=True;", null, null, "localhost,1433")] //note lack of space - here it shouldn't change the DS at all
        public void BuildConnectionStringFromAWSSecret_SubsDataSource_Correctly(string baseString, string host, string port, string expectedDataSource)
        {
            Dictionary<string, string> secret = new Dictionary<string, string>();
            if(host!=null) 
                secret.Add("host", host);
            if(port != null)
                secret.Add("port", port);

            string result = ConnectionStringUtils.BuildConnectionStringFromAWSSecret(baseString, secret);

            //minor differences in format would break roundtrippin the whole string (or make testing it like that to fragile)
            //so we use the builder ourselves to check the parts got modified or not as expected 
            SqlConnectionStringBuilder baseCsb = new SqlConnectionStringBuilder(result);
            SqlConnectionStringBuilder resultCsb = new SqlConnectionStringBuilder(result);
            Assert.Equal(expectedDataSource, resultCsb.DataSource);
            //Following should be unchanged
            Assert.Equal(baseCsb.UserID, resultCsb.UserID);
            Assert.Equal(baseCsb.Password, resultCsb.Password);
            Assert.Equal(baseCsb.InitialCatalog, resultCsb.InitialCatalog);
            Assert.Equal(baseCsb.TrustServerCertificate, resultCsb.TrustServerCertificate);
        }

    }
}
