using swz.SurveyPlus.IntranetApplication;
using System;
using System.Collections.Generic;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestExtensions
    {
        [Fact]
        public void GetNonEmptyStringValueOrDefault_Works()
        {
            {
                Dictionary<string, string> dictionary = new Dictionary<string, string>();
                dictionary.Add("size", "medium");
                dictionary.Add("weight", "");
                dictionary.Add("height", "      ");

                Assert.Equal("medium", dictionary.GetNonEmptyStringValueOrDefault("size"));
                Assert.Equal("medium", dictionary.GetNonEmptyStringValueOrDefault("size", "large"));

                Assert.Null(dictionary.GetNonEmptyStringValueOrDefault("weight"));
                Assert.Equal("heavy", dictionary.GetNonEmptyStringValueOrDefault("weight", "heavy"));

                Assert.Null(dictionary.GetNonEmptyStringValueOrDefault("colour"));
                Assert.Null(dictionary.GetNonEmptyStringValueOrDefault("colour", null));
                Assert.Equal("blue", dictionary.GetNonEmptyStringValueOrDefault("weight", "blue"));
            }

            {
                Dictionary<string, string> dictionary = null;
                Assert.Throws<NullReferenceException>(() => dictionary.GetNonEmptyStringValueOrDefault("foo"));
            }

            
        }
    }
}
