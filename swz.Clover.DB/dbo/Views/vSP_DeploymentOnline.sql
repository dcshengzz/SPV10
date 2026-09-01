
------------------------------------------------------------------
-- for imputation feature
------------------------------------------------------------------
CREATE VIEW [dbo].[vSP_DeploymentOnline] AS 
select d.Id, d.Name, d.QnnId, d.StructDivisionId from QNN_DPLY d
inner join QNN_QNN q on d.QnnId = q.Id
where q.Type='O' and d.IsDeleted = 0 and q.IsDeleted = 0 and q.Status = 1 and d.Status = 1
AND d.IsMultipleResponse=0 AND d.IsAnonymous=0
