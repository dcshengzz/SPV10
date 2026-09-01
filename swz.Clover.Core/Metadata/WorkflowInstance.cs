using swz.Clover.Core.Metadata.DbObjects;
using System;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using Newtonsoft.Json;
using swz.Clover.Core.View;

namespace swz.Clover.Core.Metadata
{
    public class WorkflowInstance : IMetadataItem
    {
        public Guid Id;
        public string SchemeCode;
        public string StateName;
        public string ActivityName;
        public Guid? ParentProcessId;
        public Guid? RootProcessId;

        public byte? InstanceStatus;

        public List<WorkflowProcessInstancePersistence> Persistance;
        public List<WorkflowProcessTimer> Timers;
        public List<WorkflowProcessTransitionHistory> History;
        public List<WorkflowProcessInstance> ChildrenProcess;

        public int FindInCollectionByKey<T>(List<T> coll) where T : IMetadataItem
            => coll.FindIndex(c => (c as Module)?.Id == Id);

        public static async Task<WorkflowInstance> LoadById(Guid id)
        {
            var item = await WorkflowProcessInstance.SelectByKey(id);
            if (item == null)
                return null;

            var persistances = await WorkflowProcessInstancePersistence.SelectByProcessId(id);
            var status = await WorkflowProcessInstanceStatus.SelectByKey(id);
            var history = await WorkflowProcessTransitionHistory.SelectByProcessId(id);
            var timers = await WorkflowProcessTimer.SelectByProcessId(id);
            var children = await WorkflowProcessInstance.SelectByParentProcessId(id);

            return new WorkflowInstance()
            {
                Id = item.Id,
                SchemeCode = item.SchemeCode,
                StateName = item.StateName,
                ActivityName = item.ActivityName,
                ParentProcessId = item.ParentProcessId,
                RootProcessId = item.RootProcessId,

                InstanceStatus = status?.Status,
                Persistance = persistances,
                Timers = timers,
                History = history,
                ChildrenProcess = children
            };
        }

        public static async Task<object> LoadInstances(long skip, long take, 
            string id, string scheme, string status, string activity, string state,
            string sort)
        {
            Order order = Order.Empty;
            if (!string.IsNullOrEmpty(sort))
            {
                var sortEl = sort.Split(' ');
                if(sortEl.Length == 2)
                {
                    var sortType = sortEl[1].Trim().ToUpper();
                    if (sortType == "DESC")
                        order = Order.StartDesc(sortEl[0].Trim());
                    else if (sortType == "ASC")
                        order = Order.StartAsc(sortEl[0].Trim());
                    else
                        throw new Exception("Incorrect 'sort' parameter!");

                }
            }

            Filter filter = Filter.And;
            if (Guid.TryParse(id, out Guid processId))
            {
                filter.Equal(processId, "Id");
            }

            if (byte.TryParse(status, out byte instanceStatus))
            {
                filter.Equal(instanceStatus, "InstanceStatus");
            }

            if (!string.IsNullOrEmpty(scheme)) {
                filter.LikeRightLeft(scheme, "SchemeCode");
            }

            if (!string.IsNullOrEmpty(activity))
                filter.LikeRightLeft(activity, "ActivityName");
            
            if (!string.IsNullOrEmpty(state))
                filter.LikeRightLeft(state, "StateName");
            
            var items = await WorkflowProcessInstance.Model.GetAsync(filter, order, new Paging(skip, take));
            long count = await WorkflowProcessInstance.Model.GetCountAsync(filter);
            return new {
                instances = items.Select(c=> WorkflowProcessInstance.CreateByDynamicEntity(c)).ToList(), 
                count
            };
        }
    }
}