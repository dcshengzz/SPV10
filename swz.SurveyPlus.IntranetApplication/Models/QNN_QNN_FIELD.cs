using System;
using swz.Clover.Core.ORM;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class QNN_QNN_FIELD : DbObject<QNN_QNN_FIELD>
    {
        public QNN_QNN_FIELD() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public string Name
        {
            get => _entity.Name;
            set => _entity.Name = value;
        }

        [DbObjectModel]
        public int? NumberId
        {
            get => _entity.NumberId;
            set => _entity.NumberId = value;
        }

        [DbObjectModel]
        public Guid? QnnId
        {
            get => _entity.QnnId;
            set => _entity.QnnId = value;
        }

        [DbObjectModel(ColumnName = "ReadOnly")]
        public bool? IsReadOnly
        {
            get => _entity.IsReadOnly;
            set => _entity.IsReadOnly = value;
        }

        [DbObjectModel]
        public bool? Required
        {
            get => _entity.Required;
            set => _entity.Required = value;
        }

        [DbObjectModel]
        public string Type
        {
            get => _entity.Type;
            set => _entity.Type = value;
        }
    }
}