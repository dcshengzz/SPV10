--Version 1.67
CREATE PROCEDURE [dbo].[spSP_GetDplyChoiceCount]
		@DplyId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

--count each answer value for all responses of a deployment. treate null and empty as same response.
SELECT Name, QnnFieldId, AnsVal, AnsCount, RespCount, CAST( ROUND(AnsCount *1.00 / RespCount, 4) * 100 AS FLOAT) as [Percentage]  from
(select d.Id as DplyId, d.StructDivisionId, f.NumberId, f.Name, a.QnnFieldId, IsNull(a.AnsVal, '') as AnsVal, count(IsNull(a.AnsVal, '')) as [AnsCount], IsNull(rc.RespCount, 0) as RespCount from QNN_RESP_ANS a
inner join QNN_RESP r on r.Id = a.RespId
inner join QNN_DPLY d on d.Id = r.DplyId
inner join QNN_QNN_FIELD f on f.Id = a.QnnFieldId
inner join vSP_DeploymentRespCount rc on rc.DplyId = r.DplyId
where d.Id = @DplyId
and f.Name<>'swzPdfFormIdentifier' 
and f.Name<>'btnSubmit'
AND (f.Type = 'checkbox' or  f.Type = 'radiogroup' or  f.Type = 'ListBox' or  f.Type = 'dropdown' or f.Type='RadioButton' ) 
group by d.Id, d.StructDivisionId, f.Name, f.NumberId, a.QnnFieldId, ISNULL(a.AnsVal,''), rc.RespCount
) FieldAnsCount order by NumberId

END 
GO
---------------
INSERT INTO [dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('BBE4B066-F1B6-4BB0-85A8-6D474BDB7945', N'metadata/forms', N'ChoiceCount-code.js', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-12-02 15:17:19.097', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-12-04 21:24:59.627', N'{
    getCounts: function(args){
        
        //console.log(args);
        if(!args.data.dplyId){ 
            CloverApp.API.setDataField("dplychoiceqnns", null);
            return;
        }
        //console.log("args.data.dplyId", args.data.dplyId);
        CloverApp.API.setDataField("dplychoiceqnns", args.data.dplyId);
        
    }
}', '72D461B2-234B-40D6-B410-B261964BA291');
GO
INSERT INTO [dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('6C595A69-A642-4672-91A0-16E134DB244D', N'metadata/forms', N'ChoiceCount-settings.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-12-02 15:10:11.873', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-12-07 07:07:24.400', N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2019-12-07T07:07:24.3993607+08:00",
  "isTemplate": false
}', '72D461B2-234B-40D6-B410-B261964BA291');
GO
INSERT INTO [dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('6196AED8-7537-4309-967B-EDDDD4E2D955', N'metadata/forms', N'ChoiceCount.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-12-02 15:10:10.243', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-12-07 07:07:24.287', N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Choice Count for Deployment",
        "size": "large",
        "textAlign": "left",
        "style-marginBottom": "20px"
      },
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "dplyId",
            "data-buildertype": "dictionary",
            "label": "Deployment",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_DPLY",
            "paging": true,
            "pageSize": "20",
            "columns": "Name ASC",
            "clearable": true,
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "getCounts"
                ],
                "targets": [],
                "parameters": []
              }
            }
          }
        ]
      }
    ]
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "dplychoiceqnns",
        "data-buildertype": "dplychoiceqnns",
        "events": {},
        "other-visibleConition": "",
        "style-marginTop": ""
      }
    ],
    "style-marginTop": "30px"
  }
]', '72D461B2-234B-40D6-B410-B261964BA291');
GO
-----------

ALTER TABLE [surveyplus.net].[dbo].[dwUploadedFiles]
ADD IsLocalStorage BIT NULL DEFAULT ((0));
