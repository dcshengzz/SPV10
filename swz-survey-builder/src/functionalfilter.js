class FilterTerms {
    static get Greater ()
    {
        return ">";
    }
    static IsGreater (value)
    {
        return value === FilterTerms.Greater;
    }
    static get Less ()
    {
        return ">";
    }
    static IsLess (value)
    {
        return value === FilterTerms.Less;
    }
    static get Equal ()
    {
        return "=";
    }
    static IsEqual (value)
    {
        return value === FilterTerms.Equal;
    }
    static get GreaterOrEqual ()
    {
        return ">=";
    }
    static IsGreaterOrEqual (value)
    {
        return value === FilterTerms.GreaterOrEqual;
    }
    static get LessOrEqual ()
    {
        return "<=";
    }
    static IsLessOrEqual (value)
    {
        return value === FilterTerms.LessOrEqual;
    }
    static get NotEqual ()
    {
        return "!=";
    }
    static IsNotEqual (value)
    {
        return value === FilterTerms.NotEqual;
    }
    static get Like ()
    {
        return "like";
    }
    static IsLike (value)
    {
        return value.toLowerCase() === FilterTerms.Like || value.toLowerCase() === "*like*";
    }
    static get StartsWith ()
    {
        return "like*";
    }
    static IsStartsWith (value)
    {
        return value.toLowerCase() === FilterTerms.StartsWith;
    }
    static get EndsWith ()
    {
        return "*like";
    }
    static IsEndsWith (value)
    {
        return value.toLowerCase() === FilterTerms.EndsWith;
    }
    static Evaluate (value, expected, term)
    {
        if (FilterTerms.IsGreater(term))
        {
            return FilterTerms.compareWithTypeCheck(value,expected,(v,e)=>v>e);
        }
        if (FilterTerms.IsLess(term))
        {
            return FilterTerms.compareWithTypeCheck(value,expected,(v,e)=>v<e);
        }
        if (FilterTerms.IsEqual(term))
        {
            return FilterTerms.compareWithTypeCheck(value,expected,(v,e)=>v===e);
        }
        if (FilterTerms.IsGreaterOrEqual(term))
        {
            return FilterTerms.compareWithTypeCheck(value,expected,(v,e)=>v>=e);
        }
        if (FilterTerms.IsLessOrEqual(term))
        {
            return FilterTerms.compareWithTypeCheck(value,expected,(v,e)=>v<=e);
        }
        if (FilterTerms.IsNotEqual(term))
        {
            return FilterTerms.compareWithTypeCheck(value,expected,(v,e)=>v!==e);
        }
        if (FilterTerms.IsLike(term))
        {
            return FilterTerms.likeCompare(value,expected,(v,e)=>v.indexOf(e)>=0);
        }
        if (FilterTerms.IsStartsWith(term))
        {
            return FilterTerms.likeCompare(value,expected,(v,e)=>v.startsWith(e));
        }
        if (FilterTerms.IsEndsWith(term))
        {
            return FilterTerms.likeCompare(value,expected,(v,e)=>v.endsWith(e));
        }

        throw "Unknown term " + term;
    }

    static likeCompare (value,expected,comparator)
    {
        if (value === null && expected === null)
            return true;

        if (value === undefined && expected === undefined)
            return true;

        if (value === null || value === undefined)
            return false;

        if (expected === null || expected === undefined)
            return false;
        return comparator(value.toString().toLowerCase(),expected.toString().toLowerCase());
    }

    static compareWithTypeCheck (value, expected, comparator)
    {
        if (value === null && expected === null)
            return true;

        if (value === undefined && expected === undefined)
            return true;

        if (value === null || value === undefined)
            return false;

        if (expected === null || expected === undefined)
            return false;

        if (typeof value === typeof expected)
        {
            return comparator(value,expected);
        }
        else if (typeof value === "number" && typeof expected === "string")
        {
            return comparator (value,parseFloat(expected));
        }
        else if (typeof value === "string" && typeof expected === "number")
        {
            return comparator (value,expected.toString());
        }
        else
        {
            return comparator(value,expected);
        }
    }
}

