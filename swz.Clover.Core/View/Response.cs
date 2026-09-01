using System;
using System.Collections.Generic;
using System.Linq;

namespace swz.Clover.Core.View
{
    public class ListSuccessResponse<TItem> 
    {
        public ListSuccessResponse(List<TItem> items)
        {
            Items = items;
            Success = true;
        }

        public List<TItem> Items { get; }
        public bool Success { get; }
    }

    public class ItemSuccessResponse<TItem>
    {
        public ItemSuccessResponse(TItem item)
        {
            Item = item;
            Success = true;
        }

        public ItemSuccessResponse(TItem item, string message)
        {
            Item = item;
            Success = true;
            Message = message;
        }

        public TItem Item { get; }
        public bool Success { get; }
        public long Count { get; set; }
        public string Message { get; }
    }

    public class SuccessResponse
    {
        public SuccessResponse()
        {
            Success = true;
        }

        public SuccessResponse(string message)
        {
            Message = message;
            Success = true;
        }

        public string Message { get; }

        public bool Success { get; }
    }


    public class FailResponse
    {
        private const string KEY_SUCCESS = "success";
        private const string KEY_MESSAGE = "message";
        private const string KEY_DETAILS = "details";

        private FailResponse()
        {}
     
        
        public FailResponse(string message)
        {
            Message = message;
            Details = string.Empty;
            Success = false;
        }
        
        /// <summary>
        /// Construct instance with message and details.
        /// For security reasons you should not use the details to return sensitive details like stacktraces to clients.
        /// (Can depend on their level of authorisation though).
        /// </summary>
        /// <param name="message"></param>
        /// <param name="details"></param>
        public FailResponse(string message, string details)
        {
            Message = message;
            Details = details;
            Success = false;
        }

        public string Message { get; private set;  }

        public string Details { get; private set; }

        public bool Success { get; private set; }

        public static bool IsFailResponse(DynamicEntity entity, out FailResponse fail)
        {
            if (entity == null)
                throw new ArgumentNullException(nameof(entity));

            fail = null;

            if (!entity.Dictionary.Keys.Contains(KEY_SUCCESS, StringComparer.OrdinalIgnoreCase))
                return false;

            fail = new FailResponse();
            fail.Success = false;

            if ((bool)entity.Dictionary[KEY_SUCCESS])
                return false;


            if (!entity.Dictionary.Keys.Contains(KEY_MESSAGE, StringComparer.OrdinalIgnoreCase))
                return false;
            
            fail.Message = entity.Dictionary[KEY_MESSAGE]?.ToString();


            if (!entity.Dictionary.Keys.Contains(KEY_DETAILS, StringComparer.OrdinalIgnoreCase))
                return false;
            
            fail.Details = entity.Dictionary[KEY_DETAILS]?.ToString();

            return true;
        }
    }
    
  
}
