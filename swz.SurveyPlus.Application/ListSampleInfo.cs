using swz.Clover.Core;
using swz.Clover.Core.Model;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.Application
{
    //TODO - think we need to split this, have an enhanced subclass for intranet side and a poor version to use with internet side 

    /// <summary>
    /// Best bits (ie: far from all the fields) of vSP_ListSampleInfo in an immutable object 
    /// Primarily intended as a way for internet side controllers to get this data without depending on
    /// DynamicEntity or VSPListSampleInfoModelGetItem, and with better semantics than a Dictionary and as a place
    /// to put some common calculations (like survey validity, respondent access) based on that data
    /// Please note that this object does not implement Id or Value based equality (yet)
    /// If you need to trip this object over JSON it is not very conveinent at the moment. It is suggested you
    /// instead serialise a source DynamicEntity as dictionary, and at the other end deserialise this into a
    /// dynamic and feed that to the FromDynamic factory method. (TODO - improve that so only the required
    /// fields need to travel over json)
    /// </summary>
    public class ListSampleInfo
    {
        //TODO - move this method to oe of the XXXApplication classes since its not suitable for internet side
        /// <summary>
        /// Retrieve ListSampleInfo given the dlsi id (The Id in vSP_ListSampleInfo, vSP_ListSampleInfoResp, and QNN_DPLY_SAMPLE_INFO)
        /// NOTE: This method requires the ORM access so cannot be used on the internet side under U@Db model. 
        /// </summary>
        /// <param name="dlsi"></param>
        /// <param name="vSPListSampleInfoModel"></param>
        /// <returns>null if not found, othrwise ListSampleInfo object with values taken from the first row (by NumberId) found in vSP_ListSampleInfo filtered by the dlsi Id</returns>
        /// <exception cref="ArgumentException"></exception>
        public static async Task<ListSampleInfo> GetByDlsi(Guid dlsi, EntityModel vSPListSampleInfoModel = null)
        {
            if (vSPListSampleInfoModel == null)
            {
                vSPListSampleInfoModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_ListSampleInfo, Constants.Level.NoJoins);
            }
            else if (!Constants.ModelName.vSP_ListSampleInfo.Equals(vSPListSampleInfoModel.Name))
            {
                throw new ArgumentException($"Expected model for {Constants.ModelName.vSP_ListSampleInfo} but was passed {vSPListSampleInfoModel.Name}", nameof(vSPListSampleInfoModel));
            }
            Filter byDlsi = Filter.And.Equal(dlsi, Constants.FieldName.Id);
            Order orderByLatestFirst = Order.StartDesc(Constants.FieldName.NumberId);
            Paging takeOneOnly = Paging.Create(skip: 0, take: 1);
            DynamicEntity listSampleInfo
                = (await vSPListSampleInfoModel.GetAsync(byDlsi, orderByLatestFirst, takeOneOnly))
                .FirstOrDefault();
            return listSampleInfo==null ? null : FromDynamic(listSampleInfo);
        }

        /// <summary>
        /// Accepts either a vSPListSampleInfo DynamicEntity or a VSPListSampleInfoModelGetItem, or other object with the expected properties
        /// Will also convert null MaxResponse and DaysUpdate to Constants.Unlimited (-1) and null DueDate to DateTime.MaxValue
        /// </summary>
        /// <param name="lsi">object with the expected properties, ie vSPListSampleInfoResp</param>
        /// <returns></returns>
        /// <exception cref="ArgumentNullException"></exception>
        public static ListSampleInfo FromDynamic(dynamic lsi)
        {
            if (lsi == null) throw new ArgumentNullException(nameof(lsi));
            //n.b. below cannot use [ ] as must also support the swagger object (last time), json types (now), etc etc
            //which is also why we need the explicit Convert call or casts to ensure the correct types are applied and we have valid arguments
            //to 'find' the constructor with
            int? daysUpdate = lsi.DaysUpdate;
            DateTime? dueDate = lsi.DueDate;
            int? maxResponse = lsi.MaxResponse;

            return new ListSampleInfo(
                id: Guid.Parse(Convert.ToString(lsi.Id)),
                restrictIp: Convert.ToBoolean(lsi.RestrictIp),
                restrictIpInclusive: Convert.ToBoolean(lsi.RestrictIpInclusive),
                ipCountry: (string)lsi.IpCountry,
                ipRange: (string)lsi.IpRange,
                isAnonymous: Convert.ToBoolean(lsi.IsAnonymous),
                isMultipleResponse: Convert.ToBoolean(lsi.IsMultipleResponse),
                requireAccessCode: Convert.ToBoolean(lsi.RequireAccessCode),
                visibleToRespondent: Convert.ToBoolean(lsi.VisibleToRespondent),
                uId: Convert.ToString(lsi.UID),
                dplyStatus: Convert.ToBoolean(lsi.DplyStatus),
                qnnStatus: Convert.ToBoolean(lsi.QnnStatus),
                dplyIsDeleted: Convert.ToBoolean(lsi.DplyIsDeleted),
                qnnIsDeleted: Convert.ToBoolean(lsi.QnnIsDeleted),
                qnnType: Convert.ToChar(lsi.QnnType),
                formNames: Convert.ToString(lsi.FormNames),
                qnnId: Guid.Parse(Convert.ToString(lsi.QnnId)),
                dplyId: Guid.Parse(Convert.ToString(lsi.DplyId)),
                listSampleId: Guid.Parse(Convert.ToString(lsi.ListSampleId)),
                listId: Guid.Parse(Convert.ToString(lsi.ListId)),
                sampleId: Guid.Parse(Convert.ToString(lsi.SampleId)),
                status: Guid.Parse(Convert.ToString(lsi.Status)),
                daysUpdate: daysUpdate ?? Constants.Unlimited,
                dueDate: dueDate ?? DateTime.MaxValue,
                maxResponse: maxResponse ?? Constants.Unlimited,
                uidName: Convert.ToString(lsi.UIDName),
                qnnTitle: Convert.ToString(lsi.QnnTitle),
                remarks: (string)lsi.Remarks,
                isExcelEnabled: Convert.ToBoolean(lsi.IsExcelEnabled),
                completeURL: (string)lsi.CompleteURL
            );
        }

        // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add setters. //
        // // // // // // // // // // // // // // // // // // // // // // // //

        //Add more properties as needed to support controller logic but keep it readonly
        //nb: later we might even see if can add all the properties and use with the grid too, but not yet

        /// <summary>
        /// AKA "dlsi", this is the Id in both QNN_DPLY_SAMPLE_INFO and vSP_ListSampleInfo
        /// </summary>
        public Guid Id { get; private set; }

        /// <summary>
        /// Ip and Country locking rules for survey
        /// </summary>
        public IPRestriction IPRules { get; private set; }

        /// <summary>
        /// Survey is an anonymous survey (this is based on IsAnonymous in the QNN_DPLY, and not the sample uid)
        /// </summary>
        public bool IsAnonymousSurvey { get; private set; }

        public bool IsMultipleResponse { get; private set; }

        //TODO - fix spelling error in name
        public bool IsMultiplResponseFeaturesEnabled { get => (IsMultipleResponse || IsAnonymousSurvey); }

        /// <summary>
        /// Survey requires a delegation accessCode or delegationCode for respondents to access
        /// </summary>
        public bool RequireAccessCode { get; private set; }

        /// <summary>
        /// This will be false if the survey is not set as being visible
        /// </summary>
        public bool VisibleToRespondent { get; private set; }

        /// <summary>
        /// Sample UID (UEN if using SPCP auth) 
        /// </summary>
        public string UID { get; private set; }

        /// <summary>
        /// Includes the sample UID and the Name
        /// Concat(s.UID, ' (', s.Name, ')')
        /// </summary>
        public string UIDName { get; private set; }

        public Guid QnnId { get; private set; }

        public Guid DplyId { get; private set; }

        public Guid ListSampleId { get; private set; }

        public Guid ListId { get; private set; }

        public Guid SampleId { get; private set; }

        public QnnStatusId Status { get; private set; }

        /// <summary>
        /// Number of days after submission (while survey still open) that respondent can update their response.
        /// Constants.Unlimited indicates this is not limited. (You can call IsDaysUpdateUnlimited)
        /// </summary>
        public int DaysUpdate { get; private set; }

        public bool IsDaysUpdateUnlimited { get => (DaysUpdate == Constants.Unlimited); }

        public DateTime DueDate { get; private set; }

        /// <summary>
        /// Maximum number of responses (not respondents) for this survey.
        /// Constants.Unlimited indicates this is not limited.
        /// </summary>
        public int MaxResponse { get; private set; }

        public bool IsMaxResponseUnlimited { get => (MaxResponse == Constants.Unlimited); }

        public string QnnTitle { get; private set; }

        public string formNames { get; private set; }

        public string Remarks { get; private set; }

        public bool IsExcelEnabled { get; private set; }

        /// <summary>
        /// Redrect navigation target after survey submission 
        /// (used for certain types of survey like Anonymous surveys, but not all)
        /// </summary>
        public string CompleteURL { get; private set; }

        //If our logic needs any of these directly then can change it to expose them as a property, otherwise just leave as private fields for now
        private readonly bool dplyStatus;
        private readonly bool qnnStatus;
        private readonly bool dplyIsDeleted;
        private readonly bool qnnIsDeleted;
        private readonly char qnnType;

        private ListSampleInfo(
            //yes, the order of these params is pretty random (added as needed), but since its an internal method only
            //to be called from the factory method or NewtonSoft there is no benefit to organising them right now
            Guid id,
            bool restrictIp,
            bool restrictIpInclusive,
            string ipCountry,
            string ipRange,
            bool isAnonymous,
            bool isMultipleResponse,
            bool requireAccessCode,
            bool visibleToRespondent,
            string uId,
            bool dplyStatus,
            bool qnnStatus,
            bool dplyIsDeleted,
            bool qnnIsDeleted,
            char qnnType,
            string formNames,
            Guid qnnId,
            Guid dplyId,
            Guid listSampleId,
            Guid listId,
            Guid sampleId,
            Guid status,
            int daysUpdate,
            DateTime dueDate,
            int maxResponse,
            string uidName,
            string qnnTitle,
            string remarks,
            bool isExcelEnabled,
            string completeURL)
        {
            this.Id = id;
            this.IPRules = new IPRestriction(restrictIp, restrictIpInclusive, ipCountry, ipRange);
            this.IsAnonymousSurvey = isAnonymous;
            this.IsMultipleResponse = isMultipleResponse;
            this.RequireAccessCode = requireAccessCode;
            this.VisibleToRespondent = visibleToRespondent;
            this.UID = uId;
            this.dplyStatus = dplyStatus;
            this.qnnStatus = qnnStatus;
            this.dplyIsDeleted = dplyIsDeleted;
            this.qnnIsDeleted = qnnIsDeleted;
            this.qnnType = qnnType;
            this.formNames = formNames;
            this.QnnId = qnnId;
            this.DplyId = dplyId;
            this.ListSampleId = listSampleId;
            this.ListId = listId;
            this.SampleId = sampleId;
            this.Status = QnnStatusId.FromGuid(status);
            this.DaysUpdate = daysUpdate;
            this.DueDate = dueDate;
            this.MaxResponse = maxResponse;
            this.UIDName = uidName;
            this.QnnTitle = qnnTitle;
            this.Remarks = remarks;
            this.IsExcelEnabled = isExcelEnabled;
            this.CompleteURL = completeURL;
        }

        public bool IsWithinMaxResponseCount(int currentResponseCount)
        {
            if (currentResponseCount < 0) throw new ArgumentOutOfRangeException("Cannot be negative", nameof(currentResponseCount));
            if (MaxResponse == Constants.Unlimited) return true;
            return currentResponseCount < MaxResponse;
        }

        /// <summary>
        /// True if the completionDate meets the DaysUpdate constraint.
        /// (If not complete then will return false)
        /// </summary>
        /// <param name="completionDate">DateComplete (respDateEnd)</param>
        /// <returns></returns>
        public bool IsWithinDaysUpdateAfterCompletion (DateTime? completionDate)
        {
            return TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IsWithinDaysUpdateAfterCompletion(
                DateTime.Now,
                DaysUpdate,
                completionDate); 
        }

        /// <summary>
        /// Overdue or not?
        /// </summary>
        /// <returns></returns>
        public bool IsClosedForThisRespondent()
        {
            return DueDate < DateTime.Now;
        }

        /// <summary>
        /// Result information from checkRespondentAccess (pass error information for controller logging purpose)
        /// </summary>
        public class AccessResult
        {
            public string ErrorMsg { get; private set; }
            public bool IsValid { get { return ErrorMsg == null; } }
            public AccessResult(string errorMsg)
            {
                this.ErrorMsg = errorMsg;
            }
        }
        /// <summary>
        /// Return error message if dply/qnn not active/visible to respondent, is deleted; qnn not online type
        /// or the specified sample isn't the one listed in the record
        /// or the form name is not in listed in form properties
        /// (superset of CheckSurveyAccess that also checks the UID)
        /// </summary>
        /// <param name="candidateUid"></param>
        /// <param name="accessFormName"></param>
        /// <returns></returns>
        public AccessResult CheckRespondentAccess(string candidateUid,string accessFormName)
        {
            if (String.IsNullOrWhiteSpace(candidateUid)) throw new ArgumentException(nameof(candidateUid));
            if (String.IsNullOrWhiteSpace(accessFormName)) throw new ArgumentException(nameof(accessFormName));
            /*
                previous code in internet side's UserInterfaceController:
                    if (dsiEntity == null || !Convert.ToBoolean(dsiEntity.DplyStatus) ||
                        !Convert.ToBoolean(dsiEntity.QnnStatus) ||
                        Convert.ToBoolean(dsiEntity.DplyIsDeleted) ||
                        !Convert.ToBoolean(dsiEntity.VisibleToRespondent) ||
                        Convert.ToBoolean(dsiEntity.QnnIsDeleted) ||
                        dsiEntity.QnnType != "O")
                        return Json(BusinessProcess.GenFailedDictionary("Invalid access")); //dply/qnn not active, is deleted; qnn not online type  
            */
            AccessResult surveyAccess = CheckSurveyAccess();
            if (!surveyAccess.IsValid) return surveyAccess;
            if (!candidateUid.Equals(UID, StringComparison.InvariantCultureIgnoreCase)) return new AccessResult(Constants.FormAccessErrors.InvalidSample); //wrong sample sir
            // Fix for SP-01 and SP-02 for MPA Pentest 2022-04-29, validate form name in request against form listed in form properties
            // To prevent respondent to modify the form parameter in url to access other forms (or form that required delegation code).
            string[] formNamesArray = formNames.Split("||");
            if (!formNamesArray.Contains(accessFormName,StringComparer.InvariantCultureIgnoreCase)) return new AccessResult(Constants.FormAccessErrors.NotInFormProperties); //the form that respondent trying to access is not listed in formProperties.

            return new AccessResult(null); 
        }

        /// <summary>
        /// Is this a valid survey? In other words are the deployment and the qnn both active? Is the deployment set visible to respondents?
        /// Is it marked as deleted (legacy check)?
        /// Is it of the online type (legacy check)?
        /// </summary>
        /// <returns></returns>
        public AccessResult CheckSurveyAccess()
        {
            if (!dplyStatus) return new AccessResult(Constants.FormAccessErrors.DeploymentDisabled); //the deployment is disabled
            if (!qnnStatus) return new AccessResult(Constants.FormAccessErrors.FormPropertiesDisabled); //the form properties is disabled
            if (dplyIsDeleted) return new AccessResult(Constants.FormAccessErrors.DeploymentDeleted); //deployment deleted (legacy soft delete)
            if (!VisibleToRespondent) return new AccessResult(Constants.FormAccessErrors.SurveyNotVisible); //survey not visible yet
            if (qnnIsDeleted) return new AccessResult(Constants.FormAccessErrors.FormPropertiesDeleted); //form properties deleted (legacy soft delete)
            if ('O' != qnnType) return new AccessResult(Constants.FormAccessErrors.NotOnlineForm); //not an online form
            return new AccessResult(null);
        }

    }
}
