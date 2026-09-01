CREATE TABLE [dbo].[QNN_HELP] (
    [Id]          UNIQUEIDENTIFIER NOT NULL,
    [NumberId]    INT              IDENTITY (1, 1) NOT NULL,
    [Type]        NVARCHAR (50)    NOT NULL,
    [Topic]       NVARCHAR (200)   NOT NULL,
    [Heading]     NVARCHAR (200)   NULL,
    [Content]     NVARCHAR (MAX)   NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedDate] DATETIME         NULL,
    [Status]      BIT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_QNN_HELP] PRIMARY KEY CLUSTERED ([Id] ASC)
);



