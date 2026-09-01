namespace swz.Clover.Core.Model
{
    public class PlainAttributeModel : AttributeModel
    {
        public override string PropertyName => Name;

        //public override TableDescription TableDescription => new TableDescription(DataModel.SchemaName, DataModel.TableName);
    }
}
