using System.Collections.Generic;

namespace swz.Clover.Core.Model
{
    public class FormDataMapping
    {
        public Dictionary<string,object> ToData { get; }
        public Dictionary<string,object> ToForm { get; }

        public FormDataMapping()
        {
            ToData = new Dictionary<string, object>();
            ToForm = new Dictionary<string, object>();
        }
    }
}
