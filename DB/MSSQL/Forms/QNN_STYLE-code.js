{
    clearServerCache: function(args){
        const url = '/customcssstyle/clearCache';
        return fetch(url,
            {
                credentials: 'same-origin',
                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                method: 'post'
            })
        return;
    }
    
}



