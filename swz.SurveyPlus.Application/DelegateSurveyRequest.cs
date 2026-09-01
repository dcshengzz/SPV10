using Newtonsoft.Json;
using System;

namespace swz.SurveyPlus.Application
{
    // // // // // // // // // // // // // // // // // // // // // // // //
    //NOTE: this object is intended to be immutable. Do not add setters. //
    // // // // // // // // // // // // // // // // // // // // // // // //

    public class DelegateSurveyRequest
    {
        public Guid QnnDplySampleInfoId { get; private set; }
        public string Email { get; private set; }
        public DateTime ValidityStart { get; private set; }
        public DateTime ValidityEnd { get; private set; }
        public string Comments { get; private set; }
        public string Name { get; private set; }
        public string DelegateFromName { get; private set; }        

        [JsonConstructor]
        public DelegateSurveyRequest(
            Guid qnnDplySampleInfoId,
            string email,
            DateTime validityStart,
            DateTime validityEnd,
            string comments,
            string name,
            string delegateFromName)
        {
            //Note: Newtonsoft will also use this constructor when deserialising. The arguments need
            //      need to match the properties (that come in the json), although first letter casing
            //      is not sensitive.
            //For more info: https://stackoverflow.com/a/30899593/8243046

            if (Guid.Empty.Equals(qnnDplySampleInfoId)) throw new ArgumentException(nameof(qnnDplySampleInfoId));
            if (string.IsNullOrWhiteSpace(email)) throw new ArgumentException(nameof(email));
            if (validityStart >= validityEnd) throw new ArgumentException(nameof(validityStart));
            if (string.IsNullOrEmpty(email) || !swz.Clover.Core.Utils.Email.IsAddressFormatValid(email)) throw new ArgumentException(nameof(email));
            if (string.IsNullOrWhiteSpace(name)) throw new ArgumentException(nameof(name));
            if (string.IsNullOrWhiteSpace(delegateFromName)) throw new ArgumentException(nameof(delegateFromName));

            this.QnnDplySampleInfoId = qnnDplySampleInfoId;
            this.Email = email;
            this.ValidityStart = validityStart;
            this.ValidityEnd = validityEnd;
            this.Comments = (comments == null) ? "" : comments;
            this.Name = name;
            this.DelegateFromName = delegateFromName;
        }

        public override string ToString()
        {
            return $"{nameof(DelegateSurveyRequest)}[QnnDplySampleInfoId={QnnDplySampleInfoId}, Email={Email}, ValidityStart={ValidityStart}, ValidityEnd={ValidityEnd} ...]";
        }
    }
}
