import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'

import CloverAdminPanelBase from './../panelbase'
import CloverAdminBusinessFlowEdit from './businessflowedit'

export default class CloverAdminBusinessFlow extends CloverAdminPanelBase {
  constructor(props) {
    super(props);

    this.dataindex = "businessFlow";
    this.panelindex = "businessflow";
    this.datatype = "businessflow";
    this.idfield = "id";
    this.editform = CloverAdminBusinessFlowEdit;
    this.title = CloverAdminLang.businessflow.title;
  }

  gridColumns(){
    return [{
        key: 'name',
        name: CloverAdminLang.column.name,
        resizable: true
    },{
        key: 'scheme',
        name: CloverAdminLang.businessflow.schemecolumn,
        resizable: true
    },{
      key: 'defaultForm',
      name: CloverAdminLang.businessflow.defaultformcolumn,
      resizable: true
    }];
  }

  getDefaultObjectCode(){
      return "";
  }

  validate(){
    var res = true;
    var editrow = this.state.editrow;
    var msgRequiredField = CloverAdminLang.msg.fieldrequired;
    editrow.__error = {
          name: (editrow.name == undefined || editrow.name == "") ? msgRequiredField : undefined,
          scheme: (editrow.scheme == undefined || editrow.scheme == "") ? msgRequiredField : undefined,
          defaultForm: (editrow.defaultForm == undefined || editrow.defaultForm == "") ? msgRequiredField : undefined
      };

    res &= editrow.__error.name == undefined && editrow.__error.scheme == undefined && editrow.__error.defaultForm == undefined;
   
    if(editrow.map != undefined){
      editrow.__error.map = [];
      editrow.map.forEach(function(m){
        let errobj = {
          states: !Array.isArray(m.states) || m.states.length == 0 ?  msgRequiredField : undefined,
          roles: !Array.isArray(m.roles) || m.roles.length == 0 ?  msgRequiredField : undefined,
          form: m.form == undefined || m.form == "" ? msgRequiredField : undefined,
        };
        editrow.__error.map.push(errobj);
        res &= errobj.states == undefined && errobj.roles == undefined && errobj.form == undefined;
        
       });
    }
    
    return res;
  }
}