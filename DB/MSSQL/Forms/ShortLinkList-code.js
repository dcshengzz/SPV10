{
    updateFilter: function(args) {
        console.log("args to updateFilter", args);
        const data = args.data;
        
        const search = data.FilterSearch ? data.FilterSearch : null;
        const linkType = data.FilterLinkType ? data.FilterLinkType : "ALL";
        const status = data.FilterStatus ? data.FilterStatus : "ALL";
        
        const filter = [];
        if(search) {
            filter.push({
               column: "Name, DisplayDescription, DisplayTarget",
               nextValue: search,
               term: "like",
               value: search,
            });
        }
        if("ALL" != linkType) {
            filter.push({
               column: "LinkType",
               nextValue: linkType,
               term: "=",
               value: linkType,
            });
        }
        if("ALL" != status) {
            filter.push({
               column: "Status",
               nextValue: status,
               term: "=",
               value: status,
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridShortLink: filter,
                        }
                    }
                }
            }    
        };
        console.log("delta", delta);
        return delta;
    }
}