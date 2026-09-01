CREATE VIEW [dbo].[vSP_DataEditorDeployment] AS 
select o.DplyId AS Id, o.DplyId, o.UserId, d.Name, d.IsAnonymous, d.IsMultipleResponse,
CASE
	WHEN d.Status=1 THEN 'Active'   
	WHEN d.Status=0 THEN 'Design'   
END 
as StatusText, d.Status,

q.Title, q.Type as QnnType,  d.DateEnd, d.UpdatedBy, d.CreatedDate, d.UpdatedDate,  sc.SampleCount, rc.RespCount, d.Tags,

ISNULL(CAST(rc.RespCount as varchar(10)),0)  + '/' + CAST(sc.SampleCount as varchar(10)) as Responses, d.StructDivisionId, 

u.Name as UpdatedByUsername

from vSP_DeploymentOwner o
left join QNN_DPLY d on o.DplyId=d.Id
left join QNN_QNN q on d.QnnId = q.Id
left join dwSecurityUser u on u.Id = d.UpdatedBy
left join vSP_DeploymentSampleCount sc on sc.DplyId = o.DplyId
left join vSP_DeploymentRespCount rc on rc.DplyId = o.DplyId


where d.IsDeleted=0 and q.IsDeleted=0 
