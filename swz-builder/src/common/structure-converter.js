
function initPush(arrayName, obj, toPush) {
    if (obj[arrayName] === undefined) {
        obj[arrayName] = [];
    }
    obj[arrayName].push(toPush);
}

function multiInitPush(arrayName, obj, toPushArray) {
    var len;
    len = toPushArray.length;
    if (obj[arrayName] === undefined) {
        obj[arrayName] = [];
    }
    while (len-- > 0) {
        obj[arrayName].push(toPushArray.shift());
    }
}


export default class StructureConverter {

    constructor(config) {
        this.config = config = config || {};
        this.config.id = config.id || 'id';
        this.config.parent = config.parent || 'parent';
        this.config.children = config.children || 'nodes';
        this.config.options = config.options || { deleteParent: false };
    }
 
    toNested(flat, rootNodeId) {
        var i, len, temp, roots, id, parent, pendingChildOf, flatEl;
        i = 0;
        roots = [];
        temp = {};
        pendingChildOf = {};

        for (i, len = flat.length; i < len; i++) {
            flatEl = flat[i];
            id = flatEl[this.config.id];
            parent = flatEl[this.config.parent];
            temp[id] = flatEl;
            if (parent === rootNodeId) {
                roots.push(flatEl);
            } else {
                if (temp[parent] !== undefined) {
                    // Parent is already in temp, adding the current object to its children array.
                    initPush(this.config.children, temp[parent], flatEl);
                } else {
                    // Parent for this object is not yet in temp, adding it to pendingChildOf.
                    initPush(parent, pendingChildOf, flatEl);
                }
            }

            if (this.config.options.deleteParent) {
                delete flatEl[this.config.parent];
            }

            if (pendingChildOf[id] !== undefined) {
                // Current object has children pending for it. Adding these to the object.
                multiInitPush(this.config.children, flatEl, pendingChildOf[id]);
            }
        }

        return roots;
    }

}