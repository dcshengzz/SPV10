{
    updateFilter: function(args) {
        console.log("args to updateFilter", args);
        const data = args.data;
        
        const search = data.FilterSearch ? data.FilterSearch : null;
        const type = data.FilterType ? data.FilterType : "ALL";
        
        const filter = [];
        if(search) {
            filter.push({
               column: "Topic, Heading",
               nextValue: search,
               term: "like",
               value: search,
            });
        }
        if("ALL" != type) {
            filter.push({
               column: "Type",
               nextValue: type,
               term: "=",
               value: type,
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridHelp: filter,
                        }
                    }
                }
            }    
        };
        console.log("delta", delta);
        return delta;
    }
}