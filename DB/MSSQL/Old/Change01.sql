CREATE VIEW [dbo].[vSP_ListPropCount] AS 
select l.Id, count(*) as PropCount, STUFF((SELECT ',' + UPPER(Alias) 
		                    from qnn_list_prop where ListId = l.Id
		                    group by Alias, NumberId
		                    order by NumberId
		            FOR XML PATH(''), TYPE
		            ).value('.', 'NVARCHAR(MAX)') 
		        ,1,1,'') as Fields, STUFF((SELECT ',' + UPPER(Id) 
		                    from qnn_list_prop where ListId = l.Id
		                    group by Id, NumberId
		                    order by NumberId
		            FOR XML PATH(''), TYPE
		            ).value('.', 'NVARCHAR(MAX)') 
		        ,1,1,'') as FieldsId from QNN_LIST_PROP p
left join QNN_LIST l on l.Id = p.ListId
group by l.Id
GO

INSERT INTO [dbo].[dwAppSettings] ([Name], [Value], [GroupName], [ParamName], [Order], [EditorType], [IsHidden]) VALUES (N'TrkListActiveYN', N'False', N'TrackList', N'Is Track List Active', '0', N'0', '0');
GO

ALTER TABLE [dbo].[QNN_SAMPLE] ADD CONSTRAINT [Unique_UID] UNIQUE ([UID])
GO

CREATE UNIQUE INDEX [IDX_UID] ON [dbo].[QNN_SAMPLE]
([UID] ASC) 
GO



CREATE FUNCTION dbo.splitIds
(
   @List      VARCHAR(MAX),
   @Delimiter VARCHAR(255)
)
RETURNS TABLE
AS
  RETURN ( SELECT Item  FROM
      ( SELECT Item = x.i.value('(./text())[1]', 'varchar(max)')
        FROM ( SELECT [XML] = CONVERT(XML, '<i>'
        + REPLACE(@List, @Delimiter, '</i><i>') + '</i>').query('.')
          ) AS a CROSS APPLY [XML].nodes('i') AS x(i) ) AS y
      WHERE Item IS NOT NULL
  );

GO

create PROCEDURE [dbo].[spSP_DeleteSampleProp]
		@ListId uniqueidentifier,
		@ListSampleIds NVARCHAR(MAX)

	AS
	BEGIN
		SET NOCOUNT ON;
		delete from QNN_LIST_SAMPLE_PROP where ListId = @ListId and ListSampleId IN( SELECT Item FROM dbo.splitIds(@ListSampleIds, ',')); 
	END

GO