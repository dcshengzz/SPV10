




-------

CREATE VIEW [dbo].[vSP_GlobalMsgWithSampleCount] AS 
	select 
		m.Id,
		m.NumberId, 
		m.MsgContent, 
		m.EmailSubj, 
		m.EmailFrom, 
		m.StructDivisionId, 
		m.CreatedBy, 
		m.CreatedDate, 
		m.UpdatedBy, 
		m.UpdatedDate, 
		m.IsTargetUsers,
		ISNULL(s.SampleCount,0) + ISNULL(gu.SampleCount,0)  as SampleCount,
		ISNULL(sc.EmailsSent,0) as EmailsSent,
		u.Name as UserName,
		m.JobId, m.JobIsCanceled,
		m.ScheduledDate 
	from 
		QNN_GLOBAL_MSG m 
		inner join dwSecurityUser u on u.Id = m.CreatedBy 
		left join (
			select s.GlobalMsgId, count(*) as SampleCount from QNN_GLOBAL_MSG_SAMPLE s
			group by s.GlobalMsgId ) s on m.Id = s.GlobalMsgId
		left join (
			select s.GlobalMsgId, count(*) as EmailsSent from QNN_GLOBAL_MSG_SAMPLE s
			where s.EmailSentDate is not null
			group by s.GlobalMsgId ) sc on m.Id = sc.GlobalMsgId
		left join (
			select gu.GlobalMsgId, count(*) as SampleCount from QNN_GLOBAL_MSG_USER gu
			group by gu.GlobalMsgId )  gu on m.Id = gu.GlobalMsgId