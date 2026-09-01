CREATE INDEX [IDX_Name] ON [dbo].[QNN_QNN_FIELD]
([Name] ASC) 
GO


CREATE UNIQUE INDEX [IDX_NumberId] ON [dbo].[QNN_RESP]
([NumberId] ASC) 
GO

CREATE INDEX [IDX_DateStart] ON [dbo].[QNN_RESP]
([DateStart] ASC) 
GO

CREATE INDEX [IDX_DateComplete] ON [dbo].[QNN_RESP]
([DateComplete] ASC) 
GO

CREATE INDEX [IDX_Name] ON [dbo].[QNN_SAMPLE]
([Name] ASC) 
GO

CREATE INDEX [IDX_Email] ON [dbo].[QNN_SAMPLE]
([Email] ASC) 
GO

CREATE INDEX [IDX_Name] ON [dbo].[dwSecurityUser]
([Name] ASC) 
GO

CREATE INDEX [IDX_Title] ON [dbo].[QNN_STATUS]
([Title] ASC) 
GO

DBCC DBREINDEX ('[dbo].[dwSecurityUser]', ' ', 70);  
GO  