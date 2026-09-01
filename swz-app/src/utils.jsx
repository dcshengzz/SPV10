import merge from 'deepmerge'
import store from './store.jsx'

const convertParentChildArrayToTree =
    function (pcarr, idgetter = (pci) => pci.id, parentidgetter = (pci) => pci.parentId, sortgetter = (pci) => pci.SortOrder) {
        let root = null;
        let clearedpcarr = pcarr.map((pci) => ({ id: idgetter(pci), parentid: parentidgetter(pci), order: sortgetter(pci) }));

        let roots = clearedpcarr.filter((pci) => !pci.parentid);
       
        if (roots.length === 1) {
            root = [roots[0]];
            root.parent = null;
            root.children = clearedpcarr.filter((pci) => pci.parentid === root.id).sort((pci) => pci.sort);
        }
        else if (roots.length === 0) {
            throw ('At least one element have to be a parent');
        } else {
            root = { id: null, parentid: null };
            root.parent = null;
            root.children = roots.sort((pci) => pci.sort);;
        }

        let processChild = (child, parent) => {
            child.parent = parent;
            child.children = clearedpcarr.filter((pci) => pci.parentid === child.id).sort((pci) => pci.sort);
            if (child.children && child.children.length > 0)
                child.children.forEach((c)=>processChild(c,child));
        };
        if (root.children && root.children.length > 0)
            root.children.forEach((c) => processChild(c, root));
        return root;
    };

const jsonEqual = 
    function(a, b) {
        return JSON.stringify(a) === JSON.stringify(b);
    };

const encodeQueryData =
    function (data) {
    let ret = [];
    var state = store.getState();
    
    if (state.app.impersonatedUserId){
        ret.push('impersonatedUserId=' + encodeURIComponent(state.app.impersonatedUserId));
    }
    
    for (let d in data)
            if (data.hasOwnProperty(d))
                ret.push(encodeURIComponent(d) + '=' + encodeURIComponent(data[d]));
    return ret.join('&');
    };

const isObject = function (item) {
    return (item && typeof item === 'object' && !Array.isArray(item));
};

function isEmptyObject(obj) {
    for (var prop in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, prop)) {
            return false;
        }
    }
    return true;
}

function findFormElement(model, value, propertyName = "key") {
    let findFunc = (item) => {
        if (item[propertyName] === value)
            return item;
        let found = null;
        if (item.children && item.children.length > 0)
            found = item.children.find(ci => findFunc(ci) != null);
        return found;

    };
    let findInArray = (array) => {
        for (let i = 0; i < array.length; i++) {
            let result = findFunc(array[i]);
            if (result)
                return result;
        }
        return null;
    }

    return findInArray(model);
}

const dontMerge = (destination, source) => source;


const mergeDeep = function(target, source) {
    let result = merge(target, source, { arrayMerge: dontMerge });
    return result;
};

const uuid = () => {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
};

const isNull= (value) =>
{
    if (typeof value === 'object' && value === null)
        return true;
    
    if (typeof value !== 'undefined')
    {
        return false;
    }
    return true;
};

const dateFormat = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}(?:\.\d*)?)(Z|([+\-])(\d{2}):(\d{2}))$/;

function dateReviver(key, value) {
    if (typeof value === "string" && dateFormat.test(value)) {
        return new Date(value);
    }
    //else if(typeof value === "string" && value!==null && value!==undefined && value!="" && !isNaN(value)){
    //
//	if(isInteger(Number(value))){
    //    	return Number(value);
//	}
//	else if(isFloat(Number(value))){
//		return value;
//	}
//	
    //}
    else if(typeof value === "string" && value.toLowerCase() === 'true'){
        return 1;	
    }
    else if(typeof value === "string" && value.toLowerCase() === 'false'){
        return 0;	
    }		
    return value;
}

function isFloat(n){
 return n === +n && n !== (n|0);
}

function isInteger(n){
 return n === +n && n === (n|0);
}

function cloneDataObject(dataObject) {
    var cloned = {...dataObject};
    for(let property in cloned) {
        if (Array.isArray(cloned[property]))
        {
            var clonedArray = [];
            dataObject[property].forEach(i=>{
                if(typeof(i) == "object") clonedArray.push({...i});
                else clonedArray.push(i);
            });
            cloned[property] = clonedArray;
        }
    }
    return cloned;
}

function encodeHtml(html) {
    const node = document.createElement('div');
    html.split('\n').forEach(line => {
        node.appendChild(document.createTextNode(line));
        node.appendChild(document.createElement('br'));
    });
    node.removeChild(node.lastChild);
    return node.innerHTML;
}

export { convertParentChildArrayToTree, encodeHtml, jsonEqual, encodeQueryData, isEmptyObject, findFormElement, mergeDeep, uuid, isNull, dateReviver, cloneDataObject }
