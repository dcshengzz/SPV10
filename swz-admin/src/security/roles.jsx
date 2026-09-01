import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'

import CloverAdminPanelBase from './../panelbase'
import CloverAdminRoleEdit from './roleedit'

export default class CloverAdminRoles extends CloverAdminPanelBase {
  constructor(props) {
    super(props);

    this.dataindex = "roles";
    this.panelindex = "roles";
    this.defaultNamePrefix = "role";
    this.idfield = "id";
    this.editform = CloverAdminRoleEdit;
    this.title = CloverAdminLang.role.title;
    this.datatype = "roles"
  }

  gridColumns(){
    return [{
        key: 'code',
        name: CloverAdminLang.column.code,
        resizable: true
    },{
        key: 'name',
        name: CloverAdminLang.column.name,
        resizable: true
    }];
  }

  validate(){
    var res = true;
    var editrow = this.state.editrow;
    var msgRequiredField = CloverAdminLang.msg.fieldrequired;
    editrow.__error = {
          name: (editrow.name == undefined || editrow.name == "") ? msgRequiredField : undefined,
          code: (editrow.code == undefined || editrow.code == "") ? msgRequiredField : undefined
      };

    res &= editrow.__error.name == undefined && editrow.__error.code == undefined;
    return res;
  }
}