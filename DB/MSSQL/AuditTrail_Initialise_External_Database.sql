-- AuditTrail_Initialise_External_Database.sql
-- Last updated 2023-04-14

-- Script to create database objects for SurveyPlus Audit Log
-- To run in the EXTERNAL DATABASE to create the following objects:
--   Tables: AuditLog, AuditSampleName, AuditUserName, AuditDivisionName
--   Views: vSP_AuditLog
--   Indexes: idx_FullTextIndex
--   Full Text Catalogs: fulltextCatalog
--   Full Text Index (with key index idx_FullTextIndex) 

-- After executing this script in the external database, manually drop and recreate the following in the SURVEYPLUS DATABASE:
--   Synonyms: sy_AuditLog, sySP_vSP_AuditLog, sy_AuditSampleName, sy_AuditUserName, sy_AuditDivisionName

-- Please note that due to constraints in SQL Server 2022 and below, 
-- the external database must be on the same server as the SurveyPlus database. 
-- (For later versions please check relevant documentation).

-- Please remember to set the appropriate users and rights on the audit database (this script does not do this)

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AuditLog](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[SampleId] [uniqueidentifier] NULL,
	[EventBatch] [uniqueidentifier] NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[EventType] [nvarchar](20) NOT NULL,
	[TableName] [nvarchar](100) NULL,
	[RecordId] [uniqueidentifier] NULL,
	[ColumnName] [nvarchar](100) NULL,
	[OriginalValue] [nvarchar](max) NULL,
	[NewValue] [nvarchar](max) NULL,
	[StructDivisionId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_AuditLog] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[AuditSampleName](
	[SampleId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[UID] [nvarchar](320) NOT NULL,
 CONSTRAINT [PK_AuditSampleName] PRIMARY KEY CLUSTERED 
(
	[SampleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AuditUserName](
	[UserId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_AuditUserName] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AuditDivisionName](
	[StructDivisionId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_AuditDivisionName] PRIMARY KEY CLUSTERED 
(
	[StructDivisionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE VIEW [dbo].[vSP_Auditlog] WITH SCHEMABINDING
AS 
	--WARNING: If you alter this view you will need to recreate the indexes on it
	SELECT 
		al.Id, 
		al.UserId, 
		al.SampleId, 
		al.EventBatch,
		al.EventDate,
		al.EventType,
		al.TableName,
		al.RecordId,
		al.ColumnName, 
		al.OriginalValue,
		al.NewValue,
		al.StructDivisionId,
		NULLIF(asn.UID,'') AS [UID],
		NULLIF(asn.Name,'') AS [SampleName],
		NULLIF(aun.Name,'') AS [UserName],
		NULLIF(adn.Name,'') AS [Division]
	FROM
		dbo.AuditLog al
		INNER JOIN dbo.AuditUserName aun ON ISNULL(al.UserId,'00000000-0000-0000-0000-000000000000') = aun.UserId
		INNER JOIN dbo.AuditSampleName asn ON ISNULL(al.SampleId,'00000000-0000-0000-0000-000000000000') = asn.SampleId
		INNER JOIN dbo.AuditDivisionName adn ON ISNULL(al.StructDivisionId,'00000000-0000-0000-0000-000000000000') = adn.StructDivisionId;
GO

CREATE FULLTEXT CATALOG [fulltextCatalog] WITH ACCENT_SENSITIVITY = ON
AS DEFAULT
GO

CREATE UNIQUE CLUSTERED INDEX [idx_FullTextIndex]
    ON [dbo].[vSP_auditlog]([Id] ASC);
GO

CREATE FULLTEXT INDEX ON [dbo].[vSP_auditlog]
    ([OriginalValue] LANGUAGE 1033, [NewValue] LANGUAGE 1033)
    KEY INDEX [idx_FullTextIndex]
    ON [fulltextCatalog];
GO

		

