using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.View;
using swz.Workflow;
using swz.Workflow.Core.Runtime;
using HashHelper = swz.Clover.Core.Utils.HashHelper;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    [Authorize]
    public class WorkflowController : Controller
    {
        private IConfigurationRoot _configuration;
        private readonly ILogger<WorkflowController> _logger;

        public WorkflowController(IWebHostEnvironment env, ILogger<WorkflowController> logger)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));

            //TODO - refactor the below. Its called for every request to WorkflowController
            //       but only used to get the name of the admin role in one place
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddEnvironmentVariables();
            _configuration = builder.Build();
        }

        [Route("workflow/designerapi")]
        public IActionResult DesignerAPI()
        {
            Stream filestream = null;
            var isPost = Request.Method.Equals("POST", StringComparison.OrdinalIgnoreCase);
            if (isPost && Request.Form.Files != null && Request.Form.Files.Count > 0)
                filestream = Request.Form.Files[0].OpenReadStream();

            var pars = new NameValueCollection();
            foreach (var q in Request.Query)
            {
                pars.Add(q.Key, q.Value.First());
            }


            if (isPost)
            {
                var parsKeys = pars.AllKeys;
                foreach (var key in Request.Form.Keys)
                {
                    if (!parsKeys.Contains(key))
                    {
                        pars.Add(key, Request.Form[key]);
                    }
                }
            }

            var operation = pars["operation"].ToLower();
            if (operation == "save")
            {
                if (!CheckAccess())
                {
                    return AccessDenied();
                }

                if (CloverRuntime.Metadata.BlockMetadataChanges)
                    return Content("ConfigAPI: Changes are locked!");
            }

            var res = WorkflowInit.Runtime.DesignerAPI(pars, filestream);

            if (pars["operation"].ToLower() == "downloadscheme")
                return File(Encoding.UTF8.GetBytes(res), "text/xml", "scheme.xml");
            if (pars["operation"].ToLower() == "downloadschemebpmn")
                return File(Encoding.UTF8.GetBytes(res), "text/xml", "scheme.bpmn");

            return Content(res);
        }

        [Route("workflow/get")]
        public async Task<ActionResult> GetData(string name, string urlFilter)
        {
            try
            {
                object entityId;
                string filterActionName = null;
                string idValue = null;
                var filterItems = new List<ClientFilterItem>();

                if (NotNullOrEmpty(urlFilter))
                {
                    try
                    {
                        filterItems.AddRange(JsonConvert.DeserializeObject<List<ClientFilterItem>>(urlFilter));
                    }
                    catch
                    {
                        if (CloverRuntime.ServerActions.ContainsFilter(urlFilter))
                        {
                            filterActionName = urlFilter;
                        }
                        else
                        {
                            idValue = urlFilter;
                        }
                    }
                }

                if (!string.IsNullOrEmpty(idValue))
                {
                    if (Guid.TryParse(idValue, out Guid parsedGuid))
                    {
                        entityId = parsedGuid;
                    }
                    else
                    {
                        entityId = idValue;
                    }
                }
                else
                {
                    var data = await DataSource.GetDataForFormAsync(new GetDataRequest(name) { Filter = filterItems, FilterActionName = filterActionName });
                    entityId = data.Entity?.GetPrimaryKey();
                }

                //if entity does not enable workflow (eg, dply does not enable workflow), then don't proceed further
                if (entityId != null)
                {
                    try
                    {
                        var model = await MetadataToModelConverter.GetEntityModelByModelAsync(name, 0, true);
                        var entity = (await model.GetAsync(Filter.And.Equal(entityId, "Id"))).FirstOrDefault() as dynamic;

                        if (entity == null)
                            return Json(new FailResponse("Could not get workflow info"));

                        if (!entity.EnableWorkflow)
                            return Json(new ItemSuccessResponse<ClientWorkflowResponse>(new ClientWorkflowResponse() { Commands = null, States = new List<ClientWorkflowState>() }));
                    }
                    catch (Exception e)
                    {
                        _logger.LogError(e, nameof(GetData) + " - caught unexpected exception, name={0}, urlFilter={1}", name, urlFilter);
                        return Json(new ItemSuccessResponse<ClientWorkflowResponse>(new ClientWorkflowResponse() { Commands = null, States = new List<ClientWorkflowState>() }));

                    }
                }

                var userId = GetUserId();
                var processId = GetProcessId(entityId, name);

                if (processId.HasValue && (await WorkflowInit.Runtime.IsProcessExistsAsync(processId.Value)))
                {
                    var commands = (await WorkflowInit.Runtime.GetAvailableCommandsAsync(processId.Value, userId.ToString())).Select(c =>
                        new ClientWorkflowCommand() { Text = c.LocalizedName, Type = (byte)c.Classifier, Value = c.CommandName }).ToList();
                    var states = (await WorkflowInit.Runtime.GetAvailableStateToSetAsync(processId.Value)).Select(s =>
                        new ClientWorkflowState() { Value = s.Name, Text = s.VisibleName }).ToList();

                    return Json(new ItemSuccessResponse<ClientWorkflowResponse>(new ClientWorkflowResponse() { Commands = commands, States = states }));
                }
                else //if it is new process, get initial commands
                {
                    var commands = await GetInitialCommands(name, userId);
                    return Json(new ItemSuccessResponse<ClientWorkflowResponse>(new ClientWorkflowResponse() { Commands = commands, States = new List<ClientWorkflowState>() }));
                }
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(GetData) + " - caught unexpected exception, name={0}, urlFilter={1}", name, urlFilter);
                return Json(new FailResponse("Could not get workflow info"));
            }
        }

      

        [Route("workflow/execute")]
        [HttpPost]
        public async Task<ActionResult> ExecuteCommand(string name, string id, string command)
        {
            try
            {
                var processId = GetProcessIdFromString(id,name);
                
                var userId = GetUserId();

                if (!await WorkflowInit.Runtime.IsProcessExistsAsync(processId))
                {
                    var wfCommand = (await GetInitialCommands(name, userId)).FirstOrDefault(c => c.Value.Equals(command));
                    if (wfCommand == null)
                        return Json(new FailResponse("Command not found."));
                    await WorkflowInit.Runtime.CreateInstanceAsync(new CreateInstanceParams(wfCommand.Scheme, processId)
                    {
                        IdentityId = userId.ToString()
                    });
                }

                var commandObject = (await WorkflowInit.Runtime.GetAvailableCommandsAsync(processId, userId.ToString())).FirstOrDefault(c => c.CommandName.Equals(command));

                if (commandObject == null)
                    return Json(new FailResponse("Command not found."));

                await WorkflowInit.Runtime.ExecuteCommandAsync(commandObject, userId.ToString(), userId.ToString());

                return Json(new SuccessResponse());
            }

            catch (Exception e)
            {
                _logger.LogError(e, nameof(ExecuteCommand) + " - caught unexpected exception, name={0} id={1}, command={2}", name, id, command);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [Route("workflow/set")]
        [HttpPost]
        public async Task<ActionResult> SetState(string name, string id, string state)
        {
            try
            {
                var processId = GetProcessIdFromString(id,name);
                var userId = GetUserId();

                if (!await WorkflowInit.Runtime.IsProcessExistsAsync(processId))
                {
                    return Json(new FailResponse($"Process with id={id} is not found."));
                }

                await WorkflowInit.Runtime.SetStateAsync(processId, userId.ToString(), userId.ToString(), state);

                return Json(new SuccessResponse());
            }

            catch (Exception e)
            {
                _logger.LogError(e, nameof(SetState) + " - caught unexpected exception, name={0} id={1}, state={2}", name, id, state);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }
        
        private static Guid GetProcessIdFromString(string id, string formName)
        {
            if (Guid.TryParse(id, out Guid idGuid))
                return idGuid;
            
            return HashHelper.FromString($"{formName}_{id}");
        }
        
        private static Guid? GetProcessId(object entityId, string formName)
        {
            if (entityId == null)
                return null;
            
            if (entityId is Guid entityIdAsGuid)
                return entityIdAsGuid;

            return HashHelper.FromString($"{formName}_{entityId}");
        }
        
        private static Guid GetUserId()
        {
            return CloverRuntime.Security.CurrentUser.ImpersonatedUserId.HasValue
                ? CloverRuntime.Security.CurrentUser.ImpersonatedUserId.Value
                : CloverRuntime.Security.CurrentUser.Id;
        }

        private static bool NotNullOrEmpty(string urlFilter)
        {
            return !string.IsNullOrEmpty(urlFilter) && !urlFilter.Equals("null", StringComparison.OrdinalIgnoreCase);
        }

        private async Task<List<ClientWorkflowCommand>> GetInitialCommands(string name, Guid userId)
        {
            List<string> schemeNames = CloverRuntime.Metadata.GetWorkflowByForm(name);
            var commands = new List<ClientWorkflowCommand>();
            if (schemeNames != null)
            {
                foreach (var schemeName in schemeNames)
                {
                    var schemeCommands = (await WorkflowInit.Runtime.GetInitialCommandsAsync(schemeName,
                        userId.ToString())).Select(c =>
                        new ClientWorkflowCommand()
                        {
                            Text = c.LocalizedName,
                            Type = (byte)c.Classifier,
                            Value = c.CommandName,
                            Scheme = schemeName
                        }).ToList();

                    commands.AddRange(schemeCommands.Where(a => commands.All(b => a.Value != b.Value)));
                }
            }
            return commands;
        }

        private bool CheckAccess()
        {
            var role = _configuration["Clover:AdminRole"];
            if (string.IsNullOrEmpty(role) || role == "*")
                return true;

            return (CloverRuntime.Security.CurrentUser != null && CloverRuntime.Security.CurrentUser.IsInRole(role));
        }

        private ActionResult AccessDenied()
        {
            return Content("It's just for admins!");
        }
    }
}
