#pragma warning disable 1591
namespace swz.Clover.Core.ORM
{
    public class ChangePart
    {
        public string PropertyName { get; set; }
        public object NewValue { get; set; }
        public object InitialValue { get; set; }
    }
}
