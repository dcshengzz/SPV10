/*
Filter object structure:
let filter = [
{column: "Name" | "Name1,Name2,Name3" | "*",
value: value,
term: ">" | "<" | "=" | ">=" | "<=" | "!=" | "like" | "like*" | "*like" | "*like*"
]
"*like*" === "like"
 */

import React from 'react'
import {Input,Checkbox, Button} from 'semantic-ui-react'
import ReactDataGrid from 'react-data-grid';
import {Row} from 'react-data-grid';
//import {Toolbar, Selectors } from 'react-data-grid-addons';
import {FunctionalFilter,FilterTerms} from '../functionalfilter'
import moment from 'moment';

class CheckBoxFormatter extends React.Component {
    render(){	
        const value = Boolean(this.props.value);
        return (<Checkbox checked={value} disabled/>);
    }
}
class LinkFormatter extends React.Component {
    render(){	
        const value = this.props.value;
        return (<span><div title={value}><a href='#' class='LinkFormatter'>{value}</a></div></span>);
    }
}

class NumberFormatter extends React.Component {
    render() {
        const value = this.props.value;
        return (<span style={{textAlign: 'left'}}><div title={value}>{value}</div></span>);
    }
}

class DateFormatter extends React.Component {
    render() {
        const value = moment(this.props.value);
        let strValue = "";
        if(value.isValid()){
            let format = (window.CloverLang !== undefined && window.CloverLang.common !== undefined && window.CloverLang.common.dateFormat != undefined) 
                ? window.CloverLang.common.dateFormat 
                : "L";
            strValue = value.format(format);
        }
        return (<span style={{textAlign: 'left'}}><div title={strValue}>{strValue}</div></span>);
    }
}

class DateTimeFormatter extends React.Component {
    render() {
        const value = moment(this.props.value);
        let strValue = "";
        if(value.isValid()){
            let format = (window.CloverLang !== undefined && CloverLang.common !== undefined && window.CloverLang.common.dateFormat != undefined) 
                ? window.CloverLang.common.dateFormat + " " + 
                (window.CloverLang.common.timeFormat !== undefined ? window.CloverLang.common.timeFormat: "HH:mm")
                : "DD MMM YYYY HH:mm";
            strValue = value.format(format);
        }
        return (<span style={{textAlign: 'left'}}><div title={strValue}>{strValue}</div></span>);
    }
}

class TimeFormatter extends React.Component {
    render() {
        const value = moment(this.props.value);
        let strValue = "";
        if(value.isValid()){
            let format = (window.CloverLang !== undefined && window.CloverLang.common !== undefined && window.CloverLang.common.timeFormat != undefined) 
                ? window.CloverLang.common.timeFormat 
                : "HH:mm";
            strValue = value.format(format);
        }
        return (<span style={{textAlign: 'left'}}><div title={strValue}>{strValue}</div></span>);
    }
}


class ButtonsFormatter extends React.Component {
    constructor(props) {
        super(props);
      //  console.log('this.props', this.props);
        this.editRow = this.editRow.bind(this);
        this.review = this.review.bind(this);
    }
    editRow(id, editForm, e) {
        
        e.preventDefault();
        if (editForm !== undefined && editForm !== "") {
            let path = `${editForm}/${id}`;
            window.location = path;
        } else {
            console.log("Please set editForm for the gridview");
        }

    }

    review(id, reviewForm, e) {

        e.preventDefault();
        if (reviewForm !== undefined && reviewForm !== "") {
            let path = `${reviewForm}/${id}`;
            window.location = path;
        } else {
            console.log("Please set reviewForm for the gridview");
        }

    }

    render() {
        const {dependentValues} = this.props;
        if (dependentValues.reviewForm !== undefined && dependentValues.reviewForm !== "") {
            return (<div><Button className='ui orange  mini button' role='button' onClick={this.editRow.bind(this, dependentValues.Id, dependentValues.editForm)}>Edit</Button><Button className='ui brown mini button' role='button' onClick={this.review.bind(this, dependentValues.Id, dependentValues.reviewForm)}>Review</Button></div>);
        }
        else {
            return (<div><Button className='ui orange  mini button' role='button' onClick={this.editRow.bind(this, dependentValues.Id, dependentValues.editForm)}>Edit</Button></div>);

        }
    }

}

const jsonEqual =
    function(a, b) {
        return JSON.stringify(a) === JSON.stringify(b);
    };

