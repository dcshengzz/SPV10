CREATE PROCEDURE [dbo].[spSP_GetDplyChoiceCount]
		@DplyId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

--count each answer value for all responses of a deployment. treate null and empty as same response.
SELECT Name, QnnFieldId, AnsVal, AnsCount, RespCount, CAST( ROUND(AnsCount *1.00 / RespCount, 4) * 100 AS FLOAT) as [Percentage]  from
(select d.Id as DplyId, d.StructDivisionId, f.NumberId, f.Name, a.QnnFieldId, IsNull(a.AnsVal, '') as AnsVal, count(IsNull(a.AnsVal, '')) as [AnsCount], IsNull(rc.RespCount, 0) as RespCount from QNN_RESP_ANS a
inner join QNN_RESP r on r.Id = a.RespId
inner join QNN_DPLY d on d.Id = r.DplyId
inner join QNN_QNN_FIELD f on f.Id = a.QnnFieldId
inner join vSP_DeploymentRespCount rc on rc.DplyId = r.DplyId
where d.Id = @DplyId
and f.Name<>'swzPdfFormIdentifier' 
and f.Name<>'btnSubmit'
AND (f.Type = 'checkbox' or  f.Type = 'radiogroup' or  f.Type = 'ListBox' or  f.Type = 'dropdown' or f.Type='RadioButton' ) 
group by d.Id, d.StructDivisionId, f.Name, f.NumberId, a.QnnFieldId, ISNULL(a.AnsVal,''), rc.RespCount
) FieldAnsCount order by NumberId

END 
