using System.Collections.Generic;

namespace swz.SurveyPlus.IdentityAccessManagement
{
    public class PatchOpBoolean
    {
        public IList<OperationBoolean> Operations { get; set; }
        public string reason { get; set; }
        public string userId { get; set; }
        public string groupId { get; set; }
    }

    public class OperationBoolean
    {
        public const string OPS_ADD = "Add";
        public const string OPS_REMOVE = "Remove";
        public const string OPS_REPLACE = "Replace";
        public string op { get; set; }
        public string path { get; set; }
        public bool value { get; set; }
    }
}
