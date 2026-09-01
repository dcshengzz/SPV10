import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'

import PanelExternal from './../panelexternal'
import EditForm from './handleredit';

export default class CloverAdminHandler extends PanelExternal {
  constructor(props) {
    super(props);

    this.editform = EditForm;
    this.dataindex = "forms";
    this.idfield = "name";
    this.panelindex = "actionhandlers";
    this.datatype = "form";
    this.title = CloverAdminLang.actionhandler.title;
    this.hidebuttons = true;
  }

  gridColumns(){
    var me = this;
    return [{
        key: 'name',
        name: CloverAdminLang.column.name,
        resizable: true
    }
  ];
  }
}