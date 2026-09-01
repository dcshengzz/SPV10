using swz.SurveyPlus.IntranetApplication;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestTimeoutSettings
    {
        [Fact]
        public void Getters_Return_Expected_Values()
        {
            TimeoutSettings settings = new TimeoutSettings(timeoutSeconds: 9.7d);
            Assert.Equal(9.7d, settings.TimeoutSeconds, 0.0001d);
            Assert.Equal(9700, settings.TimeoutMilliseconds);
            Assert.Equal(10, settings.TimeoutSecondsRoundedUp);
        }
    }
}