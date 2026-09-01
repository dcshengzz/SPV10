import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'

import PanelModal from './../panelmodal'
import CloverAdminGroupEdit from './groupedit'

export default class CloverAdminGroups extends PanelModal {
  constructor(props) {
    super(props);

    this.dataindex = "groups";
    this.panelindex = "groups";
    this.idfield = "id";
    this.editform = CloverAdminGroupEdit;
    this.datatype = "groups";
    this.title = CloverAdminLang.group.title;
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
    var editrow = this.state.editrow;
    var msgRequiredField = CloverAdminLang.msg.fieldrequired;
    editrow.__error = {
          name: (editrow.name == undefined || editrow.name == "") ? msgRequiredField : undefined
      };

    res &= editrow.__error.name == undefined;
    return res;
  }
}