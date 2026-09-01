{
     init: function(args){
        if(args.data.NewValue instanceof Array) {
            CloverApp.API.setDataField("NewValue", JSON.stringify(args.data.NewValue,null,"\t")); 
        }

        if(args.data.OriginalValue instanceof Array) {
            CloverApp.API.setDataField("OriginalValue", JSON.stringify(args.data.OriginalValue,null,"\t"));
        }

        const formattedEventDate = args.data.EventDate
            ?           (args.data.EventDate.getYear()+1900) 
                + "-" + (args.data.EventDate.getMonth()+1).toString().padStart(2,"0") 
                + "-" + args.data.EventDate.getDate().toString().padStart(2,"0")
                + " " + args.data.EventDate.getHours().toString().padStart(2,"0")
                + ":" + args.data.EventDate.getMinutes().toString().padStart(2,"0")
                + ":" + args.data.EventDate.getSeconds().toString().padStart(2,"0")
                + "." + args.data.EventDate.getMilliseconds().toString().padStart(3,"0")
            : null;
        CloverApp.API.setDataField("FormattedEventDate", formattedEventDate);
    }, 
    
    cancel: function(args) {
        if(window.opener)
            window.close();   
        else 
            CloverApp.API.redirect("form", "AuditTrail");
    },
    
}