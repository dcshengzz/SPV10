-- Feature: Deployment to add a Visible toggle to allow back office user to decide survey visibility on the respondent’s dashboard
-- Implement guide:
-- To do database sync to update model QNN_DPLY, vSP_ListSampleInfo
-- To do Mapping data model for QNN_DPLY form for VisibleToRespondent field
-- restart site or visit: http://localhost:28800/resp/resetappcache to clear cache


------------------------------------------------
-- Add a Visible toggle to allow back office user to decide survey visibility on the respondent’s dashboard
ALTER TABLE [dbo].[QNN_DPLY] ADD [VisibleToRespondent] bit NULL DEFAULT 1 
GO

-- ---------------------------
-- Add d.VisibleToRespondent to the respondent dashboard
ALTER VIEW [dbo].[vSP_ListSampleInfo] AS 
select lsi.Id, lsi.NumberId, lsi.DplyId, lsi.ListSampleId, lsi.Remarks, lsi.StatusModifyBy, lsi.StatusModifyOn, lsi.RemarksModifyBy, lsi.RemarksModifyOn, lsi.DispatchInd, lsi.ReturnInd, lsi.ProcessValidInd, lsi.ProcessEditInd, lsi.Status, lsi.PdfPassword, lsi.CreatedBy, lsi.CreatedDate, s.UID, s.Id as SampleId, 
Concat(s.UID, ' (', s.Name, ')') as UIDName, 

CASE
	WHEN s1.UID is null THEN null   
	WHEN s1.UID is not null THEN Concat(s1.UID, ' (', s1.Name, ')')
END 
as PeerName,

qs.Title as StatusTitle,
s1.UID as UIDPeer, d.CreatedDate as DplyCreatedDate, d.Name as DplyName, 
d.DateStart as DplyDateStart, d.DateEnd as DplyDateEnd, d.QnnId, d.IsDeleted as DplyIsDeleted, d.Status as DplyStatus, d.CompleteAction, d.CompleteURL, d.DaysUpdate, d.MaxResponse, d.VisibleToRespondent,

CASE
when due.DueDate is null then d.DateEnd
when due.DueDate > d.DateEnd then due.DueDate
else d.DateEnd
END 
as DueDate, 

q.Title as QnnTitle, q.IsDeleted as QnnIsDeleted, q.Status as QnnStatus, q.Type as QnnType,
--f.Name as FormName,  
CASE
	WHEN q.Type='P' THEN 'Offline'   
	WHEN q.Type='O' THEN 'Online'   
END 
as Type,

ls.ListId,

SUBSTRING(
        (
            SELECT '||'+qqf.Name  AS [text()]
            FROM QNN_QNN_FORM qqf
            WHERE qqf.QnnId = q.Id
            ORDER BY qqf.Name
            FOR XML PATH ('')
        ), 3, 1000) [FormNames], 

SUBSTRING(
		(
				SELECT '||'+qqf.[Language]  AS [text()]
				FROM QNN_QNN_FORM qqf
				WHERE qqf.QnnId = q.Id
				ORDER BY qqf.Name
				FOR XML PATH ('')
		), 3, 1000) [Languages],

SUBSTRING(
        (
            SELECT '||'+qqe.Token  AS [text()]
            FROM QNN_QNN_ENTITY qqe
            WHERE qqe.QnnId = q.Id
            ORDER BY qqe.[Language]
            FOR XML PATH ('')
        ), 3, 1000) [Tokens], 

SUBSTRING(
		(
				SELECT '||'+qqe.[Language]  AS [text()]
				FROM QNN_QNN_ENTITY qqe
				WHERE qqe.QnnId = q.Id
				ORDER BY qqe.[Language]
				FOR XML PATH ('')
		), 3, 1000) [OfflineLanguages],

r.Id as RespId, r.DateStart as RespDateStart, d.StructDivisionId,
r.DateComplete as RespDateEnd from QNN_DPLY_SAMPLE_INFO lsi
left join QNN_LIST_SAMPLE ls on lsi.ListSampleId = ls.Id
left join QNN_SAMPLE s on ls.SampleId = s.Id
left join QNN_SAMPLE s1 on ls.SamplePeerId = s1.Id
inner join QNN_DPLY d on lsi.DplyId = d.Id
left join QNN_RESP r on lsi.DplyId = r.DplyId and lsi.ListSampleId = r.ListSampleId and r.QnnId = d.QnnId
left join QNN_QNN q on d.QnnId = q.Id
--left join QNN_QNN_FORM f on f.QnnId = q.Id
left join vSP_DplySampleDueDate due on lsi.DplyId = due.DplyId and lsi.ListSampleId = due.ListSampleId
left join QNN_STATUS qs on qs.Id = lsi.Status
where d.IsDeleted = 0 and d.Status = 1
GO

