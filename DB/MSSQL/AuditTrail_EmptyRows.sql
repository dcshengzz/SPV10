--This script was extracted from oss_change184.sql, so is not necessary to run unless
--you have deleted these records

/* Insert a row of null record in tables which involved inner join with table AuditTrail 
   Workaround to replace left join as there are limitations 
   (eg. no subquery, union, left/right/outer join allowed)
   to create index view for Full-Text Index Purpose */

INSERT INTO dbo.dwSecurityUser (Id,Name,IsLocked,NumRetry) Values ('00000000-0000-0000-0000-000000000000','',0,0);

SET IDENTITY_INSERT dbo.QNN_SAMPLE ON
INSERT INTO dbo.QNN_SAMPLE (Id,NumberId,ActiveYN,UID,Name,PwdResetYN,NumRetry,IsDeleted) Values ('00000000-0000-0000-0000-000000000000',0,0,'','',0,0,1);
SET IDENTITY_INSERT dbo.QNN_SAMPLE OFF

INSERT INTO dbo.dwSecurityCredential (id,SecurityUserId,Login,AuthenticationType) values('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','',0)

INSERT INTO dbo.StructDivision (id,Name) values('00000000-0000-0000-0000-000000000000','')
