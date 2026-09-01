/****** Script for Update 'Imputation' to 'PrePopulate' for dwSecurityRole ******/
Update [dbo].[dwSecurityRole] 
Set Code = 'PrePopulate', Name = 'Pre-Populate'
where Id = 'B039A7E1-2686-A8AB-CF83-C7C4FC2E500F';

/****** Script for Update 'Imputation' to 'PrePopulate' for dwSecurityPermissionGroup  ******/
UPDATE [dbo].[dwSecurityPermissionGroup] 
SET Code = 'PrePopulate', Name = 'Pre-Populate'
where id = '9EA7A693-DC18-E324-67C9-C28A37F30D86'
