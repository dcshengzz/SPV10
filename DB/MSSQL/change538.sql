-- Removes unwanted additional rows for spheader-code.js from dwMetadata
-- that may be present in some surveyplus databases

IF EXISTS(SELECT 1 FROM dwMetadata WHERE Id='BA5FEEFC-8802-41E7-A83F-8D451A3F1D1D')
BEGIN
	DECLARE @msg NVARCHAR(max);
	DECLARE @extracount INT;
	SELECT @extracount=COUNT(*) FROM dwMetadata WHERE FileName='spheader-code.js' AND Folder='metadata/forms' AND Id<>'BA5FEEFC-8802-41E7-A83F-8D451A3F1D1D';

	IF @extracount > 0
	BEGIN
		SET @msg = CONCAT('Found ', @extracount, ' unwanted extra row(s) for spheader-code.js and will delete');
		RAISERROR (@msg, 0,0) WITH NOWAIT;
		
		DELETE FROM dwMetadata WHERE FileName='spheader-code.js' AND Folder='metadata/forms' AND Id<>'BA5FEEFC-8802-41E7-A83F-8D451A3F1D1D';
	END
	ELSE
	BEGIN
		RAISERROR ('Additional rows for spheader-code.js were not found in this database. (This is OK - no action required)', 0,0) WITH NOWAIT;
	END
END
ELSE
BEGIN
	--basic check, this row was added in 532 and should be present
	RAISERROR ('ERROR - the expected row BA5FEEFC-8802-41E7-A83F-8D451A3F1D1D for spheader-code.js is missing', 16,0) WITH NOWAIT;
END