export default class GridViewWithActions extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            items: [],
            sort: "",
            defaultSort: props.defaultSort,
            filter: props.filter,
            pageSize: 20,
            selectedIndexes: [],
            rowsCount: GridViewWithActions.staticIsServerMode(props)? undefined : 0
        };
    }

    static getDerivedStateFromProps(nextProps, prevState) {
        let newState = null;
        if (!jsonEqual(prevState.filter, nextProps.filter)) {
            newState = {filter: nextProps.filter};
            if (!GridViewWithActions.staticIsServerMode(nextProps)) {
                const newItems = Array.isArray(nextProps.value) ? GridViewWithActions.staticGetSortedAndFilteredItems(nextProps.value, nextProps.filter,
                    prevState.sort,nextProps.defaultSort) : [];
                newState.items = newItems;
                newState.selectedIndexes = [];
                newState.rowsCount = newItems.length;
            }
            else {
                newState.items = [];
                newState.selectedIndexes = [];
                newState.rowsCount = undefined;
            }
        }
        else {
            if (!GridViewWithActions.staticIsServerMode(nextProps) && prevState.originalItems !== nextProps.value) {
                newState = {};
                const newItems = Array.isArray(nextProps.value) ? GridViewWithActions.staticGetSortedAndFilteredItems(nextProps.value, prevState.filter,
                    prevState.sort, nextProps.defaultSort) : [];
                newState.items = newItems;
                newState.rowsCount = newItems.length;
                newState.selectedIndexes = [];
                newState.originalItems = nextProps.value;
            }
        }
        return newState;
    }

    isEditFormModal() {
        return this.props.editFormShowType === "modal";
    }

    isServerMode() {
        return GridViewWithActions.staticIsServerMode(this.props);
    }

    static staticIsServerMode(props) {
        return props.pagerType === "server";
    }

    refresh() {
        if (this.isServerMode()) {
            this.setState({
                items: [],
                selectedIndexes: [],
                rowsCount: undefined
            });
        }
        else{
            const newItems = Array.isArray(this.props.value) ? GridViewWithActions.staticGetSortedAndFilteredItems(this.props.value, this.state.filter,
                this.state.sort, this.props.defaultSort) : [];
            this.setState({
                items: newItems,
                rowsCount: newItems.length,
                selectedIndexes: [],
                originalItems: this.props.value
            });
               
        }
    }

    resetSelection() {
        this.setState({
            selectedIndexes: []
        });
    }

    render() {
       
        let className = this.props.className;
        let style = {...this.props.style};
        let gridProps = this.getGridPropsByPagerType(this.props.pagerType);
        gridProps.reviewForm = this.props.reviewForm;
        gridProps.columns = this.getColumns();
        gridProps.rowKey = this.props.rowKey;

        if (this.props.rowHeight !== undefined && this.props.rowHeight !== "")
            gridProps.rowHeight = this.props.rowHeight;

        if (this.props.autoHeight) {
            style.minHeight = this.props.minHeight;
            if (this.props.offSet !== undefined && this.props.offSet !== "") {
                style.height = 'calc(100vh - ' + this.props.offSet + ')';
            }
            else {
                style.height = "100vh";
            }

            className = (className === undefined ? "" : (className + " ")) + "clover-gridview-autoHeight";
        }
        else {
            if (this.props.minHeight !== undefined && this.props.minHeight !== "") {
                gridProps.minHeight = this.props.minHeight;
            }
        }

//        if (Boolean(this.props.filterRow)) {
//            gridProps.toolbar = <Toolbar enableFilter={true}/>;
//            gridProps.onAddFilter = this.handleFilterChange.bind(this);
//            gridProps.onClearFilters = this.onClearFilters.bind(this);
//        }

        if (Boolean(this.props.multiselect)) {
            gridProps.rowSelection = {
                onRowsSelected: this.onRowsSelected.bind(this),
                onRowsDeselected: this.onRowsDeselected.bind(this),
                selectBy: {
                    indexes: this.state.selectedIndexes
                }
            };
        }

        return <div key={this.props.name} name={this.props.name} className={className} style={style}>
      
      
            <ReactDataGrid key="grid"
                           {...gridProps}
                           rowsCount={this.state.rowsCount}
                           rowGetter={this.gridRowGetter.bind(this)}
                           onRowClick={this.gridOnRowClick.bind(this)}
                           onGridSort={this.handleGridSort.bind(this)}/>
        </div>;
    }

    getColumns() {
        const me = this;
        let columns;
        if (this.props.columns === undefined) {
            columns = [];
        }
        else if (Array.isArray(this.props.columns)) {
            columns = this.props.columns;
        }
        else {
            columns = JSON.parse(this.props.columns);
        }

        columns.forEach(function (item) {
            item.getRowMetaData = (row) => { return { ...row, 'editForm': me.props.editForm, 'reviewForm': me.props.reviewForm}}
            if (item.width !== null && item.width !== "" && item.width !== undefined) {
                item.width = Number(item.width);
            }

            if(item.sortable !== false){
                item.sortable = !Boolean(me.props.disableSort);
            }
            item.filterable = Boolean(me.props.filterRow);
            item.resizable = Boolean(item.resizable);

            if (item.type === "number")
                item.formatter = NumberFormatter;
            else if (item.type === "checkbox") {
                item.formatter = CheckBoxFormatter;
            }
            else if (item.type === "custom") {
                item.formatter = item.customFormatter;
            }
            else if (item.type === "date") {
                item.formatter = DateFormatter;
            }
            else if (item.type === "time") {
                item.formatter = TimeFormatter;
            }
            else if (item.type === "datetime") {
                item.formatter = DateTimeFormatter;
            }
            else if (item.type === "link") {
                item.formatter = LinkFormatter;
            }
            else if (item.type === "buttons") {
                item.formatter = ButtonsFormatter;
            }
        });
        return columns;
    }

    getGridPropsByPagerType() {
        let gridProps = {};

        const pagerType = this.props.pagerType;
        if (pagerType === "server") {
            if (this.props.pageSize !== undefined) {
                this.state.pageSize = this.props.pageSize;
            }
            gridProps.rowRenderer = RowLoadingRenderer;
            if (this.state.rowsCount === undefined)
                this.state.rowsCount = 1;
        }
        else {
            // if (Array.isArray(this.props.value)) {
            //     this.state.items = this.getSortedAndFilteredItems(this.props.value);
            // }
            //this.state.rowsCount = this.state.items.length;
        }
        return gridProps;
    }

    static staticGetSortedAndFilteredItems(array,filter,sort,defaultSort)
    {
        let items = [];
        if (array === undefined)
            return items;
        if (filter !== undefined) {
            items = array.filter((r) => filter.IsRowMatched(r));
        }
        else {
            items = array;
        }

        let currentSort = sort;
        if (sort === 'NONE' || sort === "") {
            if (defaultSort === undefined) {
                return items;
            }
            currentSort = defaultSort;
        }

        const indexSpace = currentSort.indexOf(" ");
        const sortColumn = currentSort.substring(0, indexSpace);
        const sortDirection = currentSort.substring(indexSpace + 1, currentSort.length);

        //Sorting
        const comparer = (a, b) => {
            let aValue = (a[sortColumn] !== undefined  && a[sortColumn] !== null && a[sortColumn].toLowerCase !== undefined)
                ? a[sortColumn].toLowerCase()
                : a[sortColumn];
            let bValue = (b[sortColumn] !== undefined && b[sortColumn] !== null && b[sortColumn].toLowerCase !== undefined)
                ? b[sortColumn].toLowerCase()
                : b[sortColumn];

            if (aValue === bValue)
            {
                return 0;
            }
            if (aValue === null || aValue === undefined)
            {
                return 1;
            }
            if (bValue === null || bValue === undefined)
            {
                return -1;
            }
            if (sortDirection === 'ASC') {
                return (aValue > bValue) ? 1 : -1;
            } else if (sortDirection === 'DESC') {
                return (aValue < bValue) ? 1 : -1;
            }
        };
        return items.slice(0).sort(comparer);
    }

    getSeletedRowKeys() {
        const me = this;
        let selectedKeys = [];

        this.state.selectedIndexes.forEach(function (index) {
            const obj = me.gridRowGetter(index);
            if (obj !== undefined) {
                selectedKeys.push(obj[me.props.rowKey]);
            }
        });
        return selectedKeys;
    }

    gridRowGetter(index) {
        if (index < 0)
            return undefined;
        const pagerType = this.props.pagerType;
        if (pagerType === "server") {
            if (this.state.items[index] === undefined) {
                const pageSize = this.state.pageSize;
                this.loadPage(index, pageSize);
            }
        }

        if (pagerType === "server") {
            return this.state.items[index];
        }
        else {
            return { ...this.state.items[index] }; //CLOVER-115
        }
    }

    loadPage(startIndex, pageSize) {
        const me = this;
        for (let i = 0; i < pageSize; i++) {
            this.state.items[i + startIndex] = {__loading: true};
        }

        if (this.props.getAdditionalDataForControl === undefined) {
            if (console !== undefined)
                console.log("GridView: For paging on server need to set getAdditionalDataForControl func!");
        }
        else {
            let sortString = this.state.sort;
            if (sortString === "" && this.props.defaultSort !== undefined)
                sortString = this.props.defaultSort;

            this.props.getAdditionalDataForControl(this,
                {
                    startIndex,
                    pageSize,
                    filters: this.state.filter !== undefined ? this.state.filter.GetFilterAsObjects() : [],
                    sort: sortString
                },
                function ({sIndex, pSize, rowsCount, items}) {
                    if (rowsCount === undefined || items === undefined) {
                        me.state.rowsCount = 0;
                        me.setState({
                            rowsCount: 0,
                            items: []
                        });
                    }
                    else {
                        me.state.rowsCount = rowsCount;
                        for (let i = 0; i < pSize; i++) {
                            if (i < items.length) {
                                me.state.items[sIndex + i] = items[i];
                            }
                            else {
                                me.state.items[sIndex + i] = undefined;
                            }
                        }
                        me.forceUpdate();
                    }
                });
        }
    }

    gridOnRowClick(rowIdx, row) {
        if (row === undefined)
            return;

        const timenow = Date.now();
        if (this.rowClickTime !== undefined && this.rowClickTime.rowIdx === rowIdx && (timenow - this.rowClickTime.time) <= 1000) {
            this.rowClickTime = undefined;
            this.onRowDblClick(rowIdx, row);
        }
        else {
            this.rowClickTime = {
                rowIdx: rowIdx,
                time: timenow
            };

            if (this.props.handleEvent !== undefined) {
                this.props.handleEvent({key: this.props.name, eventName: "onRowClick", parameters: {rowIdx, row}});
            }
        }
    }

    onRowDblClick(rowIdx, row) {
        if (this.props.handleEvent !== undefined) {
            this.props.handleEvent({key: this.props.name, eventName: "onRowDblClick", parameters: {rowIdx, row}});
        }
    }

    onRowsSelected(rows) {
        this.state.selectedIndexes = this.state.selectedIndexes.concat(rows.map(r => r.rowIdx));
        if (this.props.handleEvent !== undefined) {
            this.props.handleEvent({
                key: this.props.name,
                eventName: "onSelectionChanged",
                parameters: {selectedIndexes: this.state.selectedIndexes}
            });
        }
        this.forceUpdate();
    }

    onRowsDeselected(rows) {
        let rowIndexes = rows.map(r => r.rowIdx);
        this.state.selectedIndexes = this.state.selectedIndexes.filter(i => rowIndexes.indexOf(i) === -1);
        if (this.props.handleEvent !== undefined) {
            this.props.handleEvent({
                key: this.props.name,
                eventName: "onSelectionChanged",
                parameters: {selectedIndexes: this.state.selectedIndexes}
            });
        }
        this.forceUpdate();
    }

    handleGridSort(sortColumn, sortDirection) {
        const stateDelta = {};
        if (sortDirection === "NONE")
            stateDelta.sort = "";
        else
            stateDelta.sort = sortColumn + " " + sortDirection;

        const pagerType = this.props.pagerType;
        if (pagerType === "server") {
            stateDelta.items = [];
        }
        else {
            stateDelta.items = GridViewWithActions.staticGetSortedAndFilteredItems(this.props.value,
                this.state.filter, stateDelta.sort, this.props.defaultSort);
        }

        stateDelta.selectedIndexes = [];
        this.setState(stateDelta);
    }

    handleFilterChange(filter) {
        const stateDelta = {};
        let key = filter.column.key;
        let id = "columnfilter_" + key;
        stateDelta.filter = this.state.filter !== undefined ? this.state.filter : new FunctionalFilter([],this.props.columns.map(c=>c.key)) ;
        stateDelta.filter.RemoveFilter({name: key, id: id});
        if (filter.filterTerm !== "") {
            stateDelta.filter.AddFilter({names: [key], expected: filter.filterTerm, term: FilterTerms.Like, id: id});
        }
        if (GridViewWithActions.staticIsServerMode(this.props)) {
            stateDelta.items = [];
            stateDelta.selectedIndexes = [];
            stateDelta.rowsCount = undefined;
        }
        else {
            stateDelta.items = GridViewWithActions.staticGetSortedAndFilteredItems(this.props.value,
                stateDelta.filter, this.state.sort, this.props.defaultSort);
            stateDelta.selectedIndexes = [];
            stateDelta.rowsCount = stateDelta.items.length;
        }
        this.setState(stateDelta);
    }

    onClearFilters() {
        this.setState({filter: this.props.filter});
    }

    ///----------
    ///Resize
    ///----------
    componentWillUnmount() {
        this._isMounted = false;
    }

    componentDidMount() {
        this._isMounted = true;
        this.recalcSizeParams();
    }

    recalcSizeParams() {
        if (!this._isMounted)
            return;

        if (Boolean(this.props.autoHeight)) {
            const h = $(window).height();

            this.setState({
                gridHeight: h - this.props.deltaHeight
            });
        }
    }
}

class RowLoadingRenderer extends React.Component {
    setScrollLeft(scrollBy) {
        this.row.setScrollLeft(scrollBy);
    }

    getClassName() {
        return this.props.row.__loading ? 'clover-gridview-rowloading' : "";
    }

    render() {
        return (<div className={this.getClassName()}><Row ref={node => this.row = node} {...this.props}/></div>);
    }
}