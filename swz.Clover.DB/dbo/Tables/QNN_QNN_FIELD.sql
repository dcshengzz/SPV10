CREATE TABLE [dbo].[QNN_QNN_FIELD] (
    [Id]            UNIQUEIDENTIFIER NOT NULL,
    [NumberId]      INT              IDENTITY (1, 1) NOT NULL,
    [QnnId]         UNIQUEIDENTIFIER NOT NULL,
    [Name]          NVARCHAR (150)   NOT NULL,
    [Type]          NVARCHAR (50)    NULL,
    [Required]      BIT              CONSTRAINT [DF__QNN_QNN_F__Requi__7073AF84] DEFAULT ((0)) NOT NULL,
    [ReadOnly]      BIT              CONSTRAINT [DF__QNN_QNN_F__ReadO__7167D3BD] DEFAULT ((0)) NOT NULL,
    [ValidationExp] VARCHAR (MAX)    NULL,
    [ValidationErr] VARCHAR (MAX)    NULL,
    CONSTRAINT [PK_QNN_QNN_FIELD] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_QNN_FIELD_QnnId] FOREIGN KEY ([QnnId]) REFERENCES [dbo].[QNN_QNN] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IDX_Name]
    ON [dbo].[QNN_QNN_FIELD]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_NumberId]
    ON [dbo].[QNN_QNN_FIELD]([NumberId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_QnnId]
    ON [dbo].[QNN_QNN_FIELD]([QnnId] ASC);

