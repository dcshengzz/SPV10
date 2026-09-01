-- Feature: To have status dropdown for deployment email sending; To schedule email resend
-- Implementation guide:
-- run this script
-- do database sync for table QNN_STATUS to add StructDivisionId field
-- do database sync for table QNN_DPLY_MSG to add ScheduledDate, JobId, JobIsCanceled
-- do database sync for table QNN_DPLY_MSG_SAMPLE to add EmailSentDate
-- do database sync for view vSP_DplyMsgWithSampleCount to add JobId, ScheduledDate, JobIsCanceled
-- do database sync for view vSP_DplyMsgSample and set its data model's Primary Key to Id

-- do Data Mapping for form dplyMessage:
		Main entity: QNN_DPLY_MSG
		Attributes checked: DplyStep, EmailFrom, EmailSubj, Id, IsDeleted, NotifyEmail, NumberId, MsgContent, JobId, ScheduledDate, JobIsCanceled
		Create a collection mapped to gridview_1 - Collection entity: vSP_DplymsgSample, Collection filter: FilterByModelId, Parameters: {DplyMsgId: "@Id"}
-- restart site 


----------------------
--Add StructDivisionId field for QNN_STATUS for multiple instances
ALTER TABLE [dbo].[QNN_STATUS] ADD [StructDivisionId] uniqueidentifier NULL 
GO
ALTER TABLE [dbo].[QNN_STATUS] ADD CONSTRAINT [FK_QNN_STATUS] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE SET NULL ON UPDATE NO ACTION
GO
update [dbo].[QNN_STATUS] set StructDivisionId ='72D461B2-234B-40D6-B410-B261964BA291'
GO
CREATE INDEX [IDX_StructDivisionId] ON [dbo].[QNN_STATUS]
([StructDivisionId] ASC) 
GO

---------------------------
ALTER TABLE [dbo].[QNN_DPLY_MSG] ADD [ScheduledDate] datetime NULL 
GO

ALTER TABLE [dbo].[QNN_DPLY_MSG] ADD [JobId] varchar(50) NULL 
GO

ALTER TABLE [dbo].[QNN_DPLY_MSG] ADD [JobIsCanceled] bit NULL 
GO

CREATE INDEX [IDX_JobId] ON [dbo].[QNN_DPLY_MSG]
([JobId] ASC) 
GO

----------------------------------
ALTER TABLE [dbo].[QNN_DPLY_MSG_SAMPLE] ADD [EmailSentDate] datetime NULL 
GO

-------

