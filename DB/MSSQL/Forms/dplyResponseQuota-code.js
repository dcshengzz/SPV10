{
    init: function(args) {
        
    },
    
    validate: function(args){
        
        CloverApp.API.formValidate(args);
        
        let hasError = false;
        const errors = {main: {}};
        const errorMessages = [];
        
        const isUsingStratum = args.data.StrataSource!=null && args.data.StrataSource.length>0;
        if(isUsingStratum) {
            const stratum = args.data.Stratum ?? [];
            //check that at least one is defined
            if(stratum.length==0) {
                errorMessages.push("Please define at least one strata");
                errors.main.Stratum = true;
                hasError = true;
            }
            //check that each row has a stratavalue
            if(!stratum.every(row=>typeof row.StrataValue==="string" && row.StrataValue!="")) {
                errorMessages.push("'StrataValue' must be specified for all Strata rows");
                errors.main.Stratum = true;
                hasError = true;
            }
            
            //check all rows specified a valid MaxResponse
            const validMaxResponse = maxResponse => maxResponse!=null && (/^-?\d+$/.test(maxResponse)) && Number(maxResponse)!=NaN && Number(maxResponse)>=-1; 
            //stratum.forEach(row => console.log(row.MaxResponse, (/^-?\d+$/.test(row.MaxResponse)), validMaxResponse(row.MaxResponse) ) );
            if(!stratum.every(row=>validMaxResponse(row.MaxResponse))) {
                errorMessages.push("'Maximum Responses' must be -1, 0, or a positive whole number for all Strata rows");
                errors.main.Stratum = true;
                hasError = true;
            }
            //check that each row has a unique stratavalue (case-insensitive)
            const strataValues = new Set(stratum.map(row=>row.StrataValue?row.StrataValue.toUpperCase():""));
            if(strataValues.size != stratum.length) {
                errorMessages.push("'StrataValue' must be unique among the defined stratum for this deployment");
                errors.main.Stratum = true;
                hasError = true;
            }
        }
        
        if(hasError){
            throw {
                level: 1,
                message: errorMessages,
                formerrors: errors
            };
        }
        
    },
}