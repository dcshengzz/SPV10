--add animation when adding/edit dataeditor for a deployment.
--add animation when doing imputation

------------------------------

UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='A6712791-65C1-463B-BD07-3A2BDAC69C68', [Folder]=N'metadata/forms', [Filename]=N'dplysampleowner-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:19.640', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-03-16 10:22:18.953', [Data]=N'{
 
    logToConsole: function(args){
        $(".react-grid-Canvas").trigger(''click'');
        console.log(''logToConsole args'', args)
    },
    saveDplySampleOwner: function(args){
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
        
        
        //console.log(''saveDplySampleOwner args'', args)
        var dplyId = args.data.Id;
        var userId = args.data.DataEditor;
        console.log("User id is", userId);
        var gridItems = args.controlRef.state.items;
        var gridSelectedIndexes =  args.controlRef.state.selectedIndexes;
        var listSampleIds = [];
        gridSelectedIndexes.forEach( function(i) { 
            // ... do something with s ...
            listSampleIds.push(gridItems[i].ListSampleId);
        } );

        //console.log(''listSampleIds:'', listSampleIds);
        
        var formData = new FormData();
        formData.append(''userId'', userId);
        formData.append(''dplyId'', dplyId);
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/deployment/setDataEditor'';
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
                    alertify.success(response.message);
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            })
            .finally(() => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');                
            });
    },
    setOwnerSample: function(args){
        
        var dplyId = args.data.Id;
        var userId = args.data.DataEditor;
        if(userId=="" || userId==null || (Array.isArray(userId) && userId.length>1)){
            args.controlRef.state.selectedIndexes = [];
            return {};
        }         
        
        var gridItems = args.controlRef.state.items;
       
        var formData = new FormData();
        formData.append(''userId'', userId);
        formData.append(''dplyId'', dplyId);
        var url = ''/deployment/getownersample'';
        var selectedListSampleIds = [];

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
                    //console.log(''setOwnerSample args:'', args);
                    if(response.item.length>0){
                        var listSampleIds = response.item;
                        for (var i = 0; i < gridItems.length; i++) {
                            if(gridItems[i]==undefined || gridItems[i]==null) break;
                            if(listSampleIds.includes(gridItems[i].ListSampleId)){
                                selectedListSampleIds.push(i);
                               
                            }
                        }
                        //console.log(''selectedListSampleIds'', selectedListSampleIds);
                        args.controlRef.state.selectedIndexes = selectedListSampleIds;
                       
                    }
                    else{
                        args.controlRef.state.selectedIndexes = [];
                    }
                     args.controlRef.forceUpdate();

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });
            

    },
    clearGridCheckboxes: function(args){
         args.controlRef.state.selectedIndexes = [];
    }
    
        
    
}', [StructDivisionId]=NULL WHERE ([Id]='A6712791-65C1-463B-BD07-3A2BDAC69C68');
GO
-------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='B1F0C760-698D-4018-85FF-4DEBEBF9EDF8', [Folder]=N'metadata/forms', [Filename]=N'dplyImputation-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2020-01-07 13:14:00.780', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-03-16 11:06:29.657', [Data]=N'{
    addAllFields: function(args){
        var allFields = args.controlRef.state.options.map(function(option){
            return option.key;
        });
        CloverApp.API.setDataField("DeploymentQnnFields", allFields);
    },
    removeAllFields: function(args){
        CloverApp.API.setDataField("DeploymentQnnFields", []);
    },    
    
    impute: function(args){
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});        
        
        var fieldIds = args.controlRef.props.value;
        if(!fieldIds || fieldIds.length==0){
            alertify.error("Please select at least one field");
            return;
        }
        var dplyId = args.data.Id;
        var sourceDplyId = args.data.Deployment;
        var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''fieldIds'', fieldIds); 
        formData.append(''sourceDplyId'', sourceDplyId);         
        var url = ''/deployment/impute'';
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
                    alertify.success(response.message);
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            })
            .finally(() => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');                
            });            
    }
 
}', [StructDivisionId]='72D461B2-234B-40D6-B410-B261964BA291' WHERE ([Id]='B1F0C760-698D-4018-85FF-4DEBEBF9EDF8');
GO
------------------
