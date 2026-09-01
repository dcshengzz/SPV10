

-----------------------------
CREATE VIEW [dbo].[vSP_GlobalMsgUser] AS 
select s.Name, s.Email, ms.EmailSentDate, ms.Id, ms.GlobalMsgId from QNN_GLOBAL_MSG_User ms
inner join dwSecurityUser s on ms.UserId = s.Id