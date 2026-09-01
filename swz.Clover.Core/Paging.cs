namespace swz.Clover.Core
{
    public class Paging
    {
        public long Skip { get; }

        public long Take { get; }

        private Paging()
        {
        }

        public Paging(long skip, long take)
        {
            Skip = skip;
            Take = take;
        }

        public static Paging Create(long skip, long take)
        {
            return new Paging(skip, take);
        }

        public static readonly Paging Empty = new Paging();
    }
}