ALTER VIEW [dbo].[vSP_DplyMsgWithSampleCount] AS 
select m.Id, m.NumberId, m.DplyStep, m.DplyId, m.NotifyMerge, NotifyEmail,  
NotifyGenerate, m.MsgContent, m.EmailSubj, m.EmailFrom, m.EmailCC, m.EmailBCC, 
m.GenerateQnnYN, m.GenerateDateTime, m.IsDeleted, m.CreatedBy, m.CreatedDate, m.DeletedBy, 
m.DeletedDate, m.UpdatedBy, m.UpdatedDate, m.MergeDone, m.MergeOutputToken, m.GenerateProfileDone, 
m.GenerateProfileOutputToken, ISNULL(s.SampleCount,0) as SampleCount, u.Name as UserName, m.JobId, m.JobIsCanceled, m.ScheduledDate from QNN_DPLY_MSG m 
inner join dwSecurityUser u on u.Id = m.CreatedBy 
left join (
select s.DplyMsgId, count(*) as SampleCount from QNN_DPLY_MSG_SAMPLE s
group by s.DplyMsgId ) s on m.Id = s.DplyMsgId
GO
-----------------------------
CREATE VIEW [dbo].[vSP_DplyMsgSample] AS 
select s.Name, s.UID, s.Email, ms.EmailSentDate, ms.Id, ms.DplyMsgId from QNN_DPLY_MSG_SAMPLE ms
inner join QNN_LIST_SAMPLE ls on ls.Id = ms.ListSampleId
inner join QNN_SAMPLE s on ls.SampleId = s.Id
GO
----------------------
INSERT INTO [dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('E3D5BE20-1431-42B3-8EB7-9614D478C7F0', N'metadata/forms', N'dplyMessage-settings.json', '0', 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-23 06:48:48.240', NULL, NULL, 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-25 14:55:18.363', N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplyMessage",
  "lastUpdate": "2020-02-25T14:55:18.3619121+08:00",
  "entityId": "d0fc550f-5f5b-48ef-9c22-bbb30528e6c2",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "c9370afc-65af-ce1d-128b-ff72c191483e",
      "attributeId": "98ea38c9-6a0b-43c9-81e7-33c0fdf81664",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "745eb442-a214-4015-763d-c755eec82f9d",
      "attributeId": "53013ae2-ac53-49d9-8256-29517c8ce92d",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "2e313eff-505e-20bd-1d77-b769e682a84b",
      "attributeId": "05249853-6194-4045-b78a-b300b1261dbd",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "22c2ff97-d372-1635-b14c-5b85336111aa",
      "attributeId": "3827faa7-8f56-4657-b62f-3f0e2b741601",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "58d6ca3f-5562-1a2f-c667-264b808bc8e8",
      "attributeId": "59c5738d-c75c-48f3-a13d-89551dc8f265",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "fe10991b-03f6-819b-ea3d-d7c0d22e5a43",
      "attributeId": "617e73c0-cbc5-427c-8b5c-9b3eb9724eef",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "93b2e866-3493-3a03-f1fc-3acd60609772",
      "attributeId": "b048ef0b-e83c-441b-8a37-bb9c186da00e",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "a486fa98-68dc-c3fc-3e8d-663cc132d38f",
      "attributeId": "e2f43f33-e402-4bf0-8240-406f330128ef",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d4e4f928-bbf0-3903-7f5b-e31155052692",
      "attributeId": "980ba3ed-445e-4048-84e4-aa8a5a894d03",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "742c9f5f-2e42-54f7-4d33-04341f347da7",
      "attributeId": "723a024e-c6b7-4a6d-8840-700288df74fe",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6931df1a-f300-025f-3f2d-1bacd4666f5f",
      "attributeId": "5aa6f5c9-ff71-45dc-aac4-069c32bd2e46",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d705f381-e567-d49c-7c16-5c6f4ffdd799",
      "attributeId": "91b7860e-858d-4fb2-8c34-e08911284e78",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "c2e29ebf-55bc-6cfe-af47-e9318c8cce94",
      "attributeId": "d8a72553-1d8e-4c67-8429-9055cb5c6679",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8d5ceaa9-dbf6-ce90-c5c6-364eee828eeb",
      "attributeId": "c43a9452-c591-440c-a1d4-e35201bfdd51",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d845079c-af30-193c-ffc1-a242f62aaa5b",
      "attributeId": "2081e372-56bf-4d2f-bf8f-0e41e9989215",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29783cdc-9668-53ac-4146-e3eadead99c0",
      "attributeId": "e5b3a81b-2dd8-4237-9792-99dde3d846fb",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "58ef1b63-8f95-4994-1e53-83b7eb89b4fe",
      "attributeId": "59aa8497-8343-4a3e-9e58-08d0474ea25d",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "7484baa3-a364-76d7-63e3-8a9daa3f5e23",
      "attributeId": "0d5d3634-db52-47d2-b648-06aff68ef376",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fe701f01-ff07-824a-9ab2-b21a4667e146",
      "attributeId": "bc72319c-27cd-4331-8aa4-d4d7440d4558",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "b1ea41a7-4d9e-42af-8798-5df1a1742e55",
      "attributeId": "248da247-714b-4c8e-aabe-ae51b1a298d7",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d9b3fc79-8855-cfd1-ef83-b5d7665c6baf",
      "attributeId": "3e45f699-36e4-4ec2-b6d4-d79f08aa90d1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f92263b7-3937-a7f0-09cf-742e1f32328a",
      "attributeId": "bb235505-d84c-41c6-ae87-06603fabb6b0",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d66da26d-3666-017f-8186-c6b6d814ca15",
      "attributeId": "29bfaf0b-7047-4e34-b148-fa040deaf052",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "2085efba-b81b-b6e2-6ff6-e691b7832e3f",
      "attributeId": "0a6ac3a9-3884-4171-a423-0b7f032ebbef",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "b7078366-a6b7-4618-bc98-8ce0387c03af",
      "attributeId": "cd7763ec-414c-4abd-a1d2-0046377e916e",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "a809b2f0-32ca-6b65-0ea8-cc3885977ac4",
      "attributeId": "53f6d5a2-9cb9-4236-bfdf-dcf2a1325974",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6c2c3bf3-9cf0-5a81-0a9f-eb0ee82b7f1a",
      "attributeId": "3e5836b1-7ff3-4973-a46d-e8bff016f4a6",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "759a4326-893a-d1ac-840c-8380cdf0864a",
      "attributeId": "b709917c-3d9f-4566-9e8a-1aec879b7ece",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "fbeaf2c0-69a1-6298-cb5e-abb7430a963b",
      "entityId": "9d63c24a-839a-4902-b686-9f00cfa96627",
      "filter": "FilterByModelId",
      "parameter": "{DplyMsgId: \"@Id\"}",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "c4c23f6b-fa60-0571-b158-5e2d62cd0b7d",
          "attributeId": "e4a7c70c-1cc3-4a39-912b-cfd3b9313c88",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "babc2efd-47c0-2836-6b8e-64e50fa3171f",
          "attributeId": "9ad94c11-b4d2-4312-8740-7a087d4b5712",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "86d88462-7064-b6ca-5788-6e028669ed31",
          "attributeId": "43b5aac4-ea5d-41a2-8f20-5288bcf250c4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "63d4aa19-b3b9-3afc-3c21-867b6e2df47c",
          "attributeId": "331746a0-2eaf-4fe2-99ef-3fedf7eca988",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6e3e1786-611b-d1e2-2620-403ae6aa6a27",
          "attributeId": "700fd14e-ce90-4cf7-9148-30dd29e0f6fe",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7720cfa5-2ac4-b3ae-ec13-a458312da1da",
          "attributeId": "69f399e4-0f70-4375-b4e9-fd583844292a",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');
GO
---------------------------------------------------
INSERT INTO [dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('057EACAF-F332-4646-AA05-4E3D5656246A', N'metadata/forms', N'dplyMessage.json', '0', 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-23 06:48:47.203', NULL, NULL, 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-25 14:55:18.143', N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Deployment Message",
    "size": "huge"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_2",
        "data-buildertype": "staticcontent",
        "content": "<h5 class=\"ui header\">Email Subject: </h5> {EmailSubj}<p />\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email Template: </h5> {MsgContent}<p />\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email From: </h5> {EmailFrom}<p />\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Scheduled time:</h5>{ScheduledDate}<p />\n",
        "isHtml": true
      }
    ],
    "style-marginBottom": "20px",
    "style-customcss": "ui message",
    "other-visibleConition": "data.ScheduledDate",
    "style-width": "100%"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "cancelJob",
        "data-buildertype": "button",
        "content": "Cancel Job",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "cancelJob"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "other-visibleConition": "!data.JobIsCanceled && data.ScheduledDate && new Date(data.ScheduledDate )>new Date()"
      },
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Back",
        "primary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "goBack"
            ],
            "targets": [],
            "parameters": [
              {}
            ]
          }
        },
        "other-visibleConition": "",
        "inverted": false,
        "secondary": true
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "input_1",
    "data-buildertype": "input",
    "label": "",
    "fluid": true,
    "onChangeTimeout": 200,
    "placeholder": "Filter by UID",
    "events": {
      "onChange": {
        "active": true,
        "actions": [
          "setFilter",
          "applyFilter"
        ],
        "targets": [
          "gridview_1"
        ],
        "parameters": [
          {
            "name": "column",
            "value": "UID"
          }
        ]
      }
    },
    "style-marginBottom": "20px"
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Email",
        "name": "Email",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "EmailSentDate",
        "name": "Sent Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "UID ASC",
    "pagerType": "server"
  }
]', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');
GO
---------------------------------
INSERT INTO [dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('87EAD053-54CB-4735-8CBC-E812F3344AB3', N'metadata/forms', N'dplyMessage-code.js', '0', 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-23 12:29:26.007', NULL, NULL, 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-25 12:51:44.343', N'{
    init: function(args){
        if(args.data.ScheduledDate)
            args.data.ScheduledDate = dayjs(new Date(args.data.ScheduledDate)).format(''DD MMM YYYY HH:mm'')
    },
    cancelJob: function(args){
        Pace.start();
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
       
       return ()=> {
            var url = ''/deployment/canceljob'' 
            var formData = new FormData();
            formData.append(''dplyMsgId'', args.data.Id);
            
            return fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    Pace.stop();
                    $(''body'').loadingModal(''destroy'');
                    if (response.success) {
                        alertify.success(response.message);
                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: [''cancelJob'']
                                        }
                                    }
                                },
    
                                
                            }
                        });    
    
                    } else {
                        alertify.error(response.message);
                    }
    
                })
                .catch(error => {
                    alertify.error(error.message);;
                });     
       }
    }
}', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');
GO
----------------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='C1C3D084-F194-4719-B7AE-0B62F14F67E8', [Folder]=N'metadata/forms', [Filename]=N'dplyListSample-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:19.413', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-25 17:10:44.213', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyListSample",
  "lastUpdate": "2020-02-25T17:10:44.2131548+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "bc832ee5-3bd0-ebf6-3bf8-25ff0947ac8e",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a54be7e1-6121-4fe3-fabf-c0fd241bd88c",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8eece4fd-92b9-89cb-9ce5-b033fdb22e6e",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bd8efd2f-4fe7-e6ba-c68e-e09f951af003",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4efb6b7b-e2e7-cc3e-f3cf-24818308da18",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c5261b6c-0d65-53ec-13dd-e702ae734de2",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4d31d80a-df37-5b85-bc80-70ce9188cb3a",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "848759d7-3c89-24e3-0376-87e075558973",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "73ae2fc8-d42b-68e0-e6fa-b5e75987ce3d",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3a362a32-828a-0533-ec29-7c6ed2a15bc2",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c96969eb-0e90-27cf-ad4b-d81280319f35",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3a292613-dd96-6200-8334-203d03b8dffd",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a7e8e478-f1c2-f4f4-28ca-2aa868227e0e",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0afffdd2-98bc-b873-8fa7-1ac09711910e",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fe20c92c-2272-cc47-b5c1-51bd07abe8cd",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b36376b8-bcd1-c703-feb9-93a2d1908859",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9ccf729f-2efd-8a11-9778-4042a4595b35",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e22b6e0f-7d71-53d5-7f38-3a338cd21939",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "30122a30-2be2-34cc-62cf-edca9bc1f279",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7100e5fd-43b6-6f9b-08a4-9ec7a1c6fb1f",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4a6b55cd-7b7f-1cef-f45b-7a65c6438e18",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7e882006-8c36-251c-c1f4-779501f5e200",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3a7b7fed-328e-f039-94dd-3e55531421fe",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "90a595c6-b385-22f0-e282-5335681d05a4",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3d9cd8bc-8f6b-6ae1-0011-938ef017356e",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "db0ad778-8c4e-102a-ee96-fd07b7962bec",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f2c73be5-9335-fdac-6c2d-3aefd3f5c330",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "9c4efb38-5907-162e-3fea-df643d5420cc",
      "entityId": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{DplyId: \"@Id\"}",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "9978fddc-eec3-9093-b0c8-5e3aca535b6e",
          "attributeId": "fb1995a9-d5b0-41b0-8bba-de1f198a2ade",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cc4f8d6e-aa8f-5022-be5e-fd884eb06a60",
          "attributeId": "9708f58f-4391-4f2d-8ce5-3e3f705e0567",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "373aecb8-8d7d-3c8e-456b-2a66209b141a",
          "attributeId": "05aca3b9-1ff1-4224-af56-e1e7b40d2ea7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5a5722a5-a1b5-158a-1ae1-5ae945291aa7",
          "attributeId": "4a05dc25-64a0-4bc1-ab63-cd8eb47388cc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "029fbf4c-87a1-7a87-08a5-91ddbe384c50",
          "attributeId": "ba2edc74-4779-4dfa-b077-6171c7e5728a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "49497f8f-99f7-77b5-4b77-ace3a1ce3846",
          "attributeId": "fed57935-d235-4978-8e32-740704d0a4e6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "75a570bd-0915-5eb2-5b22-8ece6cf5f7bf",
          "attributeId": "0cbfca89-19a5-42af-85e5-a2924c73965b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fd5640b8-4db0-3f65-cc38-5ad3b40539e3",
          "attributeId": "0406153b-14c8-40fa-9c0f-8da423c1bf9c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b91a407d-7e52-c2f1-e639-444cf18166c5",
          "attributeId": "87142dff-3c44-4b2e-adf3-dbe6902929e3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d83e259f-c5f6-511a-22b5-f941b7170fd3",
          "attributeId": "eaf65e44-d8b3-41e2-8ea3-7fa371c24df7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d917943a-118c-c411-5c32-cde2e20ea902",
          "attributeId": "3742bb4c-1d36-43e9-91ca-7c9b06a7a387",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f0a041e9-c9b9-7264-d4b9-951950f6befa",
          "attributeId": "25fb86e0-cd5c-4827-bb81-b95c606c76a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "886f408a-a7bd-e0f1-0404-2f7e94503365",
          "attributeId": "1778d9cd-e976-41a5-94d0-f58118650e78",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b771d4be-9aab-5b84-2c43-e4a95a3877c9",
          "attributeId": "934eb22d-26ab-46df-affb-34b9ca4279bd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f1e4821a-06a4-188f-05b5-6ecb9cdb7310",
          "attributeId": "da266418-6f9d-49c6-8cd0-b848b7b1865d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "41fe8bba-6b0e-882d-946b-6055a92a0ef6",
          "attributeId": "fae8d036-d2f9-4122-9788-5a836fde5f14",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "da8cde09-24c4-a61f-b4ba-f9eb40b7461a",
          "attributeId": "d8c56aaa-a66c-4c11-885b-63b48132a4ae",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6db86a5-399d-f074-aa08-df497d17c6cf",
          "attributeId": "b78e3a71-0a01-4252-9f6d-dedcd79b7a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0d11670f-0e66-6a63-786f-97d9601c86db",
          "attributeId": "79e48f5b-600c-4e8f-93e2-3cba618395df",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "720a8aab-26dc-4fb1-a690-3008617b7107",
          "attributeId": "628f5950-57f7-4bff-a55e-387c81d3e3ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ac20f89c-b63e-32bc-2d3f-1a7deb58e78f",
          "attributeId": "bce4dc52-69b3-4f24-8085-76201ed4b669",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fcd415ed-1da7-1e97-3094-ed1a5e28f9b3",
          "attributeId": "1a3f9d0d-db31-4d8c-a2d8-2667ff9fd2a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aeb0bf43-fd73-a672-14ce-fdfccaaaadf4",
          "attributeId": "26c17cdf-0e95-42bb-945a-9cc3fea7d591",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "808b68c5-48c0-2e06-3e46-a2423bf3c6d5",
          "attributeId": "64ec9ca0-1500-4533-8754-59ebff95a686",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5e34d7a9-61b5-418a-14f2-8e4c2ab6175b",
          "attributeId": "dda35caf-327b-47f8-91ee-106063c882d4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8e05861e-51e7-54ef-6d95-0193fc383391",
          "attributeId": "c7c38d0a-36b8-4de5-ae08-96b66d3b9181",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb4fec13-5a4c-9687-5b3c-a58dfc28cc05",
          "attributeId": "118adb3e-82fd-4fca-aa90-6d282910ed7c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "72f8e5d7-8712-69eb-c424-a1b656464b15",
          "attributeId": "394be317-66d0-4ab6-81d7-98d2f10beb29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "264b48ef-2b6c-562f-a6e6-e3e5391d5975",
          "attributeId": "74097b74-c031-4848-af9c-c3e58c34e232",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a9ada3a1-679e-d102-dff3-ec944c9102d5",
          "attributeId": "91423d5e-f275-4f21-ab84-7a9d5d46db97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2e520499-6e1c-2fdd-666a-47ade51dedc5",
          "attributeId": "94071c82-1934-4dcd-aeb4-d43a67baf751",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06f1fdb9-5c93-bb44-cb12-448ddc83975a",
          "attributeId": "762c021b-e51e-41d9-b041-050e239514a6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9b284dc1-a531-4c00-9a35-562eddc83e53",
          "attributeId": "a1df9b41-0552-444b-afc4-853c61a4df92",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76ff75aa-45e9-9584-7c32-da9189fdca51",
          "attributeId": "9aca7958-c280-41a7-a3c2-97cc64a4c0d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "768325b2-72f3-f307-e9a8-7045a7467674",
          "attributeId": "34331077-922d-4518-b1d7-c44f32c7b4d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "50c4cfdb-6219-7209-572d-0a9194e49f34",
          "attributeId": "d9bc0fa8-2830-44ca-98b0-b090b8a4bd43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f11e3ca-4ae3-c4ff-83c1-13f249b82a1c",
          "attributeId": "7d379f52-c607-44ff-82b4-c168d11cbf2c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "adb774b7-ea70-9bd6-9af2-204f70b8a73c",
          "attributeId": "224bbbad-f587-4987-99d5-213d1433a56f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6d54b68b-2f0f-c53d-4986-dada95bdb84c",
          "attributeId": "6de55289-ed7b-41bc-b92b-699842f92021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d11621a0-a83c-7df6-5d13-c564361ed8ef",
          "attributeId": "ecf63c07-775f-474a-9b1f-2251837b724b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f619c28-e828-a07e-93cf-d14e6a6868d6",
          "attributeId": "9c821347-256e-4c35-8597-ce5c8a897c91",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6ca07f9-a6c6-cc1b-bc18-b59fd267f1c9",
          "attributeId": "b6c47371-3c29-4e79-a364-2f50a8ecdaa6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8c34f9b3-3e27-6368-900e-3bef8753ae5c",
          "attributeId": "282d8a24-a404-45f5-adee-7d75cf038f5b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "45d25e9d-3ccf-c473-1437-2b1fada7bbd4",
          "attributeId": "b06863c1-1413-45b2-a3b4-d503a2e203eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ff134cf-9917-97bf-e7ad-f5a3b823576a",
          "attributeId": "f61b2ba6-ffaf-4a12-9e20-3a12eea2b2d6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c8637245-6ed0-edd5-233d-c08df9e21e17",
          "attributeId": "fa13edb9-6903-448c-a613-0e3bdbb1cffd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f9e2961e-38d5-8db5-9b42-0625827b6f1c",
          "attributeId": "472c9ac3-a86f-4844-9b0d-5344b6ff8c90",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3414e56a-dab8-327f-3d91-db490d28b820",
          "attributeId": "a110fd38-22b6-4212-9dd0-ff44e6971d58",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9d387ad1-9415-6968-ad98-5b9c0dc9da8f",
          "attributeId": "0072df17-5baa-460b-8cd6-4e0a63d44ed0",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', [StructDivisionId]=NULL WHERE ([Id]='C1C3D084-F194-4719-B7AE-0B62F14F67E8');
GO
------------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='4CCDC858-527D-4321-8BEE-942751FEB26E', [Folder]=N'metadata/forms', [Filename]=N'dplyListSample.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:19.457', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-25 17:10:44.010', [Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_9",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "{Name}",
            "size": "huge",
            "subheader": "Manage list of samples specific to this deployment"
          }
        ],
        "style-float": "left"
      },
      {
        "key": "container_10",
        "data-buildertype": "container",
        "children": [],
        "style-float": "right"
      }
    ],
    "style-source": "clear: both;"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "input_4",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "setFilter",
                  "applyFilter"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": [
                  {
                    "name": "column",
                    "value": "UIDName"
                  },
                  {
                    "name": "fieldName",
                    "value": "txtResend"
                  }
                ]
              },
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "other-readOnlyConition": "",
            "placeholder": "Filter UID",
            "labelPosition": "",
            "style-marginBottom": "20px"
          },
          {
            "key": "container_6",
            "data-buildertype": "container",
            "children": [
              {
                "key": "input_1",
                "data-buildertype": "input",
                "label": "Filter Due Date  >=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridview_1"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "DueDate"
                      },
                      {
                        "name": "term",
                        "value": ">="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": ""
              },
              {
                "key": "input_5",
                "data-buildertype": "input",
                "label": "Filter Due Date  <=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridview_1"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "DueDate"
                      },
                      {
                        "name": "term",
                        "value": "<="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": "20px"
              }
            ],
            "style-marginTop": "",
            "style-marginBottom": "20px"
          },
          {
            "key": "swzmodal_1",
            "data-buildertype": "swzmodal",
            "style-display": "none",
            "children": [
              {
                "key": "container_8",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "dueDate",
                    "data-buildertype": "input",
                    "label": "Due Date",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "datetime"
                  },
                  {
                    "key": "button_5",
                    "data-buildertype": "button",
                    "content": "Submit",
                    "secondary": true,
                    "inverted": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "changeDueDate"
                        ],
                        "targets": [
                          "gridview_1"
                        ],
                        "parameters": []
                      }
                    },
                    "style-marginTop": "20px"
                  }
                ],
                "style-customcss": "ui message"
              }
            ],
            "content": "Manage Due Date",
            "secondary": true,
            "inverted": true,
            "style-customcss": "",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "manageDueDate"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            }
          }
        ],
        "events": {},
        "style-marginTop": "20px",
        "style-marginBottom": "20px",
        "style-float": "left",
        "style-customcss": "ui message"
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "dictionaryStatus",
            "data-buildertype": "dictionary",
            "label": "",
            "fluid": true,
            "selection": true,
            "placeholder": "Filter Status",
            "dataModel": "QNN_STATUS",
            "columns": "Title, NumberId ASC",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "setFilter",
                  "applyFilter"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": [
                  {
                    "name": "column",
                    "value": "Status"
                  }
                ]
              }
            },
            "style-marginBottom": "20px"
          },
          {
            "key": "container_7",
            "data-buildertype": "container",
            "children": [
              {
                "key": "input_2",
                "data-buildertype": "input",
                "label": "Filter Generated Date  >=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridview_1"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "CreatedDate"
                      },
                      {
                        "name": "term",
                        "value": ">="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": "20px"
              },
              {
                "key": "input_3",
                "data-buildertype": "input",
                "label": "Filter Generated Date  <=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridview_1"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "CreatedDate"
                      },
                      {
                        "name": "term",
                        "value": "<="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": "20px"
              }
            ],
            "style-marginTop": "",
            "style-marginBottom": "20px"
          },
          {
            "key": "btnResetPassword",
            "data-buildertype": "button",
            "content": "Reset Password",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "sampleResetPassword"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            },
            "primary": true,
            "style-marginTop": "",
            "style-source": "float:left;\n",
            "style-marginBottom": "",
            "style-marginLeft": "",
            "style-marginRight": "10px",
            "floated": "left"
          },
          {
            "key": "swzmodal_2",
            "data-buildertype": "swzmodal",
            "style-display": "none",
            "children": [
              {
                "key": "container_11",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "container_12",
                    "data-buildertype": "container",
                    "style-float": "left",
                    "children": [
                      {
                        "key": "cbMailMerge",
                        "data-buildertype": "checkbox",
                        "label": "Mail Merge",
                        "toggle": true,
                        "slider": true,
                        "events": {
                          "onChange": {
                            "active": true,
                            "actions": [
                              "showModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-marginRight": "20px"
                      },
                      {
                        "key": "cbEmail",
                        "data-buildertype": "checkbox",
                        "label": "Email",
                        "slider": true,
                        "toggle": true,
                        "events": {
                          "onChange": {
                            "active": true,
                            "actions": [
                              "showModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-marginRight": "20px"
                      },
                      {
                        "key": "cbProfile",
                        "data-buildertype": "checkbox",
                        "label": "Generate Profile",
                        "slider": true,
                        "toggle": true,
                        "events": {
                          "onChange": {
                            "active": true,
                            "actions": [
                              "showModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      }
                    ],
                    "style-customcss": "",
                    "style-source": ""
                  },
                  {
                    "key": "container_14",
                    "data-buildertype": "container",
                    "style-source": "clear: both;"
                  },
                  {
                    "key": "container_13",
                    "data-buildertype": "container",
                    "style-customcss": "",
                    "children": [
                      {
                        "key": "emailFrom",
                        "data-buildertype": "input",
                        "label": "From",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "other-visibleConition": "data.cbEmail",
                        "style-marginBottom": "20px"
                      },
                      {
                        "key": "subject",
                        "data-buildertype": "input",
                        "label": "Subject",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "other-visibleConition": "data.cbEmail",
                        "style-marginBottom": "20px"
                      },
                      {
                        "key": "scheduledDate",
                        "data-buildertype": "input",
                        "label": "Start From",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "reference": "Start From",
                        "other-visibleConition": "data.cbEmail",
                        "type": "datetime",
                        "style-marginBottom": "20px"
                      }
                    ],
                    "style-source": "",
                    "style-marginTop": "20px"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "events": {
                      "onChange": {
                        "active": false,
                        "actions": [
                          "onHtmlChange"
                        ],
                        "targets": [],
                        "parameters": []
                      },
                      "onClick": {
                        "active": false,
                        "actions": [
                          "showModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": "data.cbMailMerge||data.cbEmail"
                  },
                  {
                    "key": "container_15",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "button_2",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": true,
                        "inverted": true,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "reSend"
                            ],
                            "targets": [
                              "gridview_1"
                            ],
                            "parameters": []
                          }
                        }
                      }
                    ],
                    "style-marginTop": "20px"
                  }
                ],
                "style-customcss": "ui message"
              }
            ],
            "content": "Send Message",
            "secondary": true,
            "inverted": false,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "manageResend"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            },
            "style-customcss": "",
            "style-source": ""
          }
        ],
        "style-marginBottom": "20px",
        "style-float": "left",
        "style-marginTop": "20px",
        "style-marginLeft": "20px",
        "style-customcss": "ui message"
      }
    ],
    "style-source": "clear: both;"
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UIDName",
        "name": "UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "PeerName",
        "name": "Peer UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "StatusTitle",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "DueDate",
        "name": "Due Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "RespDateStart",
        "name": "Response Start",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "RespDateEnd",
        "name": "Response End",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "CreatedDate",
        "name": "Generated On",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": false
      }
    ],
    "rowKey": "Id",
    "pagerType": "server",
    "defaultSort": "UIDName ASC",
    "multiselect": true,
    "rowHeight": "80",
    "pageSize": "80"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Add New List Sample",
        "secondary": false,
        "inverted": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "addNewSample",
              "gridRefresh"
            ],
            "targets": [
              "gridview_1"
            ],
            "parameters": [
              {
                "name": "confirmTitle",
                "value": "addSampleConfirmTitle"
              },
              {
                "name": "confirmText",
                "value": "addSampleConfirmText"
              }
            ]
          }
        },
        "primary": true
      },
      {
        "key": "button_4",
        "data-buildertype": "button",
        "content": "Manage Message History",
        "secondary": true,
        "inverted": false,
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
        "primary": false
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Back",
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
                "value": "QNN_DPLY"
              }
            ]
          }
        },
        "secondary": true
      }
    ]
  }
]', [StructDivisionId]=NULL WHERE ([Id]='4CCDC858-527D-4321-8BEE-942751FEB26E');
GO
---------------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='4A9265AD-E634-425D-964C-6BA7325313C8', [Folder]=N'metadata/forms', [Filename]=N'dplyMessages-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:19.550', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-25 16:38:31.933', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyMessages",
  "lastUpdate": "2020-02-25T16:38:31.9321494+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "4eea8bf2-bc7c-f6e8-7876-94e848626146",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "94a1a8a7-ec79-e083-6d12-8c5b487b2fa2",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "23483e91-d133-f59b-07d4-56e3736ad830",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e692525-ebf2-26ca-f9fa-24fd75594796",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f8529e8-4447-b3eb-8fc4-27ad6d752b35",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c990e95a-2f07-44be-ddd7-a75596c2874f",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "80b90421-f882-97cc-79f2-2e513de597d3",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "eb69ab88-e705-d472-45a6-144b317956ab",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "25ff2f3a-0739-ec93-88be-21ba02a18d14",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "566dfb86-bc25-1d4c-736d-ba72a8b25c6a",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a5f413d-54a3-e1af-7dfb-7b60f07a5246",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "86bc9c77-d96c-a3db-d3b6-16b61abdc3a9",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "38d3f594-c1c5-45b5-7da0-c40251c8f047",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2b20a602-3395-05d7-a690-c28be7d7671f",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4d065225-77c1-6eb9-a037-32e4a4b24428",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c9f3b5f0-daa2-97b4-7a91-e72f7cffcff2",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0944778b-0ec1-c561-6872-f88e0dbb62f4",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ba4b3b6b-b282-738b-80d8-f63524e4b294",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "998cac2f-ddd2-61b1-4d6a-0cce55f790fb",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e5e339ef-8d58-44f3-e36f-2b4658079115",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fd691de8-ad3c-c601-c4f2-3ea528679f36",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0c382b47-6727-0456-4b40-0572c7dc5ba8",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ab5d23f2-b4d7-e289-61f1-211a31b285ef",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f5ebf44-8b4f-73a4-3347-36396f10003e",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "64a8aadd-4f40-fd3d-c155-4923df865059",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d7b147af-017c-77ff-30da-c0024133097e",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6d244d89-0282-8d31-302b-b47cedc095aa",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "7aa61911-5cad-4e47-1584-77a399729529",
      "entityId": "59aff502-0923-4c44-a333-fe09727419f2",
      "filter": "FilterByModelId",
      "parameter": "{DplyId: \"@Id\"}",
      "control": "grid",
      "dataMap": [
        {
          "id": "285a25a7-457d-9012-e148-812872f7f345",
          "attributeId": "75fe9558-ad13-4155-adfd-278726de0afe",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d31f92a-155e-3263-c253-6b9deefae68e",
          "attributeId": "46d6816a-9736-4f40-808a-6bb0529b12c5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b958e738-8730-746d-5670-dbd8f3a43c73",
          "attributeId": "e7df3305-b885-4b9f-bfd9-bc5800d2b3af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "00831898-d09a-51f0-68ef-539d2db6d01e",
          "attributeId": "d6e51f9b-36b7-4c4a-8713-94bafddffc4b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0e7e4be7-e73c-5838-4732-86444c38469b",
          "attributeId": "2c37782f-dcf0-4386-9c48-b1885c9ec96f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bbd53d9a-8b4a-ce4c-2c9e-f1401f9d8aaf",
          "attributeId": "188f0942-ea3d-4400-8ad2-8efe1fc68d8a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "88dac03c-75dc-f65c-f412-e2fca82378bf",
          "attributeId": "3b27eb5c-9959-4243-b9da-9155a90d8a85",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d653ede4-3206-d935-3940-74ca9b35d8d3",
          "attributeId": "82a1ea3e-7db2-4673-92cf-eca1c47db3c4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aa7affcf-8be7-be1a-2dea-b566f7ed2b13",
          "attributeId": "1b50815e-6bdb-4c8c-bbe1-b40e336409c5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "becb0731-4e23-e255-4a4c-d40b3bec3769",
          "attributeId": "f17fa3f1-c23d-4a90-8685-be98234f9293",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a196eb5a-94df-5f9c-fac5-56c9c4cc7065",
          "attributeId": "93f82dd7-2705-42b3-bf1a-f9d62cc57663",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "18a2abe1-7b04-d3df-82e5-6aae2d98ff37",
          "attributeId": "4c89a233-907b-4a71-accc-995d9b9c8a76",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "955b4502-cf1b-300b-06ef-57fa546c30ca",
          "attributeId": "491795d5-46e8-4247-975c-4c6419243b8f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "555a34a3-0ead-0a7c-1b70-a083fb003ab0",
          "attributeId": "1900ec19-9dac-4596-aa2a-ce82e9cfc493",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a191533f-269c-1b89-c2b2-3b7b90b6deeb",
          "attributeId": "a21d3068-cb0f-41ef-881c-25b6aca9b598",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "36c74caf-0cf3-5392-d56b-0edd3d0ad91f",
          "attributeId": "534741ae-056b-4e92-97cf-5c97cf0e51c1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "78e5a14a-bd95-a442-bf99-a8a118b8c69e",
          "attributeId": "18b42ed0-2227-4819-9b4f-38b1eca723be",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "48b97909-8a82-599c-35f5-6f19db39820f",
          "attributeId": "2cbedcd3-922c-4071-9f7a-c6baab5a6007",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6ac14fc5-7526-ccec-d21b-63b1c23a63b3",
          "attributeId": "df0b7d03-a12e-4c21-8148-cb0d6bfc163c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d75a6f43-73e1-7c3e-adab-3511fc06bf19",
          "attributeId": "475d3632-b629-4d78-8935-e19451cc5cd0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "41ac7538-f4ec-9965-9973-9e6f2750bed8",
          "attributeId": "b49c8574-e461-4400-8df5-68b08cf6cb3f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b5e475da-2dff-3583-3dba-cec738de299a",
          "attributeId": "4026dc0f-3e46-4c2f-a65c-249366dd0993",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fd58cb00-a6ef-8621-0806-65c27c32379d",
          "attributeId": "568d1b2d-ba87-4cb1-b7f1-ad30dd23982e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f128f3a4-343e-9fb5-a0d0-c12d4a66440f",
          "attributeId": "019de426-2ba0-4e03-88af-6d32a6b16a40",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb1f93ae-5190-83af-f71e-3a0e8c1deab2",
          "attributeId": "8014719b-0387-4367-9581-b3fbe54acb76",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4dccfa04-2541-88e9-f46e-0d4b81c5a9d0",
          "attributeId": "12da9e1a-c2f6-4e0e-bbba-dd98e38d72c2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "303c8966-b0b0-25fd-4166-04d4d4343c86",
          "attributeId": "ad82bb50-5d29-4c85-b93d-4ce2c219ddf5",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', [StructDivisionId]=NULL WHERE ([Id]='4A9265AD-E634-425D-964C-6BA7325313C8');
GO
---------------------------------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='FDA03FAD-1EA3-45A7-96C2-3C23FB76AD5A', [Folder]=N'metadata/forms', [Filename]=N'dplyMessages.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:19.593', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-25 16:38:31.503', [Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_9",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "{Name}",
            "size": "huge",
            "subheader": "Manage message history of this deployment"
          }
        ],
        "style-float": "left"
      },
      {
        "key": "container_10",
        "data-buildertype": "container",
        "children": [],
        "style-float": "right"
      }
    ],
    "style-source": "clear: both;"
  },
  {
    "key": "grid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "DplyStep",
        "name": "Step",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "name": "Mail Merge?",
        "key": "NotifyMerge",
        "type": "custom",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "NotifyEmail",
        "name": "Email?",
        "type": "custom",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "NotifyGenerate",
        "name": "Generate Profile?",
        "type": "custom",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "SampleCount",
        "name": "Number of Samples",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "CreatedDate",
        "name": "Created On",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "UserName",
        "name": "Created By",
        "sortable": true,
        "filterable": false,
        "resizable": false
      }
    ],
    "rowKey": "Id",
    "pagerType": "server",
    "defaultSort": "NumberId DESC",
    "multiselect": false,
    "rowHeight": "80",
    "pageSize": "80",
    "minHeight": "",
    "editForm": "",
    "events": {
      "onRowClick": {
        "active": false,
        "actions": [],
        "targets": [],
        "parameters": []
      }
    }
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Back",
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
                "value": "QNN_DPLY"
              }
            ]
          }
        },
        "secondary": true
      }
    ],
    "style-marginTop": "20px",
    "style-marginBottom": "20px"
  }
]', [StructDivisionId]=NULL WHERE ([Id]='FDA03FAD-1EA3-45A7-96C2-3C23FB76AD5A');
GO
-----------------------------------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='179E2EA8-3E6A-4ABC-B861-C582873ED86F', [Folder]=N'metadata/forms', [Filename]=N'dplyMessages-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:19.507', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-25 16:37:36.300', [Data]=N'{
    init: function(args) {        
        var innerArgs = args;
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[1].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyMerge){
                        var url = "/deployment/downloadMailMerge/" + p.row.MergeOutputToken;
                        if(p.row.MergeDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Generating");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };
                model.columns[2].customFormatter = function (p) {

                    if(p.row.NotifyEmail){
                        return CloverApp.API.createElement("span", {onClick: (e)=> {e.stopPropagation();CloverApp.API.redirectToForm("dplyMessage", p.row.Id)}, className: ''link-style''}, ''Yes'');
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };
                
                  model.columns[3].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyGenerate){
                        var url = "/deployment/downloadProfile/" + p.row.GenerateProfileOutputToken;
                        if(p.row.GenerateProfileDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Generating");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };              
            }
            return model;
        };    

        
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);   
    },    
  
    goBack: function(args) {
        args.state.router.history.goBack();
    },
 
    

}', [StructDivisionId]=NULL WHERE ([Id]='179E2EA8-3E6A-4ABC-B861-C582873ED86F');
GO

