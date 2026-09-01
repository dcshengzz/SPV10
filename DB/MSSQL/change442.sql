-- Will UPDATE existing row(s) in dwMetadata for the following:
-- ResponseReport-settings.json
-- ResponseReport-code.js
-- QNN_DPLY-code.js
-- QNN_DPLY-settings.json

UPDATE [dwMetadata] SET
[Id]='791d7a4f-ae91-4b4a-8856-a192a8229c1f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ResponseReport-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-01-17 14:32:33.143', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-01-22 20:07:19.560', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2024-01-22T20:07:19.5470075+08:00",
  "isTemplate": false,
  "securityGroup": "Reports"
}' WHERE [Id]='791d7a4f-ae91-4b4a-8856-a192a8229c1f';

UPDATE [dwMetadata] SET
[Id]='057924ab-2b2b-4f40-a90a-28506e9c12ce', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ResponseReport-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-01-17 14:32:42.590', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [UpdatedDate]='2020-02-14 08:51:04.973', 
[Data]=N'{
    
   getCount: function(args){
        

 var htmlTable = ''<table style="border-color: black; width: 100px; height: 100px;" border="1"><tbody><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr></tbody></table>'';

 CloverApp.API.setDataField(''HTMLTable'',htmlTable);
        
    },

  onSearch: function (args){

    var _loadingStart = function() {
        $(''body'').loadingModal({
            text: ''Loading...'',
            animation: ''foldingCube'',
            backgroundColor: ''#1262E2''
        });
    };
    
    var _loadingStop = function() {
        $(''body'').loadingModal(''destroy'');
    };
   
    // Implement function to remove element from array
    var _removeElement = function(array, element) {
        var _index = array.indexOf(element);
        if (_index == -1) return;
        array.splice(_index, 1);
    };
    // Implement function to add elemenbt 
    var _addUniqueElement = function(array, element) {
        var _index = array.indexOf(element);
        if (_index > -1) return;
        array.push(element);
    };
    
    var _getNumOfWeeks = function(totweeks){
            var arr = [];
            
            if(totweeks == 1)
            {
                var obj = { key : 1 ,
                value : 1 };
                
                arr.push(obj);
            }
           /* if(totweeks == 1)
            {
                var obj = { key : 1 ,
                value : 1 ,
                text : "Latest Week"};
                
                arr.push(obj);
            }*/
            else
            {
                 for(let k = 1; k <= totweeks; k++)
                 {
               var obj = {
                        key: k, 
                        value:k,
                        text: "Week " + k
                     };
                     arr.push(obj);
                }
            }
           
            return arr;
        }
    var dplyId = args.data.ddlDeployment;
    var surveyType = args.data.ddlSurveyType;
    var weeks = args.data.ddlWeek;
    
    if(dplyId == undefined || dplyId == '''' && surveyType == undefined || surveyType == "")
       return alertify.error(''Invalid input'');
    
    var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''rType'',surveyType);
        formData.append(''weekNumber'',weeks);
        
     var url = ''/report/dailyereport'';
     
     var _loadingPromise = new Promise(function(resolve, reject) {
            _loadingStart();

            setTimeout(() => {
                resolve({});
            }, 2000);
        });
        
    var _hideControls = args.state.app.form.models.hideControls;
    return () => {
    _loadingStart();
     return fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                _loadingStop();
                if (response.success) {
                    var totweeks = response.count;
                    var UpperTable = response.UpperTable;
                    var active = response.Active;
                    var LowerTable = response.LowerTable;
                    var htmlTables = '''';
                    var weeksVal = 0;
                     
                     
                     
                   if(weeks !== null && weeks !== undefined)
                   {
                        weeksVal = Object.keys(weeks).length;
                   }
                   
                      if(totweeks == 0)
                       {
                        htmlTables = ''<br>''+''<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;" border="1" bordercolor="#808080" cellpadding="15" background-color="rgba(230, 247, 255,0.1)"><tbody><tr><td><h4>There is no report snapshot saved for this survey.''+''</h4></td></tr></tbody></table>''+''<br>''+''<hr>'';
                       }
                      else if(weeks === null || weeks === undefined || weeksVal === 0 )
                      {
                        upperRows = UpperTable[totweeks];
                        middleRows = active[totweeks];
                        lowerRows = LowerTable[totweeks];
                        if(upperRows.length == 0 || middleRows.length == 0 || lowerRows.length == 0)
                       {
                         htmlTable = ''<br>''+''<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;" border="1" bordercolor="#808080" cellpadding="15" background-color="rgba(230, 247, 255,0.1)"><tbody><tr><td><h4>There is no report snapshot saved for week : ''+ totweeks + ''</h4></td></tr></tbody></table>''+''<br>''+''<hr>'';
                       }
                        else
                        {
                            
                        var tableStart =  ''<br>''+''<br>'' +''<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;background-color:rgba(230, 247, 255,0.1);" border="1" bordercolor="#808080" cellpadding="15"><tbody style="border-color:#cccccc;">'';
                        var tableContent = '''';
                        var tableContent2 = '''';
                        var tableContent3 = '''';
                        var tableEnd = ''</tbody></table>'';
                    
                       
                       var preResponse;
                       if(totweeks !== null && totweeks !== 0 && totweeks !== 1)
                       {
                             preResponse = UpperTable[totweeks - 1];
                       }
                      
                   
                        for(let h = 0 ; h < upperRows.length; h++){
                           
                            if(totweeks == null || totweeks == 0 || totweeks == 1 )
                            {
                                if(h == 0)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[h].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px"  colspan="5">'' + upperRows[h].ActiveCases + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if ( h == 1)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[h].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[h].ActiveCases + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[h].InactiveCases + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[h].SampleSize + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[h].ResponseRate + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if (h == upperRows.length-1)
                                {
                                    let rowS = ''<tr bgcolor="#ffad33">'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[h].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
                                else
                                {
                                     let rowS = ''<tr>'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[h].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
  
                         
                            }
                            else 
                            {
                                
                                  if(h == 0)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[h].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px"  colspan="6">'' + upperRows[h].ActiveCases + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if ( h == 1)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[h].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[h].ActiveCases + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[h].InactiveCases + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[h].SampleSize + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[h].ResponseRate + ''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[h].ResponseRateforPweek + ''</th>'';//+''<th style="padding:5px;font-size:16px">'' + preResponse[h].ResponseRate + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if (h == upperRows.length-1)
                                {
                                    let rowS = ''<tr bgcolor="#ffad33">'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[h].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRate + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRateforPweek + ''</td>'';//+''<td style="padding:5px">'' + preResponse[h].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
                                else
                                {
                                     let rowS = ''<tr>'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[h].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRate + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRateforPweek + ''</td>'';//+''<td style="padding:5px">'' + preResponse[h].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
  
                    
                            }
                                    
                         
                            
                       }
                    
                        for(let g = 0 ; g < middleRows.length; g++){
                            let rowSU = ''<tr>'';
                            let rowEU = ''</tr>'';
                             let MrowData = '''';
                            
                            if( surveyType == ''MP'' || surveyType == ''IU'')
                            
                            {
                               if(g == 0)
                               {
                                   MrowData = ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].ResponseCategory + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].Status + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].TA + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[g].MTS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[g].STS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[g].Total + ''</th>''+''<th></th>'';                    
                               }
                               else if (g == middleRows.length-1)
                               {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[g].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + middleRows[g].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[g].MTS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].STS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].Total + ''</td>''+''<td></td>'';                              
                               }
                               else
                               {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[g].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[g].MTS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].STS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].Total + ''</td>''+''<td></td>'';                                                   
                               }
                         
                            }
                            else
                            {
                                
                                if(g == 0)
                                {
                                   MrowData = ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].ResponseCategory + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].Status + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].TA + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[g].TS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[g].Total + ''</th>''+''<th style="padding:5px;font-size:16px;"> </th>''+''<th style="padding:5px;font-size:16px;"> </th>'' ;                                    
                                }
                                else if (g == middleRows.length-1)
                                {
                                    MrowData = ''<td style="padding:5px">'' + middleRows[g].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + middleRows[g].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[g].TS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'' ;                                    
                                }
                                else
                                {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[g].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[g].TS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'' ;                                                                       
                                }
                         
                            }
                           
                            tableContent2 = tableContent2 + rowSU + MrowData + rowEU;
                            
                       }
                   
                        for(let k = 0 ; k < lowerRows.length; k++){
                            let rowSL = ''<tr>'';
                            let rowEL = ''</tr>'';
                            let LrowData = '''';
                            if( surveyType == ''MP'' || surveyType == ''IU'')
                            {
                             
                                if( k == lowerRows.length-2 )
                                {
                              
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px;font-size:16px;">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[k].MTS + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[k].STS + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[k].Total + ''</td>''+''<td></td>'';
                                }
                                else if( k == lowerRows.length-5 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td></td>'';
                                }
                                else if ( k == lowerRows.length-10 )
                                {
                                   LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td></td>'';                                
                                }
                                else
                                {
                                   LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td></td>'';                                    
                                }
                                
                            }
                            else
                            {
                                if( k == lowerRows.length-2 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'';
                                }
                                else if( k == lowerRows.length-5 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'';
                                }
                                else if ( k == lowerRows.length-10 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'';
                                }
                                else
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'';
                                }
                         
                        
                            }
                                tableContent3 = tableContent3 + rowSL + LrowData + rowEL;
                            
                       }
                       
                       
                       
                        var htmlTable = tableStart + tableContent + tableContent2 + tableContent3 + tableEnd;
                        
                        }
                        htmlTables = htmlTables + htmlTable;
                   }
                      else
                      {
                        
                      var weekFilterCount = Object.keys(weeks).length;
                      var htmlTables = '''';
                      
                      for (var v = 0 ; v < weekFilterCount; v++)
                        {
                         
                        
                        var tableContent = '''';
                        var tableContent2 = '''';
                        var tableContent3 = '''';
                        
                        var filterWeek = weeks[v];
                           
                             upperRows = UpperTable[filterWeek];
                             middleRows = active[filterWeek];
                             lowerRows = LowerTable[filterWeek];
                             
                             if(upperRows.length == 0 || middleRows.length == 0 || lowerRows.length == 0)
                             {
                                 htmlTable = ''<br>''+''<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;" border="1" bordercolor="#808080" cellpadding="15" background-color="rgba(230, 247, 255,0.1)"><tbody><tr><td><h4> There is no report snapshot saved for week : ''+ filterWeek + ''</h4></td></tr></tbody></table>''+''<br>''+''<hr>'';
                             }
                             else
                             {
                                 
                            
                           
                        var tableStart =  ''<br>''+''<br>''+''<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;" border="1" bordercolor="#808080" cellpadding="15" background-color="rgba(230, 247, 255,0.1)"><tbody style="border-color:#cccccc;">'';
                        var tableEnd = ''</tbody></table>''+''<br>''+''<br>''+''<hr>'';
 
                       var preResponse;
                  
                       if(filterWeek !== null && filterWeek !== 0 && filterWeek !== 1)
                       {
                           preResponse = UpperTable[filterWeek - 1];
                       }
                     
                      
                           
                     for(let p = 0 ; p < upperRows.length; p++){
           
           
                     if(filterWeek == null || filterWeek == 0 || filterWeek == 1)
                        
                        {
                            let rowS = ''<tr>'';
                            let rowE = ''</tr>'';
                            let UrowData = ''<td style="padding:5px">'' + upperRows[p].EnterpriseType + ''</td>'' + ''<td>'' + upperRows[p].ActiveCases + ''</td>'' + ''<td>'' + upperRows[p].InactiveCases + ''</td>''+''<td>'' + upperRows[p].SampleSize + ''</td>''+''<td>'' + upperRows[p].SampleSizeAft + ''</td>''+''<td>'' + upperRows[p].ResponseRate + ''</td>'' ;
                            //tableContent = tableContent + rowS + UrowData + rowE;



                                     if(p == 0)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[p].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px"  colspan="5">'' + upperRows[p].ActiveCases + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if ( p == 1)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[p].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[p].ActiveCases + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[p].InactiveCases + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[p].SampleSize + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[p].ResponseRate + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if (p == upperRows.length-1)
                                {
                                    let rowS = ''<tr bgcolor="#ffad33">'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[p].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
                                else
                                {
                                     let rowS = ''<tr>'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[p].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }


                         }
                         else
                         {
                                if(p == 0)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:15%;">'' + upperRows[p].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px"  colspan="6">'' + upperRows[p].ActiveCases + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if ( p == 1)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[p].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[p].ActiveCases + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[p].InactiveCases + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[p].SampleSize + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[p].ResponseRate +''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[p].ResponseRateforPweek + ''</th>'';//+''<th style="padding:5px;font-size:16px">'' + preResponse[p].ResponseRate + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if (p == upperRows.length-1)
                                {
                                     let rowS = ''<tr bgcolor="#ffad33">'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[p].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRate + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRateforPweek + ''</td>'';//+''<td style="padding:5px">'' + preResponse[p].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
                                else
                                {
                                     let rowS = ''<tr>'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[p].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRate + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRateforPweek + ''</td>'';//+''<td style="padding:5px">'' + preResponse[p].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
                         }
           
                            
                       }
                       
                      
                     for(let q = 0 ; q < middleRows.length; q++){
                            let rowSU = ''<tr>'';
                            let rowEU = ''</tr>'';
                            let MrowData = '''';
                            
                            if( surveyType == ''MP'' || surveyType == ''IU'')
                            
                            {
                               if(q == 0)
                               {
                                   MrowData = ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].ResponseCategory + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].Status + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].TA + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[q].MTS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[q].STS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[q].Total + ''</th>''+''<th></th>'';                    
                               }
                               else if (q == middleRows.length-1)
                               {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[q].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + middleRows[q].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[q].MTS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].STS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].Total + ''</td>''+''<td></td>'';                              
                               }
                               else
                               {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[q].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[q].MTS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].STS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].Total + ''</td>''+''<td></td>'';                                                   
                               }
                         
                            }
                            else
                             {
                                
                                if(q == 0)
                                {
                                   MrowData = ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].ResponseCategory + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].Status + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].TA + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[q].TS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[q].Total + ''</th>''+''<th style="padding:5px;font-size:16px;"> </th>''+''<th> </th>'';                                    
                                }
                                else if (q == middleRows.length-1)
                                {
                                    MrowData = ''<td style="padding:5px">'' + middleRows[q].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + middleRows[q].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[q].TS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'' ;                                    
                                }
                                else
                                {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[q].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[q].TS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'' ;                                                                       
                                }
                         
                            }
                           
                            tableContent2 = tableContent2 + rowSU + MrowData + rowEU;
                            
                       }
                       
                     for(let r = 0 ; r < lowerRows.length; r++){
                            let rowSL = ''<tr>'';
                            let rowEL = ''</tr>'';
                            let LrowData = '''';
                            if( surveyType == ''MP'' || surveyType == ''IU'')
                            {
                             
                                if( r == lowerRows.length-2 )
                                {
                              
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px;font-size:16px;">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[r].MTS + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[r].STS + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[r].Total + ''</td>''+''<td></td>'';
                                }
                                else if( r == lowerRows.length-5 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td></td>'';
                                }
                                else if ( r == lowerRows.length-10 )
                                {
                                   LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td></td>'';                                
                                }
                                else
                                {
                                   LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td></td>'';                                    
                                }
                                
                            }
                            else
                            {
                                if( r == lowerRows.length-2 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'';
                                }
                                else if( r == lowerRows.length-5 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'';
                                }
                                else if ( r == lowerRows.length-10 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'';
                                }
                                else
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'';
                                }
                        
                            }
                                tableContent3 = tableContent3 + rowSL + LrowData + rowEL;
                        
                       }
                          
                        var htmlTable = tableStart + tableContent + tableContent2 + tableContent3 + tableEnd;
                }
                             htmlTables = htmlTables + htmlTable;
                        }

                    }
                   
                    var exportData = response;
                    CloverApp.API.setDataField(''HTMLTable'',htmlTables);
                    CloverApp.API.setDataField(''exportData'', exportData);
                    CloverApp.API.setDataField(''ddlData'',exportData);
                    CloverApp.API.setDataField(''btnSearch'', true);
                    var ddlRewrite = function (model) {
                        model[''data-elements''] = _getNumOfWeeks(totweeks);
                    }
                    CloverApp.API.rewriteControlModel("ddlWeek", ddlRewrite);
                    _removeElement(_hideControls, ''ddlWeek'');
                    
                    return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: _hideControls
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
    };
  },
  
   onExport : function(args){
      
      
      
                     var exportData = args.data.exportData;
                     var Length = exportData.count;
                     var weeks = args.data.ddlWeek;
    
                    var active = exportData.Active;
                    var LowerTable = exportData.LowerTable;
                    var UpperTable = exportData.UpperTable;
                     var LowerRows;
                     var MiddleRows;
                     var UpperRows;
                   var weeksVal;
                   if(weeks !== null && weeks !== undefined)
                   {
                        weeksVal = Object.keys(weeks).length;
                   }
                     if(weeks === null || weeks === undefined || weeksVal === 0 )
                    {
                             LowerRows = LowerTable[Length];
                             MiddleRows = active[Length];
                             UpperRows = UpperTable[Length];
             
                            var objArray; 
                            var str = '' '';
             
                            var UTable = UpperRows.concat(MiddleRows);
                            objArray = UTable.concat(LowerRows);
              
               
              
                            var array = typeof objArray != ''object'' ? JSON.parse(objArray) : objArray;
                         
                          
                          for (var n = 0; n< array.length; n++)
                          {
                              var line = '' '';
                              
                              for (var index in array[n])
                              {
                                  line += '' ''+ array[n][index] + '','';
                                  
                              }
                              
                              line.slice(0,line.length-1);
                              str += line + ''\r\n'';
                          }
              
            
                            var surveyType = args.data.ddlSurveyType;
                            var filename = "IMDADailyResponseReport_"+surveyType+"_Week"+ Length ;
                   
                             var downloadLink = document.createElement("a");
                             var blob = new Blob(["\ufeff",str]);
                             var url = URL.createObjectURL(blob);
                            downloadLink.href = url;
                            downloadLink.download = filename+".csv"; 
                            document.body.appendChild(downloadLink);
                            downloadLink.click();
                            document.body.removeChild(downloadLink);
      
                           
                           
                       }
                    else
                    {
                            var weekFilterCount = Object.keys(weeks).length;
                            
                           for (var z = 0 ; z < weekFilterCount; z++)
                           {
                           
                               
                                var filterWeek = weeks[z];
                               
                                 UpperRows = UpperTable[filterWeek];
                                 MiddleRows = active[filterWeek];
                                 LowerRows = LowerTable[filterWeek];
                                  var objArray; 
                            var str = '' '';
             
                            var FilterTable = UpperRows.concat(MiddleRows);
                            objArray = FilterTable.concat(LowerRows);
              
               
              
                            var array = typeof objArray != ''object'' ? JSON.parse(objArray) : objArray;
                         
                          
                          for (var n = 0; n< array.length; n++)
                          {
                              var line = '' '';
                              
                              for (var index in array[n])
                              {
                                  line += '' ''+ array[n][index] + '','';
                                  
                              }
                              
                              line.slice(0,line.length-1);
                              str += line + ''\r\n'';
                          }
              
                            var surveyType = args.data.ddlSurveyType;
                            var filename = "IMDADailyResponseReport_"+surveyType+"_Week"+ filterWeek ;
                             var downloadLink = document.createElement("a");
                             var blob = new Blob(["\ufeff",str]);
                             var url = URL.createObjectURL(blob);
                            downloadLink.href = url;
                            downloadLink.download = filename+".csv"; 
                            document.body.appendChild(downloadLink);
                            downloadLink.click();
                            document.body.removeChild(downloadLink);
          
                           }
                           
                       }
                   
  },
  
   onChange : function(args){
       
     CloverApp.API.setDataField("ddlWeek",[]); 
            var ddlRewrite = function (model) {
                  
                            model[''data-elements''] = 0;
                        }
          
          CloverApp.API.setDataField(''btnSearch'',undefined);
          CloverApp.API.rewriteControlModel("ddlWeek",ddlRewrite); 
          //CloverApp.API.setDataField("ddlWeek",false);
          CloverApp.API.setDataField("ddlSurveyType", []);
          CloverApp.API.setDataField(''HTMLTable'','' '');

               
       
   },
   
   
   
   
   btnCSV : function(args){
    
                     var exportData = args.data.exportData;
                     var Length = exportData.count;
                     var weeks = args.data.ddlWeek;
    
                     var active = exportData.Active;
                     var LowerTable = exportData.LowerTable;
                     var UpperTable = exportData.UpperTable;
                     var LowerRows;
                     var MiddleRows;
                     var UpperRows;
                     
                        if(weeks !== null && weeks !== undefined)
                   
                   {
                        weeksVal = Object.keys(weeks).length;
                   }
               
                   if(weeks === null || weeks === undefined || weeksVal === 0 )
                   
                   
                   {
                         LowerRows = LowerTable[Length];
                         MiddleRows = active[Length];
                         UpperRows = UpperTable[Length];
         
                        var objArray; 
                        var str = '' '';
         
                        var UTable = UpperRows.concat(MiddleRows);
                        objArray = UTable.concat(LowerRows);
          
           
          
                        var array = typeof objArray != ''object'' ? JSON.parse(objArray) : objArray;
                     
                      
                      for (var n = 0; n< array.length; n++)
                      {
                          var line = '' '';
                          
                          for (var index in array[n])
                          {
                              line += '' ''+ array[n][index] + '','';
                              
                          }
                          
                          line.slice(0,line.length-1);
                          str += line + ''\r\n'';
                      }
          
        
                        var surveyType = args.data.ddlSurveyType;
                        var filename = "IMDADailyResponseReport_"+surveyType+"_Week"+ Length ;
               
                         var downloadLink = document.createElement("a");
                         var blob = new Blob(["\ufeff",str]);
                         var url = URL.createObjectURL(blob);
                        downloadLink.href = url;
                        downloadLink.download = filename+".csv"; 
                        document.body.appendChild(downloadLink);
                        downloadLink.click();
                        document.body.removeChild(downloadLink);
  
                   }
                   
                   
                else
                   {
                        var weekFilterCount = Object.keys(weeks).length;
                        
                       
                          
                        var objArray1 = []; //array
                        var str = '' '';
                        
                        for (var z = 0 ; z < weekFilterCount; z++)
                       {
                       
                           
                         var filterWeek = weeks[z];
                           
                         UpperRows = UpperTable[filterWeek];
                         MiddleRows = active[filterWeek];
                         LowerRows = LowerTable[filterWeek];
         
                         var FilterTable = UpperRows.concat(MiddleRows);
                         second = FilterTable.concat(LowerRows);
                         
                         objArray1.push(second);
                         
                         
          
                       }
                       
                        var objArray = [];
                       for (let l = 0 ; l < objArray1.length ; l++)
                       {
                            objArray = objArray.concat(objArray1[l]);
                       }
          
                      var array = typeof objArray != ''object'' ? JSON.parse(objArray) : objArray;
                      for (var n = 0; n< array.length; n++)
                      {
                          var line = '' '';
                          
                          for (var index in array[n])
                          {
                              line += '' ''+ array[n][index] + '','';
                              
                          }
                          
                          line.slice(0,line.length-1);
                          str += line + ''\r\n'';
                      }
          
                        var surveyType = args.data.ddlSurveyType;
                        var filename = "IMDADailyResponseReport_"+surveyType+"_Week"+ filterWeek ;
                         var downloadLink = document.createElement("a");
                         var blob = new Blob(["\ufeff",str]);
                         var url = URL.createObjectURL(blob);
                        downloadLink.href = url;
                        downloadLink.download = filename+".csv"; 
                        document.body.appendChild(downloadLink);
                        downloadLink.click();
                        document.body.removeChild(downloadLink);
      
                       }
                       

  },
  
  
}

' WHERE [Id]='057924ab-2b2b-4f40-a90a-28506e9c12ce';

UPDATE [dwMetadata] SET
[Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.290', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-01-22 20:01:17.017', 
[Data]=N'{
    init: function(args) {
        if(!args.data.Id){
            CloverApp.API.setDataField("State", "Active");   
            CloverApp.API.setDataField("StateName", "Active");     
            CloverApp.API.setDataField("RecurrenceFrequency", "");      
            CloverApp.API.setDataField("IsIncludeUnansweredSection",args.data.printAllPage);
        }
        
        if(args.data.IsIncludeUnansweredSection == null ){
            CloverApp.API.setDataField("IsIncludeUnansweredSection",args.data.printAllPage);
        }

        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c)); 
        
        
         // Implement function to remove element from array
        var _removeElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index == -1) return;
            array.splice(_index, 1);
        };
        // Implement function to add elemenbt 
        var _addUniqueElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index > -1) return;
            array.push(element);
        };

        CloverApp.API.setDataField("cbMailMerge", false);
        CloverApp.API.setDataField("cbEmail", false);
        CloverApp.API.setDataField("subject", "");
        CloverApp.API.setDataField("msgContent", "");
        
        if(args.data.Id){
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.dictQuestionnaire);                  
            }
            catch(error) {
                //ignore
            }
        }          

        var dplyId = args.data.Id;

        if (args.data.Id == null) 
            return {
                app: {
                    form: {
                        models: {
                            hideControls: args.state.app.form.models.hideControls
                        }
                    }
                }
            };
    
        if(args.data.IsAnonymous){
            qnn_dplyUserActions.getAnonymousSurveyLink(args);
        }

        //Tags init
        if(args.data.Tags !== null) {
            //parse json return data after a save
            if(!Array.isArray(args.data.Tags)) {
                args.data.Tags = JSON.parse(args.data.Tags);
                CloverApp.API.setDataField("Tags", args.data.Tags);
            } 
            qnn_dplyUserActions.rewriteActiveTags(args);
        } else {
            CloverApp.API.setDataField("Tags", new Array());
        }
        
        
        // Only get category details
        // iff args.data.Id is not null
    
        var url = ''/snapData/get?id='' + dplyId;
        // _loadingStart();
        var d1 = new Date();
        return ()=>{
            return fetch(url,
                {
                    credentials: ''same-origin'',
                    method: ''get''
                })
                .then(response => response.json())
                .then(response => {
                    Pace.stop();
                    qnn_dplyUserActions.showHideControls(args);  
                    console.log("Response is", response);
                    if (response.success) {
                        
                        var _hideControls = args.state.app.form.models.hideControls;
                        var items = response.items;
                        if (items != null)
                        {
                    
                        var obj = typeof items != ''object'' ? JSON.parse(items) : items;
                        var valChkScheduler = obj[0].Id;
                        var EmailRecipients = obj[0].EmailRecipients;
                        var valEmailSuccess ;
                        var valEmailFailure ;
                        
                        if(obj[0].EmailSuccess == true)
                        {
                            valEmailSuccess = ''1'';
                        }
                        else
                        valEmailSuccess = ''0'';
                            
                        if(obj[0].EmailFailure == true)
                        {
                            valEmailFailure = ''1'';
                        }
                        else
                        {
                            valEmailFailure = ''0'';
                        }
                        
                        // var recipients = [];
                        
                        var recipients = [];
                        if(EmailRecipients == "No Recipient")
                        {
                            recipients = [];
                        }
                        else
                        {
                            var breakRecepient = EmailRecipients.split('','');
                            for (let r = 0 ; r < breakRecepient.length ; r++ )
                            {
                            recipients.push(breakRecepient[r]);
                        }
                        
                        }
                
                        /*// alert(items.length);
                        if(items !== undefined && items.length > 0){
                            _removeElement(_hideControls, dailySsForm);
                        }
                        // recipients.push(EmailRecipients);*/
                    
                        CloverApp.API.setDataField("chkScheduler", 1);
                        CloverApp.API.setDataField("ddlEmailReceipients",recipients);
                        CloverApp.API.setDataField("chkEmailSuccess", valEmailSuccess);
                        CloverApp.API.setDataField("chkEmailFail", valEmailFailure);
                        
                        _removeElement(_hideControls, ''dailySsForm'');  
                        _hideControls.concat(hideControls);
                        return Promise.resolve(
                            {
                                stateDelta: {
                                    app: {
                                        form: {
                                            models: {
                                                hideControls: _hideControls
                                            }
                                        }
                                    },
                                }
                            });  
                            
                        }
                        else
                        {
                            CloverApp.API.setDataField("chkScheduler", 0);
                            CloverApp.API.setDataField("ddlEmailReceipients", []);
                            CloverApp.API.setDataField("chkEmailSuccess", false);
                            CloverApp.API.setDataField("chkEmailFail", false);
                            return {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: args.state.app.form.models.hideControls
                                        }
                                    }
                                }
                            };                    
                        }
                    
                        //  _loadingStop();
                    
                    } // end if response.success        
                }) // end then => response
   
            .catch(function(ex) {
                alertify.error("Could not Data due to " + ex);
            });
        }; //end return  
    }, //end of init

    //Called from init
    checkQnnFields: function(qnnId){    
        const formData = new FormData();
        formData.append(''qnnId'', qnnId);
        loadingStart("Verifying survey field alias");
        postFormRequest("/qnn/checkfields",formData).then(
            response => {
               //No action 
            }, reason => {
                console.log(reason);
                alertify.alert(reason);
            }
        ).finally(loadingStop);
    }, //end of checkQnnFields
    
    setDplyState: function(args){
        if(args.data.EnableWorkflow==1){
            if(!args.data.Id){
                CloverApp.API.setDataField("State", "Draft");             
                CloverApp.API.setDataField("StateName", "Draft");                    
            }
        }  
        else{
            CloverApp.API.setDataField("State", "Active");             
            CloverApp.API.setDataField("StateName", "Active");                
        }          
    },
    
    toggleCompletionUrl: function(args){
        if(!Utils.isSelected(args.data.IsAnonymous)){
            CloverApp.API.setDataField("textCompleteURL", null);              
        }         
    },
    
    toggleAnonymousSurvey: function(args){
        if(!Utils.isSelected(args.data.IsAnonymous)){
            CloverApp.API.setDataField("textCompleteURL", null);
        }else{
            CloverApp.API.setDataField("IsMultipleResponse", 0);
        }
    },
    
    downloadInvalidColumns(args) {
        //CloverApp.API.setDataField("invalidQnnColumns",[''A11'', ''B22'', ''C33'']);
        
        var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidQnnColumns'');
    }, // end of downloadInvalidColumns
    
    downloadInvalidDates(args) {
          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidDates_Updated'');        
    }, //end of downloadInvalidDates
    
    downloadInvalidUIDs(args) {
          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidUIDs'');        
    }, //end of downloadInvalidUIDS
    
    viewArgs(args){
      console.log("View Args", args);  
    },
    
    toggoleIpInclusive: function(args){
        if(args.data.RestrictIpInclusive==1){
            CloverApp.API.setDataField("RestrictIpInclusive", "1");   
        }  
        else{
            CloverApp.API.setDataField("RestrictIpInclusive", "0");              
        }        
    },
    
    showHideControls: function(args){
        var hideControls = [];
        var showControls = [];
        if(args.data.RestrictIp==1){
            CloverApp.API.setDataField("RestrictIp", "1"); 
            if(args.data.RestrictIpInclusive==1){
                args.data.RestrictIpInclusive=''1'';
                CloverApp.API.setDataField("RestrictIpInclusive", "1");   
            }  
            else{
                args.data.RestrictIpInclusive=''0'';
                CloverApp.API.setDataField("RestrictIpInclusive", "0");              
            }            
            qnn_dplyUserActions.addUniqueElement(showControls, ''RestrictIpInclusive'');
            qnn_dplyUserActions.addUniqueElement(showControls, ''countryOrIpRange'');  

            if(args.data.IpCountry || (!args.data.IpCountry && !args.data.IpRange)){
                args.data.countryOrIpRange=''1'';
            }
            else{
                args.data.countryOrIpRange=''0'';
            }  
         
            
            if(args.data.countryOrIpRange==1){
                CloverApp.API.setDataField("countryOrIpRange", ''1'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpCountry'');                      
            }
            else{
                CloverApp.API.setDataField("countryOrIpRange", ''0'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpRange'');                         
            } 
        } else {
            //if not restricting IP
            CloverApp.API.setDataField("RestrictIp", "0");
            qnn_dplyUserActions.addUniqueElement(hideControls, ''RestrictIpInclusive'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''countryOrIpRange'');    
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');                
        }        

        return {hideControls: hideControls, showControls: showControls};
    },
    
    //TODO - refactoe
    removeElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index == -1) return;
        array.splice(_index, 1);
    },
    
    //TODO - refactor
    addUniqueElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index > -1) return;
        array.push(element);
    },
        
    setIpRestriction: function(args){
        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c));
        
        console.log(args)
        return {
            app: {
                form: {
                    models: {
                        hideControls: args.state.app.form.models.hideControls
                    }
                }
            }
        };        
    }, //end of setIpRestriction
    
    onClickSave: function (args){
        const data = args.data.chkScheduler;
        const dplyId = args.data.Id;
        
        const emailSuccess = args.data.chkEmailSuccess;
        const emailFail = args.data.chkEmailFail;
        const userId = args.data.ddlEmailReceipients;
   
        const formData = new FormData();
        formData.append(''CheckBox'', data);
        formData.append(''dplyId'',dplyId);
        formData.append(''emailSuccess'',emailSuccess);
        formData.append(''emailFail'',emailFail);
        formData.append(''userId'',userId);       
        
        Utils.loadingStart();
        //update (job data) (word ''get'' in url is legacy)
        Utils.postFormRequest("/report/getJobData",formData).then(
            response => {
                console.log(data);
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    }, //end of onClickSave
    
    parseHtml: function(args) {
        return {
              app: {
                  form: {
                      data: {
                          modified: {
                             msgContent: args.component.refs.htmlEditor.state.htmlData,
                             msgContentJson: args.component.refs.htmlEditor.state.jsonData
                            }
                        }
                    }
                }
        };  
    },
    
    dropdownQuestionnaireOnChange: function(args) {
        var qnnId = args.sourceControlValue;
        var options = args.sourceControlRef.state.options;
        console.log("Args is", args);
        if(args.data.SurveyName=="" || args.data.SurveyName ==null){
            if(options !== undefined && options.length > 0){
                for(var i = 0; i < options.length; i++){
                    if(options[i].key == qnnId){
                        CloverApp.API.setDataField("SurveyName", options[i]["text"]);
                        break;
                    }
                }
            }
        }   
    },
    
    radioCompletionActionOnChange: function(args) {
    },

    radioCompletionNavBackOnChange: function(args) {
    },

    radioCompletionNavCancelOnChange: function(args) {
    },

    btnSaveOnClick: function(args) {
        // Insert [QNN_DPLY_SAMPLE_INFO]
    },

    clearContent: function(args){
        if(args.data.countryOrIpRange=="1"){
            CloverApp.API.setDataField("IpRange", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpCountry'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpRange'');             
            
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }
        }
        else{
            CloverApp.API.setDataField("IpCountry", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpRange'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpCountry'');      
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }            
        }
    }, //end of clearContent

    navigateParentDeployment: function(args) {
        if(args.data.RecurrenceOfDplyId) {
            //CloverApp.API.redirectToForm("QNN_DPLY",args.data.RecurrenceOfDplyId);
            location.href = "/form/QNN_DPLY/" + encodeURIComponent(args.data.RecurrenceOfDplyId);
        } else {
            alertify.error("This deployment does not have a parent");
        } 
    },
    
    updateFeatureInteraction: function(args) {
        const isExcelEnabled = Utils.isSelected(args.data.IsExcelEnabled);
        const isDelegationEnabled = Utils.isSelected(args.data.RequireAccessCode);
        const isAnonymous = Utils.isSelected(args.data.IsAnonymous);
        const isMultipleResponse = Utils.isSelected(args.data.IsMultipleResponse);
        const isDirectAccessEnabled = Utils.isSelected(args.data.IsDirectAccessEnabled);
        
        if(isAnonymous) {
            if(isExcelEnabled) {
                alertify.error("Online Excel forms are not supported for anonymous surveys");
                CloverApp.API.setDataField("IsExcelEnabled",0);
            }
            
            if(isDelegationEnabled) {
                alertify.error("Delegation Access Code is not supported for anonymous surveys");
                CloverApp.API.setDataField("RequireAccessCode", 0);
            }
            
            if(isDirectAccessEnabled) {
                alertify.error("Direct Access feature is not applicable for anonymous surveys (use anonymous survey links)");
                CloverApp.API.setDataField("IsDirectAccessEnabled",0);
                Utils.queueHideControl("IsDirectAccessForComplete","hide");
            }
        }
        
        if(isMultipleResponse) {
            if(isExcelEnabled) {
                alertify.error("Online Excel forms are not supported for multiple response surveys");
                CloverApp.API.setDataField("IsExcelEnabled",0);
            }
            
            if(isDirectAccessEnabled) {  
                alertify.error("Direct Access is not supported for multiple response surveys");
                CloverApp.API.setDataField("IsDirectAccessEnabled",0);
                Utils.queueHideControl("IsDirectAccessForComplete","hide");
            }
        }
        
    },
    
    validateSampleList: function (args){
        const listId =  args.data.dictList;
        
        if(listId !== ''00000000-0000-0000-0000-000000000000''){
            Utils.loadingStart("Verifying list has samples...");
            Utils.getRequest("/deployment/CheckListHasSample/" + encodeURIComponent(listId)).then(
                response => {
                    if(!response.result) {
                        CloverApp.API.setDataField("dictList", "");
                        const selectedList = args.component.refs.dictList.state.options[args.component.refs.dictList.state.options.map(e=> e.value).indexOf(listId)].text;
                        alertify.error("Sample List " + selectedList + " is empty.");
                    }else if(Utils.isSelected(args.data.IsAnonymous) && !response.isAnonymousSampleOnly){
                        CloverApp.API.setDataField("dictList", "");
                        alertify.error("Anonymous Survey is ONLY allow for Anonymous Sample.")
                    }
                }, reason => {
                    console.log(''validateSampleList'', reason);
                }
            ).finally(Utils.loadingStop);
        }
    },
    
    getAnonymousSurveyLink: function (args){
        const dplyId =  args.data.Id;
        const qnnId =  args.data.dictQuestionnaire;
        const iconClass = "copy outline icon";
        const iconBtnClass = "ui icon button mini secondary";
        const surveyLinkKey = ''anonymous-survey-'';
        let htmlLink = "";
        Utils.loadingStart();
        Utils.getRequest("/deployment/GenerateAnonymousSurveyURL/" + encodeURIComponent(dplyId) +"/"+ encodeURIComponent(qnnId))
        .then(response => {
                if(response.success && response.result) {
                    htmlLink += ''<div><i style="display:block;margin-bottom:14px;">Click the copy button to get Anonymous Survey URL:</i>'';
                    response.result.forEach(function(item, index){
                        //Does not show as hyperlink due to access anonymous survey will attempt to logout.
                        //let urlLink = ''<li><a href="'' + item.link +''" target="_blank">'' + item.link + ''&nbsp<i>(''+ item.lang +'')</i></a></li>'';
                        let iconBtn = ''<button id="btn-''+surveyLinkKey+index+''" name="btnCopy-anonymous-survey-link" title="Copy" data-link-id="''+surveyLinkKey+index+''" class="''+iconBtnClass+''"><i data-link-id="''+surveyLinkKey+index+''" class="''+iconClass+''" ariahidden="true"></i></button>'';
                        //this urlText is required for the copy action.
                        let urlText = ''<span id="link-''+surveyLinkKey+index+''" style="display:none;">''+item.url +''</span>'';
                        let headerDiv = ''<div style="margin:18px 18px 0px 18px; word-break: break-word;">''+iconBtn +'' '' +item.language + '' '' +urlText+''</div>'';
                        let qrCodeImg = ''<img style="display:block; margin-left:auto; margin-right:auto; margin-bottom:9px; width:200px; height:200px" src="data:image/png;base64,'' + item.qrCode +''"  alt="''+item.url+''"/>'';
                        let listItem = ''<div style="width:210px;margin-bottom:14px;margin-right:14px;float:left;border:1px solid rgba(34, 36, 38, 0.15);">''+ headerDiv + qrCodeImg + ''</div>'';
                        htmlLink += listItem;
                    });
                    
                    htmlLink += "</div>"
                    
                    CloverApp.API.setDataField("anonymousSurveyLink", htmlLink);
                    
                    //Due to security issue does not allow "unsafe inline", bind separately
                    document.getElementsByName("btnCopy-anonymous-survey-link").forEach(function(btn){
                       btn.addEventListener("click",function(e){
                           e.preventDefault();
                           const copyText = document.getElementById("link-" + e.target.getAttribute(''data-link-id'')).innerText
                           navigator.clipboard.writeText(copyText);
                           alertify.success(''Copied to clipboard!'');
                       })
                    });
                }else{
                    CloverApp.API.setDataField("anonymousSurveyLink", "");
                }
            }, reason => {
                console.log(''getAnonymousSurveyLink'', reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    openTagsModal: function(args){
        try{
            let tagsData = args.data.Tags;
            let NumberOfUniqueTagsShows = 10;
            if(Array.isArray(tagsData)){
                NumberOfUniqueTagsShows = NumberOfUniqueTagsShows + tagsData.length;
            }
            Utils.loadingStart();
            Utils.getRequest("/tags/getActiveTags?number=" + encodeURIComponent(NumberOfUniqueTagsShows))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        args.data.TagsSearched = result;
                        CloverApp.API.setDataField("TagsSearched", result);
                        let tagsSearched = result;
                        if(Array.isArray(tagsData)){
                            tagsSearched = tagsSearched.filter(x => !tagsData.includes(x));
                        }
                        qnn_dplyUserActions.rewriteSearchedTags(tagsSearched);
                        qnn_dplyUserActions.rewriteDdTags(args);
                    }
                }, reason => {
                    switch(reason) {
                      case ''TAGS_NOT_FOUND'':
                        qnn_dplyUserActions.rewriteSearchedTags('''');
                        break;
                      default:
                        console.error(reason);
                        alertify.error(reason);
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    searchTagsInDB:function(args){
        try{
            let tagsToSearch = JSON.stringify(args.data.TagsSearch);
            let tagsData = args.data.Tags;
            Utils.loadingStart();
            Utils.getRequest("/tags/searchTags?search=" + encodeURIComponent(tagsToSearch))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        if(Array.isArray(tagsData)){
                            result = result.filter(x => !tagsData.includes(x));
                        }
                        qnn_dplyUserActions.rewriteSearchedTags(result);
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        qnn_dplyUserActions.rewriteSearchedTags("");
                    } else {
                        alertify.error(reason);
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    rewriteSearchedTags:function(data){
        const divTagsSearchResult = function (model) {
            model.children.splice(2);
            if(data.length == 0){
                var label = new Array();
                label[''content''] = "Tag Not Found...";
                label[''data-buildertype''] = "staticcontent";
                label[''key''] = "lblNotFound";
                model.children[2] = label;
            }
            for (x=0;x<data.length;x++){
                var tag = window.globalUserActions.createSearchedTagsButton(data[x]);
                model.children[x+2] = tag;
                if(x==9){
                    //show only 10 result
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    closeTagsModal: function (args){
        args.component.refs.mdlTag.close();
        
        var originalTags = args.data.Tags;
        if(args.data.addedTags != null && originalTags != null){
            originalTags = args.data.Tags.filter(x => !args.data.addedTags.includes(x));
        }
        args.data.Tags = originalTags;
        args.data.addedTags = null;
        CloverApp.API.setDataField("ddTags", null);
        CloverApp.API.setDataField("Tags", originalTags);
    },
    
    saveActiveTags: function(args){
        args.data.addedTags = null;
        //remove duplicate tags
        let newTags = args.data.ddTags;
        newTags = newTags.filter((newTags) => newTags != '' '');
        newTags = newTags.map(newTags => {return newTags.trim()});
        
        var unique = [...new Set(newTags)];
        args.data.ddTags = unique;
        args.data.Tags = unique;
        CloverApp.API.setDataField("ddTags", unique);
        CloverApp.API.setDataField("Tags", unique);
        
        qnn_dplyUserActions.rewriteActiveTags(args);
        args.component.refs.mdlTag.close();
    },
    
    rewriteActiveTags: function(args){
        let divActiveTags = function (model) {
            model.children.splice(2);
            for (x=0;x<args.data.Tags.length;x++){
                var tag = window.globalUserActions.createTagsButton(args.data.Tags[x]);
                model.children[x+2] = tag;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divActiveTags", divActiveTags);
        CloverApp.API.setDataField("divActiveTags", null);
    },
    
    rewriteDdTags: function(args){
        let ddTags = args.data.Tags;
        const ddTagsRewrite = function (model) {
            model[''data-elements''] = new Array();
            return model;
        };
        CloverApp.API.rewriteControlModel("ddTags", ddTagsRewrite);
        CloverApp.API.setDataField("ddTags", ddTags);
    },
    
    addTagToDropdown: function (args){
        var tagsName = args.sourceControlRef.props.additionalParams.model.content;
        let ddTags = args.data.ddTags;
        
        //this is use to remove the added tags when cancel
        if(Array.isArray(args.data.addedTags)) {
            if(!args.data.addedTags.includes(tagsName)) {
                args.data.addedTags.push(tagsName);
            }
        } else {
            args.data.addedTags = new Array(tagsName);
        }
        
        if(ddTags!=null){
            if(!ddTags.includes(tagsName)) {
                ddTags.push(tagsName);
                CloverApp.API.setDataField("ddTags", ddTags);
            }
        } else {
            args.data.ddTags = new Array(tagsName);
        }
        args.component.refs.ddTags.forceUpdate();
    },
    
    removeTagInDiv: function(args){
        var tagKeyName = args.sourceControlRef.props.name
        const divTagsSearchResult = function (model) {
            for(x=0;x<model.children.length;x++){
                if(model.children[x].key == tagKeyName) {
                    model.children.splice(x, 1);
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    addTagsSession: function(args){
        let tagsName = args.sourceControlRef.props.additionalParams.model.content;
        sessionStorage.setItem("tagsName", tagsName);
    },
}' WHERE [Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf';

UPDATE [dwMetadata] SET
[Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.340', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-11-02 15:05:58.450', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2023-11-02T15:05:58.450015+08:00",
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
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnDplyTrigger"
    }
  ],
  "schemes": [
    "DeploymentRequest"
  ],
  "dataMap": [
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
      "id": "5ff5bbc4-a456-559e-c4a0-97641498a8ad",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "control": "VisibleToRespondent",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9aabe66a-0436-b54f-3375-aafdfb544635",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "control": "IpCountry",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "77c80616-2cc4-8e3a-47a1-916e3b253c0a",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "control": "IpRange",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3ed9480e-d106-52bf-6f5b-6055e9675044",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "control": "RestrictIp",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "48323722-f032-b2b1-15ba-2346b03eeaeb",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "control": "RestrictIpInclusive",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "68dd1fb3-a7ba-4da3-e29e-c3c86dc56c1b",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "control": "IsMultipleResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a2a6881-7799-8e4a-eba7-95a661d41d68",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "control": "IsAnonymous",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a52af75b-5993-3104-55da-3834eb95fe46",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "91a4529a-a930-e58f-8e1f-5267bb706693",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6bac7e8b-eff4-6235-3446-46309d7b5fcd",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "control": "EnableWorkflow",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7d6ec65c-7e41-b878-d192-16e9432da0dd",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9a73050-00ea-672f-b10e-3138c1b79ab6",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bc809a51-2fad-044b-d321-9454cfe8f0db",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27cb805c-a635-c840-2433-1a87616a5dc0",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "257bf9f6-6af8-0f42-932b-e42a6016483f",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "936d7192-b817-1a15-9916-e032d4e77277",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a647292-82ca-62ea-4608-e916df1a54b9",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27ecd879-7354-02b8-c642-b8cce602dc9e",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d3fdfdd8-c4ff-5d98-c555-f77268ec9990",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "df1e19f4-7444-56ff-da28-26cdb1423e59",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf01c628-9c75-0af4-9cbc-33ebb397e66e",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "163ac591-1545-9b80-cbb1-44eefe356dd0",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2f7fadb0-ee58-46a1-d654-57eca28fd426",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "control": "IsExcelEnabled",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "020f9a28-e54d-750b-cb60-045ce9ed0c05",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "control": "SurveyName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b17a499b-7d84-0cc9-96d2-58795c553378",
      "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bfa65cde-ed69-b522-cae6-f91eccaa1dad",
      "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b8cd14dc-2364-8ef6-2230-c18d9d9f2dc2",
      "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
      "control": "textApiIdentifier",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb4bde3f-4a8a-c6ae-c6ae-b88664a83f9f",
      "attributeId": "50dc8926-bba9-4c03-9a59-267aab2f1999",
      "control": "IsExposeListProperties",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "729f2391-b64a-5198-beb1-947ec62f6f16",
      "attributeId": "31d51bc5-36d1-4d4a-9ba3-800e5245f1d8",
      "control": "IsDirectAccessEnabled",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f5ed2dad-6f5b-d741-a5e9-d94f9b0d242e",
      "attributeId": "d71d57fd-f787-4130-ac9e-28276b1988ed",
      "control": "IsDirectAccessForComplete",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ae906195-d1ed-a375-9361-17acb9d583e5",
      "attributeId": "f05b253e-d4b3-4cda-bd78-0175b0b18e07",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aea6df5c-cf81-6caa-ad26-375769226477",
      "attributeId": "595da6d0-43c2-4faf-8b64-242a5e2a9c10",
      "control": "IsIncludeUnansweredSection",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment"
}' WHERE [Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd';

