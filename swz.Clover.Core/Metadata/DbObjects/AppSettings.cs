using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class AppSettings : DbObject<AppSettings>
    {
        public const string ATTRIBUTE_NAME = "Name";
        public const string ATTRIBUTE_VALUE = "Value";
        public const string ATTRIBUTE_GROUP_NAME = "GroupName";
        public const string ATTRIBUTE_PARAM_NAME = "ParamName";
        public const string ATTRIBUTE_EDITOR_TYPE = "EditorType";
        public const string ATTRIBUTE_ORDER = "Order";
        public const string ATTRIBUTE_IS_HIDDEN = "IsHidden";

        [DbObjectModel(IsKey = true)]
        public string Name
        {
            get => _entity.Name;
            set => _entity.Name = value;
        }

        [DbObjectModel]
        public string Value
        {
            get => _entity.Value;
            set => _entity.Value = value;
        }

        [DbObjectModel]
        public string GroupName
        {
            get => _entity.GroupName;
            set => _entity.GroupName = value;
        }

        [DbObjectModel]
        public string ParamName
        {
            get => _entity.ParamName;
            set => _entity.ParamName = value;
        }

        [DbObjectModel]
        public string EditorType
        {
            get => _entity.EditorType;
            set => _entity.EditorType = value;
        }

        [DbObjectModel]
        public int? Order
        {
            get => _entity.Order;
            set => _entity.Order = value;
        }

        //TODO - this seems to be ignored in the admin UI!
        [DbObjectModel]
        public bool IsHidden
        {
            get => _entity.IsHidden;
            set => _entity.IsHidden = value;
        }
        
    }
}
