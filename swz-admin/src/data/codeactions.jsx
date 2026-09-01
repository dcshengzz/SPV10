import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox } from 'semantic-ui-react'
import CloverAdminPanelBase from './../panelbase'
import CloverAdminCodeActionsEdit from './codeactionsedit';

export default class CloverAdminCodeActions extends CloverAdminPanelBase {
  constructor(props) {
    super(props);

    this.dataindex = "codeActions";
    this.panelindex = "codeactions";
    this.defaultNamePrefix = "";
    this.idfield = "id";
    this.title = CloverAdminLang.codeaction.title;
    this.datatype = "codeactions";
    this.editform = CloverAdminCodeActionsEdit;
  }

  gridColumns(){
    return [{
        key: 'name',
        name: CloverAdminLang.column.name,
        resizable: true
    },{
      key: 'definedOnServer',
      name: CloverAdminLang.column.defineonservercolumn,
      resizable: true,
      type: "checkbox"
    },{
      key: 'type',
      name: CloverAdminLang.column.type,
      resizable: true,
      type: "custom",
      customFormatter: function({value}){
        let res = "Unknown";
        if(value == 0) res = "Filter";
        if(value == 1) res = "Action";
        if(value == 2) res = "Trigger";
        return res;
      }
    }];
  }

  getDefaultObjectCode(){
    return "";
  }

  showedit(row){
      if(row.definedOnServer){
        alertify.error(CloverAdminLang.codeaction.defineonservermsg);
      }
      else{
        super.showedit(row);
      }
  }

  validate(){
    var res = true;
    var editrow = this.state.editrow;
    var msgRequiredField = CloverAdminLang.msg.fieldrequired;
    editrow.__error = {
          name: (editrow.name == undefined || editrow.name == "") ? msgRequiredField : undefined
      };

    res &= editrow.__error.name == undefined;
    return res;
  }

  onDelete(){
    var me = this;
    var res = [];
    var deleterows = [];
    var selectedKeys = this.grid.getSeletedRowKeys();
    for(var i=0; i < this.props.data[this.dataindex].length; i++){
      let item = this.props.data[this.dataindex][i];  
      var isneedtodelete = false;
        for(var j=0; j < selectedKeys.length; j++){
            if(item[this.idfield] == selectedKeys[j]){
                isneedtodelete = true;
                break;
            }
        }

        if(isneedtodelete){
            var deleterow = item;

            if(deleterow.definedOnServer){
              me.setState({ confirmdeleteshow: false });
              alertify.error(CloverAdminLang.codeaction.defineonserverblockdeletemsg);
              return;
            }

            deleterow["__type"] = this.datatype;
            deleterow["__state"] = "deleted"
            deleterows.push(deleterow);
        }
        else{
            res.push(item);
        }
    }

    this.ChangeData(deleterows, function(){
        me.props.data[me.dataindex] = res;
        me.setState({ selectedIndexes: [], confirmdeleteshow: false });
    });
  }
}