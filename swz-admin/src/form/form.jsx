import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'

import PanelExternal from './../panelexternal'
import CloverAdminFormEdit from './formedit';

export default class CloverAdminForm extends PanelExternal {
  constructor(props) {
    super(props);

    this.editform = CloverAdminFormEdit;
    this.dataindex = "forms";
    this.idfield="name";
    this.panelindex = "forms";
    this.datatype = "form";
    this.title = CloverAdminLang.form.title;
  }

  gridColumns(){
    var me = this;
    return [{
        key: 'name',
        name: CloverAdminLang.column.name,
        resizable: true
    },{
      key: 'isTemplate',
      name: CloverAdminLang.column.template,
      resizable: true,
      type: 'checkbox'
    }];
  }
}