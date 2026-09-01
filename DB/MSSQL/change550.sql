-- These scripts will be used to remove the Full-Text Index feature for keyword search.
-- The database file size will not be reduced, but the space will be deallocated and made available for use by other objects.

-- Drop the full-text index
IF EXISTS (SELECT * FROM sys.fulltext_indexes WHERE object_id = OBJECT_ID('[dbo].[vSP_auditlog]'))
BEGIN
    DROP FULLTEXT INDEX ON [dbo].[vSP_auditlog];
    PRINT 'Full-text index dropped.';
END

-- Drop the full-text catalog
IF EXISTS (SELECT * FROM sys.fulltext_catalogs WHERE name = 'fulltextCatalog')
BEGIN
    DROP FULLTEXT CATALOG [fulltextCatalog];
    PRINT 'Full-text catalog dropped.';
END

-- Drop the unique clustered index
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_FullTextIndex' AND object_id = OBJECT_ID('[dbo].[vSP_auditlog]'))
BEGIN
    DROP INDEX [idx_FullTextIndex] ON [dbo].[vSP_auditlog];
    PRINT 'Unique clustered index dropped.';
END


