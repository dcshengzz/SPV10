
CREATE   PROCEDURE [dbo].[GetObjectPageUsage]
AS
BEGIN
    SET XACT_ABORT, NOCOUNT ON;

    SELECT
        o.object_id,
        i.index_id,
        s.name AS SchemaName,
        o.name AS TableName,
        CASE 
            WHEN i.index_id <= 1 THEN o.name 
            ELSE i.name 
        END AS Name,
        i.type_desc AS IndexType,
        CASE 
            WHEN i.index_id <= 1 THEN 'Table Data' 
            ELSE 'Index Structure' 
        END AS UsageCategory,
        au.type_desc AS AllocationType,
		au.total_pages AS TotalPages,
        au.used_pages AS UsedPages,
		(au.total_pages - au.used_pages) AS UnusedPages,        
		CAST(ROUND(au.total_pages * 8 / 1024., 0) AS INT) AS 'TotalMiB',
		CAST(ROUND(au.used_pages * 8 / 1024., 0) AS INT) AS 'UsedMiB',
		CAST(ROUND((au.total_pages - au.used_pages)/1024., 0) AS INT) AS 'UnusedMiB',
        p.rows AS PartitionRowCount
    FROM
        sys.all_objects o WITH (NOLOCK)
        INNER JOIN sys.schemas s WITH (NOLOCK) ON o.schema_id = s.schema_id
        INNER JOIN sys.indexes i WITH (NOLOCK) ON o.object_id = i.object_id
        INNER JOIN sys.partitions p WITH (NOLOCK) ON i.object_id = p.object_id AND i.index_id = p.index_id
        INNER JOIN sys.allocation_units au WITH (NOLOCK) ON p.partition_id = au.container_id
    WHERE 
        au.used_pages > 0
    ORDER BY 
        au.total_pages DESC;
END;