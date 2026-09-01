const timeoutsIdNameMap = {};

export default class Timeout {
    static Set (name,callback,delay)
    {
        if (timeoutsIdNameMap.hasOwnProperty(name))
        {
            clearTimeout(timeoutsIdNameMap[name]);
        }

        const timeoutId = setTimeout (callback,delay);
        timeoutsIdNameMap[name] = timeoutId;
    }

    static Clear (name)
    {
        if (timeoutsIdNameMap.hasOwnProperty(name))
        {
            clearTimeout(timeoutsIdNameMap[name]);
            delete timeoutsIdNameMap[name];
        }
    }

}