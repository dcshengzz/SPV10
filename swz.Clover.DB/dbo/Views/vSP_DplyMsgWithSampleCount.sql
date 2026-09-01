

-------

CREATE VIEW [dbo].[vSP_DplyMsgWithSampleCount] AS 
	SELECT 
		m.Id, 
		m.NumberId, 
		m.DplyStep, 
		m.DplyId, 
		m.NotifyMerge, 
		NotifyEmail,  
		NotifyGenerate, 
		m.MsgContent, 
		m.EmailSubj, 
		m.EmailFrom,  
		m.GenerateQnnYN, 
		m.GenerateDateTime, 
		m.IsDeleted, 
		m.CreatedBy, 
		m.CreatedDate, 
		m.DeletedBy, 
		m.DeletedDate, 
		m.UpdatedBy, 
		m.UpdatedDate,
		m.MergeDone, 
		m.MergeOutputToken, 
		m.GenerateProfileDone, 
		m.GenerateProfileOutputToken, 
		ISNULL(s.SampleCount,0) as SampleCount, 
		u.Name as UserName, 
		m.JobId, 
		m.JobIsCanceled,
		m.ScheduledDate 
	FROM 
		QNN_DPLY_MSG m 
		INNER JOIN dwSecurityUser u ON u.Id=m.CreatedBy 
		LEFT JOIN (
			SELECT 
				s.DplyMsgId, 
				COUNT(*) AS SampleCount FROM QNN_DPLY_MSG_SAMPLE s
			GROUP BY 
				s.DplyMsgId 
		) s ON m.Id=s.DplyMsgId
