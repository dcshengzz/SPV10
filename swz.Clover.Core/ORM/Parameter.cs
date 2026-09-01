namespace swz.Clover.Core.ORM
{
    public struct Parameter
    {
        public string Name { get; }

        public Parameter (string name) : this()
        {
            Name = name;
        }

        public override string ToString()
        {
            return CloverRuntime.DbProvider.ParameterPrefix + Name;
        }
    }
}
