using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.Metadata.DbObjects
{
   
    public class UploadedFiles : DbObject<UploadedFiles>
    {
        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public byte[] Data
        {
            get => _entity.Data;
            set => _entity.Data = value;
        }

        [DbObjectModel]
        public long AttachmentLength
        {
            get => _entity.AttachmentLength;
            set => _entity.AttachmentLength = value;
        }

        [DbObjectModel]
        public string ContentType
        {
            get => _entity.ContentType;
            set => _entity.ContentType = value;
        }

        [DbObjectModel]
        public string Name
        {
            get => _entity.Name;
            set => _entity.Name = value;
        }

        [DbObjectModel]
        public bool Used
        {
            get => _entity.Used;
            set => _entity.Used = value;
        }

		[DbObjectModel]
		public bool IsLocalStorage
		{
			get => _entity.IsLocalStorage;
			set => _entity.IsLocalStorage = value;
		}

		[DbObjectModel]
        public string CreatedBy
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
        public string UpdatedBy
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

        [DbObjectModel]
        public Guid StructDivisionId
        {
            get => _entity.StructDivisionId;
            set => _entity.StructDivisionId = value;
        }

        [DbObjectModel]
        public string Properties
        {
            get => _entity.Properties;
            set => _entity.Properties = value;
        }
    }

    /// <summary>
    /// Models a record in dwUploadedFiles. There are TWO variants of this model. 
    /// This one (UploadedFilesPoor) does not include the data blob (for efficiency as it can be veryt large!)
    /// Unless you need the data you should be using this version of the model.
    /// </summary>
    public class UploadedFilesPoor : DbObject<UploadedFilesPoor>
    {
        public UploadedFilesPoor() : base (false, "UploadedFiles")
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

		[DbObjectModel]
        public long AttachmentLength
        {
            get => _entity.AttachmentLength;
            set => _entity.AttachmentLength = value;
        }

        [DbObjectModel]
        public string ContentType
        {
            get => _entity.ContentType;
            set => _entity.ContentType = value;
        }

        [DbObjectModel]
        public string Name
        {
            get => _entity.Name;
            set => _entity.Name = value;
        }

        [DbObjectModel]
        public bool Used
        {
            get => _entity.Used;
            set => _entity.Used = value;
        }

		[DbObjectModel]
		public bool IsLocalStorage
		{
			get => _entity.IsLocalStorage;
			set => _entity.IsLocalStorage = value;
		}

		[DbObjectModel]
        public string CreatedBy
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
        public string UpdatedBy
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

        [DbObjectModel]
        public Guid StructDivisionId
        {
            get => _entity.StructDivisionId;
            set => _entity.StructDivisionId = value;
        }

        [DbObjectModel]
        public string Properties
        {
            get => _entity.Properties;
            set => _entity.Properties = value;
        }

        /// <summary>
        /// Retrieves all files in local storage (IsLocalStorage) based on the name.
        /// This method now returns an empty list rather than null if no files found. 
        /// </summary>
        /// <param name="name"></param>
        /// <param name="structDivisionIds">if not null will filter to results in these organisations</param>
        /// <returns>List of files (may be empty but never null)</returns>
        public static async Task<List<UploadedFilesPoor>> GetLocalStorageFilesByNameAsync(string name, List<Guid> structDivisionIds = null)
        {
            Filter filter = Filter.And.Equal(name, Constants.FieldName.dwUploadedFiles.Name);
            filter.Merge(Filter.And.Equal(1, Constants.FieldName.dwUploadedFiles.IsLocalStorage));
            if(structDivisionIds != null)
            {
                filter.Merge(Filter.And.In(structDivisionIds, Constants.FieldName.dwUploadedFiles.StructDivisionId));
            }
            List<UploadedFilesPoor> result = await SelectAsync(filter);
            return result;
        }

        /// <summary>
        /// Returns id of the named file in local storage (IsLocalStorage==True).
        /// Files in local storage should not have same name, if the db has such files it is undefined which one's id is returned
        /// nb, this logic is meant for File Storage feature
        /// </summary>
        /// <param name="name"></param>
        /// <returns>id or Empty if there is not file with this name in local storage</returns>
        public static async Task<Guid> GetLocalStorageIdByNameAsync(string name)
        {
            Filter filter = Filter.And.Equal(name, Constants.FieldName.dwUploadedFiles.Name);
            filter.Merge(Filter.And.Equal(1, Constants.FieldName.dwUploadedFiles.IsLocalStorage));
            List<UploadedFilesPoor> result = await SelectAsync(filter);
            return result.Count > 0 ? result[0].Id : Guid.Empty;
        }
    } //end of UploadedFilesPoor
}