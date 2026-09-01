CREATE INDEX [IDX_DplyId] ON [dbo].[QNN_DPLY_SAMPLE_OWNER]
([DplyId] ASC) 
GO

CREATE INDEX [IDX_ListSampleId] ON [dbo].[QNN_DPLY_SAMPLE_OWNER]
([ListSampleId] ASC) 
GO

CREATE INDEX [IDX_UserId] ON [dbo].[QNN_DPLY_SAMPLE_OWNER]
([UserId] ASC) 
GO

CREATE INDEX [IDX_DplyId] ON [dbo].[QNN_DPLY_SAMPLE_INFO]
([DplyId] ASC) 
GO

CREATE INDEX [IDX_ListSampleId] ON [dbo].[QNN_DPLY_SAMPLE_INFO]
([ListSampleId] ASC) 
GO

CREATE INDEX [IDX_ListId] ON [dbo].[QNN_DPLY]
([ListId] ASC) 
GO

CREATE INDEX [IDX_QnnId] ON [dbo].[QNN_DPLY]
([QnnId] ASC) 
GO

CREATE INDEX [IDX_StructDivisionId] ON [dbo].[QNN_DPLY]
([StructDivisionId] ASC) 
GO

CREATE INDEX [IDX_StructDivisionId] ON [dbo].[QNN_LIST]
([StructDivisionId] ASC) 
GO

CREATE INDEX [IDX_StructDivisionId] ON [dbo].[QNN_QNN]
([StructDivisionId] ASC) 
GO

CREATE INDEX [IDX_QnnId] ON [dbo].[QNN_QNN_ENTITY]
([QnnId] ASC) 
GO

CREATE INDEX [IDX_QnnId] ON [dbo].[QNN_QNN_FIELD]
([QnnId] ASC) 
GO

CREATE INDEX [IDX_QnnId] ON [dbo].[QNN_QNN_FORM]
([QnnId] ASC) 
GO


CREATE INDEX [IDX_QnnId] ON [dbo].[QNN_RESP]
([QnnId] ASC) 
GO

CREATE INDEX [IDX_UserId] ON [dbo].[QNN_RESP]
([UserId] ASC) 
GO

CREATE INDEX [IDX_DplyId] ON [dbo].[QNN_RESP]
([DplyId] ASC) 
GO

CREATE INDEX [IDX_ListSampleId] ON [dbo].[QNN_RESP]
([ListSampleId] ASC) 
GO

CREATE INDEX [IDX_SampleId] ON [dbo].[QNN_SAMPLE_STRUCTDIVISION]
([SampleId] ASC) 
GO

CREATE INDEX [IDX_StructDivisionId] ON [dbo].[QNN_SAMPLE_STRUCTDIVISION]
([StructDivisionId] ASC) 
GO

CREATE INDEX [IDX_ListId] ON [dbo].[QNN_LIST_PROP]
([ListId] ASC) 
GO

CREATE INDEX [IDX_ListId] ON [dbo].[QNN_LIST_SAMPLE]
([ListId] ASC) 
GO

CREATE INDEX [IDX_SampleId] ON [dbo].[QNN_LIST_SAMPLE]
([SampleId] ASC) 
GO

CREATE INDEX [IDX_SamplePeerId] ON [dbo].[QNN_LIST_SAMPLE]
([SamplePeerId] ASC) 
GO

CREATE INDEX [IDX_ListSampleId] ON [dbo].[QNN_LIST_SAMPLE_PROP]
([ListSampleId] ASC) 
GO

CREATE INDEX [IDX_ListId] ON [dbo].[QNN_LIST_SAMPLE_PROP]
([ListId] ASC) 
GO

CREATE INDEX [IDX_ListPropId] ON [dbo].[QNN_LIST_SAMPLE_PROP]
([ListPropId] ASC) 
GO

CREATE INDEX [IDX_DplyId] ON [dbo].[QNN_DPLY_MSG]
([DplyId] ASC) 
GO

CREATE INDEX [IDX_DplyMsgId] ON [dbo].[QNN_DPLY_MSG_SAMPLE]
([DplyMsgId] ASC) 
GO

CREATE INDEX [IDX_ListSampleId] ON [dbo].[QNN_DPLY_MSG_SAMPLE]
([ListSampleId] ASC) 
GO

CREATE INDEX [IDX_ListSampleId] ON [dbo].[QNN_DPLY_SAMPLE_DUEDATE]
([ListSampleId] ASC) 
GO

CREATE INDEX [IDX_DplyId] ON [dbo].[QNN_DPLY_SAMPLE_DUEDATE]
([DplyId] ASC) 
GO
