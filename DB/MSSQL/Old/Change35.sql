ALTER TABLE [dbo].[dwSecurityUser] ADD [GaSalt] varchar(256) NULL 
GO
-------------
update [dbo].[dwSecurityUser] 
set GaSalt = newid() where GaSalt is null
GO
-------------
INSERT INTO [dbo].[dwAppSettings] ([Name], [Value], [GroupName], [ParamName], [Order], [EditorType], [IsHidden]) 
VALUES (N'EnableGoogleAuthenticator', N'False', N'Security', N'Enable Google Authenticator', '0', N'checkbox', '0');
GO

