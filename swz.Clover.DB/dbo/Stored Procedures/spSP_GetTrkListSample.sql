
------------------------------
-- fix when trklistsample record has no status set, record is not selected   
	CREATE PROCEDURE [dbo].[spSP_GetTrkListSample]
		@TrkListId uniqueidentifier
	AS
	BEGIN

		select UID, NAME, EMAIL, REMARKS, s.Code as STATUSCODE, s.Title as STATUS from QNN_TRK_LIST_SAMPLE tls
		left join QNN_STATUS s on s.Id = tls.Status where TrkListId = @TrkListId ORDER BY UID ASC

	END
