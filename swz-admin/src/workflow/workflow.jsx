import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'
import PanelExternal from './../panelexternal'
import CloverAdminWorkflowEdit from './workflowedit';


export default class CloverAdminWorkflow extends PanelExternal {
  constructor(props) {
    super(props);

    this.editform = CloverAdminWorkflowEdit;
    this.dataindex = "workflow";
    this.panelindex = "workflow";
    this.idfield = "code";
    this.defaultNamePrefix = "scheme";
    this.datatype = "workflow";
    this.title = CloverAdminLang.workflow.title;
  }

  gridColumns(){
    return [{
        key: 'code',
        name: CloverAdminLang.column.code,
        resizable: true
    }];
  }

  getEditRow(){
    return {code: this.props.id};
  }
}