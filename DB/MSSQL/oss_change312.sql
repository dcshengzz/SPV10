-- Will UPDATE existing row(s) in dwMetadata for the following:
-- ChoiceCount-code.js
-- RespondentParticipationReport-code.js

UPDATE [dwMetadata] SET
[Id]='bbe4b066-f1b6-4bb0-85a8-6d474bdb7945', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ChoiceCount-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-12-02 15:17:19.097', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-24 11:14:46.580', 
[Data]=N'{
    
    getCounts: function(args) {
        
        if(!args.data.dplyId){ 
            CloverApp.API.setDataField("dplychoiceqnns", null);
            return;
        }
        
        CloverApp.API.setDataField("dplychoiceqnns", args.data.dplyId);
        
    },
    
    onExport: function(args) {
        const formData = new FormData();
        formData.append(''dplyId'', args.data.dplyId);
        Utils.loadingStart();
        Utils.postFormRequest("/report/exportanswerchoicecount", formData).then(
            response => {
                alertify.success(response.message);
            }, reason => {
                console.log("Export error",reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },

}' WHERE [Id]='bbe4b066-f1b6-4bb0-85a8-6d474bdb7945';

UPDATE [dwMetadata] SET
[Id]='4d879db0-1a88-4b78-80f7-03229fb983b0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'RespondentParticipationReport-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-04-05 13:38:21.357', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-24 11:12:05.100', 
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
        Utils.postFormRequest("/report/respondentparticipation",formData).then(
            response => {
                alertify.success(response.message);
            }, reason => {
                alertify.error(reason);
                console.log("purgeData error", reason);
            }
        ).finally(Utils.loadingStop);
    }
}' WHERE [Id]='4d879db0-1a88-4b78-80f7-03229fb983b0';

