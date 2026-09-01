
ALTER TABLE [dbo].[dwSecurityUser] ADD [IpAddress] nvarchar(30) NULL 
GO
ALTER TABLE [dbo].[dwSecurityUser] ADD [BrowserType] nvarchar(1024) NULL 
GO
ALTER TABLE [dbo].[dwSecurityUser] ADD [NumRetry] int NULL 
GO

UPDATE [dbo].[dwSecurityUser]
	SET [NumRetry] = '0';

ALTER TABLE [dbo].[dwSecurityUser] ALTER COLUMN [NumRetry] int NOT NULL 
GO

ALTER TABLE [dbo].[dwSecurityUser] ADD [LastLoginDate] datetime NULL 
GO

UPDATE [dbo].[dwAppSettings]
	SET [Name] = 'ResetPwdTimeSpan'
	WHERE Name = 'ResetPwdTimeSpanA'

INSERT INTO [dbo].[dwAppSettings]
           ([Name]
           ,[Value]
           ,[GroupName]
           ,[ParamName]
           ,[Order]
           ,[EditorType]
           ,[IsHidden])
     VALUES
           ('HostEmails'
           ,''
           ,'Security'
           ,'Administrator Emails i.e(admin@emailhost.com, admin2@emailhost.com)'
           ,'0'
           ,'0'
           ,'0')

		   INSERT INTO [dbo].[dwAppSettings]
           ([Name]
           ,[Value]
           ,[GroupName]
           ,[ParamName]
           ,[Order]
           ,[EditorType]
           ,[IsHidden])
     VALUES
           ('FailedPwdMaxAttempt'
           ,'10'
           ,'Security'
           ,'Failed Password Maximum Attempt'
           ,'0'
           ,'0'
           ,'0')