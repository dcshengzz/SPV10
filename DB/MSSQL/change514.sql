-- This script will resize the IpAddress column of QNN_RESP to VARCHAR(45)
-- It will fail if this would involve truncating data (this is not expected)

DECLARE @invalid_ipaddress_count INT;
SELECT @invalid_ipaddress_count=COUNT(*) FROM QNN_RESP WHERE IpAddress IS NOT NULL AND LEN(IpAddress) > 45;

DECLARE @ipaddress_length INT;
SELECT @ipaddress_length=COL_LENGTH('dbo.QNN_RESP', 'IpAddress');


DECLARE @new_ipaddress BIT;
SELECT @new_ipaddress=CASE WHEN @ipaddress_length=45 THEN 1 ELSE 0 END; --varchar(45)

DECLARE @old_ipaddress BIT;
SELECT @old_ipaddress=CASE WHEN @ipaddress_length=4112 THEN 1 ELSE 0 END; --nvarchar(2056)

IF( @invalid_ipaddress_count=0 AND @new_ipaddress=0 AND @old_ipaddress=1)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	--The following will fail if any index references the column (but if this script
	--reaches this line we don't expect this that be the case based on db schema at time of writing)
	ALTER TABLE QNN_RESP ALTER COLUMN IpAddress VARCHAR(45) NULL;
	
END
ELSE
BEGIN
	IF(@invalid_ipaddress_count=0 AND @new_ipaddress=1 AND @ipaddress_length=45)
	BEGIN
		RAISERROR ('The target objects have already been updated, skipping modifications', 0,0) WITH NOWAIT;
	END
	ELSE
	BEGIN
		--Unexpected situation, requires dba to check and decide how to proceed.
		--Get some diagnostic info. Go see the results window for this.
		
		SELECT 
			@invalid_ipaddress_count AS invalid_ipaddress_count,
			@new_ipaddress AS new_ipaddress,
			@old_ipaddress AS old_ipaddress,
			@ipaddress_length AS ipaddress_length
		;

		--The below situation is unexpected, although column length was 2056, it only stores IP a single ip address now
		IF(@invalid_ipaddress_count > 0)
		BEGIN
			RAISERROR ('There are %i rows with invalid IpAddress values', 0,0, @invalid_ipaddress_count) WITH NOWAIT;
			SELECT 
				r.Id AS RespId,				
				r.NumberId, 
				--r.DplyId,
				d.[Name] AS DplyName,
				--r.ListSampleId,
				s.[UID] AS [UID],
				r.UpdatedDate,
				LEN(r.IpAddress) AS IpAddress_Length,
				r.IpAddress AS Invalid_IpAddress
			FROM 
				QNN_RESP r
				LEFT JOIN QNN_LIST_SAMPLE ls ON ls.Id=r.ListSampleId
				LEFT JOIN QNN_SAMPLE s ON s.Id=ls.SampleId
				LEFT JOIN QNN_DPLY d ON d.Id=r.DplyId
			WHERE 
				r.IpAddress IS NOT NULL AND LEN(r.IpAddress) > 45
			ORDER BY
				r.NumberId ASC;
			;
		END

		RAISERROR ('The objects in QNN_RESP are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END
GO