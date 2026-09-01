{
    
    updateFilter: function(args) {
        console.log("args to updateFilter", args);
        const data = args.data;
        
        const search = data.FilterSearch ? data.FilterSearch : null;
        
        const filter = [];
        if(search) {
            filter.push({
               column: "Name, Description",
               nextValue: search,
               term: "like",
               value: search,
            });
        }
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridRule: filter,
                        }
                    }
                }
            }    
        };
        console.log("delta", delta);
        return delta;
    },
    
    clearServerCache: function(args){
        const url = '/datavalidationrule/clearCache';
        return fetch(url,
            {
                credentials: 'same-origin',
                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                method: 'post'
            })
        return;
    }
    
}