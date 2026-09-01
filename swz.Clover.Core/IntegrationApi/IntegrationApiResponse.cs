using System;

namespace swz.Clover.Core.IntegrationApi
{
    public abstract class IntegrationApiResponse
    {
        public string Error { get; set; }
        public string Message { get; set; }
        public bool Success { get; set; }
        public object Data { get; set; }
    }
    
    public abstract class IntegrationApiResponse <T> : IntegrationApiResponse
    {
        //20231214 - this definition of Data has been hiding the one in the parent class. It is unclear if that was
        //           the original intent, but has been like this since the initial commit in 2018, so we shall deem it
        //           the correct behaviour and add an explicit 'new' so VS stops warning us about it.
        //See also: 
        //  https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/knowing-when-to-use-override-and-new-keywords
        //  https://stackoverflow.com/a/6576212/8243046
        public new T Data { get; set; }
    }
    
    public class IntegrationApiFailResponse : IntegrationApiResponse<object>
    {
        public IntegrationApiFailResponse(Exception ex)
        {
            //var info = ExceptionUtils.GetExceptionInfo(ex);
            //Error = info.Message;
            //var detailsBuilder = new StringBuilder();
            //detailsBuilder.Append("Exception:");
            //detailsBuilder.AppendLine(info.Exeptions);
            //detailsBuilder.AppendLine("StackTrace:");
            //detailsBuilder.AppendLine(info.StackTrace);
            //Message = detailsBuilder.ToString();
            //Success = false;
            //Data = null;

            //For security reasons we just return a generic error message to clients
            Message = $"An error occured, please check logs near {DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff zzz")} for details";
            Success = false;
            Data = null;
        }
    }

    public class IntegrationApiSuccessResponse<T> : IntegrationApiResponse<T>
    {
        public IntegrationApiSuccessResponse(T data)
        {
            Data = data;
            Success = true;
        }
    }
    
    
    
}