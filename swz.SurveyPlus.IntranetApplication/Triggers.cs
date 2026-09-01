using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using swz.Workflow.Core.Runtime;

namespace swz.SurveyPlus.IntranetApplication
{
    public class Triggers : IServerActionsProvider
    {
        public Triggers()
        {
            _triggersAsync.Add("SetFields", SetFields);
            _triggersAsync.Add("InitFields", InitFields);
            _triggersAsync.Add("initDocument", InitDocument);
        }        

        public async Task<(string Message, bool IsCancelled)> SetFields(EntityModel model, List<dynamic> entities,
            dynamic options)
        {
            DynamicEntity fields = options as DynamicEntity;
            if (fields != null)
            {
                foreach (DynamicEntity entity in entities)
                {
                    foreach (KeyValuePair<string, object> field in fields.Dictionary)
                    {
                        if("@AccessCode".Equals(field.Value))
                        {
                            ProvisionAccessCode(entity, field.Key);
                        }
                        else
                        {
                            entity.TrySetMember(field.Key, await ReplaceVariable(field.Value, model));
                        }
                    }
                }
            }
            return (null, false);
        }

        public async Task<(string Message, bool IsCancelled)> InitFields(EntityModel model, List<dynamic> entities,
            dynamic options)
        {
            var fields = options as DynamicEntity;
            if (fields != null)
                foreach (var entity in entities)
                    if (entity[model.PrimaryKeyAttributeName] == null)
                        foreach (var field in fields.Dictionary)
                            entity.TrySetMember(field.Key, await ReplaceVariable(field.Value, model));
            return (null, false);
        }

        public static async Task<object> ReplaceVariable(object val, EntityModel model)
        {
            if (val is string)
            {
                var str = (string) val;


                if (str == "@CurrentUserId") return CloverRuntime.Security.CurrentUser.Id;

                if (str == "@CurrentUserName") return CloverRuntime.Security.CurrentUser.Name;

                if (str == "@StructDivisionId") return CloverRuntime.Security.CurrentUser.StructDivisionId;

                if (str == "@DateTimeNow" || str == "@DateNow") return DateTime.Now;

                if (str == "@DefaultState")
                {
                    var schemes = CloverRuntime.Metadata.GetWorkflowByForm(model.Name);
                    var initialState = schemes.Count == 0
                        ? new WorkflowState {Name = "", SchemeCode = "", VisibleName = ""}
                        : await WorkflowInit.Runtime.GetInitialStateAsync(schemes[0]);
                    return initialState.VisibleName;
                }
            }

            return val;
        }

        public async Task<(string Message, bool IsCancelled)> InitDocument(EntityModel model, List<dynamic> entities,
            dynamic options)
        {
            var user = CloverRuntime.Security.CurrentUser;
            var schemes = CloverRuntime.Metadata.GetWorkflowByForm(model.Name);
            foreach (var entity in entities)
                if (entity.Id == null)
                {
                    var initialState = schemes.Count == 0
                        ? new WorkflowState {Name = "", SchemeCode = "", VisibleName = ""}
                        : await WorkflowInit.Runtime.GetInitialStateAsync(schemes[0]);
                    entity.AuthorId = user.GetOperationUserId();
                    entity.author = user.GetOperationUserName();
                    entity.State = initialState.Name;
                    entity.stateName = initialState.VisibleName;
                }

            return (null, false);
        }

        /// <summary>
        /// Used by SetFields for @AccessCode
        /// Stores an enrypted AccessCode (the entity Id is used to provide the IV)
        /// </summary>
        /// <param name="entity"></param>
        /// <param name="fieldName"></param>
        /// <exception cref="ArgumentException"></exception>
        /// <exception cref="InvalidOperationException"></exception>
        private void ProvisionAccessCode(DynamicEntity entity, string fieldName)
        {
            if (string.IsNullOrEmpty(fieldName)) throw new ArgumentException(nameof(fieldName));            
            Guid? id = (Guid?)entity[Constants.FieldName.Id];
            if (id == null || Guid.Empty.Equals(id))
                throw new InvalidOperationException("Id has not been initialised, cannot provision an encrypted AccessCode");
            byte[] key = EncryptionHelper.Bytes(Constants.LoginKey);
            byte[] iv = ((Guid)id).ToByteArray();
            entity.TrySetMember(fieldName, new AccessCode().ToEncryptedString(key, iv));
        }

        #region IServerActionsProvider implementation

        private readonly
            Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, (string Message, bool IsCancelled)>> _triggers
                = new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, (string Message, bool IsCancelled)>
                >();

        private readonly
            Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Task<(string Message, bool IsCancelled)>>>
            _triggersAsync
                = new Dictionary<string,
                    Func<EntityModel, List<dynamic>, dynamic, Task<(string Message, bool IsCancelled)>>>();

        public List<string> GetFilterNames()
        {
            return new List<string>();
        }

        public bool IsFilterAsync(string name)
        {
            return false;
        }

        public bool ContainsFilter(string name)
        {
            return false;
        }

        public Filter GetFilter(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            throw new NotImplementedException();
        }

        public Task<Filter> GetFilterAsync(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            throw new NotImplementedException();
        }

        public List<string> GetTriggerNames()
        {
            return _triggers.Keys.Concat(_triggersAsync.Keys).ToList();
        }

        public bool IsTriggerAsync(string name)
        {
            return _triggersAsync.ContainsKey(name);
        }

        public bool ContainsTrigger(string name)
        {
            return _triggersAsync.ContainsKey(name) || _triggers.ContainsKey(name);
        }

        public (string Message, bool IsCancelled) ExecuteTrigger(string name, EntityModel model, List<dynamic> entities,
            dynamic options)
        {
            if (_triggers.ContainsKey(name))
                return _triggers[name](model, entities, options);
            throw new NotImplementedException();
        }

        public Task<(string Message, bool IsCancelled)> ExecuteTriggerAsync(string name, EntityModel model,
            List<dynamic> entities, dynamic options)
        {
            if (_triggersAsync.ContainsKey(name))
                return _triggersAsync[name](model, entities, options);
            throw new NotImplementedException();
        }

        public List<string> GetActionNames()
        {
            return new List<string>();
        }

        public bool IsActionAsync(string name)
        {
            return false;
        }

        public bool ContainsAction(string name)
        {
            return false;
        }

        public dynamic ExecuteAction(string name, dynamic request)
        {
            throw new NotImplementedException();
        }

        public async Task<dynamic> ExecuteActionAsync(string name, dynamic request)
        {
            throw new NotImplementedException();
        }

        #endregion
    }
}