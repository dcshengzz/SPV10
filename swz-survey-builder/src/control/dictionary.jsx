import React, { Component } from 'react'
import { Form, Dropdown, Menu } from 'semantic-ui-react'

export default class Dictionary extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            options: []
        }

        this.pageSize = props.pageSize;
        if(this.pageSize == undefined || this.pageSize == "")
            this.pageSize = 100;
    }

    static getDerivedStateFromProps(nextProps, prevState) {
        if (nextProps.dataModel != prevState.dataModel) {
            return {
                getAdditionalDataForControl: nextProps.getAdditionalDataForControl,
                dataModel: nextProps.dataModel,
                needFetch: true,
                needValueFetch: true
            }
        }

        if(nextProps.paging && nextProps.value != prevState.value && nextProps.value != undefined){
            return {
                needValueFetch: true
            };
        }

        return null;
    }

    componentDidMount() {
        this.GetAdditionalData();
    }

    componentDidUpdate(prevProps, prevState) {
        this.GetAdditionalData();
    }

    GetAdditionalData() {
        if (this.state.dataModel === undefined) {
            if (console !== undefined && this.props.buildermode == true)
                console.log("Dictionary: Set DataModel label!");
        }
        else if (this.state.getAdditionalDataForControl === undefined) {
            if (console !== undefined && this.props.buildermode == true)
                console.log("Dictionary: For paging on server need to set getAdditionalDataForControl func!");
        }
        else{
            if (this.state.needFetch) {
                let me = this;
                var settings = {model: this.state.dataModel};
                var lastLoadPage = 0;
                if(this.props.paging){
                    settings.startIndex = 0;
                    settings.pageSize = this.pageSize;
                }
                
                this.state.isFetching = true;
                this.state.needFetch = false;
                this.state.getAdditionalDataForControl(this, settings, function ({items, rowsCount}) { //TODO cancellation token from async request
                    me.setData({items, rowsCount, page: lastLoadPage}, true);
                });
            }

            if(this.state.needValueFetch){
                this.state.needValueFetch = false;
                this.loadCurrentValue();
            }
        }
    }

    render() {
        var me = this;

        var controlProps = {};
        for (var p in this.props) {
            if (p == "parentIsForm" ||
                p == "getAdditionalDataForControl" ||
                p == "dataModel" ||
                p == "clearable" ||
                p == "columns" ||
                p == "paging" ||
                p == "pageSize")
                continue;
            controlProps[p] = this.props[p];
        }

        if(this.props.readOnly)
            controlProps.disabled = true;

        controlProps.options = this.state.options;
        controlProps.onChange = this.onChange.bind(this);
        if(this.props.paging){
            controlProps.onSearchChange = this.handleSearchChange.bind(this);
            controlProps.onClose = this.onClose.bind(this);
            if(this.state.open){
                controlProps.open = true;
            }
        }

        if (controlProps.multiple) {
            if (controlProps.value == undefined || controlProps.value == null) {
                controlProps.value = [];
            }

            if (!Array.isArray(controlProps.value)) {
                controlProps.value = this.getArrayValues(controlProps.value);
            }
        }

        controlProps.loading = this.state.isFetching;
        controlProps.searchQuery = this.state.searchQuery;

        if (this.props.parentIsForm) {
            return <Form.Dropdown {...controlProps} />;
        }
        else {
            let divClass = "ui labeled input";

            if(this.props.fluid)
                divClass += " fluid";
            
            if(this.props.error)
                divClass += " error";
            return <div className={divClass}>
                {this.props.label != undefined && <div className="ui label label">{this.props.label}</div>}
                <Dropdown {...controlProps} />
            </div>;
        }
    }

    onChange(e, {name, value}) {
        let loadFlag = false;
        if(this.props.multiple){
            if(Array.isArray(value)){
                let isFind = false;
                value.forEach(function(v){
                    if(v === "__load"){
                        isFind = true;
                    }
                });

                if(isFind){
                    loadFlag = true;
                }
            }
        }
        else if(value === "__load"){
            loadFlag = true;
        }

        if(loadFlag){
            this.state.open = true;
            this.setState({isFetching: true});
            this.loadNextPage();
            value = this.props.value;
        }
        else if(this.state.open != undefined){
            this.state.open = undefined;
        }

        if (this.props.onChange != undefined)
            this.props.onChange(e, {name: this.props.name, value});
    }

    onClose(){
        if(this.state.open != true && this.state.searchQuery != ""){
            this.state.isFetching = true;
            this.state.searchQuery = "";
            this.state.lastLoadPage = -1;

            this.loadNextPage(true);
        }
    }

    handleSearchChange(e, { searchQuery }){
        let me = this;
        setTimeout(function(){
            me.setState({
                isFetching : true,
                searchQuery: searchQuery,
                lastLoadPage: -1
            });
            
            me.loadNextPage(true);
        }, 100);
    }

    loadNextPage(reset){
        var me = this;
        var settings = {model: this.state.dataModel};
        var page = this.state.lastLoadPage + 1;
        
        if(me.state.searchQuery != undefined && me.state.searchQuery != ""){
            settings.filters = [{
                column: this.getCollumnsForFilter(),
                term: "like",
                value: me.state.searchQuery
            }];
        }
        
        settings.startIndex = page * this.pageSize;
        settings.pageSize = this.pageSize;

        this.state.getAdditionalDataForControl(this, settings, function ({items, rowsCount}) {
            me.setData({items, rowsCount, page: page}, reset);
        });
    }

    setData({items, rowsCount, page}, reset){
        let options = undefined;
        if(reset){
            options = items;
            if(rowsCount > options.length){
                let text = (this.state.searchQuery != undefined ? this.state.searchQuery : "") + "...";
                options.push({key: "__load", value: "__load", text});
            }

            if (Boolean(this.props.clearable) && !Boolean(this.props.multiple)) {
                options.unshift({key: "__reset", value: "", text: "   "});
            }

            if(Boolean(this.props.multiple)){
                let values = this.getArrayValues(this.props.value)
                for(let i=0; i< values.length; i++){
                    let value = values[i];
                    for(let j=0; j< this.state.options.length; j++){
                        let option = this.state.options[j];
                        if(value == option.value){
                            options.unshift(option);
                        }
                    }
                }
            }
        }
        else{
            options = this.state.options;
            let loadingItem = undefined
            if(options.length > 0 && options[options.length - 1].key == "__load"){
                loadingItem = options.pop();
            }
            
            for(let i=0; i < items.length; i++){
                let item = items[i];
                for(let j = 0; j < options.length; j++){
                    let option = options[j];
                    if(option.key == item.key){
                        options.splice(j, 1);
                        break;    
                    }
                }
                options.push(item);
            }
            
            if(loadingItem != undefined && rowsCount > options.length)
                options.push(loadingItem);
        }
        
        this.setState({
            needFetch: false, 
            options: options,
            rowsCount, 
            isFetching: false, 
            lastLoadPage: page });
    }

    getArrayValues(value){
        let res = value;
        if (!Array.isArray(res)) {
            let valueArray;
            try {
                valueArray = JSON.parse(res);
            }
            catch (e) {
            }
            ;

            if (!Array.isArray(valueArray)) {
                valueArray = [res];
            }

            res = valueArray;
        }
        return res;
    }

    loadCurrentValue(){
        var me = this;
        if(this.props.value != undefined && this.props.value != null){
            if(this.props.multiple){
                let values = this.getArrayValues(this.props.value);
                let unfindedValues = [];
                for(let i=0; i < values.length; i++){
                    let value = values[i];
                    let isFind = false;
                    for(let j=0; j<this.state.options.length; j++)
                    {
                        let option = this.state.options[j];
                        if(option.value == value){
                            isFind = true;
                            break;
                        }
                    }
                    
                    if(!isFind){
                        unfindedValues.push(value);
                    }
                }

                if(unfindedValues.length > 0){
                    var settings = {model: this.state.dataModel};
                    settings.filters = [{
                        column: "__id",
                        term: 'in',
                        value: unfindedValues
                    }]
                    this.state.isFetching = true;
                    
                    this.state.getAdditionalDataForControl(this, settings, function ({items}) {
                        me.addAdditionalOptions(items);
                    });
                }
            }
            else{
                let isFind = false;
                for(let i=0; i < this.state.options.length; i++){
                    let option = this.state.options[i];
                    if(option.value == this.props.value){
                        isFind = true;
                        break;
                    }
                }

                if(!isFind){
                    var settings = {model: this.state.dataModel};
                    settings.filters = [{
                        column: "__id",
                        term: '=',
                        value: me.props.value
                    }]
                    this.state.isFetching = true;
                    
                    this.state.getAdditionalDataForControl(this, settings, function ({items}) {
                        me.addAdditionalOptions(items);
                    });
                }
            }
        }
    }

    addAdditionalOptions(items){
        if(!Array.isArray(items) || items.length == 0)
            return;

        var options = this.state.options;

        for(let i = items.length - 1; i >= 0; i--){
            let isFind = false;
            for(let j = 0; j < options.length; j++){
                if(options[j].key == items[i].key){
                    isFind = true;
                    break;
                }
            }

            if(!isFind){
                options.unshift(items[i]);
            }
        }

        this.state.isFetching = false;
        this.forceUpdate();
    }

    getCollumnsForFilter(){
        var pattern = new RegExp(' asc', 'gi');
        var res = this.props.columns.replace(pattern, '');

        pattern = new RegExp(' desc', 'gi');
        res = res.replace(pattern, '');

        pattern = new RegExp(' ', 'gi');
        res = res.replace(pattern, '');

        return res;
    }
}