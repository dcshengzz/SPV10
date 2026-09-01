import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'

import PanelExternal from './../panelexternal'
import FormEdit from './localizationedit';

export default class CloverAdminForm extends PanelExternal {
  constructor(props) {
    super(props);

    this.editform = FormEdit;
    this.dataindex = "localization";
    this.idfield= "name";
    this.panelindex = "localization";
    this.datatype = "localization";
    this.title = CloverAdminLang.localization.title;
  }

  gridColumns(){
    var me = this;
    return [{
        key: 'name',
        name: CloverAdminLang.column.name,
        resizable: true
    }];
  }
}