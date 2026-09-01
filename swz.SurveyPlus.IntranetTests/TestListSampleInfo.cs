using Newtonsoft.Json;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Dynamic;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestListSampleInfo
    {
        private ExpandoObject TestData(int i)
        {
            //fyi - using an ExpandoObject because if use an anonymous class it doesn't work outside the assembly
            //      see: https://stackoverflow.com/questions/2630370/c-sharp-dynamic-cannot-access-properties-from-anonymous-types-declared-in-anot
            dynamic source = new ExpandoObject();

            source.Id = Guid.Parse("3e0b48eb-2529-478a-a8fb-0b1a8adc48c0");
            source.RestrictIp = (i==0) ? true : false;
            source.RestrictIpInclusive = true;
            source.IpCountry = (i==0) ? "Singapore" : null; //TODO - better test values
            source.IpRange = (i==0) ? "127.0.0.1" : null; //TODO - better test values
            source.IsAnonymous = true;
            source.IsMultipleResponse = true;
            source.RequireAccessCode = true;
            source.VisibleToRespondent = true;
            source.UID = (i==0) ? "ABC001" : "ABC002";
            source.DplyStatus = true;
            source.QnnStatus = true;
            source.DplyIsDeleted = true;
            source.QnnIsDeleted = true;
            source.QnnType = 'O';
            source.FormNames = "Foo,Bar,Baz";
            source.QnnId = Guid.Parse("270d8ad1-9e02-4de7-9989-9f2a0686706e");
            source.DplyId = Guid.Parse("9d136b75-14cd-415e-a65f-2da76fe54929");
            source.ListSampleId = Guid.Parse("969d7102-7a69-457d-954e-6b39a92c592c");
            source.ListId = Guid.Parse("6fa2934f-e401-44e8-b2e8-00a8696e3db5");
            source.SampleId = Guid.Parse("c2dda7e3-6a6b-444d-a67e-663c380e80f1");
            source.Status = QnnStatusId.InProgress.Value;
            source.DaysUpdate = (i==0) ? (int?)42 : null;
            source.DueDate = (i==0) ? (DateTime?)DateTime.Now : null;
            source.MaxResponse = (i==0) ? (int?)1000 : null;
            source.UIDName = "Test Sample"; //todo - use format the view makes here 
            source.QnnTitle = "Test Survey";
            source.Remarks = (i == 0) ? "Lovely weather we're having" : null;
            source.IsExcelEnabled = true;
            source.CompleteURL = (i == 0) ? "http://www.softworkz.net/" : null;
            //Please add new fields both here and in AssertMatchesSource when they are added to ListSampleInfo and run the test!

            return source;
        }

        //TODO need another source with some nulls in columns that have that

        private void AssertMatchesSource(dynamic source, ListSampleInfo lsi)
        {
            Assert.Equal((Guid)source.Id, lsi.Id);
            Assert.Equal((bool)source.RestrictIp, lsi.IPRules.RestrictIp);
            Assert.Equal((bool)source.RestrictIpInclusive, lsi.IPRules.RestrictIpInclusive);
            Assert.Equal((string)source.IpCountry, lsi.IPRules.IpCountry);
            Assert.Equal((string)source.IpRange, lsi.IPRules.IpRange);
            Assert.Equal((bool)source.IsAnonymous, lsi.IsAnonymousSurvey);
            Assert.Equal((bool)source.IsMultipleResponse, lsi.IsMultipleResponse);
            Assert.Equal((bool)source.RequireAccessCode, lsi.RequireAccessCode);
            Assert.Equal((bool)source.IsAnonymous, lsi.IsAnonymousSurvey);
            Assert.Equal((bool)source.IsMultipleResponse, lsi.IsMultipleResponse);
            Assert.Equal((bool)source.RequireAccessCode, lsi.RequireAccessCode);
            Assert.Equal((bool)source.VisibleToRespondent, lsi.VisibleToRespondent);
            Assert.Equal((string)source.UID, lsi.UID);
            //Assert.Equal(source.DplyStatus, lsi.DplyStatus); //currently is private, think we should expose it
            //Assert.Equal(source.QnnStatus, lsi.QnnStatus);
            //Assert.Equal(source.DplyIsDeleted, lsi.DplyIsDeleted);
            //Assert.Equal(source.QnnIsDeleted, lsi.IsDeleted);
            //Assert.Equal(source.QnnType, lsi.QnnType);
            //Assert.Equal(source.FormNames, lsi.FormNames);
            Assert.Equal((Guid)source.QnnId, lsi.QnnId);
            Assert.Equal((Guid)source.DplyId, lsi.DplyId);
            Assert.Equal((Guid)source.ListSampleId, lsi.ListSampleId);
            Assert.Equal((Guid)source.ListId, lsi.ListId);
            Assert.Equal((Guid)source.SampleId, lsi.SampleId);
            Assert.Equal((Guid)source.Status, lsi.Status.Value);
            int expectedDaysUpdate = ((int?)source.DaysUpdate) == null ? Constants.Unlimited : (int)source.DaysUpdate;
            Assert.Equal(expectedDaysUpdate, lsi.DaysUpdate);
            DateTime expectedDueDate = ((DateTime?)source.DueDate) == null ? DateTime.MaxValue : (DateTime)source.DueDate;
            Assert.Equal(expectedDueDate, lsi.DueDate);
            int expectedMaxResponse = ((int?)source.MaxResponse) == null ? Constants.Unlimited : (int)source.MaxResponse;
            Assert.Equal(expectedMaxResponse, lsi.MaxResponse);
            Assert.Equal((string)source.UIDName, lsi.UIDName);
            Assert.Equal((string)source.QnnTitle, lsi.QnnTitle);
            Assert.Equal((string)source.Remarks, lsi.Remarks); //TODO - should this be shared with UI? NO RIGHT?
            Assert.Equal((bool)source.IsExcelEnabled, lsi.IsExcelEnabled);
            Assert.Equal((string)source.CompleteURL, lsi.CompleteURL);
            //TODO ...
            //Please add new fields both here and in TestData when they are added to ListSampleInfo and run the test!
        }

        [Theory]
        [InlineData(0)]
        [InlineData(1)]
        public void Can_Construct_FromDynamic(int index)
        {
            dynamic source = TestData(index);
            ListSampleInfo lsi = ListSampleInfo.FromDynamic(source);
            AssertMatchesSource(source, lsi);
        }

        /// <summary>
        /// Test converting a dictionary with source data (such as from a DynamicEntity) to JSON
        /// and then using that to create a ListSampleInfo. This is the way our u@app endpoint works
        /// so we test it here.
        /// </summary>
        [Theory]
        [InlineData(0)]
        [InlineData(1)]
        public void Test_JSON_to_Dictionary_To_ListSampleInfo(int index)
        {
            ExpandoObject source = TestData(index);
            IDictionary<string, object> dict = source;

            string json = JsonConvert.SerializeObject(dict);
            dynamic dm = JsonConvert.DeserializeObject(json);
            ListSampleInfo lsi = ListSampleInfo.FromDynamic(dm);

            AssertMatchesSource(source, lsi);

        }
    }
}
