CREATE VIEW [dbo].[vSP_DeploymentOwner] AS 
select d.Id as DplyId, o.UserId from QNN_DPLY_SAMPLE_OWNER o
inner join QNN_DPLY d on o.DplyId=d.Id
group by d.Id, o.UserId
