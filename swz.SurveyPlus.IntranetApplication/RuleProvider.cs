using System;
using System.Collections.Generic;
using System.Linq;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using swz.Workflow.Core.Model;
using swz.Workflow.Core.Runtime;

namespace swz.SurveyPlus.IntranetApplication
{
    public class RuleProvider : IWorkflowRuleProvider
    {
        private readonly Dictionary<string, RuleFunction> _rules = new Dictionary<string, RuleFunction>();

        public RuleProvider()
        {
            //Register your rules in the _rules Dictionary
            _rules.Add("CheckRole", new RuleFunction {CheckFunction = RoleCheck, GetFunction = RoleGet});
            _rules.Add("IsDplyAuthor", new RuleFunction {CheckFunction = AuthorCheck, GetFunction = AuthorGet});
           // _rules.Add("IsDocumentManager", new RuleFunction {CheckFunction = ManagerCheck, GetFunction = ManagerGet});
        }

        public IEnumerable<string> ManagerGet(ProcessInstance processInstance, WorkflowRuntime runtime,
            string parameter)
        {
            var documentModel = MetadataToModelConverter.GetEntityModelByModelAsync("Document").Result;
            var managerId =
                documentModel.GetAsync(Filter.And.Equal(processInstance.ProcessId, "Id")).Result.FirstOrDefault()?[
                    "ManagerId"];
            return managerId != null ? new List<string> {managerId.ToString()} : new List<string>();
        }

        public bool ManagerCheck(ProcessInstance processInstance, WorkflowRuntime runtime, string identityId,
            string parameter)
        {
            var documentModel = MetadataToModelConverter.GetEntityModelByModelAsync("Document").Result;
            var managerId =
                documentModel.GetAsync(Filter.And.Equal(processInstance.ProcessId, "Id")).Result.FirstOrDefault()?[
                    "ManagerId"];
            return managerId != null && identityId == managerId.ToString();
        }

        /// <summary>
        /// Return the guid of the creator (ie: CreatedBy) of the QNN_DPLY whose Id matches the ProcessId
        /// </summary>
        /// <param name="processInstance"></param>
        /// <param name="runtime"></param>
        /// <param name="parameter"></param>
        /// <returns>enumerable containing string guid of author or an empty enumerable </returns>
        public IEnumerable<string> AuthorGet(ProcessInstance processInstance, WorkflowRuntime runtime, string parameter)
        {
            var dplyModel = MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY).Result;
            var authorId = dplyModel.GetAsync(Filter.And.Equal(processInstance.ProcessId, "Id")).Result
                .FirstOrDefault()?["CreatedBy"];
            return authorId != null ? new List<string> {authorId.ToString()} : new List<string>();
        }

        /// <summary>
        /// Returns true if the author of the QNN_DPLY whose Id matches that of the process instance is the
        /// same as the identityId
        /// </summary>
        /// <param name="processInstance"></param>
        /// <param name="runtime"></param>
        /// <param name="identityId"></param>
        /// <param name="parameter"></param>
        /// <returns>true if the identityId matches the CreatedBy of the QNN_DPLY</returns>
        public bool AuthorCheck(ProcessInstance processInstance, WorkflowRuntime runtime, string identityId,
            string parameter)
        {
            var dplyModel = MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY).Result;
            var authorId =
                dplyModel.GetAsync(Filter.And.Equal(processInstance.ProcessId, "Id")).Result.FirstOrDefault()?
                    ["CreatedBy"].ToString();
            return identityId == authorId;
        }

        public IEnumerable<string> RoleGet(ProcessInstance processInstance, WorkflowRuntime runtime, string parameter)
        {
            var rolesModel = MetadataToModelConverter.GetEntityModelByModelAsync("dwSecurityRole").Result;
            var role = rolesModel.GetAsync(Filter.And.Equal(parameter, "Name")).Result.FirstOrDefault();
            if (role == null)
                return new List<string>();
            var roleUserModel = MetadataToModelConverter.GetEntityModelByModelAsync("dwV_Security_UserRole").Result;
            return roleUserModel.GetAsync(Filter.And.Equal(role.GetId(), "RoleId")).Result
                .Select(r => r["UserId"].ToString()).Distinct();
        }

        public bool RoleCheck(ProcessInstance processInstance, WorkflowRuntime runtime, string identityId,
            string parameter)
        {
            var rolesModel = MetadataToModelConverter.GetEntityModelByModelAsync("dwSecurityRole").Result;
            var role = rolesModel.GetAsync(Filter.And.Equal(parameter, "Name")).Result.FirstOrDefault();
            if (role == null)
                return false;
            var roleUserModel = MetadataToModelConverter.GetEntityModelByModelAsync("dwV_Security_UserRole").Result;
            return roleUserModel
                       .GetCountAsync(Filter.And.Equal(role.GetId(), "RoleId").Equal(Guid.Parse(identityId), "UserId"))
                       .Result > 0;
        }

        private class RuleFunction
        {
            public Func<ProcessInstance, WorkflowRuntime, string, IEnumerable<string>> GetFunction { get; set; }

            public Func<ProcessInstance, WorkflowRuntime, string, string, bool> CheckFunction { get; set; }
        }

        #region Implementation of IWorkflowRuleProvider

        public List<string> GetRules()
        {
            return _rules.Keys.ToList();
        }

        public bool Check(ProcessInstance processInstance, WorkflowRuntime runtime, string identityId, string ruleName,
            string parameter)
        {
            if (_rules.ContainsKey(ruleName))
                return _rules[ruleName].CheckFunction(processInstance, runtime, identityId, parameter);
            throw new NotImplementedException();
        }

        public IEnumerable<string> GetIdentities(ProcessInstance processInstance, WorkflowRuntime runtime,
            string ruleName, string parameter)
        {
            if (_rules.ContainsKey(ruleName))
                return _rules[ruleName].GetFunction(processInstance, runtime, parameter);
            throw new NotImplementedException();
        }

        #endregion
    }
}