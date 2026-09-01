CREATE PROCEDURE [dbo].[spSP_GetDplyWordCount]
		@DplyId uniqueidentifier,
		@QnnField nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;

SELECT AnsVal, AnsCount from
(select dply.Id as DplyId, dply.StructDivisionId, field.NumberId, field.Name, respAns.QnnFieldId, IsNull(respAns.AnsVal, '') as AnsVal, count(IsNull(respAns.AnsVal, '')) as [AnsCount]
from QNN_RESP_ANS respAns
inner join QNN_RESP resp on resp.Id = respAns.RespId
inner join QNN_DPLY dply on dply.Id = resp.DplyId
inner join QNN_QNN_FIELD field on field.Id = respAns.QnnFieldId
where dply.Id = @DplyId
and field.Name = @QnnField
AND field.Type = 'input'
group by dply.Id, dply.StructDivisionId, field.Name, field.NumberId, respAns.QnnFieldId, ISNULL(respAns.AnsVal,'')
) FieldAnsCount order by NumberId

END 
