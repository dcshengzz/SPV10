using swz.SurveyPlus.IntranetApplication;
using System;
using System.Collections.Generic;
using System.Linq;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestSettingsWrapper
    {

        [Fact]
        public void Constructor_Rejects_Null()
        {
            Assert.Throws<ArgumentNullException>(() =>
            {
                new SettingsWrapper(null);
            });
        }

        [Fact]
        public void TryGetString_Works()
        {
            SettingsWrapper w = CreateTestInstance();
            Assert.True(w.TryGetString("Retries", out string actualRetries));
            Assert.Equal("99", actualRetries);

            Assert.True(w.TryGetString("Delay", out string actualDelay));
            Assert.Equal("2.5", actualDelay);

            Assert.True(w.TryGetString("Message", out string actualMessage));
            Assert.Equal("hello world!", actualMessage);

            Assert.True(w.TryGetString("Enabled", out string actualEnabled));
            Assert.Equal("True", actualEnabled);

            Assert.False(w.TryGetString("NoSuchSetting", out string _));

            Assert.Throws<ArgumentNullException>(() =>
            {
                w.TryGetString(null, out var _);
            });
        }

        [Fact]
        public void TryGetLong_Works()
        {
            SettingsWrapper w = CreateTestInstance();
            Assert.True( w.TryGetLong("Retries", out long actualRetries) );
            Assert.Equal(99L, actualRetries);

            Assert.False(w.TryGetLong("Delay", out long actualDelay));
            
            Assert.False( w.TryGetLong("Message", out long actualMessage) );

            Assert.False(w.TryGetLong("Enabled", out long actualEnabled));

            Assert.False(w.TryGetLong("NoSuchSetting", out long _));

            Assert.Throws<ArgumentNullException>(() =>
            {
                w.TryGetLong(null, out var _);
            });
        }

        [Fact]
        public void TryGetInt_Works()
        {
            SettingsWrapper w = CreateTestInstance();
            Assert.True(w.TryGetInt("Retries", out int actualRetries));
            Assert.Equal(99, actualRetries);

            Assert.False(w.TryGetInt("Delay", out int actualDelay));

            Assert.False(w.TryGetInt("Message", out int actualMessage));

            Assert.False(w.TryGetInt("Enabled", out int actualEnabled));

            Assert.False(w.TryGetInt("NoSuchSetting", out int _));

            Assert.Throws<ArgumentNullException>(() =>
            {
                w.TryGetInt(null, out var _);
            });
        }

        [Fact]
        public void TryGetDouble_Works()
        {
            SettingsWrapper w = CreateTestInstance();
            Assert.True(w.TryGetDouble("Retries", out double actualRetries));
            Assert.Equal(99D, actualRetries, 0); //testing with 0 decimal place tolerance

            Assert.True(w.TryGetDouble("Delay", out double actualDelay));
            Assert.Equal(2.5D, actualDelay, 0); //testing with 1 decimal place tolerance

            Assert.False(w.TryGetDouble("Message", out double actualMessage));

            Assert.False(w.TryGetDouble("Eabled", out double actualEnabled));

            Assert.False(w.TryGetDouble("NoSuchSetting", out double _));

            Assert.Throws<ArgumentNullException>(() =>
            {
                w.TryGetDouble(null, out var _);
            });
        }

        [Fact]
        public void TryGetBool_Works()
        {
            SettingsWrapper w = CreateTestInstance();
            Assert.False(w.TryGetBool("Retries", out bool actualRetries));

            Assert.False(w.TryGetBool("Delay", out bool actualDelay));

            Assert.False(w.TryGetBool("Message", out bool actualMessage));

            Assert.True(w.TryGetBool("Enabled", out bool actualEnabled));
            Assert.True(actualEnabled);

            Assert.False(w.TryGetBool("NoSuchSetting", out bool _));

            Assert.Throws<ArgumentNullException>(() =>
            {
                w.TryGetBool(null, out var _);
            });
        }

        [Fact]
        public void Indexer_Works()
        {
            SettingsWrapper w = CreateTestInstance();
            Assert.Equal("99", w["Retries"]);
            Assert.Equal("2.5", w["Delay"]);
            Assert.Equal("hello world!", w["Message"]);
            Assert.Equal("True", w["Enabled"]);
        }

        [Fact]
        public void Indexer_Throws_For_Missing()
        {
            SettingsWrapper w = CreateTestInstance();
            Assert.Throws<SettingsWrapper.SettingNotPresentException>(() =>
            {
                var _ = w["NoSuchSetting"];
            });
        }

        [Fact]
        public void Contains_Works()
        {
            SettingsWrapper w = CreateTestInstance();
            Assert.True(w.Contains("Retries"));
            Assert.True(w.Contains("Delay"));
            Assert.True(w.Contains("Message"));
            Assert.True(w.Contains("Enabled"));
            Assert.False(w.Contains("NoSuchSetting"));

            Assert.Throws<ArgumentNullException>(() =>
            {
                w.Contains(null);
            });
        }

        private SettingsWrapper CreateTestInstance()
        {
            Dictionary<string, string> data = new Dictionary<string, string>();
            data.Add("Retries", "99");
            data.Add("Delay", "2.5");
            data.Add("Message", "hello world!");
            data.Add("Enabled", "True");
            return new SettingsWrapper(data.ToLookup(p => p.Key, p => p.Value));
        }

    }
}
