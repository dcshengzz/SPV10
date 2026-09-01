using swz.Clover.Core.Utils;
using System;
using System.Collections.Generic;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestHardwareInfo
    {
        [Fact]
        public void CanGetValue()
        {
            string fingerprint = HardwareInfo.Value();
            Assert.False(string.IsNullOrWhiteSpace(fingerprint));
        }

        [Fact]
        public void CanGetHardwareSignature()
        {
            string signature = HardwareInfo.HardwareSignature();
            Assert.False(string.IsNullOrWhiteSpace(signature));
        }

        public class ChainedPropertyComparatorTests
        {
            private readonly List<Tuple<string, object>> x, y, noBaz, aardvark, zebra;
            private readonly HardwareInfo.ChainedPropertyStringComparator fooBarBazComparator, animalComparator;

            public ChainedPropertyComparatorTests()
            {
                x = new List<Tuple<string, object>>();
                x.Add(new Tuple<string, object>("Foo", "Hello"));
                x.Add(new Tuple<string, object>("Bar", "World"));
                x.Add(new Tuple<string, object>("Baz", "B"));

                y = new List<Tuple<string, object>>();
                y.Add(new Tuple<string, object>("Foo", "Hello"));
                y.Add(new Tuple<string, object>("Bar", "World"));
                y.Add(new Tuple<string, object>("Baz", "A"));

                noBaz = new List<Tuple<string, object>>();
                noBaz.Add(new Tuple<string, object>("Foo", "Hello"));
                noBaz.Add(new Tuple<string, object>("Bar", "World"));

                fooBarBazComparator
                    = new HardwareInfo.ChainedPropertyStringComparator("Foo",
                        new HardwareInfo.ChainedPropertyStringComparator("Bar",
                            new HardwareInfo.ChainedPropertyStringComparator("Baz", null)));

                aardvark = new List<Tuple<string, object>>();
                aardvark.Add(new Tuple<string, object>("Animal", "Aardvark"));

                zebra = new List<Tuple<string, object>>();
                zebra.Add(new Tuple<string, object>("Animal", "Zebra"));

                animalComparator
                    = new HardwareInfo.ChainedPropertyStringComparator("Animal", null);
            }

            [Theory]
            [InlineData(null)]
            [InlineData("")]
            public void ConstructorRejectsInvalidPropertyName(string property)
            {
                Assert.ThrowsAny<ArgumentException>(
                    () => new HardwareInfo.ChainedPropertyStringComparator(property, null) );
            }

            [Fact]
            public void WithSingleComparison_aardvarkLTZebra()
            {
                Assert.True(animalComparator.Compare(aardvark, zebra) < 0);
            }

            [Fact]
            public void WithSingleComparison_zebraGTaardvark()
            {
                Assert.True(animalComparator.Compare(zebra, aardvark) > 0);
            }

            [Fact]
            public void WithSingleComparison_zebraEQzebra()
            {
                Assert.True(animalComparator.Compare(zebra, zebra) == 0);
            }

            [Fact]
            public void WithChainWalking_xGTy()
            {
                Assert.True(fooBarBazComparator.Compare(x, y) > 0);
            }

            [Fact]
            public void WithChainWalking_yLTx()
            {
                Assert.True(fooBarBazComparator.Compare(x, y) > 0);
                Assert.True(fooBarBazComparator.Compare(y, x) < 0);
            }

            [Fact]
            public void WithChainWalking_xEQx()
            {
                Assert.True(fooBarBazComparator.Compare(x, x) == 0);
            }

            [Fact]
            public void WithChainWalking_xgtNoBaz()
            {
                Assert.True(fooBarBazComparator.Compare(x, noBaz) > 0);
            }

            [Fact]
            public void WithChainWalking_noBazLTx()
            {
                Assert.True(fooBarBazComparator.Compare(noBaz, x) < 0);
            }

            [Fact]
            public void WithChainWalking_noBazEQNoBaz()
            {
                Assert.True(fooBarBazComparator.Compare(noBaz, noBaz) == 0);
            }
        }


        
    }
}
