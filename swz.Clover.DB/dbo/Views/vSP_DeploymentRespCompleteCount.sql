
CREATE VIEW [dbo].[vSP_DeploymentRespCompleteCount] AS 
select d.Id as DplyId, count(*) as RespCount from QNN_Resp r with (NOLOCK)
inner join QNN_DPLY d on d.Id = r.DplyId
where r.DateComplete <> ''
group by d.Id

