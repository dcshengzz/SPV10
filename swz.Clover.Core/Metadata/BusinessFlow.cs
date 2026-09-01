using System;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.Clover.Core.Metadata
{
    public class BusinessFlow : IMetadataItem
    {
        public Guid Id;
        public string Name;
        public string Scheme;
        public string DefaultForm;
        public List<BusinessFlowMap> Map;

        public int FindInCollectionByKey<T>(List<T> coll) where T : IMetadataItem
            => coll.FindIndex(c => (c as BusinessFlow)?.Id == Id);

        public static async Task<Form> GetForm(string name, Guid? id)
        {
            var md = await CloverRuntime.Metadata.PartialMetadata(new List<MetadataSectionQuery>()
            {
                new MetadataSectionQuery(MetadataSections.Businessflow)
            });

            var flow = md.BusinessFlow?.FirstOrDefault(c => c.Name != null && c.Name.Equals(name, StringComparison.OrdinalIgnoreCase));
            if (flow == null)
                throw new Exception("The flow is not found!");

            string stateName = null;
            var currentUser = CloverRuntime.Security.CurrentUser;
            var roles = currentUser.IsImpersonated ? currentUser.ImpersonatedUserRoles : currentUser.Roles;
            
            var wfRuntime = CloverRuntime.GetCreatedWorkflowRuntime();
            if (wfRuntime == null)
                throw new Exception("WorkflowRuntime must be initialized before call ConfigAPI!");

            if (id.HasValue && flow.Map != null && flow.Map.Count > 0)
            {
                if (await wfRuntime.IsProcessExistsAsync(id.Value))
                {
                    var state = await wfRuntime.GetCurrentStateAsync(id.Value);
                    stateName = state?.Name;
                }
            }
            else if (!string.IsNullOrEmpty(flow.Scheme))
            {
                stateName = (await wfRuntime.GetInitialStateAsync(flow.Scheme))?.Name;
            }

            return GetForm(flow, stateName, roles);
        }

        private static Form GetForm(BusinessFlow flow, string stateName, List<string> roles)
        {
            string formName = null;

            //Map with states & role
            if (!string.IsNullOrEmpty(stateName) && flow.Map != null)
            {
                var maps = flow.Map.Where(c => c.States != null && c.States.Contains(stateName)).ToList();
                if (maps.Any())
                {
                    formName = GetFormNameForRoles(roles, maps);
                }
            }

            //Map with role
            if (string.IsNullOrEmpty(formName) && flow.Map != null)
            {
                var statelessMaps = flow.Map.Where(m => (m.States == null || m.States.Count == 0 || m.States.Contains("*"))).ToList();
                
                if (statelessMaps.Any())
                {
                    formName = GetFormNameForRoles(roles, statelessMaps);
                }
            }

            //Default form
            if (string.IsNullOrEmpty(formName))
                formName = flow.DefaultForm;
            
            return string.IsNullOrEmpty(formName) ? 
                null : 
                CloverRuntime.Metadata.GetForm(formName); //20260701 - was CR.M
        }

        private static string GetFormNameForRoles(List<string> roles, List<BusinessFlowMap> maps)
        {
            string formName = null;
            
            var firstMapForSpecificRole = maps.FirstOrDefault(m => m.Roles != null && m.Roles.Any(roles.Contains));

            if (firstMapForSpecificRole != null)
            {
                formName = firstMapForSpecificRole.Form;
            }
            else
            {
                var firstMapForAllRoles = maps.FirstOrDefault(m => m.Roles != null && m.Roles.Any(r => r.Equals("*", StringComparison.Ordinal)));
                if (firstMapForAllRoles != null)
                    formName = firstMapForAllRoles.Form;
            }

            return formName;
        }
    }

    public class BusinessFlowMap
    {
        public List<string> States;
        public List<string> Roles;
        public string Form;
    }
}