-- Removes unwanted additional rows for Organizations-code.js from dwMetadata
-- that may be present in some surveyplus databases
IF EXISTS(SELECT 1 FROM dwMetadata WHERE Id='2CC2C415-7586-4BAD-A1DB-81D6DA8A2C3D')
BEGIN
	DECLARE @msg NVARCHAR(max);
	DECLARE @extracount INT;
	SELECT @extracount=COUNT(*) FROM dwMetadata WHERE FileName='Organizations-code.js' AND Folder='metadata/forms' AND Id<>'2CC2C415-7586-4BAD-A1DB-81D6DA8A2C3D';

	IF @extracount > 0
	BEGIN
		SET @msg = CONCAT('Found ', @extracount, ' unwanted extra row(s) for Organizations-code.js and will delete');
		RAISERROR (@msg, 0,0) WITH NOWAIT;
		
		DELETE FROM dwMetadata WHERE FileName='Organizations-code.js' AND Folder='metadata/forms' AND Id<>'2CC2C415-7586-4BAD-A1DB-81D6DA8A2C3D';
	END
	ELSE
	BEGIN
		RAISERROR ('Additional rows for Organizations-code.js were not found in this database. (This is OK - no action required)', 0,0) WITH NOWAIT;
	END
END
ELSE
BEGIN
	--basic check, this row was added in 532 and should be present
	RAISERROR ('ERROR - the expected row 2CC2C415-7586-4BAD-A1DB-81D6DA8A2C3D for Organizations-code.js is missing', 16,0) WITH NOWAIT;
END