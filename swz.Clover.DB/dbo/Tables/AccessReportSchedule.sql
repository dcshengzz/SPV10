CREATE TABLE [dbo].[AccessReportSchedule] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [ScheduleType]     NVARCHAR (50)    NULL,
    [IsEnabled]        BIT              NULL,
    [Email]            NVARCHAR (1000)  NULL,
    [CreatedBy]        UNIQUEIDENTIFIER NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedDate]      DATETIME         NULL,
    [StructDivisionId] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_AccessReportSchedule] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_AccessReportSchedule_StructDivisionId] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id])
);

