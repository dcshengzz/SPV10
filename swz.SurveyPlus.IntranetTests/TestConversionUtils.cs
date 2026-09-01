using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Globalization;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestConversionUtils
    {
        [Theory]
        [InlineData(null)]
        [InlineData("hello I am not guid")]
        [InlineData("g01649fc-090d-4685-a5a4-83cf8b21a94b")] //the word guid starts with a g, but the guid itself doesnt :p
        [InlineData("9935cfaf6b7248c4a8fbe0613bc2d2f6ffffff")] //too long!
        [InlineData("9935cfaf6b7248c4a8fbe0613bc")] //too short!
        [InlineData("bc37a0075a4345379c793f90606151ef,,182fb015-f4ba-4433-a43e-2f4de79aff7d")] //missing elements are NOT ok
        [InlineData(",")] //missing elements are NOT ok
        [InlineData("f01649fc-090d-4685-a5a4-83cf8b21a94b,")] //missing elements are NOT ok
        [InlineData(",f01649fc-090d-4685-a5a4-83cf8b21a94b")] //missing elements are NOT ok
        public void TryParseCommaDelimitedGuids_Rejects_Invalid_Guid_Strings(string s)
        {
            Assert.False(ConversionUtils.TryParseCommaDelimitedGuids(s, out List<Guid> guids));
            Assert.Empty(guids);
        }

        [Theory]
        [InlineData("", 0)] //Empty list is ok (result is an empty guid list)
        [InlineData(" ", 0)] //Whitespace is fine too
        [InlineData("              \n \r", 0)] //eggregiously so...
        [InlineData("f01649fc-090d-4685-a5a4-83cf8b21a94b", 1)]
        [InlineData("9935cfaf6b7248c4a8fbe0613bc2d2f6", 1)]
        [InlineData("  D1478D14FFB9457AA47F9CE4B45DD424     ", 1)]
        [InlineData("0183054675404c46bbad6897b1208f90,497065d77fe84cfaba0b926c8da85c26,ec9ea06da50d4b8baefe15aac3c90b24", 3)]
        [InlineData(" 569b2308-e8b8-4937-a44f-7d9d03c4c742, dd54d3c0-7dc9-492c-9e94-e61f0dffd911, 599205FD6DDA45EDAFE3C9D3688F55F8  ", 3)]
        public void TryParseCommaDelimitedGuids_Accepts_Valid_Guid_Strings(string s, int expectedCount)
        {
            Assert.True(ConversionUtils.TryParseCommaDelimitedGuids(s, out List<Guid> guids));
            Assert.Equal(expectedCount, guids.Count);
        }

        [Theory]
        [InlineData(Constants.ConstYesNo.True)]
        [InlineData(Constants.ConstYesNo.Yes)]
        [InlineData("true")]
        [InlineData("True")]
        [InlineData("y")]
        public void IsTrueYN_Returns_True_For_Truthy_Values(string value)
        {
            Assert.True(ConversionUtils.IsTrueYN(value));
        }

        [Theory]
        [InlineData(Constants.ConstYesNo.False)]
        [InlineData(Constants.ConstYesNo.No)]
        [InlineData("false")]
        [InlineData("fALse")]
        [InlineData("n")]
        public void IsTrueYN_Returns_False_For_Falsy_Values(string value)
        {
            Assert.False(ConversionUtils.IsTrueYN(value));
        }

        [Fact]
        public void IsTrueYN_Throws_ANE_For_Null()
        {
            Assert.Throws<ArgumentNullException>(() => ConversionUtils.IsTrueYN(null));
        }

        [Theory]
        [InlineData("Yes")]
        [InlineData("No")]
        [InlineData("Nope")]
        [InlineData("Nah")]
        [InlineData("Maybe")]
        [InlineData("Yeah")]
        [InlineData("")]
        [InlineData("1")]
        [InlineData("0")]
        [InlineData("True ")] //no whitespace accepted
        [InlineData(" FALSE")] //no whitespace accepted
        public void IsTrueYN_Throws_FormatException_For_Invalid_Values(string value)
        {
            Assert.Throws<FormatException>(() => ConversionUtils.IsTrueYN(value));
        }

        [Theory]
        [InlineData(Constants.ConstYesNo.True)]
        [InlineData(Constants.ConstYesNo.Yes)]
        [InlineData("true")]
        [InlineData("True")]
        [InlineData("y")]
        [InlineData(Constants.ConstYesNo.False)]
        [InlineData(Constants.ConstYesNo.No)]
        [InlineData("false")]
        [InlineData("fALse")]
        [InlineData("n")]
        public void IsValidTrueYN_Returns_True_For_Valid_Values(string value)
        {
            Assert.True(ConversionUtils.IsValidTrueYN(value));
        }

        [Theory]
        [InlineData(null)]
        [InlineData("")]
        [InlineData(" ")]
        [InlineData("Yes")]
        [InlineData("No")]
        [InlineData("Nope")]
        [InlineData("Nah")]
        [InlineData("Maybe")]
        [InlineData("Yeah")]
        [InlineData("1")]
        [InlineData("0")]
        [InlineData("True ")] //whitespace isnt valid
        [InlineData(" FALSE")] //whitespace isnt valid
        public void IsValidTrueYN_Returns_False_For_Invalid_Values(string value)
        {
            Assert.False(ConversionUtils.IsValidTrueYN(value));
        }

        [Theory]
        [InlineData(0, 0)]
        [InlineData(1, 1)]
        [InlineData(29000, 1)]
        [InlineData(59999, 1)]
        [InlineData(60001, 2)]
        [InlineData(172800000, 2880)] //48hours
        [InlineData(172801000, 2881)] //48hours and 1 second
        public void ToRoundedUpMinutes(long milliseconds, int expectedMinutes)
        {
            int minutes = ConversionUtils.ToMinutesRoundedUp(milliseconds);
            Assert.Equal(expectedMinutes, minutes);
        }

        [Fact]
        public void ToRoundedUpMinutes_Rejects_Negatives()
        {
            Assert.Throws<ArgumentException>(() => ConversionUtils.ToMinutesRoundedUp(-123));
        }

        [Theory]
        [InlineData("1970-01-01 00:00:00", "1970-01-01 00:00:00")]
        [InlineData("2022-11-12 15:48:50", "2022-11-12 15:48:50")]
        [InlineData("2022-11-12 15:48", "2022-11-12 15:48:00")]
        [InlineData("28/9/2023 2:40:37 pm", "2023-09-28 14:40:37")]
        [InlineData("10/1/2023 16:57", "2023-01-10 16:57:00")]
        [InlineData("2024-07-28", "2024-07-28 00:00:00")]
        [InlineData("28/7/2024", "2024-07-28 00:00:00")]
        //with whitespace
        [InlineData(" 1970-01-01 00:00:00", "1970-01-01 00:00:00")]
        [InlineData(" 2022-11-12    15:48:50  ", "2022-11-12 15:48:50")]
        [InlineData("28/9/2023 2:40:37 pm    ", "2023-09-28 14:40:37")]
        [InlineData("10/1/2023\n16:57", "2023-01-10 16:57:00")]
        public void ConvertToDateTimeUsingHeuristics_Works_For_Known_Formats(string dateString, string expectedString)
        {
            //Will be in local timezone, as will result from method we are testing
            DateTime expected = DateTime.ParseExact(expectedString, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
            DateTime? actual = ConversionUtils.ConvertToDateTimeUsingHeuristics(dateString);
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void ConvertToDateTimeUsingHeuristics_Returns_Null_For_Null_Or_Empty()
        {
            Assert.Null(ConversionUtils.ConvertToDateTimeUsingHeuristics(null));
            Assert.Null(ConversionUtils.ConvertToDateTimeUsingHeuristics(""));
            Assert.Null(ConversionUtils.ConvertToDateTimeUsingHeuristics(" "));
            Assert.Null(ConversionUtils.ConvertToDateTimeUsingHeuristics("     \t  \n "));
        }

        [Theory]
        [InlineData("I am a teapot")]
        [InlineData("2024-07-28 18")]
        [InlineData("12345678")]
        [InlineData("5/27/2026 5:30")] //Myanmar+USA format not supported
        [InlineData("7/28/2024")]      //Myanmar+USA format not supported
        [InlineData("1970-31-12 23:59:59")]
        [InlineData("19:09")] //time-only NOT supported at present
        [InlineData("2:40:37 pm")] //time-only NOT supported at present
        [InlineData("12,13,14")]
        [InlineData("42")]
        public void ConvertToDateTimeUsingHeuristics_Fails_For_Unknown_Formats(string dateString)
        {
            Assert.Throws<FormatException>(() => ConversionUtils.ConvertToDateTimeUsingHeuristics(dateString));
        }
    }
}
