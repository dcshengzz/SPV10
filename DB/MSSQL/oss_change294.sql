-- Will UPDATE existing row(s) in dwMetadata for the following:
-- login.json
-- login-settings.json

UPDATE [dwMetadata] SET
[Id]='6e76ef8e-afba-4fe1-900e-27d3e3adb8c7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'login.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:20.580', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-05 21:16:40.407', 
[Data]=N'[
  {
    "key": "divLoginPage",
    "data-buildertype": "container",
    "children": [
      {
        "key": "formLogin",
        "data-buildertype": "form",
        "children": [
          {
            "key": "login",
            "data-buildertype": "input",
            "label": "Login",
            "fluid": true
          },
          {
            "key": "password",
            "data-buildertype": "input",
            "label": "Password",
            "fluid": true,
            "type": "password"
          },
          {
            "key": "remember",
            "data-buildertype": "checkbox",
            "label": "Remember",
            "slider": false,
            "style-hidden": true
          },
          {
            "key": "btnLogin",
            "data-buildertype": "button",
            "content": "Login",
            "fluid": true,
            "primary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "login"
                ],
                "targets": [],
                "parameters": []
              }
            }
          }
        ],
        "style-width": ""
      }
    ],
    "style-width": "350px",
    "style-marginLeft": "auto",
    "style-marginRight": "auto",
    "style-source": "",
    "style-height": ""
  }
]' WHERE [Id]='6e76ef8e-afba-4fe1-900e-27d3e3adb8c7';

UPDATE [dwMetadata] SET
[Id]='4791ee4e-1ab2-4af2-8984-516531188286', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'login-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-02-04 13:02:48.643', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-05 21:16:40.480', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2022-04-05T21:16:40.464801+08:00",
  "isTemplate": false
}' WHERE [Id]='4791ee4e-1ab2-4af2-8984-516531188286';

