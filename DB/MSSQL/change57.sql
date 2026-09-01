UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='C6B165BE-3EB2-4CB4-9EE5-2780C37D0909', [Folder]=N'metadata/forms', [Filename]=N'resplogin-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:23.950', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-04-23 13:03:40.410', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2020-04-23T13:03:40.4091505+08:00",
  "isTemplate": false
}', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='C6B165BE-3EB2-4CB4-9EE5-2780C37D0909');
GO
-------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='3AFF3E04-37F4-4C84-9AA9-7DA112F95928', [Folder]=N'metadata/forms', [Filename]=N'resplogin.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:23.993', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-04-23 13:03:39.797', [Data]=N'[
  {
    "key": "divLoginPage",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_2",
        "data-buildertype": "form",
        "children": [
          {
            "key": "respLoginHtmlView",
            "data-buildertype": "swzhtmlview",
            "hideOutput": "block",
            "style-source": "padding: 1em;"
          }
        ],
        "style-width": "60%",
        "events": {},
        "style-marginLeft": "auto",
        "style-marginRight": "auto",
        "style-source": "float:left;\npadding-top: 8em;\npadding-left: 2em;\npadding-right: 1em;",
        "style-marginTop": ""
      },
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
                "src": "/images/imda.png",
                "style-height": "",
                "style-marginLeft": "auto",
                "style-marginRight": "auto",
                "events": {},
                "style-hidden": false
              }
            ],
            "style-width": "",
            "style-marginLeft": "auto",
            "style-marginRight": "auto",
            "style-height": "",
            "style-marginBottom": "50px",
            "style-marginTop": "",
            "style-hidden": false
          },
          {
            "key": "login",
            "data-buildertype": "input",
            "label": "Respondent Login",
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
            "key": "breadcrumb_1",
            "data-buildertype": "breadcrumb",
            "items": [
              {
                "text": "Forgot Password",
                "url": ""
              }
            ],
            "events": {
              "onItemClick": {
                "active": true,
                "actions": [
                  "forgotPassword"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-source": "",
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
            },
            "style-marginTop": "10px"
          }
        ],
        "style-width": "40%",
        "events": {},
        "style-marginLeft": "auto",
        "style-marginRight": "auto",
        "style-source": "float:left;\npadding: 5em;",
        "style-marginTop": ""
      }
    ],
    "style-width": "100%",
    "style-marginLeft": "",
    "style-marginRight": "",
    "style-source": "",
    "style-height": "",
    "events": {},
    "style-float": ""
  }
]', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='3AFF3E04-37F4-4C84-9AA9-7DA112F95928');
GO
---------------------------30
UPDATE TOP(1) [dbo].[QNN_RESP_ADMIN] SET [Id]='DB71D785-DC6E-48A8-89E2-992B4763D826',
[Name]=N'Respondent Login', 
[EditorState]=N'{"blocks":[{"key":"8tu73","text":"SIMS enables respondents to submit, via the Internet, data for national statistics surveys conducted by the Research and Statistics Unit, IMDA.","type":"header-four","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}},{"key":"e5hk6","text":"The information transmitted through IMDA is secured.","type":"header-four","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}},{"key":"4356j","text":"IMDA - SIMS will be undergoing scheduled maintenance and will be unavailable on 30 May, 6pm to 12am. ","type":"unordered-list-item","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}},{"key":"bdkvl","text":"Helpdesk at 6211 1002, 6211 1003 or 6211 1004 for assistance during office hours. Alternatively, you may email us at mu@imda.gov.sg.","type":"unordered-list-item","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}},{"key":"3390u","text":"About Us | Feedback | Contact Us   ","type":"unstyled","depth":0,"inlineStyleRanges":[{"offset":22,"length":10,"style":"color-rgba(0,0,0,0.87)"},{"offset":22,"length":10,"style":"bgcolor-rgb(255,255,255)"},{"offset":22,"length":10,"style":"fontsize-14"},{"offset":22,"length":10,"style":"fontfamily-Lato, \"Helvetica Neue\", Arial, Helvetica, sans-serif"},{"offset":22,"length":10,"style":"color-rgb(65,131,196)"},{"offset":22,"length":10,"style":"bgcolor-initial"}],"entityRanges":[{"offset":0,"length":8,"key":0},{"offset":11,"length":8,"key":1},{"offset":22,"length":10,"key":2}],"data":{}},{"key":"dogqd","text":"","type":"unstyled","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}],"entityMap":{"0":{"type":"LINK","mutability":"MUTABLE","data":{"url":"https://www.imda.gov.sg/Who-We-Are","targetOption":"_blank"}},"1":{"type":"LINK","mutability":"MUTABLE","data":{"url":"https://form.gov.sg/#!/5ce4f26d2305a40017faf7c2","targetOption":"_blank"}},"2":{"type":"LINK","mutability":"MUTABLE","data":{"url":"https://www.imda.gov.sg/Who-We-Are/contact-us","title":"<span data-offset-key=\"bv9m5-0-0\" style=\"box-sizing: inherit; color: rgb(65, 131, 196); background-color: rgb(255, 255, 255); font-size: 14px; font-family: Lato, &quot;Helvetica Neue&quot;, Arial, Helvetica, sans-serif;\"><span data-text=\"true\" style=\"box-sizing: inherit;\"><br class=\"Apple-interchange-newline\">Contact Us</span></span>","targetOption":"_blank","_map":{"type":"LINK","mutability":"MUTABLE","data":{"url":"https://www.imda.gov.sg/Who-We-Are/contact-us","title":"<span data-offset-key=\"bv9m5-0-0\" style=\"box-sizing: inherit; color: rgb(65, 131, 196); background-color: rgb(255, 255, 255); font-size: 14px; font-family: Lato, &quot;Helvetica Neue&quot;, Arial, Helvetica, sans-serif;\"><span data-text=\"true\" style=\"box-sizing: inherit;\"><br class=\"Apple-interchange-newline\">Contact Us</span></span>","targetOption":"_blank"}}}}}}', [Description]=NULL, [StartDate]='2019-01-01 00:00:00.000', 
[EndDate]='2021-12-31 23:59:00.000',
[CreatedBy]=NULL, [CreatedDate]=NULL, 
[UpdatedBy]=NULL, [UpdatedDate]=NULL, 
[Status]='1', 
[Type]=N'RespLogin' 
WHERE ([Id]='DB71D785-DC6E-48A8-89E2-992B4763D826');
GO
----------------------------