GO
----------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='50A76E5A-98F3-44BF-A161-003ED4FB2F3B', [Folder]=N'metadata/forms', [Filename]=N'respdashboard-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:23.807', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-18 21:36:47.610', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "respdashboard",
  "lastUpdate": "2020-02-18T21:36:47.2507287+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "4bd157e1-c49b-2d89-8c57-4b287783e77e",
      "entityId": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{UID:\"@UID\", DplyDateStart: \"<=@NOW\",  DueDate: \">=@NOW\", VisibleToRespondent:1}",
      "control": "grid",
      "dataMap": [
        {
          "id": "454e62cb-4c60-a55b-3c61-50b3d43d2725",
          "attributeId": "fb1995a9-d5b0-41b0-8bba-de1f198a2ade",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "6ce5a33d-de0b-6fa5-2a73-e7f28feb1560",
          "attributeId": "9708f58f-4391-4f2d-8ce5-3e3f705e0567",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d15fc186-629a-2acc-a830-ee9a8594881a",
          "attributeId": "05aca3b9-1ff1-4224-af56-e1e7b40d2ea7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "6a4fc504-11d7-40e2-de1d-e155857238fa",
          "attributeId": "4a05dc25-64a0-4bc1-ab63-cd8eb47388cc",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "48cd6633-16d5-693b-d1e9-38619778b8c7",
          "attributeId": "ba2edc74-4779-4dfa-b077-6171c7e5728a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "2640e04e-3a93-b6eb-4c27-67f5488a4725",
          "attributeId": "fed57935-d235-4978-8e32-740704d0a4e6",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "c87f7afc-7d0a-9166-4a16-c5f0056a01b3",
          "attributeId": "0cbfca89-19a5-42af-85e5-a2924c73965b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3ddb3069-b1aa-9af9-b63a-08cc83444e97",
          "attributeId": "0406153b-14c8-40fa-9c0f-8da423c1bf9c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "0b9ddc75-ab77-1cd3-8c24-ff4020c5c6cf",
          "attributeId": "87142dff-3c44-4b2e-adf3-dbe6902929e3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b695360b-170d-0003-7655-a03c133d0d69",
          "attributeId": "eaf65e44-d8b3-41e2-8ea3-7fa371c24df7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b70d2ceb-7efc-f705-2103-a8cd4b027ad7",
          "attributeId": "3742bb4c-1d36-43e9-91ca-7c9b06a7a387",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b25bf63f-3aa3-947e-a366-60ed417368e6",
          "attributeId": "25fb86e0-cd5c-4827-bb81-b95c606c76a2",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1fb41fc3-99b8-baa9-2ab8-8d67212e117c",
          "attributeId": "1778d9cd-e976-41a5-94d0-f58118650e78",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "166d8893-94dc-72e9-a1e7-927432ff6095",
          "attributeId": "934eb22d-26ab-46df-affb-34b9ca4279bd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "52de3d14-4004-7236-252b-a90e81ca5d1c",
          "attributeId": "da266418-6f9d-49c6-8cd0-b848b7b1865d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6dd359e5-703b-07c8-d61a-758af5c6cddd",
          "attributeId": "fae8d036-d2f9-4122-9788-5a836fde5f14",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1429d6af-6a93-896c-930f-4b4e68ee46cc",
          "attributeId": "d8c56aaa-a66c-4c11-885b-63b48132a4ae",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fe34d3ff-8435-d641-9a4d-3a4a493469f0",
          "attributeId": "b78e3a71-0a01-4252-9f6d-dedcd79b7a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c7d3e8eb-ab49-2ea1-ff02-3508942aa274",
          "attributeId": "79e48f5b-600c-4e8f-93e2-3cba618395df",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "cda93e23-ef31-178c-fe13-1acfe2f13abc",
          "attributeId": "628f5950-57f7-4bff-a55e-387c81d3e3ca",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "350f4d65-b4f7-3399-b5f0-74285092d8ea",
          "attributeId": "bce4dc52-69b3-4f24-8085-76201ed4b669",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e5c010e2-6b18-bc44-8f31-1463f11adfdf",
          "attributeId": "1a3f9d0d-db31-4d8c-a2d8-2667ff9fd2a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d5c20cf5-5b7e-22b1-2d30-670d51f98e75",
          "attributeId": "26c17cdf-0e95-42bb-945a-9cc3fea7d591",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "2d8b1a88-e791-c100-4547-3cdcb5e39f73",
          "attributeId": "64ec9ca0-1500-4533-8754-59ebff95a686",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "97c8cffa-7362-dccb-add9-7f40de930110",
          "attributeId": "dda35caf-327b-47f8-91ee-106063c882d4",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "c0af7095-c797-7f66-bec6-c5d689cfb543",
          "attributeId": "c7c38d0a-36b8-4de5-ae08-96b66d3b9181",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "489c77d0-eb04-1e9e-0a6e-456ec72df9c3",
          "attributeId": "118adb3e-82fd-4fca-aa90-6d282910ed7c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "00077ebb-bded-bb8e-d44b-669a23477275",
          "attributeId": "394be317-66d0-4ab6-81d7-98d2f10beb29",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "c855aeae-a535-f017-8bf0-39175617ed66",
          "attributeId": "74097b74-c031-4848-af9c-c3e58c34e232",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "7fa244ea-df21-66c5-cf68-e766e0dbe68d",
          "attributeId": "91423d5e-f275-4f21-ab84-7a9d5d46db97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0832bf04-ae05-c266-3311-b2e113c2b6a6",
          "attributeId": "94071c82-1934-4dcd-aeb4-d43a67baf751",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "31be93c9-43ae-b0c6-f1d2-29686904a7c2",
          "attributeId": "762c021b-e51e-41d9-b041-050e239514a6",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "44b7f792-2947-b29b-b723-6d6f4cced258",
          "attributeId": "a1df9b41-0552-444b-afc4-853c61a4df92",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "fe62eb57-40e5-1a54-4bb4-71bc50cb2ed0",
          "attributeId": "9aca7958-c280-41a7-a3c2-97cc64a4c0d7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "272febdb-0b54-a656-89e9-9d78a3af4d04",
          "attributeId": "34331077-922d-4518-b1d7-c44f32c7b4d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2b4d8a7d-2058-078b-0e3a-21c3929be182",
          "attributeId": "d9bc0fa8-2830-44ca-98b0-b090b8a4bd43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1faba217-d50b-1272-606c-852cc95f6fa2",
          "attributeId": "7d379f52-c607-44ff-82b4-c168d11cbf2c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0f866e8b-69e5-a407-2e4f-b498084f1c56",
          "attributeId": "224bbbad-f587-4987-99d5-213d1433a56f",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "557dce8a-e72e-fa84-3029-4dd362c92e07",
          "attributeId": "6de55289-ed7b-41bc-b92b-699842f92021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "42699bcb-ee5f-9867-2e57-ec2fd317921e",
          "attributeId": "ecf63c07-775f-474a-9b1f-2251837b724b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "6e885821-fb09-da71-344a-076527376032",
          "attributeId": "9c821347-256e-4c35-8597-ce5c8a897c91",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b5e2dcfc-855d-659e-4575-ef8206dbd50e",
          "attributeId": "b6c47371-3c29-4e79-a364-2f50a8ecdaa6",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "40aa4263-96db-6104-ce96-1b60642b6d8b",
          "attributeId": "282d8a24-a404-45f5-adee-7d75cf038f5b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "c290c29c-ce16-864d-eb59-93de1048d0e0",
          "attributeId": "b06863c1-1413-45b2-a3b4-d503a2e203eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aa191ff0-fa8c-06b2-81d4-815b26d6c961",
          "attributeId": "f61b2ba6-ffaf-4a12-9e20-3a12eea2b2d6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "09856e56-2235-23a3-1616-1f139dd27d03",
          "attributeId": "fa13edb9-6903-448c-a613-0e3bdbb1cffd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "faacf37d-a0f0-0237-743b-76554333d51d",
          "attributeId": "472c9ac3-a86f-4844-9b0d-5344b6ff8c90",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "a3f0c556-b6af-7843-0bc5-a69995134852",
          "attributeId": "a110fd38-22b6-4212-9dd0-ff44e6971d58",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "a79e63c6-b247-5e1c-eaaa-8faa215b9d88",
          "attributeId": "0072df17-5baa-460b-8cd6-4e0a63d44ed0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9185ef29-ca79-b622-a0ed-730639ea7328",
          "attributeId": "1f537c6a-d8b0-40d9-9bd7-5437fa486a05",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": true
    },
    {
      "id": "e3e786f7-eed7-7174-8ed0-8c2a5a04ac5b",
      "entityId": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{UID:\"@UID\",  DueDate:\"<=@NOW\", VisibleToRespondent:1}",
      "control": "gridview",
      "dataMap": [
        {
          "id": "d54f8032-9fef-d812-7da4-9fd539baa02c",
          "attributeId": "fb1995a9-d5b0-41b0-8bba-de1f198a2ade",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f381e43d-852f-58fa-7521-7bd27b0dc177",
          "attributeId": "9708f58f-4391-4f2d-8ce5-3e3f705e0567",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "ebba927c-ed24-6357-037d-5421c2db2c51",
          "attributeId": "05aca3b9-1ff1-4224-af56-e1e7b40d2ea7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f501757e-1a42-05f8-134e-0eb765439491",
          "attributeId": "4a05dc25-64a0-4bc1-ab63-cd8eb47388cc",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4b378256-81c6-8c8c-3139-3dfa8d158e03",
          "attributeId": "ba2edc74-4779-4dfa-b077-6171c7e5728a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e941fdc7-91b5-0cd8-2b2c-635861702e71",
          "attributeId": "fed57935-d235-4978-8e32-740704d0a4e6",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "109fb23f-c4db-7152-d2ca-58886a0bc588",
          "attributeId": "0cbfca89-19a5-42af-85e5-a2924c73965b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5fa31011-125e-6096-0bab-41c2da1ee255",
          "attributeId": "0406153b-14c8-40fa-9c0f-8da423c1bf9c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d2aa8868-0a05-6ca4-e36d-149a9baf3987",
          "attributeId": "87142dff-3c44-4b2e-adf3-dbe6902929e3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cb1a1fb9-936d-ae6a-5dac-5b1560bd7bac",
          "attributeId": "eaf65e44-d8b3-41e2-8ea3-7fa371c24df7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "5ac6fb47-4621-72be-367d-15e83d469d07",
          "attributeId": "3742bb4c-1d36-43e9-91ca-7c9b06a7a387",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "220bc418-cc9d-b07a-adc9-43b293d0e7c2",
          "attributeId": "25fb86e0-cd5c-4827-bb81-b95c606c76a2",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4dc6ef56-f131-bfab-71f4-723a1ffc8c9a",
          "attributeId": "1778d9cd-e976-41a5-94d0-f58118650e78",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b71fe3e2-e934-f3b2-b85e-0be496b89101",
          "attributeId": "934eb22d-26ab-46df-affb-34b9ca4279bd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1b16e0b3-733c-9be7-9a19-bb9940a23c79",
          "attributeId": "da266418-6f9d-49c6-8cd0-b848b7b1865d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bc4ee8fc-d922-7c2a-b666-be390f8f55be",
          "attributeId": "fae8d036-d2f9-4122-9788-5a836fde5f14",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d75fb34d-da7b-e37d-3082-5298ad39e38a",
          "attributeId": "d8c56aaa-a66c-4c11-885b-63b48132a4ae",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c9209b05-dca7-266f-ead3-4455b7c6b0f6",
          "attributeId": "b78e3a71-0a01-4252-9f6d-dedcd79b7a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a4ee373a-36a5-0b28-575a-2ff576e9922b",
          "attributeId": "79e48f5b-600c-4e8f-93e2-3cba618395df",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "70aaa645-44fc-3f99-122a-19bedfc8f8ce",
          "attributeId": "628f5950-57f7-4bff-a55e-387c81d3e3ca",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1924c50f-0f37-a1ac-d511-0c882d79e784",
          "attributeId": "bce4dc52-69b3-4f24-8085-76201ed4b669",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4cbbae20-93c7-1493-5234-e2e95dd7f41f",
          "attributeId": "1a3f9d0d-db31-4d8c-a2d8-2667ff9fd2a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9bf4821e-f51d-a9ef-c06b-55ea55544760",
          "attributeId": "26c17cdf-0e95-42bb-945a-9cc3fea7d591",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d2fe37d2-d718-2901-614c-bfaa82dedc94",
          "attributeId": "64ec9ca0-1500-4533-8754-59ebff95a686",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bc8e5266-89f6-e613-a55b-ab00ca4f91ff",
          "attributeId": "dda35caf-327b-47f8-91ee-106063c882d4",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d9b3b18e-bb3a-7f66-4e47-309fe9f725fe",
          "attributeId": "c7c38d0a-36b8-4de5-ae08-96b66d3b9181",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8c18be47-01c0-e47f-4933-a62d8af0f38a",
          "attributeId": "118adb3e-82fd-4fca-aa90-6d282910ed7c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "243f7069-0984-941b-ae5a-dbd2edd43ddd",
          "attributeId": "394be317-66d0-4ab6-81d7-98d2f10beb29",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "25d75624-bcd4-41d8-2fea-f11136b7e33c",
          "attributeId": "74097b74-c031-4848-af9c-c3e58c34e232",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "48abaea8-3977-2830-63b2-064efc2acf61",
          "attributeId": "91423d5e-f275-4f21-ab84-7a9d5d46db97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "31a8d9cf-8d70-1c1b-a51a-cc83adee2b8e",
          "attributeId": "94071c82-1934-4dcd-aeb4-d43a67baf751",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8d439bf6-63ab-c729-b6a7-15e3f1d5789b",
          "attributeId": "762c021b-e51e-41d9-b041-050e239514a6",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "c463aaaf-62be-2ba1-2df0-8b93ec1c14f3",
          "attributeId": "a1df9b41-0552-444b-afc4-853c61a4df92",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "c7fdf993-4e49-7db4-a641-384605e0111a",
          "attributeId": "9aca7958-c280-41a7-a3c2-97cc64a4c0d7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "7ec0928e-64e8-4d4d-539e-9c7410ac990e",
          "attributeId": "34331077-922d-4518-b1d7-c44f32c7b4d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "282a246d-8427-cf3c-6df9-eb78cacfa52a",
          "attributeId": "d9bc0fa8-2830-44ca-98b0-b090b8a4bd43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a160d5f-34bf-0aff-3e79-073547617f90",
          "attributeId": "7d379f52-c607-44ff-82b4-c168d11cbf2c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ecad23f0-8ae7-c583-57c9-543390b09e5b",
          "attributeId": "224bbbad-f587-4987-99d5-213d1433a56f",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "2b1ee886-7819-48e4-9661-36f7814d8229",
          "attributeId": "6de55289-ed7b-41bc-b92b-699842f92021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fef72a25-3433-522c-75d9-023b03082cc1",
          "attributeId": "ecf63c07-775f-474a-9b1f-2251837b724b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "551d3505-adc7-3677-d801-47c47a9c6758",
          "attributeId": "9c821347-256e-4c35-8597-ce5c8a897c91",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e334439d-f3d8-e831-ce9a-bfb8ad2b4c74",
          "attributeId": "b6c47371-3c29-4e79-a364-2f50a8ecdaa6",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "fcc670a8-0f31-6c53-1efd-dbc278c09bac",
          "attributeId": "282d8a24-a404-45f5-adee-7d75cf038f5b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "745899c0-299f-643d-fadf-a8250c823b8d",
          "attributeId": "b06863c1-1413-45b2-a3b4-d503a2e203eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "71265f31-9715-59b4-4d06-91cc65159640",
          "attributeId": "f61b2ba6-ffaf-4a12-9e20-3a12eea2b2d6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "abf2adac-0a09-1775-f85b-6010a682c616",
          "attributeId": "fa13edb9-6903-448c-a613-0e3bdbb1cffd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "45622517-8d2c-14a1-627c-cd56b1f5cb20",
          "attributeId": "472c9ac3-a86f-4844-9b0d-5344b6ff8c90",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "54f206c4-b974-b194-a54b-9432235ddbf2",
          "attributeId": "a110fd38-22b6-4212-9dd0-ff44e6971d58",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b847e9e0-5abb-b9e6-3c68-87ffc7b08ee5",
          "attributeId": "0072df17-5baa-460b-8cd6-4e0a63d44ed0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0072273a-1e93-3374-9164-12d9cbc24594",
          "attributeId": "1f537c6a-d8b0-40d9-9bd7-5437fa486a05",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": true
    }
  ]
}', [StructDivisionId]=NULL WHERE ([Id]='50A76E5A-98F3-44BF-A161-003ED4FB2F3B');
GO
-------------------------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='98FD848F-DF55-4E5A-BBC5-5919F423A1CD', [Folder]=N'metadata/forms', [Filename]=N'QNN_DPLY-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.340', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-18 10:54:08.757', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2020-02-18T10:54:08.7578684+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "SetFields",
      "parameter": "{\"Status\": 1, \"Target\": \"N\",  \"Type\": \"E\",  \"CreatedDate\": \"@DateNow\", \"CreatedBy\":\"@CurrentUserId\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": " {\"UpdatedDate\": \"@DateNow\", \"UpdatedBy\": \"@CurrentUserId\"}"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyListSampleAsync"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyMessageAsync"
    }
  ],
  "dataMap": [
    {
      "id": "49dc498b-862f-8db6-c96b-436359c1fe8f",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "control": "dictCategory",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09c51019-6736-b903-ba90-49c6648aed13",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "control": "radioCompletionAction",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "000c5d4f-1fd1-8038-2591-0d619c11d8ee",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "control": "textCompleteURL",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2438929-3329-c80c-347b-9da9c989eff3",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9dec37ab-922a-3546-4a78-d6b6dbfbf2a9",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3da35281-aa29-eddf-9e7b-286819c16b08",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "control": "DateEnd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa74d157-9a98-478e-d389-68f6e93d0118",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "control": "DateStart",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2b3dfd15-2fbb-ba91-0671-7a9e60427bc3",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3bdf7e66-15d8-b585-644a-c8ab8460baba",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c1b23718-7f5e-a000-e54d-d928be553567",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1fddbcc0-83cb-119d-8e03-374668bb8854",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "319c8862-be47-1e69-a018-f83506cfa587",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "textName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "97cf1d53-28c5-46a1-0570-4988a6104d89",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ce20b9d-22e3-cdc0-5b10-313082777c45",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2636b43a-a3ea-062a-574f-85d081788a96",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3190228d-0386-0414-b011-49465dd5116f",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d61f2305-3c49-14f0-6874-50ec12c9ce67",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09a1c46f-5fa4-537b-0d2c-25485bd76070",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e30afa8-b7b8-876c-4373-81d1d7060dc7",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09bf95ec-8916-105b-2c75-aae713335918",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "control": "DaysUpdate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9d067751-8f32-8b30-efae-13ca8d1128f7",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "control": "dictList",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "15c4e305-59f8-430d-e37b-fddc34f0480b",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "control": "MaxResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9f046ca8-9da9-3947-464b-7b854ef030bd",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f16cb492-4407-54c3-d6b7-c7e2d65135c2",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "control": "dictQuestionnaire",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "548a8469-7142-e4f2-83f4-ac0fcbc365f4",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "control": "radioNavBack",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e736758a-1122-7948-e429-0308aa9d6fb1",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "control": "textNavCancelUrl",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "72f8e742-b794-320f-5dca-aea702eff73e",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "control": "radioNavCancel",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8cc321aa-0522-d13a-b458-8a1398b903dd",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0c843062-e9a5-a4c5-8217-f183ce69c6e4",
      "attributeId": "2ed5084d-49c5-4111-9412-10b8930a9b2e",
      "control": "VisibleToRespondent",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment"
}', [StructDivisionId]=NULL WHERE ([Id]='98FD848F-DF55-4E5A-BBC5-5919F423A1CD');
GO
-- ----------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='655275CF-8202-4438-B66B-874EAB315889', [Folder]=N'metadata/forms', [Filename]=N'QNN_DPLY.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.393', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-18 10:54:08.550', [Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_7",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Deployment",
            "size": "huge",
            "textAlign": "left"
          }
        ],
        "style-float": ""
      },
      {
        "key": "container_13",
        "data-buildertype": "container",
        "children": [
          {
            "key": "importModal",
            "data-buildertype": "swzmodal",
            "style-source": "float: right;",
            "secondary": true,
            "content": "Import Response",
            "style-display": "none",
            "children": [
              {
                "key": "form_1",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "header_3",
                    "data-buildertype": "header",
                    "content": "Import Response",
                    "size": "medium",
                    "events": {},
                    "other-visibleConition": ""
                  },
                  {
                    "key": "listFile",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "file",
                    "style-marginTop": "10px"
                  },
                  {
                    "key": "totalRows",
                    "data-buildertype": "header",
                    "content": "Total rows: {totalRows}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalRows!= null && data.totalRows!= undefined)"
                  },
                  {
                    "key": "totalSampleResponseAdded",
                    "data-buildertype": "header",
                    "content": "Rows added: {totalSampleResponseAdded}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalSampleResponseAdded!= null && data.totalSampleResponseAdded!= undefined)"
                  },
                  {
                    "key": "totalSampleNoResponse",
                    "data-buildertype": "header",
                    "content": "Rows not added (No response): {totalSampleNoResponse}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                  },
                  {
                    "key": "totalInvalidUIDs",
                    "data-buildertype": "header",
                    "content": "Rows not added (Invalid UID): {totalInvalidUIDs}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                  },
                  {
                    "key": "totalInvalidQnnColumns",
                    "data-buildertype": "header",
                    "content": "Total invalid columns: {totalInvalidQnnColumns}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalInvalidQnnColumns!= null && data.totalInvalidQnnColumns!= undefined)"
                  },
                  {
                    "key": "moreModal",
                    "data-buildertype": "swzmodal",
                    "style-source": "",
                    "secondary": true,
                    "content": "More information",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "form_2",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "form_2",
                            "data-buildertype": "form",
                            "children": [
                              {
                                "key": "container_13",
                                "data-buildertype": "container",
                                "style-float": "right",
                                "children": [
                                  {
                                    "key": "invalidQnnColumns",
                                    "data-buildertype": "header",
                                    "content": "Invalid columns:  {totalInvalidQnnColumns}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                  },
                                  {
                                    "key": "breadcrumb_1",
                                    "data-buildertype": "breadcrumb",
                                    "items": [
                                      {
                                        "text": "Download",
                                        "url": ""
                                      }
                                    ],
                                    "events": {
                                      "onItemClick": {
                                        "active": true,
                                        "actions": [
                                          "downloadInvalidColumns"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                  },
                                  {
                                    "key": "invalidUIDs",
                                    "data-buildertype": "header",
                                    "content": "Invalid rows (UID): {totalInvalidRows}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                  },
                                  {
                                    "key": "breadcrumb_2",
                                    "data-buildertype": "breadcrumb",
                                    "items": [
                                      {
                                        "text": "Download",
                                        "url": ""
                                      }
                                    ],
                                    "events": {
                                      "onItemClick": {
                                        "active": true,
                                        "actions": [
                                          "downloadInvalidUIDs"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                  },
                                  {
                                    "key": "totalInvalidDates_Updated",
                                    "data-buildertype": "header",
                                    "content": "Total invalid date start and complete: {totalInvalidDates_Updated}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "(data.totalInvalidDates_Updated!= undefined && data.totalInvalidDates_Updated.length > 0)",
                                    "style-hidden": true
                                  },
                                  {
                                    "key": "invalidDates_Updated",
                                    "data-buildertype": "header",
                                    "content": "Invalid date start and complete : {totalInvalidDates_Updated}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                  },
                                  {
                                    "key": "breadcrumb_3",
                                    "data-buildertype": "breadcrumb",
                                    "items": [
                                      {
                                        "text": "Download",
                                        "url": ""
                                      }
                                    ],
                                    "events": {
                                      "onItemClick": {
                                        "active": true,
                                        "actions": [
                                          "downloadInvalidDates"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                  },
                                  {
                                    "key": "button_1",
                                    "data-buildertype": "button",
                                    "content": "Cancel",
                                    "style-customcss": "",
                                    "primary": false,
                                    "events-onClick": true,
                                    "events-onClick-actions": [
                                      "gridAdd"
                                    ],
                                    "events": {
                                      "onClick": {
                                        "active": true,
                                        "actions": [
                                          "closeMoreModal"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "",
                                    "style-source": "float: right;",
                                    "inverted": false,
                                    "secondary": true
                                  }
                                ],
                                "style-marginRight": "",
                                "style-width": "100%",
                                "style-marginBottom": "",
                                "style-source": ""
                              }
                            ],
                            "style-source": "overflow-y: auto;\noverflow-x: auto;"
                          }
                        ],
                        "style-source": "overflow-y: auto;\noverflow-x: auto;"
                      }
                    ],
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-customValidation": "",
                    "other-visibleConition": "(data.invalidUIDs != null && data.invalidUIDs != undefined)"
                  },
                  {
                    "key": "container_7",
                    "data-buildertype": "container",
                    "style-float": "right",
                    "children": [
                      {
                        "key": "btnImportCancel",
                        "data-buildertype": "button",
                        "content": "Cancel",
                        "style-customcss": "",
                        "primary": false,
                        "events-onClick": true,
                        "events-onClick-actions": [
                          "gridAdd"
                        ],
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "closeModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "other-visibleConition": "",
                        "style-source": "float: right;",
                        "inverted": false,
                        "secondary": true
                      },
                      {
                        "key": "btnImportSave",
                        "data-buildertype": "button",
                        "content": "Save",
                        "style-customcss": "",
                        "primary": true,
                        "events-onClick": true,
                        "events-onClick-actions": [
                          "gridAdd"
                        ],
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "submitFile"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "other-visibleConition": "",
                        "style-source": "float: right;"
                      }
                    ],
                    "style-marginRight": "",
                    "style-width": "100%",
                    "style-marginBottom": "10px"
                  }
                ],
                "style-source": "overflow-y: auto;\noverflow-x: auto;"
              }
            ],
            "size": "",
            "events": {
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "other-visibleConition": "data.Id!=null",
            "style-marginLeft": ""
          }
        ],
        "style-float": "right",
        "style-marginLeft": ""
      },
      {
        "key": "container_8",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonManageMessageHistory",
            "data-buildertype": "button",
            "content": "Manage Message History",
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "redirectToForm"
                ],
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplyMessages"
                  }
                ]
              }
            },
            "floated": "right"
          },
          {
            "key": "buttonManageListSamples",
            "data-buildertype": "button",
            "content": "Manage List Samples",
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "redirectToForm"
                ],
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplyListSample"
                  }
                ]
              }
            },
            "floated": "right"
          }
        ],
        "style-float": "right",
        "style-marginLeft": "",
        "style-marginRight": "3.5px"
      },
      {
        "key": "container_12",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonManageDataEditors",
            "data-buildertype": "button",
            "content": "Manage Data Editors",
            "events": {
              "onClick": {
                "actions": [
                  "redirectToForm"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplySampleOwner"
                  }
                ]
              }
            },
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
            "floated": "right"
          },
          {
            "key": "buttonManageImputation",
            "data-buildertype": "button",
            "content": "Manage Imputation",
            "events": {
              "onClick": {
                "actions": [
                  "redirectToForm"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplyImputation"
                  }
                ]
              }
            },
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
            "floated": "right"
          }
        ],
        "style-float": "right",
        "style-width": "100%",
        "style-marginTop": "15px"
      }
    ],
    "style-width": "100%",
    "style-float": "right"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "headerBasicProperties",
            "data-buildertype": "header",
            "content": "Basic Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_3",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "textName",
                "data-buildertype": "input",
                "label": "Name",
                "fluid": true,
                "onChangeTimeout": 200,
                "other-customValidation": "",
                "other-required": true,
                "events": {}
              },
              {
                "key": "dictCategory",
                "data-buildertype": "dictionary",
                "label": "Category",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_CATEGORY",
                "placeholder": "Select category...",
                "columns": "Name ASC",
                "search": true,
                "other-required": false,
                "other-readOnlyConition": "",
                "clearable": true,
                "filters": "[{\"column\":\"Type\", \"value\":\"D\", \"term\":\"=\"}]"
              },
              {
                "key": "dictQuestionnaire",
                "data-buildertype": "dictionary",
                "label": "Questionnaire",
                "fluid": true,
                "selection": true,
                "search": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "dropdownQuestionnaireOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "onChangeTimeout": "",
                "dataModel": "QNN_QNN",
                "columns": "Title ASC",
                "placeholder": "Select a questionnaire...",
                "other-required": true,
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:false",
                "other-readOnlyConition": ""
              },
              {
                "key": "dictList",
                "data-buildertype": "dictionary",
                "label": "List",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_LIST",
                "columns": "Name ASC",
                "search": true,
                "events": {},
                "placeholder": "Select a list...",
                "other-required": true,
                "style-source": "",
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:false",
                "other-readOnlyConition": ""
              },
              {
                "key": "VisibleToRespondent",
                "data-buildertype": "checkbox",
                "label": "Visible to Respondent",
                "defaultValue": "True",
                "toggle": true
              }
            ]
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "events": {},
            "style-source": "clear:both;"
          },
          {
            "key": "formGroupStartEndDate",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "DateStart",
                "data-buildertype": "input",
                "label": "Start On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "style-width": "100%",
                "events": {},
                "style-source": "",
                "style-marginLeft": "32px",
                "other-readOnlyConition": "",
                "other-required": true
              },
              {
                "key": "DateEnd",
                "data-buildertype": "input",
                "label": "End On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "other-readOnlyConition": "",
                "other-required": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "headerCompletionProperties",
            "data-buildertype": "header",
            "content": "Completion  Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "radioCompletionAction",
                "data-buildertype": "radiogroup",
                "label": "Action",
                "data-elements": [
                  {
                    "key": 1,
                    "value": "C",
                    "text": "Do nothing"
                  },
                  {
                    "key": 2,
                    "value": "R",
                    "text": "Redirect to URL"
                  }
                ],
                "direction": "v",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "radioCompletionActionOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "defaultValue": "C"
              },
              {
                "key": "textCompleteURL",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Specify redirect url (http://www.google.com)",
                "other-visibleConition": "data.radioCompletionAction== ''R'' ? true : false",
                "events": {},
                "style-marginLeft": "24px"
              }
            ]
          },
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "hedderNavigationProperties",
                "data-buildertype": "header",
                "content": "Navigation Properties",
                "size": "medium"
              },
              {
                "key": "fromGroupNavigationProperties",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "radioNavBack",
                    "data-buildertype": "radiogroup",
                    "label": "Back Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "0",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "1",
                        "text": "Show"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavBackOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-marginBottom": "8px",
                    "defaultValue": "0"
                  },
                  {
                    "key": "radioNavCancel",
                    "data-buildertype": "radiogroup",
                    "label": "Cancel Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "N",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "Y",
                        "text": "Show"
                      },
                      {
                        "key": 3,
                        "value": "YURL",
                        "text": "Show and redirect to URL"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavCancelOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "defaultValue": "N"
                  },
                  {
                    "key": "textNavCancelUrl",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "size": "",
                    "placeholder": "Specify redirect url (http://www.google.com)",
                    "style-marginLeft": "24px",
                    "events": {},
                    "other-visibleConition": "data.radioNavCancel == ''YURL'' ? true : false"
                  }
                ]
              }
            ],
            "style-hidden": true
          },
          {
            "key": "headerResponseProperties",
            "data-buildertype": "header",
            "content": "Response Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "custom",
            "widthsCustom": "2",
            "children": [
              {
                "key": "MaxResponse",
                "data-buildertype": "input",
                "label": "Maximum Number of Responses",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "events": {},
                "defaultValue": "-1"
              },
              {
                "key": "DaysUpdate",
                "data-buildertype": "input",
                "label": "Days for Update",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "defaultValue": "0",
                "events": {}
              }
            ]
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Initial Notification Type",
                "size": "medium"
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "cbMailMerge",
                    "data-buildertype": "checkbox",
                    "label": "Mail Merge",
                    "slider": true,
                    "toggle": true,
                    "style-marginRight": "20px",
                    "defaultValue": ""
                  },
                  {
                    "key": "cbEmail",
                    "data-buildertype": "checkbox",
                    "label": "Email",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": ""
                  },
                  {
                    "key": "cbProfile",
                    "data-buildertype": "checkbox",
                    "label": "Generate Profile",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": ""
                  }
                ]
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "subject",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "other-visibleConition": "data.cbMailMerge||data.cbEmail",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "parseHtml"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "other-visibleConition": "data.Id==null",
            "style-marginBottom": "20px"
          }
        ]
      }
    ],
    "style-float": "left",
    "style-width": "100%"
  },
  {
    "key": "container_14",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_16",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "header_4",
        "data-buildertype": "header",
        "content": "Report Properties",
        "size": "medium",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "chkScheduler",
        "data-buildertype": "checkbox",
        "label": "Save Snap Shot Daily",
        "toggle": true,
        "events": {
          "onChange": {
            "active": true,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "container_9",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "dailySsForm",
        "data-buildertype": "form",
        "children": [
          {
            "key": "ddlEmailReceipients",
            "data-buildertype": "dictionary",
            "label": "Email Recipient/s",
            "fluid": true,
            "selection": true,
            "dataModel": "vSP_dataEditors",
            "columns": "Name ASC",
            "clearable": true,
            "multiple": true,
            "events": {},
            "style-marginTop": "",
            "style-marginBottom": "",
            "other-visibleConition": "",
            "paging": true
          },
          {
            "key": "container_15",
            "data-buildertype": "container",
            "style-marginTop": "30px",
            "style-marginBottom": "30px"
          },
          {
            "key": "formgroup_4",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "chkEmailSuccess",
                "data-buildertype": "checkbox",
                "label": "Email Success",
                "toggle": true
              },
              {
                "key": "chkEmailFail",
                "data-buildertype": "checkbox",
                "label": "Email Fail",
                "toggle": true
              }
            ],
            "style-marginTop": "30px",
            "style-marginBottom": "30px",
            "orientation": "inline"
          }
        ],
        "other-visibleConition": "(data.chkScheduler != null && data.chkScheduler != 0 ? true: false)",
        "events": {},
        "other-customValidation": "",
        "other-readOnlyConition": ""
      }
    ],
    "other-visibleConition": "data.Id != null",
    "style-marginTop": "30px",
    "style-marginBottom": "30px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_4",
        "data-buildertype": "button",
        "content": "Save",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "onClickSave",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": ""
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Cancel",
        "events": {
          "onClick": {
            "actions": [
              "goBack"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "secondary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "20px",
    "style-marginTop": "30px"
  }
]', [StructDivisionId]=NULL WHERE ([Id]='655275CF-8202-4438-B66B-874EAB315889');
GO
-------------------