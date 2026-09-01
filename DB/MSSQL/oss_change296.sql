-- Will UPDATE existing row(s) in dwMetadata for the following:
-- RespondentParticipationReport-code.js

UPDATE [dwMetadata] SET
[Id]='4d879db0-1a88-4b78-80f7-03229fb983b0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'RespondentParticipationReport-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-04-05 13:38:21.357', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-08 13:33:26.333', 
[Data]=N'{
    init: function(args){
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);
    },
    
    //gridview must not in any container
    updateFilter: function(args) {
        const data = args.data;
        const searchUID = data.UID ? data.UID : null;
        const searchRespName = data.RespName ? data.RespName : null;
        const filterDeploymentName = data.DeploymentName ? data.DeploymentName : "";
        const filterStatus = data.Status ? data.Status : "";
        
        const filter = [];
        if(searchUID) {
            filter.push({
               column: "UID",
               nextValue: searchUID,
               term: "like",
               value: searchUID,
            });
        }
        
        if(searchRespName) {
            filter.push({
               column: "RespondentName",
               nextValue: searchRespName,
               term: "like",
               value: searchRespName,
            });
        }
        
        if(filterDeploymentName != "") {
            filter.push({
               column: "Id",
               nextValue: filterDeploymentName,
               term: "in",
               value: filterDeploymentName,
            });
        }
        
        if(filterStatus != "") {
            filter.push({
               column: "StatusId",
               nextValue: filterStatus,
               term: "in",
               value: filterStatus,
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridview_1: filter,
                        }
                    }
                }
            }    
        };
        return delta;
    },
    
    
    onExport: function(args) {
        const formData = new FormData();
        if(args.data.UID != undefined){
            formData.append(''UID'', args.data.UID);
        }
        if(args.data.RespName != undefined){
            formData.append(''RespName'', args.data.RespName);
        }
        
        if(args.data.Status != undefined){
            formData.append(''StatusId'', args.data.Status);
        }
        
        if(args.data.DeploymentName != undefined){
            formData.append(''DplyId'', args.data.DeploymentName);
        }
        Utils.loadingStart();
        fetch("/report/respondentparticipation", {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            }
        ).then(
            response => response.blob()
        ).then(blob => {
            Utils.loadingStop();
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement(''a'');
            a.href = url;
            a.download = ''RespondentParticipationReport.csv'';
            document.body.appendChild(a); // we need to append the element to the dom -> otherwise it will not work in firefox
            a.click();    
            a.remove();  //afterwards we remove the element again  
        })
        .catch(error => {
            Utils.loadingStop();
            console.log(error);
            alertify.error(error.message);
        });
    }
}' WHERE [Id]='4d879db0-1a88-4b78-80f7-03229fb983b0';

