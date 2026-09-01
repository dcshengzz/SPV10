
using System;

namespace swz.SurveyPlus.IdentityAccessManagement
{
    internal class Constants
    {
        //TODO - capitalise name as per C# convention, also why is it a property and not a constant?
        public static String dateFormat
        {
            get
            {//"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'"
                return "yyyy-MM-dd'T'HH:mm:ss.fff'Z'";
            }
        }
    }
}