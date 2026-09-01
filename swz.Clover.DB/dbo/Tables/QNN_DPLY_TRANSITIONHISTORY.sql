CREATE TABLE [dbo].[QNN_DPLY_TRANSITIONHISTORY] (
    [Id]                     UNIQUEIDENTIFIER NOT NULL,
    [DplyId]                 UNIQUEIDENTIFIER NOT NULL,
    [UserId]                 UNIQUEIDENTIFIER NULL,
    [AllowedToEmployeeNames] NVARCHAR (MAX)   NULL,
    [TransitionTime]         DATETIME         NULL,
    [Order]                  BIGINT           IDENTITY (1, 1) NOT NULL,
    [InitialState]           NVARCHAR (1024)  NOT NULL,
    [DestinationState]       NVARCHAR (1024)  NOT NULL,
    [Command]                NVARCHAR (1024)  NOT NULL,
    CONSTRAINT [PK_QNN_DPLY_TRANSITIONHISTORY] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_DPLY_TRANSITIONHISTORY_dwSecurityUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[dwSecurityUser] ([Id]),
    CONSTRAINT [FK_QNN_DPLY_TRANSITIONHISTORY_QNN_DPLY] FOREIGN KEY ([DplyId]) REFERENCES [dbo].[QNN_DPLY] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

