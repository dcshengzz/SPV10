using System;

namespace swz.AspNetCore.Identity.Anonymous
{
    internal class AnonymousIdData
    {
        internal string AnonymousId;
        internal DateTime ExpireDate;

        internal AnonymousIdData(string id, DateTime timeStamp)
        {
            AnonymousId = (timeStamp > DateTime.Now) ? id : null;
            ExpireDate = timeStamp;
        }
    }
}