class FunctionalFilter
{
    constructor(objectFilter,columns)
    {
        this._innerFilter = {};
        if (objectFilter === undefined || !Array.isArray(objectFilter))
            return;
        if (columns === undefined || !Array.isArray(columns))
            throw "columns must be array";

        objectFilter.forEach((el)=>{
            if (el === undefined)
                return;
            let applyToColumns;
            if (el.column === "*")
            {
                applyToColumns = columns;
            }
            else
            {
                applyToColumns = el.column.split(",").map(n=>n.trim());
            }

            this.AddFilter({names:applyToColumns,expected:el.value,term:el.term})
        })
    }

    AddFilter ({names,expected,term,id}) {
        if (names.length < 1)
            return;

        let filterId = names.length === 1 ? names[0] : names.sort().join("_");
        let filter;
        if (!this._innerFilter.hasOwnProperty(filterId)) {
            filter = this._innerFilter[filterId] = {};
            filter.funcs = [];
            filter.items = [];
            filter.test = (r) => this._innerFilter[filterId].funcs.every((f) => f(r));
        }
        else {
            filter = this._innerFilter[filterId];
        }


        let compFunc;
        let singleCompFunc = (r, name) => {
            const propName = Object.keys(r).find(k => k.toString().toLowerCase() === name.toLowerCase());
            if (propName !== undefined) {
                const result = FilterTerms.Evaluate(r[propName], expected, term);
                return result;
            }
            else
                return false;
        }

        if (names.length === 1) {
            compFunc = (r) => singleCompFunc(r,names[0]);
        }
        else {
            compFunc = (r) => names.some((name) => singleCompFunc(r,name));
        }
        filter.funcs.push(compFunc);
        filter.items.push({expected, term, id});
    }

    RemoveFilter ({name, id})
    {
        let filterId;
        let names;
        if (name !== undefined) {
            if (Array.isArray(name)) {
                filterId = name.length === 1 ? name[0] : name.sort().join("_");
                names = name;
            }
            else {
                filterId = name;
                names = [name];
            }
        }

        if (name !== undefined && id === undefined)
        {
            delete this._innerFilter[filterId];
        }
        else if (name === undefined && id === undefined)
        {
            this._innerFilter = {};
        }
        else {
            let recreateProperty = (filterId,names,id) => {
                if (!this._innerFilter.hasOwnProperty(filterId))
                    return;
                let newItems = this._innerFilter[filterId].items.filter((el) => el.id !== id);
                if (newItems.length < this._innerFilter[filterId].items.length) {
                    delete this._innerFilter[filterId];
                    newItems.forEach((ni) => {
                        this.AddFilter({names, expected: ni.expected, term: ni.term, id: ni.id});
                    })
                }
            };

            if (name !== undefined && id !== undefined) {
                recreateProperty(filterId,names,id);
            }
            else {
                const allFilterIds = Object.keys(this._innerFilter);
                allFilterIds.forEach((filterId)=>{
                    recreateProperty(filterId,filterId.split("_"),id);
                })
            }
        }
    }

    IsRowMatched (row)
    {
        const allNames = Object.keys(this._innerFilter);
        if (allNames.length <= 0)
            return true;

        for (let i = 0; i < allNames.length; i++)
        {
            if (!this._innerFilter[allNames[i]].test(row))
                return false;
        }

        return true;
    }

    GetFilterAsObjects (){
        if (this._innerFilter === undefined)
            return [];
        let result = [];
        const allNames = Object.keys(this._innerFilter);
        allNames.forEach((pn)=>{
            this._innerFilter[pn].items.forEach((i) => {
                result.push({column:pn.replace(/_/g,","),value:i.expected,term:i.term});
            })
        });
        return result;
    }
}

export { FilterTerms, FunctionalFilter }