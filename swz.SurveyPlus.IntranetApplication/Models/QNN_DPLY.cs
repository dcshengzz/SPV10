using swz.Clover.Core;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;
using System;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class QNN_DPLY : DbObject<QNN_DPLY>
    {
        public QNN_DPLY() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public int NumberId { get => _entity.NumberId; set => _entity.NumberId = value; }

        [DbObjectModel]
        public Guid QnnId { get => _entity.QnnId; set => _entity.QnnId = value; }

        [DbObjectModel]
        public Char Type { get => _entity.Type; set => _entity.Type = value; }

        [DbObjectModel]
        public Char Target { get => _entity.Target; set => _entity.Target = value; }

        [DbObjectModel]
        public bool Status { get => _entity.Status; set => _entity.Status = value; }

        [DbObjectModel]
        public string Name { get => _entity.Name; set => _entity.Name = value; }

        [DbObjectModel]
        public Guid ListId { get => _entity.ListId; set => _entity.ListId = value; }

        [DbObjectModel]
        public DateTime? DateStart { get => _entity.DateStart; set => _entity.DateStart = value; }

        [DbObjectModel]
        public DateTime? DateEnd { get => _entity.DateEnd; set => _entity.DateEnd = value; }

        [DbObjectModel]
        public int? QnnDuration { get => _entity.QnnDuration; set => _entity.QnnDuration = value; }

        [DbObjectModel]
        public char? QnnDurationUnit { get => _entity.QnnDurationUnit; set => _entity.QnnDurationUnit = value; }

        [DbObjectModel]
        public char CompleteAction { get => _entity.CompleteAction; set => _entity.CompleteAction = value; }

        [DbObjectModel]
        public string CompleteURL { get => _entity.CompleteURL; set => _entity.CompleteURL = value; }

        [DbObjectModel]
        public bool NavigateBackYN { get => _entity.NavigateBackYN; set => _entity.NavigateBackYN = value; }

        [DbObjectModel]
        public char? NavigateCancelYN { get => _entity.NavigateCancelYN; set => _entity.NavigateCancelYN = value; }

        [DbObjectModel]
        public string NavigateCancelURL { get => _entity.NavigateCancelURL; set => _entity.NavigateCancelURL = value; }

        [DbObjectModel]
        public int? MaxResponse { get => _entity.MaxResponse; set => _entity.MaxResponse = value; }

        [DbObjectModel]
        public int? DaysUpdate { get => _entity.DaysUpdate; set => _entity.DaysUpdate = value; }

        [DbObjectModel]
        public bool IsDeleted { get => _entity.IsDeleted; set => _entity.IsDeleted = value; }

        [DbObjectModel]
        public Guid? CreatedBy { get => _entity.CreatedBy; set => _entity.CreatedBy = value; }

        [DbObjectModel]
        public DateTime? CreatedDate { get => _entity.CreatedDate; set => _entity.CreatedDate = value; }

        [DbObjectModel]
        public Guid? DeletedBy { get => _entity.DeletedBy; set => _entity.DeletedBy = value; }

        [DbObjectModel]
        public DateTime? DeletedDate { get => _entity.DeletedDate; set => _entity.DeletedDate = value; }

        [DbObjectModel]
        public Guid? UpdatedBy { get => _entity.UpdatedBy; set => _entity.UpdatedBy = value; }

        [DbObjectModel]
        public DateTime? UpdatedDate { get => _entity.UpdatedDate; set => _entity.UpdatedDate = value; }

        [DbObjectModel]
        public Guid? StructDivisionId { get => _entity.StructDivisionId; set => _entity.StructDivisionId = value; }

        [DbObjectModel]
        public bool? VisibleToRespondent { get => _entity.VisibleToRespondent; set => _entity.VisibleToRespondent = value; }

        [DbObjectModel]
        public bool? RestrictIp { get => _entity.RestrictIp; set => _entity.RestrictIp = value; }

        [DbObjectModel]
        public string IpCountry { get => _entity.IpCountry; set => _entity.IpCountry = value; }

        [DbObjectModel]
        public bool? RestrictIpInclusive { get => _entity.RestrictIpInclusive; set => _entity.RestrictIpInclusive = value; }

        [DbObjectModel]
        public string IpRange { get => _entity.IpRange; set => _entity.IpRange = value; }

        [DbObjectModel]
        public bool? IsAnonymous { get => _entity.IsAnonymous; set => _entity.IsAnonymous = value; }

        [DbObjectModel]
        public bool? IsMultipleResponse { get => _entity.IsMultipleResponse; set => _entity.IsMultipleResponse = value; }

        [DbObjectModel]
        public string State { get => _entity.State; set => _entity.State = value; }

        [DbObjectModel]
        public string StateName { get => _entity.StateName; set => _entity.StateName = value; }

        [DbObjectModel]
        public bool EnableWorkflow { get => _entity.EnableWorkflow; set => _entity.EnableWorkflow = value; }

        [DbObjectModel]
        public string Remarks { get => _entity.Remarks; set => _entity.Remarks = value; }

        [DbObjectModel]
        public bool IsDataToData { get => _entity.IsDataToData; set => _entity.IsDataToData = value; }

        [DbObjectModel]
        public Guid? ValidationDplyId { get => _entity.ValidationDplyId; set => _entity.ValidationDplyId = value; }

        [DbObjectModel]
        public string RecurrenceFrequency { get => _entity.RecurrenceFrequency; set => _entity.RecurrenceFrequency = value; }

        [DbObjectModel]
        public DateTime? RecurrenceEndDate { get => _entity.RecurrenceEndDate; set => _entity.RecurrenceEndDate = value; }

        [DbObjectModel]
        public int RecurrenceAdvanceDays { get => _entity.RecurrenceAdvanceDays; set => _entity.RecurrenceAdvanceDays = value; }

        [DbObjectModel]
        public Guid? RecurrenceOfDplyId { get => _entity.RecurrenceOfDplyId; set => _entity.RecurrenceOfDplyId = value; }

        [DbObjectModel]
        public DateTime? RecurrenceNextDate { get => _entity.RecurrenceNextDate; set => _entity.RecurrenceNextDate = value; }

        [DbObjectModel]
        public string RecurrenceJobId { get => _entity.RecurrenceJobId; set => _entity.RecurrenceJobId = value; }

        [DbObjectModel]
        public bool RecurrenceEnabled { get => _entity.RecurrenceEnabled; set => _entity.RecurrenceEnabled = value; }

        [DbObjectModel]
        public string RecurrenceNotify { get => _entity.RecurrenceNotify; set => _entity.RecurrenceNotify = value; }

        [DbObjectModel]
        public bool RequireAccessCode { get => _entity.RequireAccessCode; set => _entity.RequireAccessCode = value; }

        [DbObjectModel]
        public bool IsExcelEnabled { get => _entity.IsExcelEnabled; set => _entity.IsExcelEnabled = value; }

        [DbObjectModel]
        public string SurveyName { get => _entity.SurveyName; set => _entity.SurveyName = value; }

        [DbObjectModel]
        public string Description { get => _entity.Description; set => _entity.Description = value; }

        //TODO - why is the below bool? instead of bool
        [DbObjectModel]
        public bool? IsRecurrencePrePopulateEnabled { get => _entity.IsRecurrencePrePopulateEnabled; set => _entity.IsRecurrencePrePopulateEnabled = value; }

        [DbObjectModel]
        public bool IsExposeListProperties { get => _entity.IsExposeListProperties; set => _entity.IsExposeListProperties = value; }

        [DbObjectModel]
        public string StrataSource { get => _entity.StrataSource; set => _entity.StrataSource = value; }

        public static async Task<QNN_DPLY> GetByDplyId(Guid dplyId)
        {
            var filter = Filter.And.Equal(dplyId, Constants.FieldName.Id);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0] : null;
        }

        /// <summary>
        /// Find a Previous Deployment (-1) by using RecurrenceOfDplyId and CreatedDate.
        /// CreatedDate of previous deployment is earlier then this deployment CreatedDate. 
        /// Return previous recurrence deployment. 
        /// Return parent deployment if it is the first recurrence deployment.
        /// </summary>
        /// <param name="qnnDply">current dply</param>
        /// <returns>previous deployment</returns>
        public static async Task<QNN_DPLY> GetPreviousRecurrenceByDply(QNN_DPLY qnnDply)
        {
            var filter = Filter.And
                .Equal((Guid)qnnDply.RecurrenceOfDplyId, Constants.FieldName.RecurrenceOfDplyId)
                .Less(qnnDply.CreatedDate, Constants.FieldName.CreatedDate);
            var order = Order.StartDesc(Constants.FieldName.NumberId);
            var paging = Paging.Create(skip: 0, take: 1);
            var result = await SelectAsync(filter, order, paging).ConfigureAwait(false);
            return result.Count > 0 ? result[0] : await SelectByKey(qnnDply.RecurrenceOfDplyId);
        }

    }
}
