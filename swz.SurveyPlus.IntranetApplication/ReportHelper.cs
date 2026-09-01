using CsvHelper;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using SecurityPermission = swz.Clover.Core.Metadata.DbObjects.SecurityPermission;
using Newtonsoft.Json.Linq;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using System.Dynamic;
using Microsoft.Extensions.Logging;
using System.Globalization;
using CsvHelper.Configuration;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.Clover.Core.Utils;
using Constants = swz.SurveyPlus.Application.Constants;
using System.Text;
using System.Net;
using Newtonsoft.Json;
using System.Collections.ObjectModel;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class ReportHelper
    {
        //TODO
        //There is another format refer to Constants.QnnDatetimeFormat, might want to use that as the standard and replace this
        public const string DATE_TIME_FORMAT = "dd MMM yyyy HH:mm:ss";
        public const string DATE_FORMAT = "dd MMM yyyy";

        private const string X_MARK_BOLD = "&#10006;";
        private const string X_MARK = "&#10005;";

        public static class UserAccessMatrixReport
        {
            private const int RECORD_PER_PAGE = 15; //need to agak agak so it fits paper

            /// <summary>
            /// Variants of the matrix report
            /// </summary>
            public enum AccessMatrixType 
            { 
                //20260302 - the 'by permission' variant was deprecated and removed

                /// <summary>
                /// By role - extended (has some extra columns, UI shows it as Role++)
                /// </summary>
                RoleExt, 

                /// <summary>
                /// By role
                /// </summary>
                Role 
            }

            public static string Filename(AccessMatrixType reportType, string shortApplicationName)
            {
                ArgumentNullException.ThrowIfNull(shortApplicationName, nameof(shortApplicationName));
                char[] invalidChars = Path.GetInvalidFileNameChars();
                string cleanAppName = new string(
                    shortApplicationName
                    .Replace(' ', '_')
                    .Where(ch => !invalidChars.Contains(ch))
                    .ToArray());
                return $"{cleanAppName}_User{reportType}AccessMatrix_{DateTime.Now:yyyyMMddTHHmmss}.pdf";
            }

            public static async Task<string> GetHtmlContent(Guid structDivisionId, AccessMatrixType reportType)
            {
                switch (reportType)
                {
                    case AccessMatrixType.Role:
                        return await GetRoleHtmlContent(structDivisionId, X_MARK_BOLD);
                    case AccessMatrixType.RoleExt:
                        throw new NotImplementedException("Full report not implemented for html");
                    default:
                        throw new NotImplementedException(reportType.ToString());
                }
            }

            /// <summary>
            /// Get user access matrix report by role or permission
            /// </summary>
            public static async Task<Stream> GetReport(Guid structDivisionId, AccessMatrixType reportType)
            {
                switch (reportType)
                {

                    case AccessMatrixType.Role:
                        return await GetRoleReportPDF(structDivisionId);
                    case AccessMatrixType.RoleExt:
                        return await GetRoleExtReportPDF(structDivisionId);
                    default:
                        throw new NotImplementedException(reportType.ToString());
                }
            }

            public static async Task<MemoryStream> GetRoleExtReportPDF(Guid structDivisionId)
            {
                string content = await GetAccessRoleReportScheduleHtmlContent(X_MARK, structDivisionId);
                MemoryStream result = HtmlToPdfStream.CreateLandscapeDocument(content);
                return result;
            }

            #region "User Access Role Report"
            private static async Task<MemoryStream> GetRoleReportPDF(Guid structDivisionId)
            {
                //Stopwatch spHtml = new Stopwatch();
                //spHtml.Start();
                string content = await GetRoleHtmlContent(structDivisionId, X_MARK);
                //spHtml.Stop();
                //0.06 seconds for length 54214

                //Stopwatch spPdf = new Stopwatch();
                //spPdf.Start();
                MemoryStream result = HtmlToPdfStream.CreateLandscapeDocument(content);
                //spPdf.Stop();
                //19 seconds for length 240861, capacity 262144
                return result;
            }
            private static async Task<string> GetRoleHtmlContent(Guid structDivisionId, string mark)
            {
                string result = GetStyle();
                ByRoleReportData data = await ByRoleReportData.GetInstance(structDivisionId);
                string tableHeader = GetRoleReportTableHeader(data);

                string tableStart = "<table class='user-access-matrix'><tbody>";
                string tableEnd = "</tbody></table>";
                int pageCount = 1;
                int totalPage = (data.userList.Count / RECORD_PER_PAGE) + (data.userList.Count % RECORD_PER_PAGE > 0 ? 1 : 0);

                for (int i = 1; i <= data.userList.Count; i++)
                {
                    if (i % RECORD_PER_PAGE == 1)
                    {
                        result += "<div class='user-access-matrix'" + (i != 1 ? " style='page-break-before: always;' " : string.Empty) + ">";
                        result += GetReportHeader(AccessMatrixType.Role, data.GeneratedDate, i, data.userList.Count, pageCount, totalPage, RECORD_PER_PAGE);
                        result += tableStart + tableHeader;
                    }

                    SecurityUser user = data.userList[i - 1];
                    data.organisations.TryGetValue(user.StructDivisionId??Guid.Empty, out string organisation);
                    result += GetRoleReportRow(user, organisation, data.roleList, data.userRoleList, mark);

                    if (i % RECORD_PER_PAGE == 0)
                    {
                        result += tableEnd;
                        result += "</div>";
                        pageCount++;
                    }
                }
                result += tableEnd;
                result += "</div>";
                
                return result;
            }
            private static string GetRoleReportTableHeader(ByRoleReportData data)
            {
                string result = "<thead><tr class='row-header'><td class='bold user-name-header' rowspan='2'>User</td><td class='bold user-name-header' rowspan='2'>Organisation</td>";
                result += "<td class='bold aspect-header'" + (data.roleList.Count > 1 ? "colspan='" + data.roleList.Count + "'" : string.Empty) + ">Role</td></tr>";

                result += "<tr class='row-header'>";
                foreach (SecurityRole role in data.roleList)
                {
                    result += "<td class='bold aspect-name-header'>" + HttpUtility.HtmlEncode(role.Name) + "</td>";
                }
                result += "</tr></thead>";

                return result;
            }

            private static string GetRoleReportRow(SecurityUser user, string organisation, List<SecurityRole> roleList, List<V_Security_UserRole> userRoleList, string mark)
            {
                string result = "<tr class='row-value'><td class='user-name'>" + HttpUtility.HtmlEncode(user.Name) + "</td><td>" + HttpUtility.HtmlEncode(organisation) + "</td>";
                if (roleList.Count > 0)
                {
                    foreach (SecurityRole role in roleList)
                    {
                        bool hasPermission = userRoleList.Where(u => u.UserId == user.Id && u.RoleCode == role.Code).ToList().Count > 0;
                        result += "<td class='col-value marked'>" + (hasPermission ? mark : string.Empty) + "</td>";
                    }
                }
                else
                {
                    result += "<td class='col-value></td>";
                }
                result += "</tr>";
                return result;
            }
            #endregion

            #region "User Access Report Schedule"
            //TODO what is the word "schedule" meant to mean here? who calls this and when? This is generating report html, so where does a 'schedule' come in? oshiete kudasai
            private static async Task<string> GetAccessRoleReportScheduleHtmlContent(string mark, Guid structDivisionId)
            {
                string result = GetStyle();
                ByRoleReportData data = await ByRoleReportData.GetInstance(structDivisionId);
                string tableHeader = GetAccessRoleReportScheduleTableHeader(data);

                string tableStart = "<table class='user-access-matrix'><tbody>";
                string tableEnd = "</tbody></table>";
                int pageCount = 1;
                int totalPage = (data.userList.Count / RECORD_PER_PAGE) + (data.userList.Count % RECORD_PER_PAGE > 0 ? 1 : 0);

                for (int i = 1; i <= data.userList.Count; i++)
                {
                    if (i % RECORD_PER_PAGE == 1)
                    {
                        result += "<div class='user-access-matrix'" + (i != 1 ? " style='page-break-before: always;' " : string.Empty) + ">";
                        result += GetReportHeader(AccessMatrixType.Role, data.GeneratedDate, i, data.userList.Count, pageCount, totalPage, RECORD_PER_PAGE);
                        result += tableStart + tableHeader;
                    }

                    SecurityUser user = data.userList[i - 1];
                    data.organisations.TryGetValue(user.StructDivisionId ?? Guid.Empty, out string organisation);
                    result += GetAccessRoleReportScheduleRow(user, organisation, data.roleList, data.userRoleList, data.userCredentialDict, mark);

                    if (i % RECORD_PER_PAGE == 0)
                    {
                        result += tableEnd;
                        result += "</div>";
                        pageCount++;
                    }
                }
                result += tableEnd;
                result += "</div>";

                return result;
            }
            private static string GetAccessRoleReportScheduleTableHeader(ByRoleReportData data)
            {
                string result = "<thead><tr><td class='bold' rowspan='2'>User</td>";
                result += "<td class='bold' rowspan='2'>Organisation</td>";
                result += "<td class='bold' rowspan='2'>Login ID</td>";
                result += "<td class='bold' rowspan='2'>Locked</td>";
                result += "<td class='bold' rowspan='2'>Created Date</td>";
                result += "<td class='bold' rowspan='2'>Last Login Date</td>";
                result += "<td class='bold'" + (data.roleList.Count > 1 ? "colspan='" + data.roleList.Count + "'" : string.Empty) + ">Role</td></tr>";

                result += "<tr>";
                foreach (SecurityRole role in data.roleList)
                {
                    result += "<td class='bold'>" + HttpUtility.HtmlEncode(role.Name) + "</td>";
                }
                result += "</tr></thead>";

                return result;
            }

            private static string GetAccessRoleReportScheduleRow(SecurityUser user, string organisation, List<SecurityRole> roleList, List<V_Security_UserRole> userRoleList, Dictionary<string, string> userCredentialDict, string mark)
            {
                string result = "<tr><td>" + HttpUtility.HtmlEncode(user.Name) + "</td><td>" + HttpUtility.HtmlEncode(organisation) + "</td>";
                result += "<td>" + (userCredentialDict.ContainsKey(user.Id.ToString()) ? userCredentialDict[user.Id.ToString()] : "N/A") + "</td>";
                result += "<td>" + (user.IsLocked ? mark : "") + "</td>";
                result += "<td class='nowrap'>" + (user.CreatedDate != null ? user.CreatedDate.Value.ToString(DATE_FORMAT) : "N/A") + "</td>";
                result += "<td class='nowrap'>" + (user.LastLoginDate != null ? user.LastLoginDate.Value.ToString(DATE_FORMAT) : "N/A") + "</td>";
                if (roleList.Count > 0)
                {
                    foreach (SecurityRole role in roleList)
                    {
                        bool hasPermission = userRoleList.Where(u => u.UserId == user.Id && u.RoleCode == role.Code).ToList().Count > 0;
                        result += "<td>" + (hasPermission ? mark : string.Empty) + "</td>";
                    }
                }
                else
                {
                    result += "<td></td>";
                }
                result += "</tr>";
                return result;
            }
            #endregion

            private static string GetStyle()
            {
                string result = "<style>";
                result += "body{ font-family: Lato,'Helvetica Neue',Arial,Helvetica,sans-serif; }";
                //result += "table.report-info tr td.col-props{ font-weight: bold; }";
                result += "table.user-access-matrix{ width: 100%; text-align: center; border-collapse: collapse; background-color: rgba(230, 247, 255,0.1); border-spacing: 0; margin-bottom: 20px}";
                result += "table.user-access-matrix thead tr { background-color: #6B7AE0; color: #FFF; }";
                result += "table.user-access-matrix tr td.aspect-name-header{ max-width: 140px; min-width: 140px; width: 140px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;}";
                result += "table.user-access-matrix tbody{ border-color: #cccccc; }";
                result += "table.user-access-matrix tr td{ padding: 8px 4px; border:1px solid #dee2e6;}";
                result += "table.user-access-matrix tr td.bold{font-weight: bold;}";
                result += "table.user-access-matrix tr td.nowrap{white-space: nowrap;}";
                result += "table.user-access-matrix tr td .center{display: flex; justify-content: center; flex-direction: column;}";
                result += "table.report-info tr td { padding: 0px 4px;}";
                result += "div.user-access-matrix { margin-bottom:12px;}";
                result += "div.user-access-matrix .report-header {margin-bottom:12px;}";
                result += "div.user-access-matrix .report-footer {text-align: right;}";
                result += "</style>";
                return result;
            }

            private static string GetReportHeader(
                AccessMatrixType reportType,
                DateTime generatedDate, 
                int currentRecord, 
                int totalRecord, 
                int currentPage, 
                int totalPage, 
                int recordPerPage)
            {
                string result = "<div class='report-header'><table class='report-info'>";
                int maxRecord = currentPage * recordPerPage;
                if (currentPage * recordPerPage > totalRecord)
                    maxRecord -= recordPerPage - (totalRecord % recordPerPage);

                string reportBy;
                switch (reportType)
                {
                    case AccessMatrixType.Role: reportBy = "By Role"; break;
                    default: reportBy = reportType.ToString(); break;
                }

                result += "<tr><td class='col-props'>User Access Matrix</td><td class='col-props'>:</td><td class='col-value'>" + reportBy + "</td></tr>";
                result += "<tr><td class='col-props'>Date Generated</td><td class='col-props'>:</td><td class='col-value'>" + generatedDate.ToString("dd MMM yyyy HH:mm:ss") + "</td></tr>";
                result += "<tr><td class='col-props'>Record(s)</td><td class='col-props'>:</td><td class='col-value'>" + currentRecord + " - " + maxRecord + " of " + totalRecord + "</td></tr>";
                result += "<tr><td class='col-props'>Page(s)</td><td class='col-props'> : </td><td class='col-value'>" + currentPage + " of " + totalPage + "</td></tr>";
                result += "</table></div>";
                return result;
            }

            #region "Data"
            private class ByPermissionReportData : UserAccessMatrixData
            {
                public static async Task<ByPermissionReportData> GetInstance(Guid structDivisionId)
                {
                    ByPermissionReportData instance = new ByPermissionReportData();
                    await instance.InitData(structDivisionId);
                    return instance;
                }

                public DateTime GeneratedDate { get; set; }
                public List<SecurityPermission> permissionList { get; set; }
                public Dictionary<string, List<SecurityPermission>> permissionDict { get; set; }
                public List<SecurityUser> userList { get; set; }
                private List<Guid> userIdList { get; set; }
                public List<V_Security_CheckPermissionUser> userPermissionList { get; set; }

                private async Task InitData(Guid structDivisionId)
                {
                    GeneratedDate = DateTime.Now;
                    permissionList = await SecurityPermission.SelectAsync();
                    permissionList = permissionList.OrderBy(e => e.GroupName).ThenBy(e => e.Name).ToList();
                    permissionDict = permissionList.GroupBy(e => e.GroupCode).ToDictionary(e => e.Key, p => p.OrderBy(e => e.Name).ToList());
                    userList = await ReportHelper.GetUsersForStructDivision(structDivisionId.ToString());
                    userIdList = userList.Select(e => e.Id).ToList();
                    Filter selectFiler = Filter.And.In(userIdList, "UserId").Equal(1, "AccessType");
                    userPermissionList = await V_Security_CheckPermissionUser.SelectAsync(selectFiler);
                }
            }

            private class ByRoleReportData : UserAccessMatrixData
            {
                public static async Task<ByRoleReportData> GetInstance(Guid structDivisionId)
                {
                    ByRoleReportData instance = new ByRoleReportData();
                    await instance.InitData(structDivisionId);
                    return instance;
                }

                //TODO - can we make immutable from outside the class?

                public DateTime GeneratedDate { get; set; }
                public List<SecurityRole> roleList { get; set; }

                public List<SecurityUser> userList { get; set; }

                private List<Guid> userIdList { get; set; }
                public List<V_Security_UserRole> userRoleList { get; set; }

                public Dictionary<string, string> userCredentialDict { get; set; }
                private string selectedStructDivisionId { get; set; }

                public Dictionary<Guid,String> organisations { get; set; }

                private async Task InitData(Guid structDivisionId)
                {
                    this.selectedStructDivisionId = structDivisionId.ToString(); //what is with all these strings
                    GeneratedDate = DateTime.Now;
                    //roleList = await SecurityRole.SelectAsync(Filter.And.NotEqual(Constants.Role.Admins, "Code"), Order.StartAsc("Name"));
                    roleList = await SecurityRole.SelectAsync(Filter.Empty, Order.StartAsc("Name"));
                    userList = await ReportHelper.GetUsersForStructDivision(structDivisionId.ToString());
                    userIdList = userList.Select(e => e.Id).ToList();
                    userRoleList = await V_Security_UserRole.SelectAsync(Filter.And.In(userIdList, "UserId"));
                    organisations = (await StructDivision.SelectAsync(Filter.Empty)).ToDictionary(sd => sd.Id, sd => sd.Name);

                    if (!string.IsNullOrEmpty(selectedStructDivisionId))
                    {
                        userCredentialDict = await SecurityUser.GetGenericLoginCredentialDictByUserId(userIdList);
                    }
                }
            }
            #endregion
        }

        public static class RespondentParticipationReport
        {
            public class RespondentParticipationModel
            {
                public string UID { get; set; }
                public string RespondentName { get; set; }
                public string DeploymentName { get; set; }
                public string Status { get; set; }
                public string StatusDate { get; set; }
            }

            private static async Task<List<RespondentParticipationModel>> GetData(
                string UID,
                string RespName,
                List<Guid> StatusIDs,
                List<Guid> DplyIDs,
                Clover.Core.Security.User user)
            {
                List<RespondentParticipationModel> result = new List<RespondentParticipationModel>();
                List<vSP_RespParticipation> listRespParticipation = await vSP_RespParticipation.GridFilter(UID, RespName, StatusIDs, DplyIDs, user);

                if (listRespParticipation == null)
                    return result;

                if (listRespParticipation != null && listRespParticipation.Any())
                {
                    foreach (vSP_RespParticipation de in listRespParticipation)
                    {
                        RespondentParticipationModel respParticipation = new RespondentParticipationModel();
                        respParticipation.UID = de.UID != null ? de.UID : string.Empty;
                        respParticipation.RespondentName = de.RespondentName != null ? de.RespondentName : string.Empty;
                        respParticipation.DeploymentName = de.Name != null ? de.Name : string.Empty;
                        respParticipation.Status = de.Status != null ? de.Status : string.Empty;
                        respParticipation.StatusDate = de.StatusDate.ToString(Constants.QnnDatetimeFormat);//using this format as per request in requirement
                        result.Add(respParticipation);
                    }
                }

                return result;
            }

            public static async Task<MemoryStream> GetCSV(
                string UID,
                string RespName,
                List<Guid> StatusIDs,
                List<Guid> DplyIDs,
                Clover.Core.Security.User user)
            {
                MemoryStream memory = null;
                List<RespondentParticipationModel> respParticipationList = await GetData(UID, RespName, StatusIDs, DplyIDs, user);
                if (respParticipationList != null && respParticipationList.Any())
                {
                    memory = new MemoryStream();
                    using (MemoryStream ms = new MemoryStream())
                    {
                        using (var writer = new StreamWriter(ms))
                        {
                            //TODO - consider using InvariantCulture here. See: https://github.com/JoshClose/CsvHelper/issues/1441
                            using (CsvWriter csv = new CsvWriter(writer, CultureInfo.CurrentCulture))
                            {
                                csv.WriteRecords(respParticipationList);
                                csv.Flush();
                                writer.Flush(); //important to flush, or else streamTemp length can be anything
                                ms.Seek(0, SeekOrigin.Begin);
                                ms.CopyTo(memory);
                            }
                        }
                    }
                }
                return memory;
            }

        }


        public static class FrequencyCountReport
        {
            //No.	Question_Title	Answer_No	Text	Count	Percentage

            public class FrequencyCountReportModal
            {
                public string No { get; set; }
                public string Question_Title { get; set; }
                public string Answer_No { get; set; }
                public string Text { get; set; }
                public string Count { get; set; }
                public string Percentage { get; set; }
            }


            private static async Task<List<FrequencyCountReportModal>> GetData(Guid dplyId)
            {
                List<Dictionary<string, object>> answerChoiceCount = await GetChoiceCount(dplyId);
                Dictionary<string, object> qnnChoices = await FormPropertiesApplication.GetDplyOnlineFormFieldChoices(dplyId);
                List<Dictionary<string, object>> result = new List<Dictionary<string, object>>();
                if (answerChoiceCount != null && answerChoiceCount.Any())
                {
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
                }


                List<FrequencyCountReportModal> frequencyCountList = new List<FrequencyCountReportModal>();

                if (result != null && result.Any())
                {
                    int qnnCount = 1;
                    object qnnTitle = result[0]["Name"];
                    foreach (Dictionary<string, object> de in result)
                    {
                        if (qnnTitle != de["Name"])
                        {
                            qnnCount++;
                            qnnTitle = de["Name"];
                        }


                        FrequencyCountReportModal frequencyCount = new FrequencyCountReportModal();
                        frequencyCount.No = qnnCount.ToString();
                        frequencyCount.Question_Title = de["Name"] != null ? de["Name"].ToString() : string.Empty;
                        frequencyCount.Answer_No = de["AnsVal"] != null ? de["AnsVal"].ToString() : string.Empty;
                        frequencyCount.Text = de["Text"].ToString() != null ? de["Text"].ToString() : string.Empty;
                        frequencyCount.Count = de["AnsCount"] != null ? de["AnsCount"].ToString() : string.Empty;
                        frequencyCount.Percentage = de["Percentage"] != null ? de["Percentage"].ToString() : string.Empty;
                        frequencyCountList.Add(frequencyCount);
                    }
                }

                return frequencyCountList;
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

            private static async Task<List<Dictionary<string, object>>> GetChoiceCount(Guid dplyId)
            {
                Dictionary<string, object> spParams = new Dictionary<string, object>
                {
                    {Constants.FieldName.DplyId, dplyId},
                };

                return await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(Constants.StoredProcedure.spSP_GetDplyChoiceCount,
                    spParams, new Dictionary<string, object>());
            }


            public static async Task<MemoryStream> GetCSV(Guid dplyId)
            {
                MemoryStream memory = null;
                List<FrequencyCountReportModal> respParticipationList = await GetData(dplyId);
                if (respParticipationList != null && respParticipationList.Any())
                {
                    memory = new MemoryStream();
                    using (MemoryStream ms = new MemoryStream())
                    {
                        using (var writer = new StreamWriter(ms))
                        {
                            //TODO - consider using InvariantCulture here. See: https://github.com/JoshClose/CsvHelper/issues/1441
                            using (CsvWriter csv = new CsvWriter(writer, CultureInfo.CurrentCulture))
                            {
                                csv.WriteRecords(respParticipationList);
                                csv.Flush();
                                writer.Flush();
                                ms.Seek(0, SeekOrigin.Begin);
                                ms.CopyTo(memory);
                            }
                        }
                    }
                }
                return memory;
            }
        } //end class FrequencyCountReport

        public static class ResponseStatusDashboard
        {
            private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(ResponseStatusDashboard));

            /// <summary>
            /// Represents the filename used in the db for storing the details file, it contains a DplyId in a certain format
            /// </summary>
            public class DetailsCsvName
            {
                /// <summary>
                /// DlyId extracted from the internal CSV filename
                /// </summary>
                public Guid DplyId { get; private set; }

                /// <summary>
                /// Name to present to user (excludes the dplyId)
                /// </summary>
                public string ForDownload { get; private set; }

                /// <summary>
                /// Raw filename in dwUploadedFiles
                /// </summary>
                public string Value { get; private set; }

                /// <summary>
                /// Instantiate an instance from the raw string name (ie Name in dwUploadedFiles)
                /// </summary>
                /// <param name="name"></param>
                public DetailsCsvName(string name)
                {
                    InitialiseFromName(name);
                }

                /// <summary>
                /// Create a new filename for the csv that will include the DplyId
                /// </summary>
                /// <param name="dplyId"></param>
                public DetailsCsvName(Guid dplyId)
                {
                    string name = $"ResponseStatusDetails_{dplyId}_{DateTime.Now.ToString("yyyyMMddTHHmmss")}.csv";
                    InitialiseFromName(name);
                }

                private void InitialiseFromName(string name)
                {
                    if (string.IsNullOrWhiteSpace(name)) throw new ArgumentException(nameof(name));
                    this.Value = name;
                    string[] parts = name.Split('_');
                    if (parts.Length != 3) throw new ArgumentException("Invalid format", nameof(name));
                    this.DplyId = Guid.Parse(parts[1]);
                    this.ForDownload = parts[0] + '_' + parts[2];
                }

                public override String ToString() => Value;

                //Havent added Equals and Hashcode, to add if you need them
            }

            /// <summary>
            /// Returns a collection of details for the specified deployment and (optional) status.
            /// This has an Item for each sample in the deployment, with their uid, response status, and any remarks
            /// If no records found then an empty collection is returned.
            /// </summary>
            /// <param name="dplyId"></param>
            /// <param name="statusTitles">status titles (may be empty/null if not using)</param>
            /// <returns></returns>
            public static async Task<List<spSP_GetStatusResponseDetails.Item>> GetCaseDetails(
                Guid dplyId,
                IEnumerable<string> statusTitles,
                bool isExcludeExempted)
            {
                IEnumerable<QnnStatusId> statusIds = await ResponseApplication.GetStatusIdsFromTitlesAsync(statusTitles);
                List<spSP_GetStatusResponseDetails.Item> details
                    = await spSP_GetStatusResponseDetails.ExecuteAsync(dplyId, statusIds, isExcludeExempted);
                return details;
            }

            /// <summary>
            /// Writes the details to a CSV file in dwUploadedFiles and returns the file token.
            /// Note, this method does not set a job to cleanup the file later. 
            /// (Callers that want that can use BusinessProcess.ScheduleFileCleanup)
            /// </summary>
            /// <param name="details"></param>
            /// <returns>stream</returns>
            /// <exception cref="ArgumentNullException"></exception>
            public static async Task<string> PersistDetailsCSV(Guid dplyId, List<spSP_GetStatusResponseDetails.Item> details)
            {
                using (Stream csv = CSV(details))
                {
                    var properties = new Dictionary<string, string>();
                    DetailsCsvName name = new DetailsCsvName(dplyId);
                    properties.Add(Constants.FileProperties.Name, name.Value);
                    properties.Add(Constants.FileProperties.ContentType, Constants.ContentTypes.CsvFileType);
                    properties.Add(Constants.FileProperties.IsDownloadable, "false"); //Not to be served from DataController
                    string token = await CloverRuntime.ContentProvider.AddAsync(csv, properties);
                    return token;
                }
            }

            /// <summary>
            /// Write the details to a CSV, caller is responsible for stream disposal
            /// </summary>
            /// <param name="details"></param>
            /// <returns>csv stream/returns>
            /// <exception cref="ArgumentNullException"></exception>
            private static Stream CSV(List<spSP_GetStatusResponseDetails.Item> details)
            {
                if (details == null) throw new ArgumentNullException(nameof(details));
                MemoryStream stream = new MemoryStream();

                using (StreamWriter writer = new StreamWriter(stream, leaveOpen: true))
                {
                    using (CsvWriter csv = new CsvWriter(writer, new CsvConfiguration(CultureInfo.InvariantCulture), leaveOpen: true))
                    {
                        csv.WriteRecords(details);
                        csv.Flush();
                        writer.Flush();
                    }
                }
                stream.Seek(0, SeekOrigin.Begin);
                return stream;
            }

            /// <summary>
            /// Returns the data for the response status dashboard report.
            /// </summary>
            /// <param name="qnnDply"></param>
            /// <returns>null if there are no responses, otherwise the object with the count details</returns>
            /// <exception cref="ArgumentNullException"></exception>
            public static async Task<ExpandoObject> StatusResponseCounts(Guid dplyId)
            {
                try
                {
                    EntityModel qnnDplyModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.FetchJoins);
                    DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId, qnnDplyModel);
                    if (qnnDply == null) throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

                    List<Dictionary<string, object>> statusResponse = await spSP_GetStatusResponseByDplyId.ExecuteAsync(dplyId);
                    if (!statusResponse.Any()) return null;

                    List<Dictionary<string, object>> result = new List<Dictionary<string, object>>();
                    int statusCount = 0;
                    for (var i = 0; i < statusResponse.Count; i++)
                    {
                        Dictionary<string, object> item = statusResponse[i];
                        int count = Convert.ToInt32(item["Number"]);
                        string status = (string)item["Title"];
                        string statusCode = (string)item["Code"];

                        result.Add(new Dictionary<string, object>()
                            {
                                        {"ResponseNumber", count},
                                        {"Status", status},
                                        {"StatusCode", statusCode}
                            });
                        statusCount = statusCount + count;
                    }

                    int totalStatus = statusCount;

                    dynamic exp = new ExpandoObject();
                    exp.success = true;
                    exp.dplyName = qnnDply[Constants.FieldName.Name];
                    exp.qnnTitle = qnnDply[Constants.FieldName.QnnId + '_' + Constants.FieldName.Title];
                    exp.totalStatus = totalStatus;
                    exp.items = result;
                    return exp;
                }
                catch (Exception e)
                {
                    logger.LogDebug(e, nameof(StatusResponseCounts) + " - caught unexpected exception, dplyId={0}", dplyId);
                    throw;
                }
            }

        }


        /// <summary>
        /// Returns a Name ordered list of SecurityUser that belong to the current user or selected struct division or child struct divisions thereof
        /// </summary>
        /// <param name="selectedStructDivisionIdString"></param>
        /// <returns>users order by name</returns>
        //TODO - why is structDivisionId a string????????????????????????????????????????????????????
        public static async Task<List<SecurityUser>> GetUsersForStructDivision(string selectedStructDivisionIdString = "")
        {
            Guid selectedStructDivisionId = String.IsNullOrEmpty(selectedStructDivisionIdString)
                ? (Guid)(await CloverRuntime.Security.GetCurrentUserAsync()).StructDivisionId
                : Guid.Parse(selectedStructDivisionIdString);
            List<Guid> structDivisionsIdList = await StructDivision.SelectChildrenAndThisIdListAsync(selectedStructDivisionId);
            Filter byStructDivisionId = Filter.And.In(structDivisionsIdList, Constants.FieldName.StructDivisionId);
            Order orderByName = Order.StartAsc(Constants.FieldName.Name);
            return await SecurityUser.SelectAsync(byStructDivisionId, orderByName).ConfigureAwait(false);
        }

        public static class ReportSnapshot
        {
            private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(ReportSnapshot));

            /// <summary>
            /// DTO for exchanging snapshot settings with UI, controllers, etc
            /// </summary>
            public class SnapshotSettings
            {
                public static SnapshotSettings FromQnnDplyScheduler(DynamicEntity qnnDplyScheduler)
                {
                    if (qnnDplyScheduler == null) throw new ArgumentNullException(nameof(qnnDplyScheduler));
                    if (!ConversionUtils.TryParseCommaDelimitedGuids(
                        (string)qnnDplyScheduler[Constants.FieldName.EmailRecipients],
                        out List<Guid> emailRecipients))
                            throw new ArgumentException(nameof(qnnDplyScheduler), "EmailRecipients value is invalid");

                    return new ReportHelper.ReportSnapshot.SnapshotSettings(
                        dplyId: (Guid)qnnDplyScheduler[Constants.FieldName.DplyId],
                        isSaveSnapshot: true,
                        isEmailOnSuccess: (bool)qnnDplyScheduler[Constants.FieldName.EmailSuccess],
                        isEmailOnFailure: (bool)qnnDplyScheduler[Constants.FieldName.EmailFailure],
                        emailRecipients: emailRecipients);
                }

                //N.b. Intended to be immutable after instantiation, so don't add public setters
                //N.b. Constructor args and property names are used in JSON, need to update on client side too if renaming

                public Guid DplyId { get; private set; }
                public bool IsSaveSnapshot { get; private set; } = false;
                public bool IsEmailOnSuccess { get; private set; }
                public bool IsEmailOnFailure { get; private set; }
                public ReadOnlyCollection<Guid> EmailRecipients { get; private set; }

                [JsonConstructor]
                public SnapshotSettings(Guid dplyId, bool isSaveSnapshot, bool isEmailOnSuccess, bool isEmailOnFailure, List<Guid> emailRecipients)
                {
                    this.DplyId = dplyId;
                    this.IsSaveSnapshot = isSaveSnapshot;
                    this.IsEmailOnSuccess = isEmailOnSuccess;
                    this.IsEmailOnFailure = isEmailOnFailure;
                    this.EmailRecipients = new ReadOnlyCollection<Guid>(emailRecipients??new List<Guid>());
                }

                public SnapshotSettings(Guid dplyId)
                {
                    this.DplyId = dplyId;
                    this.EmailRecipients = new ReadOnlyCollection<Guid>(new List<Guid>());
                }
            }

            /// <summary>
            /// Update the report snapshot settings in the database by creating, updating, or deleting the relevant row
            /// in QNN_DPLY_SCHEDULER.
            /// Note that any email recipients that don't currently exist in cSP_dataEditors view will be quietly dropped when saving.
            /// </summary>
            public static async Task UpdateQnnDplyScheduler(SnapshotSettings settings, Guid updatedByUserId)
            {
                EntityModel qnnDplySchedulerModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SCHEDULER, Constants.Level.NoJoins);

                //Get the deployment to 1. verify it really exists, and 2. because we need its name for JobDescription
                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(settings.DplyId);
                if (qnnDply == null)
                    throw new ArgumentException(nameof(settings), "Invalid deployment");
                                    
                DynamicEntity existingQnnDplyScheduler
                    = await DeploymentApplication.GetQnnDplySchedulerByDplyId(settings.DplyId, qnnDplySchedulerModel);
                bool hasExistingConfiguration = (existingQnnDplyScheduler != null);
                if (settings.IsSaveSnapshot)
                {   //Enabling report snapshots for this deployment

                    string validRecipients;
                    if(settings.EmailRecipients.Any())
                    {
                        EntityModel vSP_dataEditorsModel
                            = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_dataEditors, Constants.Level.NoJoins);
                        List<Guid> validRecipientIds
                            = (await vSP_dataEditorsModel.GetAsync(Filter.And.In<Guid>(settings.EmailRecipients.ToList(), Constants.FieldName.Id)))
                            .Select(de => (Guid)de[Constants.FieldName.Id])
                            .ToList();

                        //TODO - A struct division id check here would need to be for a recipient in the deployment's
                        //       division or its children, and also in any ancestor division of the deployment
                        //       so that we don't remove those added by someone in a higher org (the dictionary doesn't strip
                        //       such entries even though they aren't displayed in the UI to a user who is in a child division)
                        //       (But for now, we shall leave this as a TODO and preserve any *existing* editor named here)

                        //Ensure no duplicates and convert to comma delimited list for storage in the db column
                        validRecipients = string.Join(',', validRecipientIds.Distinct().ToList());
                    }
                    else
                    {
                        validRecipients = "";
                    }
                    
                    DateTime now = DateTime.Now;
                    DynamicEntity qnnDplyScheduler;
                    if (hasExistingConfiguration)
                    {   //Modify the existing entity
                        qnnDplyScheduler = existingQnnDplyScheduler;
                    }
                    else
                    {   //Need to create and initialise a new entity
                        qnnDplyScheduler = await qnnDplySchedulerModel.NewAsync();
                        qnnDplyScheduler[Constants.FieldName.DplyId] = settings.DplyId;
                        qnnDplyScheduler[Constants.FieldName.JobDescription] = (string)qnnDply[Constants.FieldName.Name];
                        qnnDplyScheduler[Constants.FieldName.LastJobRun] = null; //n.b. old behaviour was to set current time on creation
                        qnnDplyScheduler[Constants.FieldName.CreatedDate] = now;
                        qnnDplyScheduler[Constants.FieldName.CreatedBy] = updatedByUserId;
                    }
                    qnnDplyScheduler[Constants.FieldName.UpdatedDate] = now;
                    qnnDplyScheduler[Constants.FieldName.UpdatedBy] = updatedByUserId;
                    qnnDplyScheduler[Constants.FieldName.EmailSuccess] = settings.IsEmailOnSuccess;
                    qnnDplyScheduler[Constants.FieldName.EmailFailure] = settings.IsEmailOnFailure;
                    qnnDplyScheduler[Constants.FieldName.EmailRecipients] = validRecipients;
                    await qnnDplySchedulerModel.UpdateSingleAsync(qnnDplyScheduler);
                }
                else
                {   //Disabling report snapshots for the deployment is done by removing its snapshot settings
                    //this won't remove existing snapshot data for the deployment
                    if (hasExistingConfiguration)
                    {
                        await qnnDplySchedulerModel.DeleteAsync(new List<object> { (Guid)existingQnnDplyScheduler[Constants.FieldName.Id] });
                    }
                }
            }

            /// <summary>
            /// Extracts report snapshot data into the QNN_REPORT_SNAPSHOT table for later use in the imda reports
            /// and sends an email to pre-specified users notifying the outcome. This is intended to be called from
            /// a daily hangfire job. 
            /// </summary>
            public static async Task TakeReportSnapshot(DynamicEntity reportSnapshotSetting)
            {
                if (reportSnapshotSetting == null) throw new ArgumentNullException(nameof(reportSnapshotSetting));
                try
                {
                    Guid dplyId = (Guid)reportSnapshotSetting[Constants.FieldName.DplyId];
                    DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId);
                    if (qnnDply == null)
                        throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

                    if (!ConversionUtils.TryParseCommaDelimitedGuids(
                        (string)reportSnapshotSetting[Constants.FieldName.EmailRecipients],
                        out List<Guid> recipientIds))
                            throw new FormatException("EmailRecipients does not contain a list of Guids");
                    bool hasRecipients = recipientIds.Any();
                    try
                    {
                        spSP_TakeReportSnapshot spSP_TakeReportSnapshot = await spSP_TakeReportSnapshot.GetInstanceUsingAppSettingsAsync();

                        //If Stored Procedure throws exception it will go to catch (but I note that invalid dplyId will not throw one)
                        List<Dictionary<string, object>> results = await spSP_TakeReportSnapshot.ExecuteAsync(dplyId);

                        //The main purpose of the SP is to add data into QNN_REPORT_SNAPSHOT, but it also returns the values
                        //it has marshalled to the caller. If it returns nothing it is likely that the deployment was deleted.
                        //(However with other recent changes such as making QNN_REPORT_SCHEDULER.DplyId a foreign key with
                        // ON DELETE CASCADE and an explicit check for the deployment above we should not encounter this here any more)
                        if (!results.Any())
                            throw new InternalException($"{nameof(spSP_TakeReportSnapshot)}- no rows returned, dplyId {dplyId} might not refer to a valid deployment");

                        bool isEmailOnSuccess = (bool)reportSnapshotSetting[Constants.FieldName.EmailSuccess];
                        if (isEmailOnSuccess && hasRecipients)
                            await SendReportSnapshotEmail(isSuccess: true, recipientIds, qnnDply);

                        Logger.LogInformation(nameof(TakeReportSnapshot) + " - snapshot saved succesfully for dplyId={0}", dplyId);
                    }
                    catch (Exception e)
                    {
                        Logger.LogError(e, nameof(TakeReportSnapshot) + " - caught unexpected exception while executing stored procedure processing dplyId={0}", dplyId);
                        bool isEmailOnFailure = (bool)reportSnapshotSetting[Constants.FieldName.EmailFailure];
                        if (isEmailOnFailure && hasRecipients)
                            await SendReportSnapshotEmail(isSuccess: false, recipientIds, qnnDply);
                    }
                }
                catch (Exception e)
                {
                    Logger.LogError(e, nameof(TakeReportSnapshot) + " - caught unexpected exception");
                }
            }

            private static async Task SendReportSnapshotEmail(bool isSuccess, List<Guid> recipientIds, DynamicEntity qnnDply)
            {
                if (recipientIds == null || !recipientIds.Any()) throw new ArgumentException(nameof(recipientIds), "no recipients specified");
                if (qnnDply == null) throw new ArgumentNullException(nameof(qnnDply));

                try
                {
                    EntityModel dwSecurityUserModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.dwSecurityUser, Constants.Level.NoJoins);
                    MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();

                    string deploymentName = (string)qnnDply[Constants.FieldName.Name];

                    foreach (Guid userId in recipientIds.Distinct().ToList())
                    {
                        DynamicEntity user = await IntranetAccountApplication.GetDwSecurityUserByIdAsync(userId);

                        if (user != null)
                        {
                            string userEmail = (string)user[Constants.FieldName.Email];
                            StringBuilder builder = new StringBuilder();
                            string subject;

                            string date = DateTime.Now.ToString(Constants.DateFormat);

                            if (isSuccess)
                            {
                                subject = $"Snapshots saved successfully for {deploymentName} on {date}.";
                                builder.AppendLine("Hi,");
                                builder.AppendLine();
                                builder.AppendLine(WebUtility.HtmlEncode(subject));
                                builder.AppendLine();
                                builder.AppendLine("Thank you.");
                            }
                            else
                            {
                                subject = $"Snapshots unsuccessful for {deploymentName} on {date}.";
                                builder.AppendLine("Hi,");
                                builder.AppendLine();
                                builder.AppendLine(WebUtility.HtmlEncode(subject));
                                builder.AppendLine();
                                builder.AppendLine("Please contact administrators.");
                                builder.AppendLine();
                                builder.AppendLine("Thank you.");
                            }
                            string body = builder.ToString();

                            await BusinessProcess.Enqueue.SendEmail(
                                mailSettings: mailSettings,
                                email: userEmail,
                                subject: subject,
                                body: body,
                                appName: Email.UseDefaultSenderDisplayName);

                            Logger.LogDebug(nameof(SendReportSnapshotEmail) + " - enqueued job to send snapshot notification mail, userEmail={0}, subject={1}", userEmail, subject);
                        } // end if user (note that we just ignore invalid userIds here, these would be users who were deleted)              
                    } //end for
                }
                catch (Exception e)
                {
                    Logger.LogError(e, nameof(SendReportSnapshotEmail) + " - caught unexpected exception");
                }
            }
        } //end of ReportSnapshot

    } //end of ReportHelper

    interface UserAccessMatrixData
    {
        DateTime GeneratedDate { get; }
    }
}
