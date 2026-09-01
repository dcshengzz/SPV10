using swz.SurveyPlus.Application;
using System;
using System.IO;
using System.Collections.Generic;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestIndexingUtils
    {
        [Fact]
        public void IndexUniqueElements_Works_For_Unique_Elements()
        {
            {
                Assert.Empty(TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IndexUniqueElements(new string[] { }));
                Assert.Single(TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IndexUniqueElements(new string[] { "hello world" }));
            }

            {
                Dictionary<string, int> results
                    = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IndexUniqueElements(
                    new string[] { "foo", "bar", "baz" },
                    caseInsensitive: false);
                Assert.Equal(3, results.Count);
                Assert.Equal(0, results["foo"]);
                Assert.Equal(1, results["bar"]);
                Assert.Equal(2, results["baz"]);
                Assert.False(results.ContainsKey("FOO"));
                Assert.False(results.ContainsKey("bAR"));
                Assert.False(results.ContainsKey("Baz"));
            }

            {
                Dictionary<string, int> results
                    = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IndexUniqueElements(
                    new string[] { "foo", "bar", "baz" },
                    caseInsensitive: true);
                Assert.Equal(3, results.Count);
                Assert.Equal(0, results["foo"]);
                Assert.Equal(1, results["bar"]);
                Assert.Equal(2, results["baz"]);
                Assert.Equal(0, results["Foo"]);
                Assert.Equal(1, results["Bar"]);
                Assert.Equal(2, results["BAZ"]);
                Assert.Equal(2, results["bAz"]);
            }

            {
                Dictionary<string, int> results
                    = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IndexUniqueElements(
                    new string[] { " UID", " Username" },
                    caseInsensitive: true);
                Assert.Equal(2, results.Count);
                Assert.Equal(0, results[" UID"]);
                Assert.Equal(0, results[" uid"]);
                Assert.Equal(1, results[" userName"]);
            }
        }

        [Fact]
        public void IndexUniqueElements_Rejects_Bad_Arrays()
        {
            Assert.Throws<ArgumentNullException>(
                () => TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IndexUniqueElements(null));
            Assert.Throws<ElementNotUniqueException>(
                () => TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IndexUniqueElements(new string[] { "foo", "bar", "foo" }));
            Assert.Throws<ArgumentException>(
                () => TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IndexUniqueElements(new string[] { "foo", null, "baz" }));
        }
    }
}
