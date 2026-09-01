using System;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class Metadata : DbObject<Metadata>
    {
        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }


        [DbObjectModel]
        public string Filename
        {
            get => _entity.Filename;
            set => _entity.Filename = value;
        }

        [DbObjectModel]
        public string Folder
        {
            get => _entity.Folder;
            set => _entity.Folder = value;
        }

        [DbObjectModel]
        public string Data
        {
            get => _entity.Data;
            set => _entity.Data = value;
        }

        [DbObjectModel]
        public Guid? CreatedBy
        {
            get => _entity.CreatedBy;
            set => _entity.CreatedBy = value;
        }

        [DbObjectModel]
        public DateTime? CreatedDate
        {
            get => _entity.CreatedDate;
            set => _entity.CreatedDate = value;
        }

        [DbObjectModel]
        public Guid? UpdatedBy
        {
            get => _entity.UpdatedBy;
            set => _entity.UpdatedBy = value;
        }

        [DbObjectModel]
        public DateTime? UpdatedDate
        {
            get => _entity.UpdatedDate;
            set => _entity.UpdatedDate = value;
        }

        //[DbObjectModel]
        //public Guid? DeletedBy
        //{
        //    get => _entity.DeletedBy;
        //    set => _entity.DeletedBy = value;
        //}

        //[DbObjectModel]
        //public DateTime? DeletedDate
        //{
        //    get => _entity.DeletedDate;
        //    set => _entity.DeletedDate = value;
        //}

        [Obsolete]
        [DbObjectModel]
        public bool IsDeleted
        {
            get => _entity.IsDeleted;
            set => _entity.IsDeleted = value;
        }


        [DbObjectModel]
        public Guid? StructDivisionId
        {
            get => _entity.StructDivisionId;
            set => _entity.StructDivisionId = value;
        }

    }

}