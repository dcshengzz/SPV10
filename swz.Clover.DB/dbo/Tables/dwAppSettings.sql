CREATE TABLE [dbo].[dwAppSettings] (
    [Name]       NVARCHAR (50)   NOT NULL,
    [Value]      NVARCHAR (1000) NOT NULL,
    [GroupName]  NVARCHAR (50)   NULL,
    [ParamName]  NVARCHAR (1024) NOT NULL,
    [Order]      INT             NULL,
    [EditorType] NVARCHAR (50)   NULL,
    [IsHidden]   BIT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dwAppSettings] PRIMARY KEY CLUSTERED ([Name] ASC)
);

