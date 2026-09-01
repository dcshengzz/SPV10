using QRCoder;

namespace swz.Clover.Core.Utils
{
    public static class QRCodeUtils
    {
        public static byte[] GenerateQrCodePng(string code, int pixelsPerModule = 5)
        {
            //See: https://github.com/codebude/QRCoder/issues/354
            QRCodeGenerator qrGenerator = new QRCodeGenerator();
            QRCodeData qrCodeData = qrGenerator.CreateQrCode(code, QRCodeGenerator.ECCLevel.Q);
            PngByteQRCode qrCode = new PngByteQRCode(qrCodeData);
            return qrCode.GetGraphic(pixelsPerModule);
        }

    }
}
