-- Change the CreatedBy and UpdatedBy columns in dwUploadedFiles to NVARCHAR(320) (instead of NCHAR(1024))
-- Drop the unused DeletedBy and DeletedDate columns (IsDeleted will be retained for now)

DECLARE @dwUploadedFiles_object_id INT;
SELECT @dwUploadedFiles_object_id = object_id FROM sys.objects WHERE name='dwUploadedFiles';

DECLARE @new_createdby_column_size BIT;
SELECT @new_createdby_column_size = CASE WHEN max_length = 640 THEN 1 ELSE 0 END 
	FROM sys.columns WHERE object_id = @dwUploadedFiles_object_id AND name='CreatedBy';

DECLARE @new_updatedby_column_size BIT;
SELECT @new_updatedby_column_size = CASE WHEN max_length = 640 THEN 1 ELSE 0 END
	FROM sys.columns WHERE object_id = @dwUploadedFiles_object_id AND name='UpdatedBy';

DECLARE @old_deletedby BIT;
SELECT @old_deletedby=1 
	FROM sys.columns WHERE object_id = @dwUploadedFiles_object_id AND name='DeletedBy';

IF(@new_createdby_column_size=0 AND @new_updatedby_column_size=0 AND @old_deletedby=1)
BEGIN
	
	DECLARE @invalid_rowcount INT;
	SELECT @invalid_rowcount=COUNT(*) 
		FROM dwUploadedFiles WHERE LEN(TRIM(CreatedBy))>320 OR LEN(TRIM(UpdatedBy))>320; --ignores DeletedBy

	IF(@invalid_rowcount = 0)
	BEGIN
		RAISERROR ('Expected pre-script objects found in dwUploadedFiles and existing data ok, proceeding with modifications', 0,0) WITH NOWAIT;
		
		ALTER TABLE dwUploadedFiles ALTER COLUMN CreatedBy NVARCHAR(320);
		ALTER TABLE dwUploadedFiles ALTER COLUMN UpdatedBy NVARCHAR(320);
		ALTER TABLE dwUploadedFiles DROP COLUMN DeletedBy;
		ALTER TABLE dwUploadedFiles DROP COLUMN DeletedDate;
	END
	ELSE
	BEGIN
		SELECT
			@invalid_rowcount AS invalid_rowcount
		;

		SELECT 
			[Id], 
			[Name], 
			[CreatedBy],
			[CreatedDate],
			[UpdatedBy],
			[UpdatedDate]
		FROM 
			dwUploadedFiles 
		WHERE
			LEN(TRIM(CreatedBy))>320 OR LEN(TRIM(UpdatedBy))>320	
		ORDER BY 
			[CreatedDate] ASC,
			[UpdatedDate] ASC
		;

		RAISERROR ('There are rows with invalid data in dwUploadedFile (CreatedBy or UpdatedBy values that are too long or non-null DeletedBy/DeletedDate value). Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END
ELSE
BEGIN
	IF(@new_createdby_column_size=1 AND @new_updatedby_column_size=1)
	BEGIN
		RAISERROR ('The target objects have already been updated, skipping modifications', 0,0) WITH NOWAIT;
	END
	ELSE
	--The table wasn't as we expected it to be and its not because the changes were already made 
	--so we don't know how to handle it and must fail (we don't expect to see this condition)
	BEGIN
		--Unexpected situation, requires dba to check and decide how to proceed.
		--Get some diagnostic info. Go see the results window for this.		
		SELECT 
			@new_createdby_column_size AS new_createdby_column_size,
			@new_updatedby_column_size AS new_updatedby_column_size,
			@old_deletedby AS old_deletedby
		;

		SELECT
			[name], user_type_id, max_length
		FROM 
			sys.columns
		WHERE
			object_id = @dwUploadedFiles_object_id
			AND [name] IN ('CreatedBy','CreatedDate','UpdatedBy','UpdatedDate','DeletedBy','DeletedDate')
		;

		RAISERROR ('The objects in dwUploadedFiles are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END