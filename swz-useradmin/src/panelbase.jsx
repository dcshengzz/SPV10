
import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./basecomponent"
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'
import GridView from './../../swz-builder/src/control/gridview'

export default class PanelBase extends BaseComponent {
  constructor(props) {
    super(props);

    if(this.idfield == undefined)
        this.idfield = "id";

    this.state = {
        openmodal: false};    

    var me = this;
    window.onresize = function() {
        me.recalcSizeParams();
    };
  }

  createNewObject(){
    var obj = {
        __state: "inserted"
    };
    obj[this.idfield] = this.NewGUID();
    return obj;
  }
  
  showedit(row){
    this.state.editrowid = undefined;
    this.props.parent.openpage(this.panelindex, row[this.idfield]);
  }

  loadeditrow(){
    this.state.editrowid = this.props.id;
    if(this.props.id == undefined){
        this.state.editrow = undefined;
        return;
    }
    
    var originalRow = this.getEditRow();
    this.state.editrow = this.СloneObj(originalRow);
  }

  applyeditrow(){
    var me = this;
    var id = this.state.editrow[this.idfield];
    var index = -1;

    var coll = this.props.data[this.dataindex];
    for(var i = 0; i < coll.length; i++){
        if(id === coll[i][this.idfield]){
            index = i;
            break;
        }
    }

    if(index >= 0){
        this.props.data[this.dataindex][index] = this.state.editrow;
    }
    else{
        this.props.data[this.dataindex].unshift(this.state.editrow);
    }
  }

  back(){
    this.props.parent.openpage(this.panelindex);
  }

  getEditRow(){
    let id = this.props.id;
    if(id == "new"){
        let obj = this.createNewObject();
        if(this.props.copyid !== undefined){
            let data = this.props.data[this.dataindex];
            for(var i=0; i < data.length; i++){
                if(data[i][this.idfield] == this.props.copyid){
                    for(let p in data[i]){
                        if(obj[p] === undefined){
                            obj[p] = data[i][p];
                        }
                    }
                    break;
                }
            }
        }
        return obj;
    }
    
    let data = this.props.data[this.dataindex];
    for(var i=0; i < data.length; i++){
        if(data[i][this.idfield] == id){
            return data[i];
        }
    }

    alertify.error(CloverAdminLang.msg.objectnotfound);
    return undefined;
  }

  //Render methods
  render(){
    if(this.state.editrowid != this.props.id){
        this.loadeditrow();
    }

    return (<div>
        {this.props.id == undefined ? 
            this.renderMainForm() : 
            this.renderEditForm()}</div>);
  }

  validate(){
      return true;
  }

  reload(){
    this.state = {};
    this.forceUpdate();
  }

  renderMainForm(){
    var me = this;
    var rowCount = this.props.data[this.dataindex] == undefined ? 0 : this.props.data[this.dataindex].length;
    var hideconfirmdelete = () => {me.setState({confirmdeleteshow: false})};
    
    var columns = this.gridColumns();
    var defaultSort = "";
    if(columns.length > 0)
        defaultSort = columns[0].key + " ASC";
     
   /*  var rowHeight = this.rowHeight !== null && this.rowHeight !== undefined ? this.rowHeight : 40;
    
alert("The row height is", rowHeight); */
    var res = (<div>
        <h1>{this.title}</h1>
        {this.renderToolbar()}
        <GridView key="Formgrid"
            rowKey={this.idfield} rowHeight={80} columns={this.gridColumns()}
            defaultSort={defaultSort}
            minHeight={this.state.gridHeight} multiselect={true}
            value={this.props.data[this.dataindex]}
            handleEvent={this.gridHandleEvent.bind(this)}
            ref={(grid)=> { this.grid = grid; }}
        />
        <Confirm open={this.state.confirmdeleteshow}
            dimmer={'blurring'}
            content={CloverAdminLang.msg.confirmdelete}
            onCancel={hideconfirmdelete}
            onConfirm={this.onDelete.bind(this)} /> 
        </div>);
        
        return res;
  }

