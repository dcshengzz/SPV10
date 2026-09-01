using System.Collections.Generic;
using System.Threading.Tasks;
using swz.Clover.Core.Model;

namespace swz.Clover.Core
{
    public interface IServerActionsProvider
    {
        List<string> GetFilterNames();
        bool IsFilterAsync(string name);
        bool ContainsFilter(string name);
        Filter GetFilter(string name, EntityModel model, List<dynamic> entities, dynamic options);
        Task<Filter> GetFilterAsync(string name, EntityModel model, List<dynamic> entities, dynamic options);
        
        List<string> GetTriggerNames();
        bool IsTriggerAsync(string name);
        bool ContainsTrigger(string name);
        (string Message, bool IsCancelled) ExecuteTrigger(string name, EntityModel model, List<dynamic> entities, dynamic options);
        Task<(string Message, bool IsCancelled)> ExecuteTriggerAsync(string name, EntityModel model, List<dynamic> entities, dynamic options);

        List<string> GetActionNames();
        bool IsActionAsync(string name);
        bool ContainsAction(string name);
        dynamic ExecuteAction(string name, dynamic request);
        Task<dynamic> ExecuteActionAsync(string name, dynamic request);
    }
}