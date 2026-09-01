using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics.Contracts;
using System.Dynamic;
using System.Linq;
using System.Net.Http.Headers;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices.ComTypes;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using swz.Clover.Core.Base;
using swz.Clover.Core.Metadata.DbObjects;

namespace swz.Clover.Core.Metadata
{
    public class Metadata
    {
        public LicenseInfo LicenseInfo;
        public List<AppSettings> AppSettings;

        //DataModel
        public List<DataModel> DataModel;
        
        //CodeActions
        public List<CodeAction> CodeActions;

        //Workflow
        public List<WorkflowScheme> Workflow;
        
        //Form
        public List<Form> Forms;
        public List<BusinessFlow> BusinessFlow;

        //Rule
        public List<QNN_RULE> Rules;
        
        //Modules
        public List<Module> Modules;
        
        //Security
        public List<Group> Groups;
        public List<Role> Roles;
        public List<Permission> Permissions;
        public List<User> Users;

        public List<object> localization;
        public List<StructDivision> StructDivisions;
        /// <summary>
        /// Additional parameters used by Admin panel
        /// </summary>
        public Dictionary<string, object> AdditionalParams { get; set; }
		public List<UploadedFilesPoor> FileUploads;

		public void Update(JToken item, string type, MetadataObjectState state)
        {
            if (type == MetadataSections.Businessflow)
            {
                UpdateObj(BusinessFlow, item, typeof(BusinessFlow), state);
            }
            else if (type == MetadataSections.Codeactions)
            {
                UpdateObj(CodeActions, item, typeof(CodeAction), state);
            }
            else if (type == MetadataSections.Datamodel)
            {
                UpdateObj(DataModel, item, typeof(DataModel), state);
            }
            else if (type == MetadataSections.Form)
            {
                UpdateObj(Forms, item, typeof(Form), state);
            }
            else if (type == MetadataSections.Modules)
            {
                UpdateObj(Modules, item, typeof(Module), state);
            }
        }

        private void UpdateObj<T>(List<T> objColl, JToken item, Type type, MetadataObjectState state) where T: IMetadataItem
        {
            T obj = item.ToObject<T>();
           
            switch (state)
            {
                case MetadataObjectState.Deleted:
                {
                    var index = obj.FindInCollectionByKey(objColl);
                    objColl.RemoveAt(index);
                    break;
                }
                case MetadataObjectState.Updated:
                {
                    var index = obj.FindInCollectionByKey(objColl);
                    objColl[index] = obj;
                    break;
                }
                case MetadataObjectState.Inserted:
                    objColl.Add(obj);
                    break;
            }
        }
    }
}