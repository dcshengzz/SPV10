
CREATE   VIEW [dbo].[vSP_DplySampleDueDate] AS 

 select si.DplyId, si.ListSampleId, sd.DueDate 
 from QNN_DPLY_SAMPLE_INFO as si
 cross apply 
     (select top 1 DplyId, ListSampleId, DueDate
      from QNN_DPLY_SAMPLE_DUEDATE 
      where DplyId = si.DplyId and ListSampleId = si.ListSampleId
      order by NumberId desc) as sd
