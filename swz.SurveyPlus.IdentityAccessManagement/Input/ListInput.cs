namespace swz.SurveyPlus.IdentityAccessManagement
{
    public class ListInput
    {
        public string filter { get; set; }
        public int startIndex { get; set; }
        public int itemsPerPage { get; set; }
        public string ascOrderBy { get; set; }
        public string descOrderBy { get; set; }
    }
}
