-- change560.sql 
-- This script adjusts the preconfigured AutoSave delay timeout 
-- n.b. Will not change the value if it was already customised away from the old default value

DECLARE @new_default_autosave_delay NVARCHAR(100) = '20';
DECLARE @old_default_autosave_delay NVARCHAR(100) = '3';
DECLARE @current_autosave_delay NVARCHAR(100);
SELECT @current_autosave_delay=[Value] FROM dwAppSettings WHERE [Name]='AutosaveDelay';

IF @current_autosave_delay IS NULL
BEGIN
	RAISERROR ('ERROR: Failed to find AutosaveDelay setting in dwAppSettings!',16, 1); --not ok
	--this setting should have been added when 557 was run
END
ELSE IF @current_autosave_delay=@new_default_autosave_delay
BEGIN
	RAISERROR ('AutosaveDelay already set to the new default value (nothing further to change)', 0,0) WITH NOWAIT; --ok
END
ELSE IF @current_autosave_delay<>@old_default_autosave_delay AND @current_autosave_delay<>@new_default_autosave_delay
BEGIN
	RAISERROR ('AutosaveDelay is using a customised value (and will not be changed)', 0,0) WITH NOWAIT; --ok
END
ELSE IF @current_autosave_delay=@old_default_autosave_delay
BEGIN
	RAISERROR ('Changing AutosaveDelay from old default value to new default value', 0,0) WITH NOWAIT; --ok (usual case)
	UPDATE dwAppSettings SET [Value]=@new_default_autosave_delay WHERE [Name]='AutosaveDelay';
END
