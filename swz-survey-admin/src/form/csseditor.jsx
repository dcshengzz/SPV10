import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'

import PanelExternal from '../panelexternal'
import EditForm from './cssedit';

export default class CloverAdminCss extends PanelExternal {
  constructor(props) {
    super(props);

    this.editform = EditForm;
    this.dataindex = "forms";
    this.idfield = "name";
    this.panelindex = "formstyle";
    this.datatype = "form";
    this.title = "Form Style";
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