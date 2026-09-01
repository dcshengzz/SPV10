CREATE TYPE [dbo].[RespAnsUpdate] AS TABLE (
    [Id]                UNIQUEIDENTIFIER NULL,
    [NewAnsVal]         NVARCHAR (MAX)   NULL,
    [NewIsPrePopulated] BIT              NULL);

