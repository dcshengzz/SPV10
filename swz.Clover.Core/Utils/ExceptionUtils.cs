using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace swz.Clover.Core.Utils
{
    public static class ExceptionUtils
    {
        public static HashSet<string> StacktraceItemsForRemove = new HashSet<string>()
        {
            "--- End of stack trace from previous location where exception was thrown ---",
            "at System.Threading.Tasks.ContinuationResultTaskFromResultTask",
            "at System.Threading.Tasks.Task",
            "at System.Threading.ExecutionContext.Run",
            "at System.Runtime.ExceptionServices",
            "at System.Runtime.CompilerServices.TaskAwaiter",
            "at System.Runtime.CompilerServices.ConfiguredTaskAwaitable",
        };

        //I would like to correct this old spelling error in Exeptions, but as this is a tuple, that also means fixing code that depends on it
        public static (string Message, string Exeptions, string StackTrace) GetExceptionInfo(Exception ex)
        {
            string message;
            var currentException = ex;
            var exceptionBuilder = new StringBuilder();
            var stacktraceBuilder = new StringBuilder();
            var stackTraces = new List<string>();
            
            
            string delimeter = string.Empty;
            do
            {
                message = currentException.Message;
                var formattableString = $"{delimeter}({currentException.GetType().Name}){currentException.Message}";
                exceptionBuilder.AppendLine(formattableString);
                //n.b StackTrace element we add to the list will be null if this exception has no stacktrace
                stackTraces.Add(currentException.StackTrace); 
                delimeter = delimeter == String.Empty ? "->" : $"-{delimeter}";
                currentException = currentException.InnerException;
            } while (currentException != null);

            var isFirst = true;
            
            foreach (string st in stackTraces.AsEnumerable().Reverse())
            {
                //st will be null if the exception it came from doesn't have a stacktrace
                string[] splittedSt = (st == null) 
                    ? new string[] { } 
                    : st.Split(new[] { "\r\n" }, StringSplitOptions.None);

                var filteredSt = splittedSt.Where(str =>
                {
                    var tr = str.Trim();
                    return !StacktraceItemsForRemove.Any(i => tr.StartsWith(i));
                });
                
                if (!isFirst)
                {
                    stacktraceBuilder.AppendLine("----------");
                    
                }
                isFirst = false;
                foreach (var filtered in filteredSt)
                {
                   stacktraceBuilder.AppendLine(filtered);
                }
            }
            
            

            return (message, exceptionBuilder.PrepareString(), stacktraceBuilder.PrepareString());
        }

        private static string PrepareString(this StringBuilder sb)
        {
           return sb.ToString().TrimEnd("\r\n".ToCharArray());
        }
    }
}