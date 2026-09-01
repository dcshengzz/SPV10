import React, { Component } from 'react'
import JSON5 from 'json5'
import { Input, Checkbox, Dropdown, Form, Icon, Button } from 'semantic-ui-react'
import Upload from './upload';
import DatePicker from './datepicker';

export default class CollectionEditor extends React.Component {
    constructor(props){
    super(props);
        this.state = { 
            expanded: {},
            disableDelete: false,
            header: false,
            headerTitle: null,
            headerSize: null,
            layoutOption: null
        };
    }

    applyCollapseAll(data){
        for(var p in data){
            if(this.state.expanded[p] == undefined)
            this.state.expanded[p] = false;
        }
    }


    componentWillReceiveProps = (nextProps) => {
        if (nextProps.disableDelete != null || nextProps.disableDelete != undefined){
            this.setState({disableDelete: nextProps.disableDelete});
        }
        if (nextProps.layoutOption != null || nextProps.layoutOption != undefined){
            var layoutOption = nextProps.layoutOption;
            this.setState({layoutOption});
        }
        if (nextProps.header != null || nextProps.header != undefined){
            var header = nextProps.header; 
            var headerTitle = nextProps.headerTitle;
            var headerSize = nextProps.headerSize;
            this.setState({header});
            this.setState({headerTitle});
            this.setState({headerSize});
        }
    }

    render() {
        var columns = this.props.columns;
        var data = this.props.value;
        var error = this.props.error;
        var showAddBtn = !Boolean(this.props.readOnly) && this.props.disableAdd !== true;

        if(Boolean(this.props.collapseAll) && Array.isArray(data)){
            this.applyCollapseAll(data);
        }

        if(columns == undefined || columns.length == 0){
            return <div>Fill columns property!</div>;
        }

        let btnAddValue = "Add"; //Add button for collectioneditor in forms
        if(window.CloverAdminLang != undefined && window.CloverAdminLang.collectioneditor != undefined){
            btnAddValue = window.CloverAdminLang.collectioneditor.add;
        }

        this.state.data = this.getCopyRowsFromProps();
        return (<div style={this.props.style} className="field">
            <div className="ui grid middle aligned margin-bottom-16">
              <div className="row">
                <div className="left aligned eight wide column">
                  {this.props.useSmallLabel ? <label>{this.props.label}</label> : <h2>{this.props.label}</h2>}
                {this.state.header ? 
                    <h2>{this.state.headerTitle}</h2>
                :   null
                }
               </div>
                <div className="right aligned eight wide column"> 
                  {showAddBtn && 
                  <Button className="buttontype2 round" onClick={this.btnAdd.bind(this)} size={this.props.useMiniAddButton ? "mini" : "medium"}>
                      <Icon name='add'/>
                      {btnAddValue}
                  </Button>}
                </div>
              </div>
            </div>
            {this.state.layoutOption == "vertical" ? 
                <div>
                    {this.renderVerticalLayout(columns, this.state.data, error)}
                </div>
            :
                <table className="clover-collectioneditor">
                    <tbody>
                        {this.renderHeaderRow(columns)}
                        {this.renderRows(columns, this.state.data, error)}
                    </tbody>
                </table>
            }
            </div>);
    }

