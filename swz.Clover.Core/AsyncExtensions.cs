using System;
using System.Diagnostics;
using System.Text;
using System.Threading.Tasks;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core
{
    public static class AsyncExtensions
    {
        public static async void FireAndForget(this Func<Task> task, Action success = null, Action<Exception> fail = null)
        {
            try
            {
                await Task.Run(task);
                success?.Invoke();
            }
            catch (Exception e)
            {
                fail?.Invoke(e);
            }
        }
        
     
        public static void FireAndForgetWithDefaultExceptionLogger(this Func<Task> task)
        {
            FireAndForget(task, fail: LogException);
        }
        
     

        private static void LogException(Exception e)
        {
            if (Debugger.IsAttached)
            {
                var info = ExceptionUtils.GetExceptionInfo(e);
                var errorBuilder = new StringBuilder();
                errorBuilder.AppendLine("Unhandled exception.");
                errorBuilder.AppendLine($"Message: {info.Message}");
                errorBuilder.AppendLine($"Exceptions: {info.Exeptions}");
                errorBuilder.Append($"StackTrace: {info.StackTrace}");
                Debug.WriteLine(errorBuilder);
            }
        }
    }
}