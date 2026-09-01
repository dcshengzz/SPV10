using System;
using System.Collections.Generic;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.View;
using static swz.SurveyPlus.IntranetApplication.ReportHelper;
using static swz.SurveyPlus.Application.Constants;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.Clover.Core.Metadata;
using Microsoft.AspNetCore.Http;
using swz.SurveyPlus.IntranetApplication.Models;
using User = swz.Clover.Core.Security.User;
using Newtonsoft.Json;
using System.Text;
using System.Net;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    [Authorize]
    public class ReportController : Controller
    {
        private readonly ILogger<ReportController> logger;

        public ReportController(ILogger<ReportController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region imp

        [HttpPost]
        [Route("report/snapshot/settings")]
        public async Task<ActionResult> SetSnapshotSettings()
        {
            //This was previously named GetJobData with the route "report/getJobData"

            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");

                //20240617 - Now posting JSON instead of a form
                //The following block of code could be replaced by '[FromBody] SnapshotSettings settings' in the arguments
                //once we have fixed issue #134 , although doing it here has the advantage of it being inside our try/catch
                //so gets our error logging if cannot deserialise it
                ReportHelper.ReportSnapshot.SnapshotSettings settings;
                using (StreamReader reader = new StreamReader(Request.Body, Encoding.UTF8))
                {
                    string body = await reader.ReadToEndAsync();
                    settings = JsonConvert.DeserializeObject<ReportHelper.ReportSnapshot.SnapshotSettings>(body);
                }

                //Verify the deployment exists and that this user has organisation access to it
                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(settings.DplyId);
                if (qnnDply == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, settings.DplyId);
                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(qnnDply))
                    throw new PermissionException($"Lacks StructDivision access to dplyId {settings.DplyId}");

                //Having marshalled the data and verified user's access we can now proceed to update the settings in database
                await ReportHelper.ReportSnapshot.UpdateQnnDplyScheduler(settings, currentUser.Id);
                return Json(new SuccessResponse("Snapshot settings updated"));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SetSnapshotSettings) + " - caught unexpected exception");
                return Json(new FailResponse("Internal Error. Please check with system administrator"));
            }

        }

        /// <summary>
        /// Retrieves the report snapshot settings for the specified deployment from QNN_DPLY_SCHEDULER
        /// </summary>
        [HttpGet]
        [Route("report/snapshot/settings")]
        public async Task<ActionResult> GetSnapshotSettings(Guid dplyId)
        {
            if (Guid.Empty.Equals(dplyId)) return BadRequest("dplyId");
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(dplyId))
                    throw new PermissionException($"Requires StructDivision access to this deployment");

                //QNN_DPLY_SCHEDULER doesn't schedule anything, rather it holds the deployment's settings for the daily snapshot job
                //and it will be absent for deployments that dont have snapshots switched on
                DynamicEntity qnnDplyScheduler
                    = await DeploymentApplication.GetQnnDplySchedulerByDplyId(dplyId);

                bool isSaveSnapshot = (qnnDplyScheduler != null);
                ReportHelper.ReportSnapshot.SnapshotSettings settings = (isSaveSnapshot)
                    ? ReportHelper.ReportSnapshot.SnapshotSettings.FromQnnDplyScheduler(qnnDplyScheduler)
                    : new ReportHelper.ReportSnapshot.SnapshotSettings(dplyId);
                return Json(new ItemSuccessResponse<ReportHelper.ReportSnapshot.SnapshotSettings>(settings));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetSnapshotSettings) + " - caught unexpected exception, dplyId={0}", dplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        #endregion

        #region dailyreports

        private async Task<string> CalDateString(string dplyId)
        {
            var modeltbl2 = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY); // call dply tbl
            var datatbl2 = (await modeltbl2.GetAsync(Filter.And.Equal(dplyId, "Id"))).FirstOrDefault() as dynamic;

            DateTime sDatetbl2 = Convert.ToDateTime(datatbl2.DateStart);
            var eDatetbl2 = Convert.ToDateTime(datatbl2.DateEnd);

            var currentDate = DateTime.Now;

            string today = DateTime.Today.ToString("dd MMM yyyy");

            double NumberofWeek;
            DateTime startDatetbl2, endDatetbl2;
            string DateStringtbl2;

            //01/08/2020 12:00:00 AM

            if (sDatetbl2 != DateTime.MinValue)
            {
                startDatetbl2 = Convert.ToDateTime(sDatetbl2); ///sdate
				if (eDatetbl2 != DateTime.MinValue)

                {
                    endDatetbl2 = Convert.ToDateTime(eDatetbl2);//edate
                    string tmpStr;
                    if (endDatetbl2 >= currentDate)
                    {
                        NumberofWeek = (currentDate - startDatetbl2).TotalDays / 7;
                        tmpStr = DateStringtbl2 = "Week " + Math.Ceiling(NumberofWeek) + " : As of " + currentDate.ToString("dd MMM yyyy");
                    }
                    else
                    {
                        NumberofWeek = (endDatetbl2 - startDatetbl2).TotalDays / 7;
                        tmpStr = DateStringtbl2 = "Week " + Math.Ceiling(NumberofWeek) + " : As of " + endDatetbl2.ToString("dd MMM yyyy");
                    }

                    DateStringtbl2 = tmpStr;
                }
                else

                {
                    endDatetbl2 = currentDate;//edate
                    NumberofWeek = (endDatetbl2 - startDatetbl2).TotalDays / 7;
                    DateStringtbl2 = "Week " + Math.Ceiling(NumberofWeek) + " : As of " + today;
                }


            }
            else
            {
                startDatetbl2 = Convert.ToDateTime(datatbl2.CreatedDate);

                if (eDatetbl2 != DateTime.MinValue)

                {
                    endDatetbl2 = Convert.ToDateTime(eDatetbl2);//edate
                    string tmpStr;
                    if (endDatetbl2 >= currentDate)
                    {
                        NumberofWeek = (currentDate - startDatetbl2).TotalDays / 7;
                        tmpStr = DateStringtbl2 = "Week " + Math.Ceiling(NumberofWeek) + " : As of " + currentDate.ToString("dd MMM yyyy");
                    }
                    else
                    {
                        NumberofWeek = (endDatetbl2 - startDatetbl2).TotalDays / 7;
                        tmpStr = DateStringtbl2 = "Week " + Math.Ceiling(NumberofWeek) + " : As of " + endDatetbl2.ToString("dd MMM yyyy");
                    }

                    DateStringtbl2 = tmpStr;
                }
                else

                {
                    endDatetbl2 = currentDate;//edate
                    NumberofWeek = (endDatetbl2 - startDatetbl2).TotalDays / 7;
                    DateStringtbl2 = "Week " + Math.Ceiling(NumberofWeek) + " : As of " + today;
                }


            }

            return DateStringtbl2;
        }

        //TODO - why is dplyId a string when we use Guid for our QNN_DPLY keys?
        private async Task<List<DateTime>> CalTotDates(string dplyId)
        {
            var startDate = DateTime.MinValue;
            var endDate = DateTime.MinValue;
            var distinctDate = DateTime.MinValue;

            var sParam = new Dictionary<string, object> { { "DplyId", dplyId }, { "Flag", "Start" } };

            var sDate = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("spSP_GetWeek",
                                          sParam, new Dictionary<string, object>());
            foreach (var sd in sDate)
            {
                startDate = (DateTime)sd["CreatedDate"];       //get startdate
            }

            var eParam = new Dictionary<string, object> { { "DplyId", dplyId }, { "Flag", "End" } };

            var eDate = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("spSP_GetWeek",
                                         eParam, new Dictionary<string, object>());
            foreach (var ed in eDate)
            {
                endDate = (DateTime)ed["CreatedDate"]; //getenddate
            }

            var dParam = new Dictionary<string, object> { { "DplyId", dplyId }, { "Flag", "Distinct" } };

            var distinctDates = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("spSP_GetWeek",
                                         dParam, new Dictionary<string, object>());

            List<DateTime> distinctDateList = new List<DateTime>();
            DateTime dDate = DateTime.MinValue;

            foreach (var dd in distinctDates)
            {
                distinctDate = (DateTime)dd["CreatedDate"]; //getenddate
                distinctDateList.Add(distinctDate);
            }

            DateTime lastDateOfWeek = DateTime.MinValue;
            List<DateTime> lastDateOfWeeks = new List<DateTime>();

            for (DateTime i = startDate.AddDays(7); i <= endDate; i = i.AddDays(7))
            {
                for (var j = 0; j <= distinctDateList.Count; j++)
                {
                    if (distinctDateList[j] >= i)
                    {
                        lastDateOfWeek = distinctDateList[j - 1];
                        lastDateOfWeeks.Add(lastDateOfWeek);
                        break;
                    }
                }
            }
            lastDateOfWeeks.Add(endDate);

            return lastDateOfWeeks;
        }

        //TODO - dlyId, rType are retrieved from form, so dont pass it also
        //       Need to check deployments struct division access too
        //       use GetCurentUserAsync
        //       Use of constants for stored procedure names
        //       Can use DeploymentApplication.GetQnnDplyByDplyId now
        //       Fix broken indentation
        //       Move most of the method to a helper method in ReportHelper or such like to declutter controller
        
        [HttpPost]
        [Route("report/dailyereport")]
        public async Task<ActionResult> ImdaDailyReport(string dplyId, string rType)
        {
            try
            {
                if (!CloverRuntime.Security.CurrentUser.IsInRole(Constants.Role.SurveyAdmin)) throw new PermissionException();

                int sumTA, sumMTS, sumSTS, sumTS, sumTot;
                int sumTAActiveUse, sumMTSActiveUse, sumSTSActiveUse, sumTSActiveUse, sumTotalActiveUse;
                int sumTAActiveNotUse, sumMTSActiveNotUse, sumSTSActiveNotUse, sumTSActiveNotUse, sumTotalActiveNotUse;
                int sumTAInactive, sumMTSInactive, sumSTSInactive, sumTSInactive, sumTotalInactive;
                int sumTANonResp, sumMTSNonResp, sumSTSNonResp, sumTSNonResp, sumTotalNonResp;
                int sampleAftBandITA, sampleAftBandIMTS, sampleAftBandISTS, sampleAftBandITS, sampleAftBandITot;
                int valBouncedTA, valBouncedMTS, valBouncedSTS, valBouncedTS, valBouncedTot;
                decimal responseRateTA, responseRateMTS, responseRateSTS, responseRateTS, responseRateTot;
                List<decimal> preTAResponse = new List<decimal>();
                List<decimal> preMTSResponse = new List<decimal>();
                List<decimal> preSTSResponse = new List<decimal>();
                List<decimal> preTSResponse = new List<decimal>();
                List<decimal> preTotResponse = new List<decimal>();
                List<DateTime> LastDateofWeek = new List<DateTime>();
                decimal preTA = 0.0M;
                decimal preMTS = 0.0M;
                decimal preSTS = 0.0M;
                decimal preTS = 0.0M;
                decimal preTot = 0.0M;
                dplyId = HttpContext.Request.Form["dplyId"]; //"87ae3744-44c3-45d8-99dd-e94b6d597660";//
                rType = HttpContext.Request.Form["rType"]; //"MP";//


                var tbl2Param = new Dictionary<string, object>
                        {
                            {"DplyId", dplyId}
                        };

                var modeldplyId = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SCHEDULER);
                var dplySchedulerDm = await modeldplyId.GetAsync(Filter.Empty);
                var dplyIds = dplySchedulerDm.Select(e => e["DplyId"].ToString()).ToList();

                DateTime LastdayofWeek = DateTime.MinValue;
                //int n = 7;
                string[] btext;
                string BatchNo;
                int totweek = 0;
                int weekCount = 0;
                string DateString;
                string DateStringtbl2;
                string preResponseRate;
                string responseRate;
                dynamic objActive = new ExpandoObject();
                dynamic objresultL = new ExpandoObject();
                dynamic objresultU = new ExpandoObject();

                if ((rType == "MP" || rType == "IU") && dplyIds.Contains(dplyId))
                {
                    LastDateofWeek = await CalTotDates(dplyId);
                    totweek = LastDateofWeek.Count;
                    for (int a = 0; a < LastDateofWeek.Count; a++)
                    {
                        //LastdayofWeek = DateTime.MinValue;
                        var activeUse = new List<Dictionary<string, object>>();
                        var resultUTable = new List<Dictionary<string, object>>();
                        var resultLTable = new List<Dictionary<string, object>>();

                        weekCount = a + 1;
                        sumTA = sumMTS = sumSTS = sumTS = sumTot = 0;
                        sumTAActiveUse = sumMTSActiveUse = sumSTSActiveUse = sumTSActiveUse = sumTotalActiveUse = 0;
                        sumTAActiveNotUse = sumMTSActiveNotUse = sumSTSActiveNotUse = sumTSActiveNotUse = sumTotalActiveNotUse = 0;
                        sumTAInactive = sumMTSInactive = sumSTSInactive = sumTSInactive = sumTotalInactive = 0;
                        sumTANonResp = sumMTSNonResp = sumSTSNonResp = sumTSNonResp = sumTotalNonResp = 0;
                        valBouncedTA = valBouncedMTS = valBouncedSTS = valBouncedTS = valBouncedTot = 0;
                        sampleAftBandITA = sampleAftBandIMTS = sampleAftBandISTS = sampleAftBandITS = sampleAftBandITot = 0;

                        var item = LastDateofWeek[a];
                        btext = item.ToString("MM dd yyyy").Split(' ');
                        BatchNo = String.Concat(btext[0], btext[1], btext[2]);

                        List<string> batchList = new List<string>();
                        var bParam = new Dictionary<string, object> { { "DplyId", dplyId }, { "Flag", "List" } };
                        var modalBatchNo = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("spSP_GetWeek",
                                        bParam, new Dictionary<string, object>());
                        foreach (var batch in modalBatchNo)
                        {
                            var Batch = (string)batch["BatchNo"];
                            batchList.Add(Batch);
                        }

                        if (!batchList.Contains(BatchNo))
                        {
                            DateString = "Week " + weekCount + " : As of " + LastdayofWeek.ToString("dd MMM yyyy");
                            preResponseRate = "Response Rate for Week : " + (weekCount - 1);
                            responseRate = "Response Rate for Week : " + weekCount;
                        }
                        else
                        {
                            var Param = new Dictionary<string, object>
                        {
                            {"DplyId", dplyId},
                            {"BatchNo",BatchNo}
                        };

                            var weightGroupResult =
                                    await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("spSP_GetDailySnapShot",
                                        Param, new Dictionary<string, object>());
                            if
                              (!weightGroupResult.Any())
                            {
                                return Json(new FailResponse("No response data yet"));
                                //return null;
                            }


                            DateString = "Week " + weekCount + " : As of " + item.ToString("dd MMM yyyy");
                            preResponseRate = "Response Rate for Week : " + (weekCount - 1);
                            responseRate = "Response Rate for Week : " + weekCount;

                            activeUse.Add(new Dictionary<string, object>()
                            {
                                {"ResponseCategory","Response Category"},
                                {"Status", "Status"},
                                {"TA",  "TA"},
                                {"MTS","MTS"},
                                {"STS", "STS" },
                                {"Total", "Total"},

                            });

                            foreach (var dataResult in weightGroupResult)
                            {
                                var code = (string)dataResult["Code"];
                                var ResponseCategory = dataResult["ResponseCategory"];
                                var Status = (string)dataResult["Status"];
                                var TA = (int)dataResult["TA"];
                                var MTS = (int)dataResult["MTS"];
                                var STS = (int)dataResult["STS"];
                                var Total = (int)dataResult["Total"];
                                dataResult.Add("Text", null);

                                sumTA += TA;
                                sumMTS += MTS;
                                sumSTS += STS;
                                sumTot += Total;

                                if ((string)ResponseCategory == "Active(Usable)")
                                {
                                    sumTAActiveUse += TA;
                                    sumMTSActiveUse += MTS;
                                    sumSTSActiveUse += STS;
                                    sumTotalActiveUse += Total;

                                    if (code == "SB")
                                    {
                                        activeUse.Add(new Dictionary<string, object>()
                                {
                                {"ResponseCategory",ResponseCategory},
                                {"Status", Status},
                                {"TA",  dataResult["TA"]},
                                {"MTS", dataResult["MTS"]},
                                {"STS", dataResult["STS"] },
                                {"Total", dataResult["Total"]},
                                });
                                    }
                                    else if (code == "RC")
                                    {
                                        activeUse.Add(new Dictionary<string, object>()
                                {
                                    {"ResponseCategory"," "},
                                    {"Status", Status},
                                    {"TA",  dataResult["TA"]},
                                    {"MTS", dataResult["MTS"]},
                                    {"STS", dataResult["STS"] },
                                    {"Total", dataResult["Total"]},

                                });
                                        activeUse.Add(new Dictionary<string, object>()
                                {
                                    {"ResponseCategory"," "},
                                    {"Status","Active (Usable) Sub Total"},
                                    {"TA",sumTAActiveUse},
                                    {"MTS",sumMTSActiveUse},
                                    {"STS",sumSTSActiveUse},
                                    {"Total",sumTotalActiveUse},
                                });

                                    }
                                    else
                                    {
                                        activeUse.Add(new Dictionary<string, object>()
                                {
                                    {"ResponseCategory"," "},
                                    {"Status", Status},
                                    {"TA",  dataResult["TA"]},
                                    {"MTS", dataResult["MTS"]},
                                    {"STS", dataResult["STS"] },
                                    {"Total", dataResult["Total"]},

                                });
                                    }

                                }
                                else if ((string)ResponseCategory == "Active(Not Usable)")
                                {

                                    sumTAActiveNotUse += TA;
                                    sumMTSActiveNotUse += MTS;
                                    sumSTSActiveNotUse += STS;
                                    sumTotalActiveNotUse += Total;

                                    if (code == "OS")
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                            {
                                {"ResponseCategory",ResponseCategory},
                                {"Status", Status},
                                {"TA",  dataResult["TA"]},
                                {"MTS", dataResult["MTS"]},
                                {"STS", dataResult["STS"] },
                                {"Total", dataResult["Total"]},

                            });

                                    }
                                    else if (code == "EM")
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                            {
                                {"ResponseCategory","  "},
                                {"Status", Status},
                                {"TA",  dataResult["TA"]},
                                {"MTS", dataResult["MTS"]},
                                {"STS", dataResult["STS"] },
                                {"Total", dataResult["Total"]},

                            });

                                        resultLTable.Add(new Dictionary<string, object>()
                            {

                                {"ResponseCategory"," "},
                                {"Status","Active (Not Usable) Sub Total"},
                                {"TA",sumTAActiveNotUse},
                                {"MTS",sumMTSActiveNotUse},
                                {"STS",sumSTSActiveNotUse},
                                {"Total",sumTotalActiveNotUse},

                            });
                                    }

                                    else
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                                {
                                    {"ResponseCategory","  "},
                                    {"Status", Status},
                                    {"TA",  dataResult["TA"]},
                                    {"MTS", dataResult["MTS"]},
                                    {"STS", dataResult["STS"] },
                                    {"Total", dataResult["Total"]},

                                });
                                    }
                                }
                                else if ((string)ResponseCategory == "Inactive")
                                {
                                    sumTAInactive += TA;
                                    sumMTSInactive += MTS;
                                    sumSTSInactive += STS;
                                    sumTotalInactive += Total;

                                    if (code == "CO")
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                            {
                                {"ResponseCategory",ResponseCategory},
                                {"Status", Status},
                                {"TA",  dataResult["TA"]},
                                {"MTS", dataResult["MTS"]},
                                {"STS", dataResult["STS"] },
                                {"Total", dataResult["Total"]},

                            });

                                    }
                                    else if (code == "NI")
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                            {
                                {"ResponseCategory"," "},
                                {"Status", Status},
                                {"TA",  dataResult["TA"]},
                                {"MTS", dataResult["MTS"]},
                                {"STS", dataResult["STS"] },
                                {"Total", dataResult["Total"]},

                            });

                                        resultLTable.Add(new Dictionary<string, object>()
                            {
                                {"ResponseCategory"," "},
                                {"Status","Inactive Sub Total"},
                                {"TA",sumTAInactive},
                                {"MTS",sumMTSInactive},
                                {"STS",sumSTSInactive},
                                {"Total",sumTotalInactive},

                            });
                                    }
                                    else
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                            {
                                {"ResponseCategory"," "},
                                {"Status", Status},
                                {"TA",  dataResult["TA"]},
                                {"MTS", dataResult["MTS"]},
                                {"STS", dataResult["STS"] },
                                {"Total", dataResult["Total"]},

                            });
                                    }

                                }
                                else if ((string)ResponseCategory == "Non-Response")
                                {

                                    sumTANonResp += TA;
                                    sumMTSNonResp += MTS;
                                    sumSTSNonResp += STS;
                                    sumTotalNonResp += Total;

                                    if (code == "BO")
                                    {
                                        valBouncedTA += TA;
                                        valBouncedMTS += MTS;
                                        valBouncedSTS += STS;
                                        valBouncedTot += Total;


                                        resultLTable.Add(new Dictionary<string, object>()
                            {
                                {"ResponseCategory",ResponseCategory},
                                {"Status", Status},
                                {"TA",  dataResult["TA"]},
                                {"MTS", dataResult["MTS"]},
                                {"STS", dataResult["STS"] },
                                {"Total", dataResult["Total"]},

                            });
                                    }
                                    else
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                            {
                                {"ResponseCategory"," "},
                                {"Status", Status},
                                {"TA",  dataResult["TA"]},
                                {"MTS", dataResult["MTS"]},
                                {"STS", dataResult["STS"] },
                                {"Total", dataResult["Total"]},

                            });


                                        resultLTable.Add(new Dictionary<string, object>()
                            {
                                {"ResponseCategory"," "},
                                {"Status","Non-Response Sub Total"},
                                {"TA",sumTANonResp},
                                {"MTS",sumMTSNonResp},
                                {"STS",sumSTSNonResp},
                                {"Total",sumTotalNonResp},

                            });
                                    }

                                }

                                else
                                {

                                    resultLTable.Add(new Dictionary<string, object>()
                            {
                                {"ResponseCategory",ResponseCategory},
                                {"Status",Status},
                                {"TA",dataResult["TA"] },
                                {"MTS", dataResult["MTS"] },
                                {"STS", dataResult["STS"]},
                                {"Total",dataResult["Total"]}

                            });
                                }

                            }

                            resultLTable.Add(new Dictionary<string, object>() //total
							{
                                {"ResponseCategory","Total"},
                                {"Status"," "},
                                {"TA",sumTA},
                                {"MTS", sumMTS },
                                {"STS",sumSTS},
                                {"Total",sumTot}

                            });

                            resultLTable.Add(new Dictionary<string, object>() //total
							{
                                {"ResponseCategory"," "},
                                {"Status"," "},
                                {"TA"," "},
                                {"MTS", " " },
                                {"STS"," "},
                                {"Total"," "}

                            });

                            #region UpperTable

                            resultUTable.Add(new Dictionary<string, object>() //Hdr row 1
							{
                            {"EnterpriseType",DateString},
                            {"ActiveCases","" },
                            {"InactiveCases","" },
                            {"SampleSize","" },
                            {"SampleSizeAft",""},
                            {"ResponseRate",""},
                            {"ResponseRateforPweek","" }
                            });



                            sampleAftBandITA = (sumTA - (valBouncedTA + sumTAInactive));
                            sampleAftBandIMTS = (sumMTS - (valBouncedMTS + sumMTSInactive));
                            sampleAftBandISTS = (sumSTS - (valBouncedSTS + sumSTSInactive));
                            sampleAftBandITot = (sumTot - (valBouncedTot + sumTotalInactive));


                            if (sampleAftBandITA != 0)
                            {
                                responseRateTA = Math.Round((((decimal)(sumTAActiveUse + sumTAActiveNotUse) / (decimal)sampleAftBandITA) * 100m), 2);
                                preTAResponse.Add(responseRateTA);
                            }
                            else
                            {
                                responseRateTA = 0;
                                preTAResponse.Add(responseRateTA);

                            }

                            if (sampleAftBandIMTS != 0)
                            {

                                responseRateMTS = Math.Round((((decimal)(sumMTSActiveUse + sumMTSActiveNotUse) / (decimal)sampleAftBandIMTS) * 100m), 2);
                                preMTSResponse.Add(responseRateMTS);
                            }
                            else
                            {

                                responseRateMTS = 0;
                                preMTSResponse.Add(responseRateMTS);
                            }
                            if (sampleAftBandISTS != 0)
                            {

                                responseRateSTS = Math.Round((((decimal)(sumSTSActiveUse + sumSTSActiveNotUse) / (decimal)sampleAftBandISTS) * 100m), 2);
                                preSTSResponse.Add(responseRateSTS);
                            }
                            else
                            {

                                responseRateSTS = 0;
                                preSTSResponse.Add(responseRateSTS);

                            }
                            if (sampleAftBandITot != 0)
                            {

                                responseRateTot = Math.Round((((decimal)(sumTotalActiveUse + sumTotalActiveNotUse) / (decimal)sampleAftBandITot) * 100m), 2);
                                preTotResponse.Add(responseRateTot);
                            }
                            else
                            {

                                responseRateTot = 0;
                                preTotResponse.Add(responseRateTot);

                            }


                            int index = 0;
                            if (preTAResponse.Count != 0 && preTAResponse.Count != 1)
                            {
                                index = preTAResponse.Count - 2;
                                preTA = preTAResponse[index];
                            }
                            else
                            {
                                preTA = 0;
                            }

                            if (preMTSResponse.Count != 0 && preMTSResponse.Count != 1)
                            {
                                index = preMTSResponse.Count - 2;
                                preMTS = preMTSResponse[index];
                            }
                            else
                            {
                                preMTS = 0;
                            }

                            if (preSTSResponse.Count != 0 && preSTSResponse.Count != 1)
                            {
                                index = preSTSResponse.Count - 2;
                                preSTS = preSTSResponse[index];
                            }
                            else
                            {
                                preSTS = 0;
                            }
                            if (preTotResponse.Count != 0 && preTotResponse.Count != 1)
                            {
                                index = preTotResponse.Count - 2;
                                preTot = preTotResponse[index];
                            }
                            else
                            {
                                preTot = 0;
                            }


                            if ((weekCount - 1) != 0)
                            {

                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Enterprise Type" },
                    {"ActiveCases","Active Cases (No. of Responses)" },
                    {"InactiveCases","Inactive Cases (No. of Response)" },
                    {"SampleSize","Sample Size" },
                    {"SampleSizeAft","Sample Size After Removing bounced and Inactive cases"},
                    {"ResponseRate",responseRate},
                    {"ResponseRateforPweek",preResponseRate }
                });

                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","TA" },
                    {"ActiveCases",sumTAActiveUse+sumTAActiveNotUse },
                    {"InactiveCases",sumTAInactive },
                    {"SampleSize",sumTA },
                    {"SampleSizeAft",sampleAftBandITA},
                    {"ResponseRate",responseRateTA+"%"},
                    {"ResponseRateforPweek",preTA+"%" }
                });

                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","MTS" },
                    {"ActiveCases", sumMTSActiveUse+sumMTSActiveNotUse},
                    {"InactiveCases",sumMTSInactive },
                    {"SampleSize",sumMTS },
                    {"SampleSizeAft",sampleAftBandIMTS},
                    {"ResponseRate",responseRateMTS+"%"},
                    {"ResponseRateforPweek",preMTS+"%" }
                });
                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","STS" },
                    {"ActiveCases", sumSTSActiveUse+sumSTSActiveNotUse},
                    {"InactiveCases",sumSTSInactive },
                    {"SampleSize",sumSTS },
                    {"SampleSizeAft",sampleAftBandISTS},
                    {"ResponseRate",responseRateSTS+"%"},
                    {"ResponseRateforPweek",preSTS+"%" }
                });

                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Total:" },
                    {"ActiveCases", sumTotalActiveUse+sumTotalActiveNotUse},
                    {"InactiveCases",sumTotalInactive },
                    {"SampleSize",sumTot },
                    {"SampleSizeAft",sampleAftBandITot},
                    {"ResponseRate",responseRateTot+"%"},
                    {"ResponseRateforPweek",preTot+"%"}
                });
                            }
                            else
                            {
                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Enterprise Type" },
                    {"ActiveCases","Active Cases (No. of Responses)" },
                    {"InactiveCases","Inactive Cases (No. of Response)" },
                    {"SampleSize","Sample Size" },
                    {"SampleSizeAft","Sample Size After Removing bounced and Inactive cases"},
                    {"ResponseRate",responseRate},
                   // {"ResponseRateforPweek",preResponseRate }
                });

                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","TA" },
                    {"ActiveCases",sumTAActiveUse+sumTAActiveNotUse },
                    {"InactiveCases",sumTAInactive },
                    {"SampleSize",sumTA },
                    {"SampleSizeAft",sampleAftBandITA},
                    {"ResponseRate",responseRateTA+"%"},
                    //{"ResponseRateforPweek",preTA+"%" }
                });

                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","MTS" },
                    {"ActiveCases", sumMTSActiveUse+sumMTSActiveNotUse},
                    {"InactiveCases",sumMTSInactive },
                    {"SampleSize",sumMTS },
                    {"SampleSizeAft",sampleAftBandIMTS},
                    {"ResponseRate",responseRateMTS+"%"},
                   // {"ResponseRateforPweek",preMTS+"%" }
                });
                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","STS" },
                    {"ActiveCases", sumSTSActiveUse+sumSTSActiveNotUse},
                    {"InactiveCases",sumSTSInactive },
                    {"SampleSize",sumSTS },
                    {"SampleSizeAft",sampleAftBandISTS},
                    {"ResponseRate",responseRateSTS+"%"},
                    //{"ResponseRateforPweek",preSTS+"%" }
                });

                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Total:" },
                    {"ActiveCases", sumTotalActiveUse+sumTotalActiveNotUse},
                    {"InactiveCases",sumTotalInactive },
                    {"SampleSize",sumTot },
                    {"SampleSizeAft",sampleAftBandITot},
                    {"ResponseRate",responseRateTot+"%"},
                    //{"ResponseRateforPweek",preTot+"%"}
                });
                            }
                            #endregion

                        }


                            //weekCountObj.test = new dynamic[1];
                            //weekCountObj.test["Week" + weekCount] = activeUse;
                            ((IDictionary<String, Object>)objActive)[Convert.ToString(weekCount)] = activeUse;
                        ((IDictionary<String, Object>)objresultL)[Convert.ToString(weekCount)] = resultLTable;
                        ((IDictionary<String, Object>)objresultU)[Convert.ToString(weekCount)] = resultUTable;

                    }


                }
                else if ((rType == "II" || rType == "MI") && dplyIds.Contains(dplyId))
                {
                    LastDateofWeek = await CalTotDates(dplyId);
                    totweek = LastDateofWeek.Count;
                    for (int a = 0; a < LastDateofWeek.Count; a++)
                    {
                        //LastdayofWeek = DateTime.MinValue;
                        var activeUse = new List<Dictionary<string, object>>();
                        var resultUTable = new List<Dictionary<string, object>>();
                        var resultLTable = new List<Dictionary<string, object>>();

                        weekCount = a + 1;

                        sumTA = sumMTS = sumSTS = sumTS = sumTot = 0;
                        sumTAActiveUse = sumMTSActiveUse = sumSTSActiveUse = sumTSActiveUse = sumTotalActiveUse = 0;
                        sumTAActiveNotUse = sumMTSActiveNotUse = sumSTSActiveNotUse = sumTSActiveNotUse = sumTotalActiveNotUse = 0;
                        sumTAInactive = sumMTSInactive = sumSTSInactive = sumTSInactive = sumTotalInactive = 0;
                        sumTANonResp = sumMTSNonResp = sumSTSNonResp = sumTSNonResp = sumTotalNonResp = 0;
                        valBouncedTA = valBouncedMTS = valBouncedSTS = valBouncedTS = valBouncedTot = 0;
                        sampleAftBandITA = sampleAftBandIMTS = sampleAftBandISTS = sampleAftBandITS = sampleAftBandITot = 0;

                        var item = LastDateofWeek[a];

                        btext = item.ToString("MM dd yyyy").Split(' ');
                        BatchNo = String.Concat(btext[0], btext[1], btext[2]);


                        List<string> batchList = new List<string>();
                        var bParam = new Dictionary<string, object> { { "DplyId", dplyId }, { "Flag", "List" } };
                        var modalBatchNo = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("spSP_GetWeek",
                                        bParam, new Dictionary<string, object>());
                        foreach (var batch in modalBatchNo)
                        {
                            var Batch = (string)batch["BatchNo"];
                            batchList.Add(Batch);
                        }

                        //BatchNo = "02062020";
                        if (!batchList.Contains(BatchNo))
                        {

                            DateString = "Week " + weekCount + " : As of " + LastdayofWeek.ToString("dd MMM yyyy");
                            preResponseRate = "Response Rate for Week : " + (weekCount - 1);
                            responseRate = "Response Rate for Week : " + weekCount;

                            //activeUse.Add(new Dictionary<string, object>());
                            //resultLTable.Add(new Dictionary<string, object>());
                            //resultUTable.Add(new Dictionary<string, object>());




                        }
                        else
                        {


                            var Param = new Dictionary<string, object>
                        {
                            {"DplyId", dplyId},
                            {"BatchNo",BatchNo}
                        };


                            var weightGroupResult =
                                    await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("spSP_GetDailySnapShot",
                                        Param, new Dictionary<string, object>());
                            if
                              (!weightGroupResult.Any())
                            {
                                return Json(new FailResponse("No response data yet"));
                                //return null;
                            }


                            DateString = "Week " + weekCount + " : As of " + item.ToString("dd MMM yyyy");
                            preResponseRate = "Response Rate for Week : " + (weekCount - 1);
                            responseRate = "Response Rate for Week : " + weekCount;


                            #region LowerTable



                            activeUse.Add(new Dictionary<string, object>()
                {
                     {"ResponseCategory","Response Category"},
                                            {"Status", "Status"},
                                            {"TA",  "TA"},
                                            {"TS", "TS"},
                                            {"Total", "Total"},

                });


                            foreach (var dataResult in weightGroupResult)
                            {
                                var code = (string)dataResult["Code"];
                                var ResponseCategory = dataResult["ResponseCategory"];
                                var Status = (string)dataResult["Status"];
                                var TA = (int)dataResult["TA"];
                                var TS = (int)dataResult["TS"];
                                var Total = (int)dataResult["TOTALS"];
                                dataResult.Add("Text", null);


                                sumTA += TA;
                                sumTS += TS;
                                sumTot += Total;

                                if ((string)ResponseCategory == "Active(Usable)")
                                {

                                    sumTAActiveUse += TA;
                                    sumTSActiveUse += TS;
                                    sumTotalActiveUse += Total;

                                    if (code == "SB")
                                    {
                                        activeUse.Add(new Dictionary<string, object>()
                                        {
                                {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS },
                                            {"Total", Total},

                                        });
                                    }
                                    else if (code == "RC")
                                    {
                                        activeUse.Add(new Dictionary<string, object>()
                                        {
                                {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total", Total},

                                        });

                                        activeUse.Add(new Dictionary<string, object>()
                        {
                            {"ResponseCategory"," "},
                            {"Status","Active (Usable) Sub Total"},
                            {"TA",sumTAActiveUse},
                            {"TS",sumTSActiveUse},
                            {"Total",sumTotalActiveUse},

                        });

                                    }
                                    else
                                    {
                                        activeUse.Add(new Dictionary<string, object>()
                                        {
                                {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS },
                                            {"Total", Total},

                                        });
                                    }

                                }
                                else if ((string)ResponseCategory == "Active(Not Usable)")
                                {

                                    sumTAActiveNotUse += TA;

                                    sumTSActiveNotUse += TS;
                                    sumTotalActiveNotUse += Total;


                                    if (code == "OS")
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                                        {
                                    {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS },
                                            {"Total", Total},

                                        });

                                    }
                                    else if (code == "EM")
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                                        {
                                    {"ResponseCategory","  "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total", Total},

                                        });

                                        resultLTable.Add(new Dictionary<string, object>()
                        {

                            {"ResponseCategory"," "},
                            {"Status","Active (Not Usable) Sub Total"},
                            {"TA",sumTAActiveNotUse},
                            {"TS",sumTSActiveNotUse},
                            {"Total",sumTotalActiveNotUse},

                        });
                                    }

                                    else
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                                        {
                                    {"ResponseCategory","  "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS",TS},
                                            {"Total", Total},

                                        });
                                    }



                                }
                                else if ((string)ResponseCategory == "Inactive")
                                {
                                    sumTAInactive += TA;

                                    sumTSInactive += TS;
                                    sumTotalInactive += Total;


                                    if (code == "CO")
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total", Total},

                                        });

                                    }
                                    else if (code == "NI")
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total", Total},

                                        });

                                        resultLTable.Add(new Dictionary<string, object>()
                        {
                            {"ResponseCategory"," "},
                            {"Status","Inactive Sub Total"},
                            {"TA",sumTAInactive},
                            {"TS",sumTSInactive},
                            {"Total",sumTotalInactive},

                        });
                                    }
                                    else
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total", Total},

                                        });
                                    }

                                }
                                else if ((string)ResponseCategory == "Non-Response")
                                {

                                    sumTANonResp += TA;
                                    sumTSNonResp += TS;
                                    sumTotalNonResp += Total;


                                    if (code == "BO")
                                    {
                                        valBouncedTA += TA;

                                        valBouncedTS += TS;
                                        valBouncedTot += Total;


                                        resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total", Total},

                                        });
                                    }
                                    else
                                    {
                                        resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total",Total},

                                        });


                                        resultLTable.Add(new Dictionary<string, object>()
                        {
                            {"ResponseCategory"," "},
                            {"Status","Non-Response Sub Total"},
                            {"TA",sumTANonResp},
                            {"TS",sumTSNonResp},
                            {"Total",sumTotalNonResp},

                        });
                                    }

                                }

                                else
                                {

                                    resultLTable.Add(new Dictionary<string, object>()
                        {
                             {"ResponseCategory",ResponseCategory},
                            {"Status",Status},
                            {"TA",TA },
                            {"TS", TS },
                            {"Total",Total}

                        });
                                }

                            }

                            resultLTable.Add(new Dictionary<string, object>() //total
                        {
                            {"ResponseCategory","Total"},
                            {"Status"," "},
                            {"TA",sumTA},
                            {"TS", sumTS },
                            {"Total",sumTot}
                        });


                            resultLTable.Add(new Dictionary<string, object>() //total
                        {
                            {"ResponseCategory"," "},
                            {"Status"," "},
                            {"TA"," "},
                            {"TS", " " },
                            {"Total"," "}
                        });

                            #endregion

                            #region UpperTable

                            resultUTable.Add(new Dictionary<string, object>() //Hdr row 1
                {
                    {"EnterpriseType",DateString},
                    {"ActiveCases","" },
                    {"InactiveCases","" },
                    {"SampleSize","" },
                    {"SampleSizeAft",""},
                    {"ResponseRate",""},
                    {"ResponseRateforPweek","" }
                });






                            sampleAftBandITA = (sumTA - (valBouncedTA + sumTAInactive));
                            sampleAftBandITS = (sumTS - (valBouncedTS + sumTSInactive));
                            sampleAftBandITot = (sumTot - (valBouncedTot + sumTotalInactive));

                            if (sampleAftBandITA != 0)
                            {
                                responseRateTA = Math.Round((((decimal)sumTAActiveUse / (decimal)sampleAftBandITA) * 100m), 2);
                                preTAResponse.Add(responseRateTA);
                            }
                            else
                            {
                                responseRateTA = 0;
                                preTAResponse.Add(responseRateTA);
                            }
                            if (sampleAftBandITS != 0)
                            {

                                responseRateTS = Math.Round((((decimal)sumTSActiveUse / (decimal)sampleAftBandITS) * 100m), 2);
                                preTSResponse.Add(responseRateTS);
                            }
                            else
                            {

                                responseRateTS = 0;
                                preTSResponse.Add(responseRateTS);

                            }
                            if (sampleAftBandITot != 0)
                            {

                                responseRateTot = Math.Round((((decimal)sumTotalActiveUse / (decimal)sampleAftBandITot) * 100m), 2);
                                preTotResponse.Add(responseRateTot);
                            }
                            else
                            {
                                responseRateTot = 0;
                                preTotResponse.Add(responseRateTot);
                            }


                            int index = 0;

                            if (preTAResponse.Count != 0 && preTAResponse.Count != 1)
                            {
                                index = preTAResponse.Count - 2;
                                preTA = preTAResponse[index];
                            }
                            else
                            {
                                preTA = 0;
                            }


                            if (preTSResponse.Count != 0 && preTSResponse.Count != 1)
                            {
                                index = preTSResponse.Count - 2;
                                preTS = preTSResponse[index];
                            }
                            else
                            {
                                preTS = 0;
                            }
                            if (preTotResponse.Count != 0 && preTotResponse.Count != 1)
                            {
                                index = preTotResponse.Count - 2;
                                preTot = preTotResponse[index];
                            }
                            else
                            {
                                preTot = 0;
                            }

                            if ((weekCount - 1) != 0)
                            {
                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Enterprise Type" },
                    {"ActiveCases","Active Cases (No. of Responses)" },
                    {"InactiveCases","Inactive Cases (No. of Response)" },
                    {"SampleSize","Sample Size" },
                    {"SampleSizeAft","Sample Size After Removing bounced and Inactive cases"},
                    {"ResponseRate",responseRate},
                    {"ResponseRateforPweek",preResponseRate }
                });
                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","TA" },
                    {"ActiveCases",sumTAActiveUse+sumTAActiveNotUse },
                    {"InactiveCases",sumTAInactive },
                    {"SampleSize",sumTA },
                    {"SampleSizeAft",sampleAftBandITA},
                    {"ResponseRate",responseRateTA+"%"},
                    {"ResponseRateforPweek",preTA+"%" }
                });


                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","TS" },
                    {"ActiveCases", sumTSActiveUse+sumTSActiveNotUse},
                    {"InactiveCases",sumTSInactive },
                    {"SampleSize",sumTS },
                    {"SampleSizeAft",sampleAftBandITS},
                    {"ResponseRate",responseRateTS+"%"},
                    {"ResponseRateforPweek",preTS+"%" }
                });

                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Total:" },
                    {"ActiveCases", sumTotalActiveUse+sumTotalActiveNotUse},
                    {"InactiveCases",sumTotalInactive },
                    {"SampleSize",sumTot },
                    {"SampleSizeAft",sampleAftBandITot},
                    {"ResponseRate",responseRateTot+"%"},
                    {"ResponseRateforPweek",preTot+"%" }
                });


                            }
                            else
                            {
                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Enterprise Type" },
                    {"ActiveCases","Active Cases (No. of Responses)" },
                    {"InactiveCases","Inactive Cases (No. of Response)" },
                    {"SampleSize","Sample Size" },
                    {"SampleSizeAft","Sample Size After Removing bounced and Inactive cases"},
                    {"ResponseRate",responseRate},
                   // {"ResponseRateforPweek",preResponseRate }
                });
                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","TA" },
                    {"ActiveCases",sumTAActiveUse+sumTAActiveNotUse },
                    {"InactiveCases",sumTAInactive },
                    {"SampleSize",sumTA },
                    {"SampleSizeAft",sampleAftBandITA},
                    {"ResponseRate",responseRateTA+"%"},
                   // {"ResponseRateforPweek",preTA+"%" }
                });


                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","TS" },
                    {"ActiveCases", sumTSActiveUse+sumTSActiveNotUse},
                    {"InactiveCases",sumTSInactive },
                    {"SampleSize",sumTS },
                    {"SampleSizeAft",sampleAftBandITS},
                    {"ResponseRate",responseRateTS+"%"},
                    //{"ResponseRateforPweek",preTS+"%" }
                });

                                resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Total:" },
                    {"ActiveCases", sumTotalActiveUse+sumTotalActiveNotUse},
                    {"InactiveCases",sumTotalInactive },
                    {"SampleSize",sumTot },
                    {"SampleSizeAft",sampleAftBandITot},
                    {"ResponseRate",responseRateTot+"%"},
                   // {"ResponseRateforPweek",preTot+"%" }
                });
                            }



                            #endregion

                        }

                        ((IDictionary<String, Object>)objActive)[Convert.ToString(weekCount)] = activeUse;
                        ((IDictionary<String, Object>)objresultL)[Convert.ToString(weekCount)] = resultLTable;
                        ((IDictionary<String, Object>)objresultU)[Convert.ToString(weekCount)] = resultUTable;

                    }


                }
                else if ((rType == "MP" || rType == "IU") && (!dplyIds.Contains(dplyId)))
                {

                    var activeUse = new List<Dictionary<string, object>>();
                    var resultUTable = new List<Dictionary<string, object>>();
                    var resultLTable = new List<Dictionary<string, object>>();

                    var modeltbl2 = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY); // call dply tbl
                    var datatbl2 = (await modeltbl2.GetAsync(Filter.And.Equal(dplyId, "Id"))).FirstOrDefault() as dynamic;

                    var weightGroupResulttbl2 =
                              await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("spSP_GetWeightgroupbyDplyID",
                                                                             tbl2Param, new Dictionary<string, object>());

                    totweek = 1;
                    #region Date Calculation
                    DateStringtbl2 = await CalDateString(dplyId);
                    #endregion

                    sumTA = sumMTS = sumSTS = sumTS = sumTot = 0;
                    sumTAActiveUse = sumMTSActiveUse = sumSTSActiveUse = sumTSActiveUse = sumTotalActiveUse = 0;
                    sumTAActiveNotUse = sumMTSActiveNotUse = sumSTSActiveNotUse = sumTSActiveNotUse = sumTotalActiveNotUse = 0;
                    sumTAInactive = sumMTSInactive = sumSTSInactive = sumTSInactive = sumTotalInactive = 0;
                    sumTANonResp = sumMTSNonResp = sumSTSNonResp = sumTSNonResp = sumTotalNonResp = 0;
                    valBouncedTA = valBouncedMTS = valBouncedSTS = valBouncedTS = valBouncedTot = 0;
                    sampleAftBandITA = sampleAftBandIMTS = sampleAftBandISTS = sampleAftBandITS = sampleAftBandITot = 0;

                    #region LowerTable




                    activeUse.Add(new Dictionary<string, object>()
                {
                     {"ResponseCategory","Response Category"},
                                            {"Status", "Status"},
                                            {"TA",  "TA"},
                                            {"MTS","MTS"},
                                            {"STS", "STS" },
                                            {"Total", "Total"},

                });


                    foreach (var dataResult in weightGroupResulttbl2)
                    {
                        var code = (string)dataResult["Code"];
                        var ResponseCategory = dataResult["ResponseCategory"];
                        var Status = (string)dataResult["Status"];
                        var TA = (int)dataResult["TA"];
                        var MTS = (int)dataResult["MTS"];
                        var STS = (int)dataResult["STS"];
                        var Total = (int)dataResult["Total"];
                        dataResult.Add("Text", null);


                        sumTA += TA;
                        sumMTS += MTS;
                        sumSTS += STS;
                        sumTot += Total;




                        if ((string)ResponseCategory == "Active(Usable)")
                        {

                            sumTAActiveUse += TA;
                            sumMTSActiveUse += MTS;
                            sumSTSActiveUse += STS;
                            sumTotalActiveUse += Total;
                            if (code == "SB")
                            {
                                activeUse.Add(new Dictionary<string, object>()
                                        {
                                {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  dataResult["TA"]},
                                            {"MTS", dataResult["MTS"]},
                                            {"STS", dataResult["STS"] },
                                            {"Total", dataResult["Total"]},

                                        });
                            }
                            else if (code == "RC")
                            {
                                activeUse.Add(new Dictionary<string, object>()
                                        {
                                {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  dataResult["TA"]},
                                            {"MTS", dataResult["MTS"]},
                                            {"STS", dataResult["STS"] },
                                            {"Total", dataResult["Total"]},

                                        });

                                activeUse.Add(new Dictionary<string, object>()
                        {
                            {"ResponseCategory"," "},
                            {"Status","Active (Usable) Sub Total"},
                            {"TA",sumTAActiveUse},
                            {"MTS",sumMTSActiveUse},
                            {"STS",sumSTSActiveUse},
                            {"Total",sumTotalActiveUse},

                        });

                            }
                            else
                            {
                                activeUse.Add(new Dictionary<string, object>()
                                        {
                                {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  dataResult["TA"]},
                                            {"MTS", dataResult["MTS"]},
                                            {"STS", dataResult["STS"] },
                                            {"Total", dataResult["Total"]},

                                        });
                            }

                        }
                        else if ((string)ResponseCategory == "Active(Not Usable)")
                        {

                            sumTAActiveNotUse += TA;
                            sumMTSActiveNotUse += MTS;
                            sumSTSActiveNotUse += STS;
                            sumTotalActiveNotUse += Total;
                            if (code == "OS")
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                                    {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  dataResult["TA"]},
                                            {"MTS", dataResult["MTS"]},
                                            {"STS", dataResult["STS"] },
                                            {"Total", dataResult["Total"]},

                                        });

                            }
                            else if (code == "EM")
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                                    {"ResponseCategory","  "},
                                            {"Status", Status},
                                            {"TA",  dataResult["TA"]},
                                            {"MTS", dataResult["MTS"]},
                                            {"STS", dataResult["STS"] },
                                            {"Total", dataResult["Total"]},

                                        });

                                resultLTable.Add(new Dictionary<string, object>()
                        {

                            {"ResponseCategory"," "},
                            {"Status","Active (Not Usable) Sub Total"},
                            {"TA",sumTAActiveNotUse},
                            {"MTS",sumMTSActiveNotUse},
                            {"STS",sumSTSActiveNotUse},
                            {"Total",sumTotalActiveNotUse},

                        });
                            }

                            else
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                                    {"ResponseCategory","  "},
                                            {"Status", Status},
                                            {"TA",  dataResult["TA"]},
                                            {"MTS", dataResult["MTS"]},
                                            {"STS", dataResult["STS"] },
                                            {"Total", dataResult["Total"]},

                                        });
                            }



                        }
                        else if ((string)ResponseCategory == "Inactive")
                        {
                            sumTAInactive += TA;
                            sumMTSInactive += MTS;
                            sumSTSInactive += STS;
                            sumTotalInactive += Total;

                            if (code == "CO")
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  dataResult["TA"]},
                                            {"MTS", dataResult["MTS"]},
                                            {"STS", dataResult["STS"] },
                                            {"Total", dataResult["Total"]},

                                        });

                            }
                            else if (code == "NI")
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  dataResult["TA"]},
                                            {"MTS", dataResult["MTS"]},
                                            {"STS", dataResult["STS"] },
                                            {"Total", dataResult["Total"]},

                                        });

                                resultLTable.Add(new Dictionary<string, object>()
                        {
                            {"ResponseCategory"," "},
                            {"Status","Inactive Sub Total"},
                            {"TA",sumTAInactive},
                            {"MTS",sumMTSInactive},
                            {"STS",sumSTSInactive},
                            {"Total",sumTotalInactive},

                        });
                            }
                            else
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  dataResult["TA"]},
                                            {"MTS", dataResult["MTS"]},
                                            {"STS", dataResult["STS"] },
                                            {"Total", dataResult["Total"]},

                                        });
                            }

                        }
                        else if ((string)ResponseCategory == "Non-Response")
                        {

                            sumTANonResp += TA;
                            sumMTSNonResp += MTS;
                            sumSTSNonResp += STS;
                            sumTotalNonResp += Total;

                            if (code == "BO")
                            {
                                valBouncedTA += TA;
                                valBouncedMTS += MTS;
                                valBouncedSTS += STS;
                                valBouncedTot += Total;

                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  dataResult["TA"]},
                                            {"MTS", dataResult["MTS"]},
                                            {"STS", dataResult["STS"] },
                                            {"Total", dataResult["Total"]},

                                        });
                            }
                            else
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  dataResult["TA"]},
                                            {"MTS", dataResult["MTS"]},
                                            {"STS", dataResult["STS"] },
                                            {"Total", dataResult["Total"]},

                                        });


                                resultLTable.Add(new Dictionary<string, object>()
                        {
                            {"ResponseCategory"," "},
                            {"Status","Non-Response Sub Total"},
                            {"TA",sumTANonResp},
                            {"MTS",sumMTSNonResp},
                            {"STS",sumSTSNonResp},
                            {"Total",sumTotalNonResp},

                        });
                            }

                        }

                        else
                        {

                            resultLTable.Add(new Dictionary<string, object>()
                        {
                              {"ResponseCategory",ResponseCategory},
                            {"Status",Status},
                            {"TA",dataResult["TA"] },
                            {"MTS", dataResult["MTS"] },
                            {"STS", dataResult["STS"]},
                            {"Total",dataResult["Total"]}

                        });
                        }

                    }

                    resultLTable.Add(new Dictionary<string, object>() //total
                        {
                            {"ResponseCategory","Total"},
                            {"Status"," "},
                            {"TA",sumTA},
                            {"MTS", sumMTS },
                            {"STS",sumSTS},
                            {"Total",sumTot}

                        });


                    #endregion

                    #region UpperTable

                    resultUTable.Add(new Dictionary<string, object>() //Hdr row 1
                {
                    {"EnterpriseType",DateStringtbl2},
                    {"ActiveCases","" },
                    {"InactiveCases","" },
                    {"SampleSize","" },
                    {"SampleSizeAft",""},
                    {"ResponseRate",""},
                    //{"ResponseRateforPweek","" }
                });

                    resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Enterprise Type" },
                    {"ActiveCases","Active Cases (No. of Responses)" },
                    {"InactiveCases","Inactive Cases (No. of Response)" },
                    {"SampleSize","Sample Size" },
                    {"SampleSizeAft","Sample Size After Removing bounced and Inactive cases"},
                    {"ResponseRate","Response Rate"},
                    //{"ResponseRateforPweek","Response Rate for Previous Week" }
                });



                    sampleAftBandITA = (sumTA - (valBouncedTA + sumTAInactive));
                    sampleAftBandIMTS = (sumMTS - (valBouncedMTS + sumMTSInactive));
                    sampleAftBandISTS = (sumSTS - (valBouncedSTS + sumSTSInactive));
                    sampleAftBandITot = (sumTot - (valBouncedTot + sumTotalInactive));

                    if (sampleAftBandITA != 0)
                    {
                        responseRateTA = Math.Round((((decimal)(sumTAActiveUse + sumTAActiveNotUse) / (decimal)sampleAftBandITA) * 100m), 2);

                    }
                    else
                    {
                        responseRateTA = 0;


                    }

                    if (sampleAftBandIMTS != 0)
                    {

                        responseRateMTS = Math.Round((((decimal)(sumMTSActiveUse + sumMTSActiveNotUse) / (decimal)sampleAftBandIMTS) * 100m), 2);

                    }
                    else
                    {

                        responseRateMTS = 0;

                    }
                    if (sampleAftBandISTS != 0)
                    {

                        responseRateSTS = Math.Round((((decimal)(sumSTSActiveUse + sumSTSActiveNotUse) / (decimal)sampleAftBandISTS) * 100m), 2);

                    }
                    else
                    {

                        responseRateSTS = 0;


                    }
                    if (sampleAftBandITot != 0)
                    {

                        responseRateTot = Math.Round((((decimal)(sumTotalActiveUse + sumTotalActiveNotUse) / (decimal)sampleAftBandITot) * 100m), 2);
                    }
                    else
                    {

                        responseRateTot = 0;

                    }
                    resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","TA" },
                    {"ActiveCases",sumTAActiveUse+sumTAActiveNotUse },
                    {"InactiveCases",sumTAInactive },
                    {"SampleSize",sumTA },
                    {"SampleSizeAft",sampleAftBandITA},
                    {"ResponseRate",responseRateTA+"%"},
                    {"ResponseRateforPweek"," " }
                });

                    resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","MTS" },
                    {"ActiveCases", sumMTSActiveUse+sumMTSActiveNotUse},
                    {"InactiveCases",sumMTSInactive },
                    {"SampleSize",sumMTS },
                    {"SampleSizeAft",sampleAftBandIMTS},
                    {"ResponseRate",responseRateMTS+"%"},
                    {"ResponseRateforPweek"," " }
                });
                    resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","STS" },
                    {"ActiveCases", sumSTSActiveUse+sumSTSActiveNotUse},
                    {"InactiveCases",sumSTSInactive },
                    {"SampleSize",sumSTS },
                    {"SampleSizeAft",sampleAftBandISTS},
                    {"ResponseRate",responseRateSTS+"%"},
                    {"ResponseRateforPweek"," " }
                });

                    resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Total:" },
                    {"ActiveCases", sumTotalActiveUse+sumTotalActiveNotUse},
                    {"InactiveCases",sumTotalInactive },
                    {"SampleSize",sumTot },
                    {"SampleSizeAft",sampleAftBandITot},
                    {"ResponseRate",responseRateTot+"%"},
                    {"ResponseRateforPweek"," " }
                });

                    #endregion

                    ((IDictionary<String, Object>)objActive)[Convert.ToString(1)] = activeUse;
                    ((IDictionary<String, Object>)objresultL)[Convert.ToString(1)] = resultLTable;
                    ((IDictionary<String, Object>)objresultU)[Convert.ToString(1)] = resultUTable;

                }

                else
                {

                    var activeUse = new List<Dictionary<string, object>>();
                    var resultUTable = new List<Dictionary<string, object>>();
                    var resultLTable = new List<Dictionary<string, object>>();

                    var modeltbl2 = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY); // call dply tbl
                    var datatbl2 = (await modeltbl2.GetAsync(Filter.And.Equal(dplyId, "Id"))).FirstOrDefault() as dynamic;
                    totweek = 1;
                    sumTA = sumMTS = sumSTS = sumTS = sumTot = 0;
                    sumTAActiveUse = sumMTSActiveUse = sumSTSActiveUse = sumTSActiveUse = sumTotalActiveUse = 0;
                    sumTAActiveNotUse = sumMTSActiveNotUse = sumSTSActiveNotUse = sumTSActiveNotUse = sumTotalActiveNotUse = 0;
                    sumTAInactive = sumMTSInactive = sumSTSInactive = sumTSInactive = sumTotalInactive = 0;
                    sumTANonResp = sumMTSNonResp = sumSTSNonResp = sumTSNonResp = sumTotalNonResp = 0;
                    valBouncedTA = valBouncedMTS = valBouncedSTS = valBouncedTS = valBouncedTot = 0;
                    sampleAftBandITA = sampleAftBandIMTS = sampleAftBandISTS = sampleAftBandITS = sampleAftBandITot = 0;

                    var weightGroupResulttbl2 =
                                    await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("spSP_GetWeightgroupbyDplyID",
                                     tbl2Param, new Dictionary<string, object>());

                    DateStringtbl2 = await CalDateString(dplyId);

                    #region LowerTable
                    activeUse.Add(new Dictionary<string, object>()
                {
                     {"ResponseCategory","Response Category"},
                        {"Status", "Status"},
                        {"TA",  "TA"},
                        {"TS", "TS"},
                        {"Total", "Total"},
                });

                    foreach (var dataResult in weightGroupResulttbl2)
                    {
                        var code = (string)dataResult["Code"];
                        var ResponseCategory = dataResult["ResponseCategory"];
                        var Status = (string)dataResult["Status"];
                        var TA = (int)dataResult["TA"];
                        var TS = (int)dataResult["TS"];
                        var Total = (int)dataResult["TOTALS"];
                        dataResult.Add("Text", null);

                        sumTA += TA;
                        sumTS += TS;
                        sumTot += Total;

                        if ((string)ResponseCategory == "Active(Usable)")
                        {
                            sumTAActiveUse += TA;
                            sumTSActiveUse += TS;
                            sumTotalActiveUse += Total;
                            if (code == "SB")
                            {
                                activeUse.Add(new Dictionary<string, object>()
                                        {
                                {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS },
                                            {"Total", Total},

                                        });
                            }
                            else if (code == "RC")
                            {
                                activeUse.Add(new Dictionary<string, object>()
                                {
                                    {"ResponseCategory"," "},
                                    {"Status", Status},
                                    {"TA",  TA},
                                    {"TS", TS},
                                    {"Total", Total},
                                });

                                activeUse.Add(new Dictionary<string, object>()
                        {
                            {"ResponseCategory"," "},
                            {"Status","Active (Usable) Sub Total"},
                            {"TA",sumTAActiveUse},
                            {"TS",sumTSActiveUse},
                            {"Total",sumTotalActiveUse},

                        });

                            }
                            else
                            {
                                activeUse.Add(new Dictionary<string, object>()
                                        {
                                            {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS },
                                            {"Total", Total},
                                        });
                            }
                        }
                        else if ((string)ResponseCategory == "Active(Not Usable)")
                        {

                            sumTAActiveNotUse += TA;
                            sumTSActiveNotUse += TS;
                            sumTotalActiveNotUse += Total;
                            if (code == "OS")
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                                            {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS },
                                            {"Total", Total},
                                        });
                            }
                            else if (code == "EM")
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                                            {"ResponseCategory","  "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total", Total},

                                        });

                                resultLTable.Add(new Dictionary<string, object>()
                        {
                            {"ResponseCategory"," "},
                            {"Status","Active (Not Usable) Sub Total"},
                            {"TA",sumTAActiveNotUse},
                            {"TS",sumTSActiveNotUse},
                            {"Total",sumTotalActiveNotUse},

                        });
                            }
                            else
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                                            {"ResponseCategory","  "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS",TS},
                                            {"Total", Total},
                                        });
                            }
                        }
                        else if ((string)ResponseCategory == "Inactive")
                        {
                            sumTAInactive += TA;
                            sumTSInactive += TS;
                            sumTotalInactive += Total;

                            if (code == "CO")
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                                               {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total", Total},
                                        });
                            }
                            else if (code == "NI")
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                {
                                            {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total", Total},

                                        });

                                resultLTable.Add(new Dictionary<string, object>()
                        {
                            {"ResponseCategory"," "},
                            {"Status","Inactive Sub Total"},
                            {"TA",sumTAInactive},
                            {"TS",sumTSInactive},
                            {"Total",sumTotalInactive},

                        });
                            }
                            else
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total", Total},

                                        });
                            }

                        }
                        else if ((string)ResponseCategory == "Non-Response")
                        {

                            sumTANonResp += TA;
                            sumTSNonResp += TS;
                            sumTotalNonResp += Total;

                            if (code == "BO")
                            {
                                valBouncedTA += TA;

                                valBouncedTS += TS;
                                valBouncedTot += Total;

                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory",ResponseCategory},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total", Total},

                                        });
                            }
                            else
                            {
                                resultLTable.Add(new Dictionary<string, object>()
                                        {
                               {"ResponseCategory"," "},
                                            {"Status", Status},
                                            {"TA",  TA},
                                            {"TS", TS},
                                            {"Total",Total},

                                        });


                                resultLTable.Add(new Dictionary<string, object>()
                        {
                            {"ResponseCategory"," "},
                            {"Status","Non-Response Sub Total"},
                            {"TA",sumTANonResp},
                            {"TS",sumTSNonResp},
                            {"Total",sumTotalNonResp},

                        });
                            }

                        }

                        else
                        {

                            resultLTable.Add(new Dictionary<string, object>()
                        {
                             {"ResponseCategory",ResponseCategory},
                            {"Status",Status},
                            {"TA",TA },
                            {"TS", TS },
                            {"Total",Total}

                        });
                        }

                    }

                    resultLTable.Add(new Dictionary<string, object>() //total
                        {
                            {"ResponseCategory","Total"},
                            {"Status"," "},
                            {"TA",sumTA},
                            {"TS", sumTS },
                            {"Total",sumTot}
                        });



                    #endregion

                    #region UpperTable

                    resultUTable.Add(new Dictionary<string, object>() //Hdr row 1
                {
                    {"EnterpriseType",DateStringtbl2},
                    {"ActiveCases","" },
                    {"InactiveCases","" },
                    {"SampleSize","" },
                    {"SampleSizeAft",""},
                    {"ResponseRate",""},
                    {"ResponseRateforPweek","" }
                });

                    resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Enterprise Type" },
                    {"ActiveCases","Active Cases (No. of Responses)" },
                    {"InactiveCases","Inactive Cases (No. of Response)" },
                    {"SampleSize","Sample Size" },
                    {"SampleSizeAft","Sample Size After Removing bounced and Inactive cases"},
                    {"ResponseRate","Response Rate"},
                    {"ResponseRateforPweek","Response Rate for Previous Week" }
                });

                    //    resultUTable.Add(new Dictionary<string, object>()
                    //{
                    //     {"EnterpriseType",' '},
                    //                            {"ActiveCases", " "},
                    //                            {"InactiveCases",  " "},
                    //                            {"SampleSize", " " },
                    //                            {"SampleSizeAft", " "},
                    //        {"ResponseRate"," " },

                    //});

                    sampleAftBandITA = (sumTA - (valBouncedTA + sumTAInactive));
                    sampleAftBandITS = (sumTS - (valBouncedTS + sumTSInactive));
                    sampleAftBandITot = (sumTot - (valBouncedTot + sumTotalInactive));

                    if (sampleAftBandITA != 0)
                    {
                        responseRateTA = Math.Round((((decimal)sumTAActiveUse / (decimal)sampleAftBandITA) * 100m), 2);

                    }
                    else
                    {
                        responseRateTA = 0;

                    }
                    if (sampleAftBandITS != 0)
                    {

                        responseRateTS = Math.Round((((decimal)sumTSActiveUse / (decimal)sampleAftBandITS) * 100m), 2);

                    }
                    else
                    {

                        responseRateTS = 0;

                    }
                    if (sampleAftBandITot != 0)
                    {

                        responseRateTot = Math.Round((((decimal)sumTotalActiveUse / (decimal)sampleAftBandITot) * 100m), 2);
                    }
                    else
                    {

                        responseRateTot = 0;
                    }

                    resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","TA" },
                    {"ActiveCases",sumTAActiveUse+sumTAActiveNotUse },
                    {"InactiveCases",sumTAInactive },
                    {"SampleSize",sumTA },
                    {"SampleSizeAft",sampleAftBandITA},
                    {"ResponseRate",responseRateTA+"%"},
                   // {"ResponseRateforPweek"," " }
                });


                    resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","TS" },
                    {"ActiveCases", sumTSActiveUse+sumTSActiveNotUse},
                    {"InactiveCases",sumTSInactive },
                    {"SampleSize",sumTS },
                    {"SampleSizeAft",sampleAftBandITS},
                    {"ResponseRate",responseRateTS+"%"},
                    //{"ResponseRateforPweek"," " }
                });

                    resultUTable.Add(new Dictionary<string, object>() //Hdr row 2
                {
                    {"EnterpriseType","Total:" },
                    {"ActiveCases", sumTotalActiveUse+sumTotalActiveNotUse},
                    {"InactiveCases",sumTotalInactive },
                    {"SampleSize",sumTot },
                    {"SampleSizeAft",sampleAftBandITot},
                    {"ResponseRate",responseRateTot+"%"},
                   // {"ResponseRateforPweek"," " }
                });

                    #endregion

                    ((IDictionary<String, Object>)objActive)[Convert.ToString(1)] = activeUse;
                    ((IDictionary<String, Object>)objresultL)[Convert.ToString(1)] = resultLTable;
                    ((IDictionary<String, Object>)objresultU)[Convert.ToString(1)] = resultUTable;
                }

                dynamic exp = new ExpandoObject();
                exp.success = true;
                exp.count = totweek;
                exp.Active = objActive;
                exp.LowerTable = objresultL;
                exp.UpperTable = objresultU;
                return Json(exp);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ImdaDailyReport) + " - caught unexpected exception, dplyId={0}, rType={1}", dplyId, rType);
                return Json(new FailResponse("Internal Error. Please check with system administrator"));
            }

        }

        #endregion

        //TODO - this seems to get called twice by client for no obvious reason (maybe something to do with react's
        //       flow as the fetch is done in componentWillReceiveProps ... ?
        /// <summary>
        /// Endpoint to generate the ChoiceCount report. This is invoked by the dplyChoiceQnns control
        /// (see swz-builder/src/control/dplychoiceqnns.jsx)
        /// Used by ChoiceCount form
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("report/answerchoicecount")]
        public async Task<ActionResult> AnswerChoiceCount()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");

                string strDplyId = HttpContext.Request.Form["dplyId"];
                string companyTypes = HttpContext.Request.Form["companyTypes"];

                if (!Guid.TryParse(strDplyId, out Guid dplyId))
                    return Json(new FailResponse(Constants.Message.InvalidInput));

                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId);
                if (qnnDply == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);
                if (!(bool)qnnDply[Constants.FieldName.Status])
                    return Json(new FailResponse($"{Constants.Message.InvalidInput} (deployment is not enabled)"));

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(qnnDply, currentUser))
                    throw new PermissionException("Lacks organisation access to deployment");

                //Use a seperate query to get the form properties (instead of joining many tables as we did previously)
                Guid qnnId = (Guid)qnnDply[Constants.FieldName.QnnId];
                DynamicEntity qnnQnn = await FormPropertiesApplication.GetQnnQnnById(qnnId);
                if (qnnQnn == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_QNN, qnnId);

                List<Dictionary<string, object>> answerChoiceCount =
                    await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                        Constants.StoredProcedure.spSP_GetDplyChoiceCount,
                        new Dictionary<string, object>
                        { {"DplyId", dplyId} },
                        new Dictionary<string, object>());
                if (!answerChoiceCount.Any()) return Json(new FailResponse("No response data yet"));

                Dictionary<string, object> qnnChoices = await FormPropertiesApplication.GetDplyOnlineFormFieldChoices(dplyId);
                List<Dictionary<string, object>> result = new List<Dictionary<string, object>>();
                if (qnnChoices != null && qnnChoices.Any())
                {
                    foreach (var answerchoice in answerChoiceCount)
                    {
                        string key = (string)answerchoice["Name"];
                        string ansVal = (string)answerchoice["AnsVal"];
                        answerchoice.Add("Text", "");

                        if (qnnChoices.ContainsKey(key))
                        {
                            JArray dataElements = (JArray)qnnChoices[key];

                            if (string.IsNullOrEmpty(ansVal))
                            {
                                answerchoice["Idx"] = dataElements.Count + 1;
                                result.Add(answerchoice);
                            }

                            for (int i = 0; i < dataElements.Count; i++)
                            {
                                string tokenValue = dataElements[i].SelectToken("value")?.Value<string>();

                                if (tokenValue == null)
                                    continue;

                                if (tokenValue != ansVal)
                                {
                                    if (!result.Any(r => (string)r["Name"] == key && (string)r["AnsVal"] == tokenValue) &&
                                        !answerChoiceCount.Any(a => (string)a["Name"] == key && (string)a["AnsVal"] == tokenValue))
                                    {
                                        result.Add(new Dictionary<string, object>()
                                        {
                                            {"Name", key},
                                            {"QnnFieldId",  answerchoice["QnnFieldId"]},
                                            {"Text", dataElements[i]?.SelectToken("text")?.Value<string>()},
                                            {"AnsVal", tokenValue},
                                            {"AnsCount", 0},
                                            {"RespCount", answerchoice["RespCount"]},
                                            {"Percentage", 0},
                                            {"Idx", i}

                                        });
                                    }
                                }
                                else
                                {
                                    answerchoice["Idx"] = GetAnswerIndex(dataElements, key, ansVal);
                                    answerchoice["Text"] = dataElements[i]["text"];
                                    result.Add(answerchoice);
                                }
                            }
                        }
                    }
                }
                else
                {
                    result = answerChoiceCount;
                }

                dynamic exp = new ExpandoObject();
                exp.success = true;
                exp.dplyName = (string)qnnDply[Constants.FieldName.Name];
                exp.qnnTitle = (string)qnnQnn[Constants.FieldName.Title];
                exp.items = result;
                return Json(exp);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(AnswerChoiceCount) + " - caught unexpected Exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Called by the Export button on the Frequency Count Report to export the data in a background job
        /// </summary>
        /// <returns></returns>
		[HttpPost]
        [Route("report/exportanswerchoicecount")]
        public async Task<ActionResult> ExportChoiceCount()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SurveyAdmin}");

                string strDplyId = HttpContext.Request.Form["dplyId"];

                if (!Guid.TryParse(strDplyId, out Guid dplyId))
                    return Json(new FailResponse(Constants.Message.InvalidInput));

                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId);
                if (qnnDply == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

                if (!(bool)qnnDply[Constants.FieldName.Status])
                    return Json(new FailResponse(Constants.Message.InvalidInput));

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(qnnDply, currentUser))
                    throw new PermissionException("Lacks organisation access to deployment");

                await BusinessProcess.Enqueue.ExportFrequencyCountReport(dplyId);

                return Json(new SuccessResponse("The system is running the frequency count report export in the background. You will be informed of the outcome via email when it is done."));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ExportChoiceCount) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Endpoint for the Export button for the respondent participation report
        /// </summary>
        /// <returns></returns>
		[Authorize]
        [HttpPost]
        [Route("report/respondentparticipation")]
        public async Task<ActionResult> RespondentParticipation()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SurveyAdmin}");

                IFormCollection form = Request.Form;
                string uid = form["UID"];
                string respName = form["RespName"];
                string commaDelimitedStatusIds = form["StatusId"];
                string commaDelimitedDplyIds = form["DplyId"];

                if (!ConversionUtils.TryParseCommaDelimitedGuids(commaDelimitedStatusIds, out List<Guid> statusIds))
                    if (commaDelimitedStatusIds != null) return Json(new FailResponse(Constants.Message.InvalidInput));

                if (!ConversionUtils.TryParseCommaDelimitedGuids(commaDelimitedDplyIds, out List<Guid> dplyIds))
                    if (commaDelimitedDplyIds != null) return Json(new FailResponse(Constants.Message.InvalidInput));

                //n.b. Job will quietly filter out deployments the current user doesn't have struct division access to

                await BusinessProcess.Enqueue.ExportParticipationReport(
                    UID: uid,
                    RespName: respName,
                    StatusIDs: statusIds,
                    DplyIDs: dplyIds);

                return Json(new SuccessResponse("The system is running the respondent participation report export in the background. You will be informed of the outcome via email when it is done."));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(RespondentParticipation) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Endpoint for the Export button for the respondent participation report
        /// </summary>
        /// <returns></returns>
        [Authorize]
        [HttpGet]
        [Route("report/respondentparticipationgridfilter")]
        public async Task<ActionResult> RespondentParticipationGridFilter(
            string UID,
            string RespName,
            string StatusIds,
            string DplyIds)
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SurveyAdmin}");

                string uid = string.IsNullOrWhiteSpace(UID) ? null : UID.Trim();
                string respName = string.IsNullOrWhiteSpace(RespName) ? null : RespName.Trim();
                if (!ConversionUtils.TryParseCommaDelimitedGuids(StatusIds, out List<Guid> statusIds))
                    if (StatusIds != null) return Json(new FailResponse(Constants.Message.InvalidInput)); //Failed to parse a non-null input

                if (!ConversionUtils.TryParseCommaDelimitedGuids(DplyIds, out List<Guid> dplyIds))
                    if (DplyIds != null) return Json(new FailResponse(Constants.Message.InvalidInput)); //Failed to parse a non-null input

                List<vSP_RespParticipation> result
                    = await vSP_RespParticipation.GridFilter(uid, respName, statusIds, dplyIds, currentUser);

                if (result == null)
                    return Json(new SuccessResponse("NO_RESULT"));

                if (result != null && result.Count > 0)
                    return Json(new ItemSuccessResponse<List<vSP_RespParticipation>>(result));

                return Json(new SuccessResponse("NO_RESULT"));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(RespondentParticipationGridFilter) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Route("report/dashboard/weeklyresponse")]
        public async Task<ActionResult> WeeklyResponse()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SurveyAdmin}");

                string strDplyId = HttpContext.Request.Form["dplyId"];
                string filterWeightGroup = HttpContext.Request.Form["filtersWeightGroup"];
                List<string> list = new List<string>();

                var weightGroupsArray = filterWeightGroup != null ? filterWeightGroup.Split(",").ToList() : list;

                if (!Guid.TryParse(strDplyId, out Guid dplyId))
                    return Json(new FailResponse(Constants.Message.InvalidInput));

                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId);
                if (qnnDply == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(qnnDply, currentUser))
                    throw new PermissionException("Lacks organisation access to deployment");

                if (!(bool)qnnDply[Constants.FieldName.Status])
                    return Json(new FailResponse($"{Constants.Message.InvalidInput} (deployment not enabled)"));

                Guid qnnId = (Guid)qnnDply[Constants.FieldName.QnnId];
                DynamicEntity qnnQnn = await FormPropertiesApplication.GetQnnQnnById(qnnId);
                if (qnnQnn == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_QNN, qnnId);

                List<Dictionary<string, object>> totalSampleAftRemoval
                    = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                        Constants.StoredProcedure.spSP_GetResponseAftRemovalByDplyId,
                        new Dictionary<string, object> { { "DplyId", dplyId } },
                        new Dictionary<string, object>());

                List<Dictionary<string, object>> overallResponse =
                    await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                        Constants.StoredProcedure.spSP_GetWeeklyActiveResponseByDplyId,
                        new Dictionary<string, object> { { "DplyId", dplyId } },
                        new Dictionary<string, object>());
                if (!overallResponse.Any()) return Json(new FailResponse("No response data yet"));

                Dictionary<int, Int32> items = new Dictionary<int, Int32>();
                var totalCount = 0;

                for (int i = 0; i < overallResponse.Count; i++)
                {
                    Dictionary<string, object> item = overallResponse[i];
                    int count = Convert.ToInt32(item["Number"]);
                    string company = item["WeightGroup"] != null ? item["WeightGroup"].ToString() : null;
                    int weekNumber = Convert.ToInt32(item["WeekNumber"]);
                    bool weekExist = count > 0 && weekNumber > 0;

                    bool checkWeightGroupCondition = (weightGroupsArray.Count > 0 && weightGroupsArray.Contains(company)) || weightGroupsArray.Count < 1;

                    if (weekExist)
                    {
                        if (checkWeightGroupCondition)
                        {
                            totalCount = totalCount + count;

                            if (!items.ContainsKey(weekNumber))
                            {
                                items[weekNumber] = totalCount;
                            }
                            else
                            {
                                items[weekNumber] = totalCount;
                            }
                        }

                    }

                }

                dynamic exp = new ExpandoObject();
                exp.success = true;
                exp.dplyName = qnnDply[Constants.FieldName.Name];
                exp.qnnTitle = qnnQnn[Constants.FieldName.Title]; //TODO - is this even used though?
                exp.totalActive = totalCount;
                exp.totalSampleAftRemoval = totalSampleAftRemoval;
                exp.items = items;
                return Json(exp);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(WeeklyResponse) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }

        }

        /// <summary>
        /// File download for the exported StatusResponse case details csv. This has special handling to get the DplyId from its
        /// stored filename and verify that the downloaded is in the appropriate role and strct division to download it. 
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("report/dashboard/statusresponse/download/{token}")]
        public async Task<ActionResult> DownloadStatusResponseDetails(string token)
        {
            if (string.IsNullOrEmpty(token)) return BadRequest();
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!CloverRuntime.Security.CurrentUser.IsInRole(Constants.Role.SurveyAdmin)) throw new PermissionException();

                if (!await CloverRuntime.ContentProvider.ExistAsync(token)) return NotFound("File does not exist or has been deleted");
                var file = await CloverRuntime.ContentProvider.GetAsync(token);
                var name = new ReportHelper.ResponseStatusDashboard.DetailsCsvName(file.Properties[FileProperties.Name]);

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(name.DplyId))
                    throw new PermissionException($"Lacks organisation access to deployment {name.DplyId}");

                return File(
                    fileStream: file.Stream,
                    contentType: file.Properties[FileProperties.ContentType],
                    fileDownloadName: name.ForDownload);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadStatusResponseDetails) + " - caught unexpected exception, token={0}", token);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Will enqueue a background job to email a download link to the current user to download the
        /// status and remarks for the selected deployment and status (Export button on the response status dashboard)
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("report/dashboard/statusresponse/exportdetails")]
        public async Task<ActionResult> ExportStatusResponseDetails()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SurveyAdmin}");

                if (!Guid.TryParse(Request.Form["dplyId"], out Guid dplyId))
                    return Json(new FailResponse($"{Constants.Message.InvalidInput} (dplyId)"));

                if (!bool.TryParse(Request.Form["excludeExempted"], out bool isExcludeExempted))
                    return Json(new FailResponse($"{Constants.Message.InvalidInput} (excludeExempted"));

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(dplyId))
                    throw new PermissionException($"Lacks organisation access to deployment {dplyId}");

                List<string> statusTitles = HttpContext.Request.Form["status"].ToList();

                await BusinessProcess.Enqueue.ExportStatusResponseDetails(dplyId, statusTitles, isExcludeExempted);

                return Json(new SuccessResponse("The system is running the export in the background. You will be informed of the outcome via email when it is done."));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ExportStatusResponseDetails) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpGet]
        [Route("report/dashboard/statusresponse")]
        public async Task<ActionResult> StatusResponse(string dplyId)
        {
            try
            {
                if (!Guid.TryParse(dplyId, out Guid qnnDplyId))
                    return Json(new FailResponse(Constants.Message.InvalidInput));

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SurveyAdmin}");

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(qnnDplyId))
                    throw new PermissionException();

                ExpandoObject exp = await ReportHelper.ResponseStatusDashboard.StatusResponseCounts(qnnDplyId);
                return (exp == null)
                    ? Json(new FailResponse("No response data yet"))
                    : Json(new ItemSuccessResponse<ExpandoObject>(exp));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(StatusResponse) + " - caught unexpected exception. dplyId={0}", dplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Route("report/dashboard/sectorsegmentresponse")]
        public async Task<ActionResult> SectorSegmentResponse()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SurveyAdmin} role");

                string strDplyId = HttpContext.Request.Form["dplyId"];
                string filterType = HttpContext.Request.Form["filterType"];
                string filterItems = HttpContext.Request.Form["filters"];
                string filterWeightGroup = HttpContext.Request.Form["filtersWeightGroup"];

                bool isSegmentFilter = "Segment".Equals(filterType);
                bool isSectorFilter = "Sector".Equals(filterType);

                List<string> emptyList = new List<string>(); //empty list used as placeholder for the below if not that filter type
                List<string> segmentTypes = isSegmentFilter && filterItems != null ? filterItems.Split(",").ToList() : emptyList;
                List<string> sectorTypes = isSectorFilter && filterItems != null ? filterItems.Split(",").ToList() : emptyList;
                List<string> weightGroups = filterWeightGroup != null ? filterWeightGroup.Split(",").ToList() : emptyList;

                if (!Guid.TryParse(strDplyId, out Guid dplyId))
                    return Json(new FailResponse(Constants.Message.InvalidInput));

                DynamicEntity qnnDply
                    = await DeploymentApplication.GetQnnDplyById(dplyId);
                if (qnnDply == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);
                if (!(bool)qnnDply[Constants.FieldName.Status])
                    return Json(new FailResponse($"{Constants.Message.InvalidInput} (deployment not enabled)"));
                Guid dplyStructDivisionId = (Guid)qnnDply[Constants.FieldName.StructDivisionId];
                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(qnnDply, currentUser))
                    throw new PermissionException($"Lacks organisation access to QNN_DPLY {dplyId}");

                Dictionary<string, object> spParams
                    = (isSegmentFilter) ? new Dictionary<string, object>
                        {
                            {"DplyId", dplyId},
                            {"Segments", string.Join("|", segmentTypes)}
                        }
                    : new Dictionary<string, object>
                        {
                            {"DplyId", dplyId},
                            {"Sectors", string.Join("|", sectorTypes)}
                        };

                string storedProcedure = isSegmentFilter
                    ? Constants.StoredProcedure.spSP_GetSegmentResponseByDplyId
                    : Constants.StoredProcedure.spSP_GetSectorResponseByDplyId;
                List<Dictionary<string, object>> overallResponseItems
                    = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                        storedProcedure,
                        spParams,
                        new Dictionary<string, object>());

                if (!overallResponseItems.Any()) return Json(new FailResponse("No response data yet"));
                List<Dictionary<string, object>> options = new List<Dictionary<string, object>>();
                List<Dictionary<string, object>> items = new List<Dictionary<string, object>>();
                IDictionary<string, object> respondedObj = new ExpandoObject() as IDictionary<string, Object>;
                //All Samples Without Bounced And InActiveObj
                IDictionary<string, object> totalSampleAftObj = new ExpandoObject() as IDictionary<string, Object>;
                IDictionary<string, object> bouncedAndInActiveObj = new ExpandoObject() as IDictionary<string, Object>;
                Dictionary<string, List<dynamic>> wgsRespondedObj = new Dictionary<string, List<dynamic>>();
                Dictionary<string, List<dynamic>> wgsTotalSampleAftObj = new Dictionary<string, List<dynamic>>();

                for (var i = 0; i < overallResponseItems.Count; i++)
                {
                    Dictionary<string, object> item = overallResponseItems[i];
                    int count = Convert.ToInt32(item["Number"]);
                    string group = item["Group_Name"] != null ? item["Group_Name"].ToString() : null;
                    string weightGroup = item["WeightGroup"] != null ? item["WeightGroup"].ToString() : null;
                    string segment = item.ContainsKey("Segment") && item["Segment"] != null ? item["Segment"].ToString() : null;
                    string sector = item.ContainsKey("Sector") && item["Sector"] != null ? item["Sector"].ToString() : null;
                    bool groupExist = count > 0 && group != null;
                    bool weightGroupExist = weightGroup != null;

                    bool checkSegmentCondition = (segmentTypes.Count > 0 && segmentTypes.Contains(segment)) || segmentTypes.Count < 1;
                    bool checkSectorCondition = (sectorTypes.Count > 0 && sectorTypes.Contains(sector)) || sectorTypes.Count < 1;
                    bool checkWeightGroupCondition = (weightGroups.Count > 0 && weightGroups.Contains(weightGroup)) || weightGroups.Count < 1;

                    string key = isSegmentFilter ? item["Segment"].ToString() : item["Sector"].ToString();
                    IDictionary<string, object> wgRespondedObj = new ExpandoObject() as IDictionary<string, Object>;
                    IDictionary<string, object> wgTotalSampleAftObj = new ExpandoObject() as IDictionary<string, Object>;

                    if (groupExist && weightGroupExist)
                    {
                        string option = isSegmentFilter ? segment : sector;
                        if (!options.Any(r => (string)r["value"] == option))
                        {
                            options.Add(new Dictionary<string, object>()
                            {
                                {"key", i},
                                {"text", option},
                                {"value", option},
                            });
                        }

                        if ((isSegmentFilter && checkSegmentCondition) || (isSectorFilter && checkSectorCondition))
                        {
                            if (checkWeightGroupCondition)
                            {
                                if (group == "Responded")
                                {
                                    if (respondedObj.ContainsKey(key))
                                        respondedObj[key] = Int32.Parse(respondedObj[key].ToString()) + count;
                                    else
                                        respondedObj.Add(key, count);

                                    if (wgRespondedObj.ContainsKey(weightGroup))
                                        wgRespondedObj[weightGroup] = count;
                                    else
                                        wgRespondedObj.Add(weightGroup, count);

                                    if (wgsRespondedObj.ContainsKey(key))
                                    {
                                        List<Object> oldList = wgsRespondedObj[key];
                                        oldList.Add(wgRespondedObj);
                                    }
                                    else
                                    {
                                        List<dynamic> wgList = new List<dynamic>();
                                        wgList.Add(wgRespondedObj);
                                        wgsRespondedObj.Add(key, wgList);
                                    }

                                    if (totalSampleAftObj.ContainsKey(key))
                                        totalSampleAftObj[key] = Int32.Parse(totalSampleAftObj[key].ToString()) + count;
                                    else
                                        totalSampleAftObj.Add(key, count);

                                    if (wgTotalSampleAftObj.ContainsKey(weightGroup))
                                        wgTotalSampleAftObj[weightGroup] = count;
                                    else
                                        wgTotalSampleAftObj.Add(weightGroup, count);

                                }
                                else if (group == "BouncedAndInActive")
                                {
                                    continue;
                                }
                                else
                                {
                                    if (totalSampleAftObj.ContainsKey(key))
                                        totalSampleAftObj[key] = Int32.Parse(totalSampleAftObj[key].ToString()) + count;
                                    else
                                        totalSampleAftObj.Add(key, count);

                                    if (wgTotalSampleAftObj.ContainsKey(weightGroup))
                                        wgTotalSampleAftObj[weightGroup] = count;
                                    else
                                        wgTotalSampleAftObj.Add(weightGroup, count);
                                }

                                if (wgsTotalSampleAftObj.ContainsKey(key))
                                {
                                    List<Object> oldList = wgsTotalSampleAftObj[key];
                                    oldList.Add(wgTotalSampleAftObj);
                                }
                                else
                                {
                                    List<dynamic> wgList = new List<dynamic>();
                                    wgList.Add(wgTotalSampleAftObj);
                                    wgsTotalSampleAftObj.Add(key, wgList);
                                }

                            }
                        }
                    }
                }

                Dictionary<string, IDictionary<string, Object>> wgsNewTotalSampleAftObj = new Dictionary<string, IDictionary<string, Object>>();
                IDictionary<string, object> segmentObj = new ExpandoObject() as IDictionary<string, Object>;
                List<object> wgsTotalListObj = new List<Object>();
                List<object> wgsNewTotalListObj = new List<Object>();
                //Total up wgsTotalSampleAftObj
                foreach (KeyValuePair<string, List<dynamic>> x in wgsTotalSampleAftObj)
                {
                    List<dynamic> wgsTotalList = wgsTotalSampleAftObj[x.Key];
                    //Replace the list here later

                    IDictionary<string, object> wgNewTotalObj = new ExpandoObject() as IDictionary<string, Object>;
                    for (int k = 0; k < wgsTotalList.Count; k++)
                    {
                        IDictionary<string, object> wgItem = wgsTotalList[k] as IDictionary<string, Object>;
                        foreach (var h in wgItem)
                        {
                            if (wgNewTotalObj.ContainsKey(h.Key))
                            {
                                int oldValue = Int32.Parse(wgNewTotalObj[h.Key].ToString());
                                wgNewTotalObj[h.Key] = oldValue + Int32.Parse(wgItem[h.Key].ToString());
                            }
                            else
                            {
                                wgNewTotalObj.Add(h.Key, Int32.Parse(wgItem[h.Key].ToString()));
                            }
                        }
                    }
                    wgsNewTotalSampleAftObj[x.Key] = wgNewTotalObj;
                }

                wgsTotalSampleAftObj.Clear();
                IDictionary<string, object> tableKeys = new ExpandoObject() as IDictionary<string, Object>;
                if (weightGroups.Count < 1)
                    tableKeys.Add("Overall", true);

                foreach (KeyValuePair<string, object> item in totalSampleAftObj)
                {
                    IDictionary<string, object> map = new ExpandoObject() as IDictionary<string, Object>;

                    int totalSampleAftCount = Int32.Parse(totalSampleAftObj[item.Key].ToString());
                    int overallResponse = respondedObj.ContainsKey(item.Key) ? Int32.Parse(respondedObj[item.Key].ToString()) : 0;
                    double overallPercent = overallResponse < 1 ? 0 : (double)Math.Round((double)(100 * overallResponse) / totalSampleAftCount, 2);
                    if (weightGroups.Count < 1)
                        map["Overall"] = overallPercent;

                    if (wgsRespondedObj.ContainsKey(item.Key))
                    {
                        List<dynamic> wgRespondedList = wgsRespondedObj[item.Key];
                        for (var i = 0; i < wgRespondedList.Count; i++)
                        {
                            IDictionary<string, object> wgRespondedObj = wgRespondedList[i] as IDictionary<string, Object>;
                            foreach (KeyValuePair<string, object> wg in wgRespondedObj)
                            {
                                int wgResponse = Int32.Parse(wgRespondedObj[wg.Key].ToString());
                                int wgTotal = wgsNewTotalSampleAftObj.ContainsKey(item.Key) && wgsNewTotalSampleAftObj[item.Key].ContainsKey(wg.Key) ? Int32.Parse(wgsNewTotalSampleAftObj[item.Key][wg.Key].ToString()) : 0;
                                double wgPercent = wgTotal < 1 ? 0 : (double)Math.Round((double)(100 * wgResponse) / wgTotal, 2);
                                map[wg.Key.ToString()] = wgPercent;

                                if (!tableKeys.ContainsKey(wg.Key))
                                    tableKeys.Add(wg.Key, true);
                            }
                        }
                    }
                    segmentObj[item.Key] = map;
                }

                //Processing
                dynamic exp = new ExpandoObject();
                exp.success = true;
                exp.dplyName = qnnDply[Constants.FieldName.Name];
                exp.items = segmentObj;
                exp.options = options;
                exp.tableKeys = tableKeys.Keys.ToList();
                return Json(exp);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SectorSegmentResponse) + " - caught an unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }

        }

        /// <summary>
        /// For DashboardOverall
        /// </summary>
        [HttpPost]
        [Route("report/dashboard/overallresponse")]
        public async Task<ActionResult> OverallResponse()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SurveyAdmin}");

                string strDplyId = HttpContext.Request.Form["dplyId"];
                if (!Guid.TryParse(strDplyId, out Guid dplyId))
                    return Json(new FailResponse(Constants.Message.InvalidInput));

                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId);
                if (qnnDply == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(qnnDply, currentUser))
                    throw new Exception($"Lacks organisation access to deployment {dplyId}");

                if (!(bool)qnnDply[Constants.FieldName.Status])
                    return Json(new FailResponse(Constants.Message.InvalidInput));

                List<Dictionary<string, object>> overallResponse =
                    await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                        Constants.StoredProcedure.spSP_GetOverallResponseByDplyId,
                        new Dictionary<string, object> { { "DplyId", dplyId } },
                        new Dictionary<string, object>());
                if (!overallResponse.Any()) return Json(new FailResponse("No response data yet"));
                List<Dictionary<string, object>> result = new List<Dictionary<string, object>>();

                int activeCount = 0;
                int bouncedAndInActiveCount = 0;
                int pendingCount = 0;
                int othersCount = 0;

                for (int i = 0; i < overallResponse.Count; i++)
                {
                    Dictionary<string, object> item = overallResponse[i];
                    int count = Convert.ToInt32(item["Number"]);
                    string group = item["Group_Name"] != null ? item["Group_Name"].ToString() : null;
                    string company = item["WeightGroup"] != null ? item["WeightGroup"].ToString() : null;
                    string industry = item["IndustryGroup"] != null ? item["IndustryGroup"].ToString() : null;
                    bool groupExist = count > 0 && group != null;
                    bool typeExist = company != null && industry != null;

                    if (groupExist && typeExist)
                    {

                        if (group == "Active")
                        {
                            result.Add(new Dictionary<string, object>()
                            {
                                {"ResponseNumber", count},
                                {"CompanyType", company},
                                {"IndustryType", industry},
                            });
                            activeCount = count + activeCount;
                        }
                        else if (group == "BouncedAndInActive")
                        {
                            bouncedAndInActiveCount = count + bouncedAndInActiveCount;
                        }
                        else if (group == "Pending")
                        {
                            pendingCount = count + pendingCount;
                        }
                        else
                        {
                            othersCount = count + othersCount;
                        }
                    }
                }

                int totalSample = activeCount + bouncedAndInActiveCount + pendingCount + othersCount;
                int totalSampleAftRemoval = totalSample - bouncedAndInActiveCount;

                dynamic exp = new ExpandoObject();
                exp.success = true;
                exp.dplyName = qnnDply[Constants.FieldName.Name];
                //Removed qnnTitle as its unused by DashboardOverall
                exp.totalActive = activeCount;
                exp.totalSample = totalSample;
                exp.totalSampleAftRemoval = totalSampleAftRemoval;
                exp.items = result;
                return Json(exp);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(OverallResponse) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [Authorize]
        [HttpGet]
        [Route("report/useraccessmatrix")]
        public async Task<ActionResult> UserAccessMatrixHtml(string aspect)
        {
            if (!Enum.TryParse(aspect, out ReportHelper.UserAccessMatrixReport.AccessMatrixType reportType))
                return BadRequest("aspect");
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.UserAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.UserAdmin}");

                string htmlContent = await UserAccessMatrixReport.GetHtmlContent(currentUser.StructDivisionId.Value, reportType);
                if (string.IsNullOrEmpty(htmlContent))
                    return Json(new FailResponse("No data found."));

                return Json(new ItemSuccessResponse<string>(htmlContent));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UserAccessMatrixHtml) + " - caught unexpected exception, reportType={0}", reportType.ToString());
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [Authorize]
        [HttpGet]
        [Route("report/useraccessmatrix/download")]
        public async Task<ActionResult> DownloadUserAccessMatrix(string aspect)
        {
            if (!Enum.TryParse(aspect, out ReportHelper.UserAccessMatrixReport.AccessMatrixType reportType))
                return BadRequest("aspect");
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.UserAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.UserAdmin}");

                Stream fileContent = await UserAccessMatrixReport.GetReport(currentUser.StructDivisionId.Value, reportType);
                if (fileContent != null)
                {
                    string appName = await SettingsHelper.Common.GetApplicationName();
                    //Note that stream will be closed by aspnetcore. See: https://github.com/dotnet/aspnetcore/issues/7277
                    return File(
                        fileStream: fileContent, 
                        contentType: Constants.ContentTypes.PdfFileType,
                        fileDownloadName: ReportHelper.UserAccessMatrixReport.Filename(reportType, appName));
                }
                else
                {
                    return Json(new FailResponse("No data found."));
                }
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadUserAccessMatrix) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Get the list of type="input" questions of chosen deployment
        /// </summary>
        /// <param name="dplyId"></param>
        /// <returns></returns>
        [Authorize]
        [HttpGet]
        [Route("report/wordcloudfields/{dplyId}")]
        public async Task<ActionResult> GetWordCloudFields(Guid dplyId)
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SurveyAdmin}");

                string formName = await DeploymentApplication.GetDplyFormName(dplyId);
                string source = CloverRuntime.Metadata.GetFormSource(formName);
                List<FormItem> formItems = FormSerializer.Deserialize(source);
                List<FormItem> fieldItems = FormPropertiesApplication.GetAllFormItems(formItems, new List<FormItem>());
                if (fieldItems == null || !fieldItems.Any(i => Constants.WordCloudControls.Contains(i.Type)))
                    return null;

                List<Dictionary<string, object>> fieldKeys = new List<Dictionary<string, object>>();
                int key = 0;

                foreach (FormItem item in fieldItems)
                {

                    if (!Constants.WordCloudControls.Contains(item.Type))
                        continue;

                    else
                    {
                        string inputType = item.Properties.ContainsKey("type")
                            ? item.Properties["type"].ToString()
                            : null;

                        if (inputType != "text")
                            continue;

                        fieldKeys.Add(new Dictionary<string, object>()
                        {
                            {"key", key++},
                            {"text", item.Key},
                            {"value", item.Key},
                        });
                    }
                }

                if (!fieldKeys.Any()) return Json(new FailResponse("The Selected Deployment has no text input question."));

                return Json(new ItemSuccessResponse<List<Dictionary<string, object>>>(fieldKeys));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetWordCloudFields) + " - caught unexpected exception, dplyId={0}", dplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Generate Word Cloud Report based on the chosen deployment and question.
        /// </summary>
        /// <param name="dplyId"></param>
        /// <param name="qnnField"></param>
        /// <returns></returns>
        [Authorize]
        [HttpPost]
        [Route("report/wordcloudreport")]
        public async Task<ActionResult> GenerateWordCloud(Guid dplyId, string qnnField)
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SurveyAdmin}");

                if (string.IsNullOrEmpty(qnnField)) return BadRequest();

                DynamicEntity deployment = await DeploymentApplication.GetQnnDplyById(dplyId);
                if (deployment == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

                if (!(bool)deployment[Constants.FieldName.Status])
                    return Json(new FailResponse(Constants.Message.InvalidInput));

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(deployment, currentUser))
                    throw new PermissionException($"Lacks organisation access to deployment {dplyId}");

                List<Dictionary<string, object>> wordCounts
                    = await spSP_GetDplyWordCount.GetDplyWordCount(dplyId, qnnField);

                if (!wordCounts.Any()) return Json(new FailResponse("No response data yet"));

                List<Dictionary<string, object>> wordCountItems = new List<Dictionary<string, object>>();
                foreach (Dictionary<string, object> wordCount in wordCounts)
                {
                    string AnsVal = (string)wordCount[Constants.FieldName.AnsVal];
                    int AnsCount = (int)wordCount["AnsCount"];
                    if (!string.IsNullOrEmpty(AnsVal))
                    {
                        wordCountItems.Add(new Dictionary<string, object>()
                        {
                            {"AnsVal", AnsVal},
                            {"AnsCount", AnsCount}
                        });
                    }

                }
                return Json(new ItemSuccessResponse<List<Dictionary<string, object>>>(wordCountItems));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GenerateWordCloud) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Download a CSV file of user profiles (based on caller's org tree). This is considered
        /// a supplement to the User Access Matrix and so has the same access requirements as that.
        /// </summary>
        [HttpGet]
        [Route("report/userprofilelist")]
        public async Task<ActionResult> DownloadUserProfileList()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.UserAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.UserAdmin}");

                string appName = await SettingsHelper.Common.GetApplicationName();
                char[] invalidChars = Path.GetInvalidFileNameChars();
                string cleanAppName = new string(
                    appName
                    .Replace(' ', '_')
                    .Where(ch => !invalidChars.Contains(ch))
                    .ToArray());
                return File(
                    fileStream: await UserAccessMatrixApplication.UserProfileListCSV(currentUser.StructDivisionId.Value),
                    contentType: System.Net.Mime.MediaTypeNames.Text.Csv,
                    fileDownloadName: $"{appName}_UserProfileList_{DateTime.Now.ToString("yyyyMMddTHHmmss")}.csv");
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadUserProfileList) + " - caught unexpected exception");
                return StatusCode(
                    (int)HttpStatusCode.InternalServerError,
                    Constants.Message.InternalErrorException);
            }
        }

        private static int GetAnswerIndex(Dictionary<string, object> qnnChoices, string key, string ansVal)
        {
            if (!qnnChoices.ContainsKey(key)) return -1;
            var dataElements = (JArray)qnnChoices[key];
            return GetAnswerIndex(dataElements, key, ansVal);
        }

        private static int GetAnswerIndex(JArray dataElements, string key, string ansVal)
        {
            for (var i = 0; i < dataElements.Count; i++)
            {
                if (dataElements[i].SelectToken("value")?.Value<string>() == ansVal)
                {
                    return i;
                }
            }
            return -1;
        }
    }
}