    //Header
    renderHeaderRow(columns){
        const {disableDelete} = this.state;

        var res = [];
        var index = 0;
        columns.forEach(function(c){
            var key;
            var title;
            var width;
            var dataListOptions = undefined;
            if(typeof c === 'object'){
                key = c.key;
                title = c.name;
                width = c.width;
                if(Array.isArray(c.dataList))
                    dataListOptions = c.dataList;
            }
            else{
                key = c;
                title = c;
            }
            
            if(title != undefined && title.length >= 2){
                title = title.charAt(0).toUpperCase() + title.slice(1);
            }

            var dataListControl;
            var dataListId = undefined;
            if(dataListOptions != undefined){
                dataListId = key + "_datalist";
                let optValue = [];
                dataListOptions.forEach(function(o){
                    optValue.push(<option key={o} value={o} />);
                });
                dataListControl = <datalist key={dataListId} id={dataListId}>{optValue}</datalist>;
            }

            res.push(<td key={index} style={{width:width}}>{title}{dataListControl}</td>);
            index++;
        });

        {disableDelete == false ? res.push(<td key="btntd" className="clover-collectioneditor-buttoncol"></td>) : ''}
        /*
        if(!Boolean(this.props.readOnly) && this.props.disableAdd !== true){
          let addcontent = "Add";
          if(window.CloverAdminLang != undefined && window.CloverAdminLang.collectioneditor != undefined){
              addcontent = window.CloverAdminLang.collectioneditor.add;
          }
          res.push(<td key="btntd" className="clover-collectioneditor-buttoncol"><a key="btnadd" className="clover-btn" onClick={this.btnAdd.bind(this)}>{addcontent}</a></td>);
        }
        */
        return <tr key="headertr" className="clover-collectioneditor-header">{res}</tr>;
    }

    //Hierarchical
    getDragColumn(rows, i){
        let draggable = !Boolean(this.props.readOnly) && Boolean(this.props.draggable);
        if(draggable){
            return <div
                draggable={draggable}
                onDragStart={this.onDragStart.bind(this, i, rows)}
                onDragEnd={this.onDragEnd.bind(this, i, rows)}
                onDragOver={this.onDragOver.bind(this)}
                onDrop={this.onDrop.bind(this, i, rows)} 
                key="celldrag" className="clover-collectioneditor-action">
                <Icon onClick={this.onExpand.bind(this, i, false)}  name='ellipsis vertical' />
            </div>;
        }
        return undefined;
    }

