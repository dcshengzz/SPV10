using swz.SurveyPlus.IntranetApplication;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestRetrySettings
    {
        [Fact]
        public void Getters_Return_Expected_Values()
        {
            RetrySettings settings = new RetrySettings(retries: 2, baseRetryDelaySeconds: 5.2d);
            Assert.Equal(5.2d, settings.BaseRetryDelaySeconds, 0.0001d);
            Assert.Equal(5200, settings.BaseRetryDelayMilliseconds);
        }
    }
}
