-- Removes the unused RespIp column from QNN_RESP
-- It is expected that none of the rows in QNN_RESP will have a value for this column,
-- this is checked and the script will fail if this expectation is wrong.

DECLARE @qnn_resp_object_id INT;
SELECT @qnn_resp_object_id=Object_ID(N'dbo.QNN_RESP');

DECLARE @respip_exists INT;
SELECT @respip_exists=1 FROM sys.columns WHERE Name='RespIp' AND Object_ID=@qnn_resp_object_id;

IF @respip_exists=1
BEGIN

	DECLARE @respip_count INT;
	SELECT @respip_count = COUNT(*) FROM QNN_RESP WHERE RespIp IS NOT NULL AND RespIp <> '';
	IF( @respip_count=0)
	BEGIN
		RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

		ALTER TABLE QNN_RESP DROP COLUMN [RespIp];	
	END
	ELSE
	BEGIN
		RAISERROR ('There are %i rows with unexpectedly populated RespIp', 0,0, @respip_count) WITH NOWAIT;

		SELECT Id,DplyId,RespIp FROM QNN_RESP WHERE RespIp IS NOT NULL AND RespIp <> '';

		RAISERROR ('The objects in QNN_RESP are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END
ELSE
BEGIN
	RAISERROR ('The target objects have already been updated, skipping modifications', 0,0) WITH NOWAIT;
END
