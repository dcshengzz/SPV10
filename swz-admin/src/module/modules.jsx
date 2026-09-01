import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox } from 'semantic-ui-react'
import PanelBase from './../panelbase'
import EditForm from './moduleedit';

export default class Modules extends PanelBase {
  constructor(props) {
    super(props);

    this.dataindex = "modules";
    this.panelindex = "modules";
    this.idfield = "id";
    this.editform = EditForm;
    this.title = "Modules";
    this.datatype = "modules";
  }

  gridColumns(){
    return [{
        key: 'name',
        name: CloverAdminLang.column.name,
        resizable: true
    }];
  }

  validate(){
    var res = true;
    var editrow = this.state.editrow
    var msgRequiredField = CloverAdminLang.msg.fieldrequired;
    editrow.__error = {
          name: (editrow.name == undefined || editrow.name == "") ? msgRequiredField : undefined
      };

    res &= editrow.__error.name == undefined;
      
    return res;
  }
}