    renderRows(columns, data, errors, parentIdValue, level, prefix){
        const {disableDelete} = this.state
        var showDeleteBtn = disableDelete !== true;
      
        let me = this;
        let res = [];
        let rows = data;        
        if(level == undefined)
            level = 0;

        if(prefix === undefined)
            prefix = "";
       
        for(var i = 0; i < rows.length; i++){
            if(this.props.childrenField === undefined && this.props.hierarchical){
                if(rows[i][this.props.parentIdField] != parentIdValue){
                    continue;
                }
            }
            
            let dragcol = this.getDragColumn(rows, i);
            let expand = undefined;
            let children = undefined;
            if(this.props.hierarchical){
                let icon;
                var parentPrefix = prefix + String(i + "_");
                if(this.props.parentIdField !== undefined && this.props.parentIdField !== ""){
                    let parentId = rows[i][this.props.idField];
                    if(parentId != undefined && parentId != ""){
                        children = this.renderRows(columns, data, errors, parentId, level+1, parentPrefix);
                        if(children.length > 0){
                            var isexpanded = this.state.expanded[prefix + i];
                            if(isexpanded == undefined || isexpanded == true){
                                icon = <img onClick={this.onExpand.bind(this, prefix + i, false)} className="clover-collectioneditor-imgbutton" src="/images/collapse.svg"/>;
                            }
                            else{
                                icon = <img onClick={this.onExpand.bind(this, prefix + i, true)} className="clover-collectioneditor-imgbutton" src="/images/expand.svg"/>;
                                children = undefined;
                            }
                        }
                    }
                }
                else if(Array.isArray(rows[i][this.props.childrenField]) && rows[i][this.props.childrenField].length > 0) {
                    children = this.renderRows(columns, rows[i][this.props.childrenField], errors, undefined, level+1, parentPrefix);
                    if(children.length > 0){
                        var isexpanded = this.state.expanded[prefix + i];
                        if(isexpanded == undefined || isexpanded == true){
                            icon = <img onClick={this.onExpand.bind(this, prefix + i, false)} className="clover-collectioneditor-imgbutton" src="/images/collapse.svg"/>;
                        }
                        else{
                            icon = <img onClick={this.onExpand.bind(this, prefix + i, true)} className="clover-collectioneditor-imgbutton" src="/images/expand.svg"/>;
                            children = undefined;
                        }
                    }
                }
                else{
                    icon = <img style={{opacity:0}} className="clover-collectioneditor-imgbutton" src="/images/collapse.svg"/>;
                }
                
                expand = <div className="clover-collectioneditor-action">{icon}</div>;
            }

            let row = [];
            let errorOnRow = Array.isArray(errors) ? errors[i] : undefined;
            for(var j = 0; j < columns.length; j++){
                let colName;
                let control = this.props.readOnly ? "" : "input";
                let dataListId = undefined;
                let options = undefined;
                if(typeof columns[j] === 'object'){
                    colName = columns[j].key;
                    control = columns[j].control;
                    if(Array.isArray(columns[j].dataList)){
                        dataListId = colName + "_datalist";
                    }

                    if(Array.isArray(columns[j].options)){
                        options = columns[j].options;
                    }
                }
                else{
                    colName = columns[j];
                }

                let errorFlag = undefined;
                if(errorOnRow != undefined){
                    errorFlag = Boolean(errorOnRow[colName]);
                }

                let element = undefined;
                if(control == "checkbox"){
                    element = <Form.Checkbox
                        key={i + "_" + j} 
                        name={colName} 
                        checked={Boolean(rows[i][colName])} 
                        readOnly={Boolean(this.props.readOnly)}
                        error={errorFlag}
                        onChange={this.handleChange.bind(this, rows[i])}></Form.Checkbox>;
                } 
                else if(control == "span"){
                    element = <span
                    key={i + "_" + j} 
                    name={colName} >{rows[i][colName]}</span>;
                }
                else if(control == "number"){
                    let value = rows[i][colName] == null ? "" : rows[i][colName];
                    element = <Form.Input
                        key={i + "_" + j} 
                        name={colName} 
                        type="number"
                        error={errorFlag}
                        value={value} 
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, rows[i])}></Form.Input>;
                }
                else if(control == "date"){
                    let value = rows[i][colName] == null ? "" : rows[i][colName];
                    element = <DatePicker
                        key={i + "_" + j} 
                        name={colName} 
                        type="date"
                        error={errorFlag}
                        value={value} 
                        isForm={true}
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, rows[i])}></DatePicker>;
                }
                else if(control == "datetime"){
                    let value = rows[i][colName] == null ? "" : rows[i][colName];
                    element = <DatePicker
                        key={i + "_" + j} 
                        name={colName} 
                        type="datetime"
                        error={errorFlag}
                        value={value} 
                        isForm={true}
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, rows[i])}></DatePicker>;
                }
                else if(control == "dropdown"){
                    let value = rows[i][colName] == null ? 
                        (Boolean(columns[j].multiple) ? [] : "")
                        : rows[i][colName];
                    element = <Form.Dropdown
                        key={i + "_" + j} 
                        name={colName} 
                        multiple={Boolean(columns[j].multiple)}
                        error={errorFlag}
                        value={value} 
                        options={options}
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, rows[i])}></Form.Dropdown>;
                }
                else if(control == "file" || control == "file2"){
                    let value = rows[i][colName] == null ? "" : rows[i][colName];
                    element = <Upload
                        key={i + "_" + j} 
                        name={colName} 
                        error={errorFlag}
                        value={value}
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, rows[i])}
                        downloadUrl={this.props.downloadUrl}
                        uploadUrl={this.props.uploadUrl}
                        isForm={true}
                        hideClearButton={control == "file2"} ></Upload>;
                }
                else if(control == "custom"){
                    let value = rows[i][colName] == null ? "" : rows[i][colName];
                    if(this.props.placeholders != undefined && 
                        Array.isArray(this.props.placeholders[colName]) &&
                        this.props.placeholders[colName].length > 0){
                        let model = this.props.placeholders[colName][0];
                        if(model != undefined){
                            model.key = colName;
                            let row = rows[i];
                            element = this.props.createControl(this, model["data-buildertype"], {
                                model, data: row, errors: errorOnRow,
                                parentItem: this.props.name,
                                buildermode: this.props.buildermode, 
                                handleEvent: function(args){
                                    if(args.eventName == "onChange"){
                                        me.handleChange(row, args.syntheticEvent, {name: args.name, value: args.value, checked: args.checked});
                                    }
                                    else{
                                        this.props.handleChange(args);
                                    }
                                },
                                getAdditionalDataForControl: this.props.getAdditionalDataForControl,
                                readOnly: this.props.readOnly,
                                uploadUrl : this.props.uploadUrl, 
                                downloadUrl : this.props.downloadUrl,
                                controlsToReplace: []
                            });
                        }
                    }
                    else if(this.props.buildermode && this.props.createBuilderDropzone != undefined){
                        element = this.props.createBuilderDropzone(colName, value);
                    } 
                } else if(control == "textarea"){
                    let value = rows[i][colName] == null ? "" : rows[i][colName];
                    element = <Form.TextArea
                        key={i + "_" + j} 
                        name={colName} 
                        list={dataListId}
                        error={errorFlag}
                        rows={'2'}
                        value={value} 
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, rows[i])}></Form.TextArea>;
                
                }
                else{ 
                    let value = rows[i][colName] == null ? "" : rows[i][colName];
                    element = <Form.Input
                        key={i + "_" + j} 
                        name={colName} 
                        list={dataListId}
                        error={errorFlag}
                        value={value} 
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, rows[i])}></Form.Input>;
                }

                if(j==0){
                    let paddingLeft;
                    if(level != 0){
                        paddingLeft = String(level * 15) + "px";
                    }

                    row.push(<td key={i + "_" + j + "td"} style={{paddingLeft}}>{expand}{dragcol}{element}</td>);
                }
                else
                    row.push(<td key={i + "_" + j + "td"}>{element}</td>);
            }

            if(!Boolean(this.props.readOnly)){
                if(this.props.hierarchical){
                    let id = rows[i][this.props.idField];
                    row.push(<td key="celldelete" className="clover-collectioneditor-cellbtn">
                        <div className="field">
                            { id !== undefined && 
                                <Icon key="addchild" onClick={this.btnAddChild.bind(this, i, rows)} link name='add' />
                            }
                            <Icon key="delete" onClick={this.btnDelete.bind(this, i, rows)} link name='delete' />
                            
                        </div>
                    </td>);
                    
                }
                else{
                    {showDeleteBtn == true ? row.push(<td key="celldelete" className="clover-collectioneditor-cellbtn">
                        <div className="field">
                        {showDeleteBtn && 
                            <Icon key="delete" onClick={this.btnDelete.bind(this, i, undefined)} link name='delete' />
                        }
                        </div></td>) : '' }
                }
            }
            
            res.push(<tr key={prefix + i} className="clover-collectioneditor-row" data-rowindex={i}>{row}</tr>);
            res = res.concat(children);
        }

        return res;
    }

    renderVerticalLayout(columns, data, errors){
        const {disableDelete} = this.state
        var showDeleteBtn = disableDelete !== true;
        
        let me = this;
        let res = [];

        for(var i=0 ; i < data.length; i++){
            //Data in row
            let row = data[i];

            let errorOnRow = Array.isArray(errors) ? errors[i] : undefined;
            let errorFlag = undefined;
            if(errorOnRow != undefined){
                errorFlag = Boolean(errorOnRow[colName]);
            }

            let line = [];
            for(var x=0 ; x < columns.length; x++){
                //Make column vertical  
                let colName;
                let column = columns[x];
                let colHeader = column['name'];
                let key = column['key'];
                let colWidth=column['width'];
                let control = this.props.readOnly ? "" : "input";

                let dataListId = undefined;
                if(typeof column === 'object'){
                    colName = column['key'];
                    control = column['control'];
                    if(Array.isArray(column.dataList)){
                        dataListId = colName + "_datalist";
                    }

                    if(Array.isArray(column.options)){
                        options = column.options;
                    }
                }else{
                    colName = column;
                }

                let element = undefined;
                let elementKey = i + "_" + x ;
                if(control == "checkbox"){
                    element = <Form.Checkbox
                        key={elementKey}
                        name={colName}
                        style={{width:colWidth}}
                        label={colHeader}
                        checked={Boolean(row[key])} 
                        readOnly={Boolean(this.props.readOnly)}
                        error={errorFlag}
                        onChange={this.handleChange.bind(this, row)}></Form.Checkbox>;
                } 
                else if(control == "span"){
                    element = <div 
                    className="field clover-collectioneditor-vertical-span" 
                    style={{width:colWidth}}>
                        <label>{colHeader}</label>
                        <span
                        key={elementKey}
                        name={colName}>{row[key]}</span>
                    </div>;
                }
                else if(control == "number"){
                    let value = row[key] == null ? "" : row[key];
                    element = <Form.Input
                        key={elementKey}
                        name={colName}
                        style={{width:colWidth}}
                        type="number"
                        error={errorFlag}
                        value={value}
                        label={colHeader}
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, row)}></Form.Input>;
                }
                else if(control == "date"){
                    let value = row[key] == null ? "" : row[key];
                    element = <DatePicker
                        key={elementKey}
                        name={colName}
                        style={{width:colWidth}}
                        type="date"
                        error={errorFlag}
                        value={value}
                        label={colHeader}
                        isForm={true}
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, row)}></DatePicker>;
                }
                else if(control == "datetime"){
                    let value = row[key] == null ? "" : row[key];
                    element = <DatePicker
                        key={elementKey}
                        name={colName}
                        style={{width:colWidth}}
                        type="datetime"
                        error={errorFlag}
                        value={value}
                        label={colHeader}
                        isForm={true}
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, row)}></DatePicker>;
                }
                else if(control == "dropdown"){
                    let value = row[key] == null ? 
                        (Boolean(column['multiple']) ? [] : "")
                        : row[key];
                    element = <Form.Dropdown
                        key={elementKey}
                        name={colName}
                        style={{width:colWidth}}
                        multiple={Boolean(column['multiple'])}
                        error={errorFlag}
                        value={value} 
                        label={colHeader}
                        options={options}
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, row)}></Form.Dropdown>;
                }
                else if(control == "file" || control == "file2"){
                    let value = row[key] == null ? "" : row[key];
                    element = <Upload
                        key={elementKey}
                        name={colName}
                        style={{width:colWidth}}
                        error={errorFlag}
                        value={value}
                        label={colHeader}
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, row)}
                        downloadUrl={this.props.downloadUrl}
                        uploadUrl={this.props.uploadUrl}
                        isForm={true}
                        hideClearButton={control == "file2"} ></Upload>;
                }
                else if(control == "input"){ 
                    let value = row[key] == null ? "" : row[key];
                    element = <Form.Input
                        key={elementKey} 
                        name={colName} 
                        style={{width:colWidth}}
                        list={dataListId}
                        error={errorFlag}
                        value={value} 
                        label={colHeader}
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, row)}></Form.Input>;
                }
                else if(control == "textarea"){ 
                    let value = row[key] == null ? "" : row[key];
                    element = <Form.TextArea
                        key={elementKey} 
                        name={colName}
                        style={{width:colWidth}}
                        list={dataListId}
                        error={errorFlag}
                        rows={'2'}
                        value={value} 
                        label={colHeader}
                        readOnly={Boolean(this.props.readOnly)}
                        onChange={this.handleChange.bind(this, row)}></Form.TextArea>;
                }
                line.push(<div key={'ce_r_d_' + elementKey}>{element}</div>);
            }
            if(!Boolean(this.props.readOnly)){
                line.push(<div key="celldelete" className="clover-collectioneditor-cellbtn">
                    <div className="field">
                    {showDeleteBtn && 
                        <Icon key="delete" onClick={this.btnDelete.bind(this, i, undefined)} link name='delete' />
                    }
                    </div></div>);
            }
            
            res.push(<React.Fragment key={'_' + i}>{i > 0 ? <hr></hr> : '' }<div className="clover-collectioneditor-row" data-rowindex={i}>{line}</div></React.Fragment>);
        }

        return res;
    }

    btnDelete(index, rows){
        if(this.props.onChange == undefined)
            return;

        if(rows === undefined)
            rows = this.state.data;
       
        var obj = rows[index];
        rows.splice(index, 1);

        this.sendChangesToParent();
    }

    btnAddChild(index, rows){
        if(rows === undefined)
            rows = this.state.data == undefined ? [] : this.state.datae;

        var objParent = rows[index];
        var obj = this.props.defaultrow == undefined ? {} : {...this.props.defaultrow};
        
        if(this.props.parentIdField !== undefined && this.props.parentIdField !== ""){
            obj[this.props.parentIdField] = objParent[this.props.idField];
            rows.push(obj);
        }
        else{
            if(!Array.isArray(rows[index][this.props.childrenField]))
                rows[index][this.props.childrenField] = [];
            
            rows[index][this.props.childrenField].push(obj);
        }

        if(this.props.handleEvent != undefined){
            this.props.handleEvent({key: this.props.name, eventName: "onAddChild", parameters: { rowIdx: rows.length - 1, row: obj }});
        }
        this.sendChangesToParent();
    }

    btnAdd(){
        var obj = this.props.defaultrow == undefined ? {} : this.props.defaultrow;
        this.state.data.push(obj);

        if(this.props.handleEvent != undefined){
            this.props.handleEvent({key: this.props.name, eventName: "onAdd", parameters: { rowIdx: this.state.data.length - 1, row: obj }});
        }

        this.sendChangesToParent();
    }

    onExpand(i, value){
      this.state.expanded[i] = value;
      this.forceUpdate();
    }

    onDragOver(e){
        e.preventDefault();
    }
    
    onDragStart(index, rows, e){
       e.dataTransfer.setData('index', index); 
       this.state.dragElementIndex = index;
       this.state.dragRows = rows;
    }

    onDragEnd(index, e){
        this.state.dragElementIndex = undefined;
        this.state.dragRows = undefined;
     }

    onDrop(index, rows, e){
        var rowIndexA = this.state.dragElementIndex;
        var rowsA = this.state.dragRows;
        var rowIndexB = index;
        var rowsB = rows;
        if(rowIndexA != undefined){
            if(rowIndexB != rowIndexA){
                if(this.props.parentIdField !== undefined && this.props.parentIdField !== ""){
                    rowsA[rowIndexA][this.props.parentIdField] = rowsB[rowIndexB][this.props.parentIdField];
                }
                rowsB.splice(rowIndexB, 0, rowsA.splice(rowIndexA, 1)[0]);
                this.sendChangesToParent();
            }
            e.preventDefault();
        }
        return false;
    }

    handleChange(item, e, {name, value, checked}){
        if(this.props.onChange == undefined)
            return;
       
        if(value == undefined && checked != undefined){
            item[name] = checked
        }
        else{
            item[name] = value;
        }
        
        this.sendChangesToParent();

        if(e != undefined)
            e.preventDefault();
        else
            this.forceUpdate();
    }

    getCopyRowsFromProps(){
        var rows = this.props.value == undefined ? [] : this.props.value;
        this.state.stringmode = false;
        if(!Array.isArray(rows)){
            rows = JSON5.parse(rows);
            this.state.stringmode = true;
        }
        else{
            rows = rows.slice();
        }

        return rows;
    }

    sendChangesToParent(){
        let rows = this.state.data;
        let res = this.state.stringmode ? JSON5.stringify(rows) : rows;
        this.props.onChange(null, {name: this.props.name, value: res});
    }
}