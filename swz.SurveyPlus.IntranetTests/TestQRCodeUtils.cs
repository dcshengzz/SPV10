using swz.Clover.Core.Utils;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestQRCodeUtils
    {
        [Fact]
        public void Can_Generate_QR_Code()
        {
            byte[] qrCode = QRCodeUtils.GenerateQrCodePng("Hello World");
            Assert.NotNull(qrCode);
            Assert.True(qrCode.Length > 0);
        }
    }
}
