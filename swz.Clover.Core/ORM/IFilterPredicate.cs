using swz.Clover.Core.Model;

namespace swz.Clover.Core.ORM
{
    public interface IFilterPredicate
    {
        string Build(object value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string Build(object value, string property, FilterPurpose purpose, string tableAlias);
        bool IsLike { get; }
    }
}
