INSERT INTO [dbo].[dwAppSettings]
           ([Name]
           ,[Value]
           ,[GroupName]
           ,[ParamName]
           ,[Order]
           ,[EditorType]
           ,[IsHidden])
     VALUES
          ('IntranetDomainUrl',
           'localhost:28800',
           'Intranet Domain Url',
           'Intranet Domain URL',
           '5'
           ,'0'
           ,'0')
GO