import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'

import PanelExternal from './../panelexternal'
import EditForm from './mapdataedit';

export default class CloverAdminMapData extends PanelExternal {
  constructor(props) {
    super(props);

    this.editform = EditForm;
    this.dataindex = "forms";
    this.idfield = "name";
    this.panelindex = "formdata";
    this.datatype = "form";
    this.title = CloverAdminLang.datamap.title;
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