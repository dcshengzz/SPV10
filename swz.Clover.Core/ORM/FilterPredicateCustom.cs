using System.Collections.Generic;

namespace swz.Clover.Core.ORM
{
    internal class FilterPredicateCustom
    {
        public string Criteria { get; set; }
        public Dictionary<string, object> Parameters { get; set; }
    }
}
