using swz.SurveyPlus.Application;
using System;
using System.IO;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestFileUtils
    {
        [Theory]
        [InlineData("readme.txt")]
        [InlineData("hello")]
        [InlineData("hello.foo.bar")]
        public void CombineWithPath_Accepts_Plain_Filename(string filename)
        {
            FileUtils.CombineWithPath("C:/www", filename);
        }

        [Theory]
        [InlineData("C:\\Windows\\System32\\drivers\\etc\\hosts")]
        [InlineData("C:/Windows/System32/drivers/etc/hosts")]
        [InlineData("\\smb.example.com")]
        [InlineData("foo/bar")]
        [InlineData("../foo")]
        [InlineData("xyz/../../foo")]
        [InlineData("./foo")]
        public void CombineWithPath_Rejects_Filename_With_Path(string filename)
        {
            Assert.ThrowsAny<ArgumentException>(() =>
                FileUtils.CombineWithPath("C:/www", filename));
        }

        [Fact]
        public void CombineWithPath_Returns_Filename_If_Path_Null()
        {
            string filename = "fluffy_kitten.png";
            Assert.Equal(filename, FileUtils.CombineWithPath(null, filename));
        }

        [Fact]
        public void CombineWithPath_Returns_Filename_If_Path_Empty()
        {
            string filename = "fluffy_kitten.png";
            Assert.Equal(filename, FileUtils.CombineWithPath("", filename));
        }

        [Theory]
        [InlineData(" ")]
        [InlineData("\t")]
        [InlineData("\n")]
        [InlineData("    ")]
        [InlineData(" \t \n  ")]
        public void CombineWithPath_Fails_If_Path_Whitespace(string path)
        {
            Assert.ThrowsAny<ArgumentException>(() =>
                FileUtils.CombineWithPath(path, "test.jpg"));
        }

        [Theory]
        [InlineData("c:/", "windows")]
        [InlineData("c:/windows/system32/drivers/etc", "hosts")]
        public void CombineWithPath_Gives_Same_Result_As_PathDotCombine_For_Valid_Input(string path, string filename)
        {
            string expected = Path.Combine(path, filename);
        }

        [Theory]
        [InlineData("archive.zip", Constants.ContentTypes.ZipFileType)]
        [InlineData("archive.7z", Constants.ContentTypes.SevenZipFileType)]
        [InlineData("readme.txt", Constants.ContentTypes.TextFileType)]
        [InlineData("foo.bar.txt", Constants.ContentTypes.TextFileType)]
        [InlineData("hello.csv", Constants.ContentTypes.CsvFileType)]
        [InlineData("chickens.xlsx", Constants.ContentTypes.XlsxFileType)]
        [InlineData("index.html", Constants.ContentTypes.HtmlFileType)]
        [InlineData("index.htm", Constants.ContentTypes.HtmlFileType)]
        [InlineData("mail merge thing.pdf", Constants.ContentTypes.PdfFileType)]
        [InlineData("no extension", Constants.ContentTypes.UnknownApplicationType)]
        [InlineData("unknownextension.wtf", Constants.ContentTypes.UnknownApplicationType)]
        public void Test_GuessContentType(string filename, string expected)
        {
            string actual = FileUtils.GuessContentType(filename);
            Assert.Equal(expected, actual);
        }
    }
}