----------------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='6122CF0B-786E-4824-9DB3-81870FEAD8A8', [Folder]=N'metadata/forms', [Filename]=N'dplyListSample-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:19.370', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-22 15:47:00.573', [Data]=N'{
    
    addNewSample: function(args){
        
        var dplyId = args.data.Id;
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''listId'', listId);        
        var url = ''/deployment/addnewsample'';

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    //console.log(''addNewSample args:'', args);
                    alertify.success(response.message);
                    args.controlRef.refresh();
                    

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });
            

    },
    manageDueDate: function(args){
        
        //console.log("manageDueDate", args);
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_1.close();
             alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_1.props.swzData.isOpen = true;
            
        }
        
    },
    changeDueDate: function(args){
        
        //console.log("changeDueDate", args);
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_1.close();
             alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_1.props.swzData.isOpen = true;
        }
        var dplyId = args.data.Id;
        var dueDate = args.data.dueDate;
        var listSampleIds = [];
        
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var listSampleId = args.controlRef.state.items[gridIndex].ListSampleId;
            listSampleIds.push(listSampleId);
        }
        
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''dueDate'', dueDate);
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/deployment/changeDueDate'';

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    args.component.refs.swzmodal_1.close();
                    alertify.success(response.message);

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });        
        
        
    },    
    goBack: function(args) {
        args.state.router.history.goBack();
    },
    manageResend: function(args){
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_2.close();
            alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_2.props.swzData.isOpen = true;
        }
        
    },
    reSend: function(args){
        //console.log("resend args", args);
        Pace.start();
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
        var dplyId = args.data.Id;
        var mailMerge = (args.data.cbMailMerge==null || args.data.cbMailMerge==undefined)? false : args.data.cbMailMerge;
        var email = (args.data.cbEmail==null || args.data.cbEmail==undefined)? false : args.data.cbEmail;
        var emailFrom = (email && args.data.emailFrom)? args.data.emailFrom : "";
        var scheduledDate = (email && args.data.scheduledDate)? args.data.scheduledDate : "";        
        var profile = (args.data.cbProfile==null || args.data.cbProfile==undefined)? false : args.data.cbProfile;        
        if(!mailMerge && !email && !profile){
            alertify.error("Check at least one");
            return {};
        }
        
        var msgContent = "";
        if(email || mailMerge){
            msgContent = args.component.refs.htmlEditor.state.htmlData;
        }
        var subject = args.data.subject;
        
        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Please input email subject");
            return {};            
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Please input messange content.");
            return {};            
        }
                
        
        
        //var formName = args.data.formName;
        var listSampleIds = [];
        
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var listSampleId = args.controlRef.state.items[gridIndex].ListSampleId;
            listSampleIds.push(listSampleId);
        }
        
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''profile'', profile);        
        formData.append(''subject'', subject);
        //formData.append(''formName'', formName);
        formData.append(''email'', email);    
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);        
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/deployment/resend'';

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    alertify.success(response.message);

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });   
        
    },
    
    sampleResetPassword: function(args){
        
        if (args.controlRef.state.selectedIndexes.length < 1){
            alertify.error("Please select at least one list sample");
            return
        }
        console.log("Sample reset password!", args);
        var sampleIds = [];
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var sampleId = args.controlRef.state.items[gridIndex].SampleId;
            sampleIds.push(sampleId);
        }
        CloverApp.API.setDataField("loading", "");
        //CloverApp.API.setDataField("loading", "Loading...");
        var formData = new FormData();
        formData.append(''sampleIds'', sampleIds);        
        var url = ''/deployment/resetresppassword'';
        alertify.success("Loading...");
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    alertify.success(response.message);
                    //CloverApp.API.setDataField("loading", response.message);
                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);
                //CloverApp.API.setDataField("loading", error.message);
            });   
        
    },
    showModal: function(args){
        args.component.refs.swzmodal_2.props.swzData.isOpen = true;
    }
        
    

}', [StructDivisionId]=NULL WHERE ([Id]='6122CF0B-786E-4824-9DB3-81870FEAD8A8');
GO