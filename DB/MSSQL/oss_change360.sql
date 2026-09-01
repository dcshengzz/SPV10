-- Will INSERT row(s) into dwMetadata for the following:
-- InvitesChangePassword-code.js
-- InvitesChangePassword-settings.json
-- InvitesChangePassword.json

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'87b82e62-da4e-43d8-be2d-800369927dfc', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'InvitesChangePassword-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-25 11:59:45.693', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-27 15:46:51.200', 
N'{
//  For the javascript code please refer to the jsx file.
}');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'8318f59d-6876-48ef-9c37-a781b5db472b', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'InvitesChangePassword-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-25 11:47:00.157', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-25 11:53:15.053', 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2022-10-25T11:53:15.0531445+08:00",
  "isTemplate": false
}');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'975a72ee-b022-4e01-ac1e-53025bc8cf43', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'InvitesChangePassword.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-25 11:47:00.103', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-25 11:53:15.020', 
N'[
  {
    "key": "divLoginPage",
    "data-buildertype": "container",
    "children": [
      {
        "key": "formLogin",
        "data-buildertype": "form",
        "children": [
          {
            "key": "divLogo",
            "data-buildertype": "container",
            "children": [
              {
                "key": "image_1",
                "data-buildertype": "image",
                "src": "/images/logo.svg",
                "style-height": "51px",
                "style-marginLeft": "auto",
                "style-marginRight": "auto"
              }
            ],
            "style-width": "",
            "style-marginLeft": "auto",
            "style-marginRight": "auto",
            "style-height": "",
            "style-marginBottom": "50px",
            "style-marginTop": ""
          },
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Please enter your new password",
            "size": "medium"
          },
          {
            "key": "newPassword",
            "data-buildertype": "input",
            "label": "New Password",
            "fluid": true,
            "type": "password",
            "other-required": true
          },
          {
            "key": "confirmPassword",
            "data-buildertype": "input",
            "label": "Confirm Password",
            "fluid": true,
            "type": "password",
            "other-required": true
          },
          {
            "key": "btnSubmit",
            "data-buildertype": "button",
            "content": "Confirm",
            "fluid": true,
            "primary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "validate",
                  "changePassword"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "secondary": false
          },
          {
            "key": "button_1",
            "data-buildertype": "button",
            "content": "Cancel",
            "fluid": true,
            "primary": false,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "cancel"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "secondary": true
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
]');