  renderToolbar(){
    var me = this;
    var showconfirmdelete = () => {me.setState({confirmdeleteshow: true})};
    var showconfirmcreate = () => {
        this.props.parent.openpage(this.panelindex, "new");
    };

    return <div className="cloveradmin-toolbar">
            <Button className="buttontype1" onClick={showconfirmcreate}>{CloverAdminLang.button.create}</Button>
            <Button className="buttontype2" onClick={showconfirmdelete}>{CloverAdminLang.button.delete}</Button>
        </div>;
  }

  renderEditForm(){
    return React.createElement(this.editform,
        {...this.props,
            parent: this,
            data: this.state.editrow,
            ischanged: this.state.ischanged,
            metadata: this.props.data,
            handleChange: this.handleChange,
            onSave: this.onSave,
            onCancel: this.onCancel
        });
  }

  onSave(){
    var me = this;

    if(!this.validate()){
        alertify.error(CloverAdminLang.msg.checkerrorsonform);
        return;
    }

    if(me.state.editrow["__state"] != undefined){
        me.state.editrow["__type"] = this.datatype;
        this.ChangeData([me.state.editrow], function(response){
            me.ResetSystemProps(me.state.editrow);
            me.applyeditrow();
            me.showedit(me.state.editrow);
        });
    }
    else{
        alertify.success(CloverAdminLang.msg.unchangedobject);
    }
  }

  onCancel(){
    let editrow = this.state.editrow;
    this.loadeditrow();

    //Because controls don't understand change value to undefined correctly.
    if(editrow != undefined){
        for(var p in editrow){
            if(this.state.editrow[p] == undefined && editrow[p] != undefined){
                let type = typeof(editrow[p]);
                if(type == "string")
                    this.state.editrow[p] = "";
            }
        }
    }

    this.forceUpdate();
  }
//
// Check data
//

getDefaultObjectCode(){
    var res = this.defaultNamePrefix;
    for(var i=0; i < 1000; i++){
        var tmp = res + (i == 0 ? "" : "_" + i.toString());
        if(this.validateCode(tmp)){
            res = tmp;
            break;
        }
    }
    return res;
  }

  validateCode(code){
    var isUnique = true;
    var coll = this.props.data[this.dataindex];
    if(coll != undefined){
        for(var i=0; i < coll.length; i++){
            var item = coll[i];
            if(item[this.idfield] == code){
                isUnique = false;
                break;
            }    
        }
    }
    return isUnique;
  }

//
//Events
//
  onDelete(){
    var me = this;
    var res = [];
    var deleterows = [];
    var selectedKeys = this.grid.getSeletedRowKeys();
    for(var i=0; i < this.props.data[this.dataindex].length; i++){
        let item = this.props.data[this.dataindex][i];
        let isneedtodelete = false;
        for(var j=0; j < selectedKeys.length; j++){
            if(item[this.idfield] == selectedKeys[j]){
                isneedtodelete = true;
                break;
            }
        }

        if(isneedtodelete){
            var deleterow = this.props.data[this.dataindex][i];
            deleterow["__type"] = this.datatype;
            deleterow["__state"] = "deleted"
            deleterows.push(deleterow);
        }
        else{
            res.push(this.props.data[this.dataindex][i]);
        }
    }

    me.setState({ confirmdeleteshow: false });
    this.ChangeData(deleterows, function(){
        me.props.data[me.dataindex] = res;
        me.grid.resetSelection();
        me.forceUpdate();
    });
  }

//
//Recalc page size
//
componentWillUnmount(){
    this._isMounted = false;
}

componentDidMount() {
  this._isMounted = true;
  this.recalcSizeParams();
}

recalcSizeParams(){
  if(!this._isMounted)
      return;
  var h = $(window).height();

  this.setState({
      gridHeight: h - 210 - this.props.deltaHeight
  });
}

  gridColumns(){
    return [{
        key: 'code',
        name: CloverAdminLang.column.code,
        resizable: true
    }];
  }

  gridHandleEvent({eventName, parameters}){
    if(eventName == "onRowDblClick"){
        this.showedit(parameters.row);
    }
    if(eventName == "onRowClick"){
        this.showedit(parameters.row);
    }
  }
}