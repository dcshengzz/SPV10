import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Button } from 'semantic-ui-react'
import CloverAdminPanelBase from './../panelbase'
import CloverAdminDataEdit from './dataedit';

export default class CloverAdminData extends CloverAdminPanelBase {
  constructor(props) {
    super(props);

    this.dataindex = "dataModel";
    this.panelindex = "datamodel";
    this.defaultNamePrefix = "table";
    this.datatype = "datamodel";
    this.title = CloverAdminLang.data.title;
    this.idfield = "id";
    this.editform = CloverAdminDataEdit;
  }

  renderToolbar(){
    var me = this;
    var showconfirmdelete = () => {me.setState({confirmdeleteshow: true})};
    var showconfirmcopy = () => {
      var selectedKeys = this.grid.getSeletedRowKeys();
      if(selectedKeys.length !== 1){
        alertify.error(CloverAdminLang.msg.needtoselectoneitem);
      }
      else{
        me.props.parent.openpage(this.panelindex, "new", selectedKeys[0]);
      }
    };
    var showconfirmcreate = () => {me.props.parent.openpage(this.panelindex, "new")};

    return <div className="cloveradmin-toolbar">
            <Button className="buttontype1" onClick={showconfirmcreate}>{CloverAdminLang.button.create}</Button>
            <Button className="buttontype2" onClick={showconfirmcopy}>{CloverAdminLang.button.copy}</Button>
            <Button className="buttontype2" onClick={showconfirmdelete}>{CloverAdminLang.button.delete}</Button>
        </div>;
  }

  gridColumns(){
    return [{
        key: 'name',
        name: CloverAdminLang.column.name,
        resizable: true
    },{
        key: 'dbObjectName',
        name: CloverAdminLang.data.dbobjectfield,
        resizable: true
    }];
  }

  validate(){
    var res = true;
    var editrow = this.state.editrow;
    var msgRequiredField = CloverAdminLang.msg.fieldrequired;
    editrow.__error = {
          name: (editrow.name == undefined || editrow.name == "") ? msgRequiredField : undefined,
          dbObjectName: (editrow.dbObjectName == undefined || editrow.dbObjectName == "") ? msgRequiredField : undefined
      };

    res &= editrow.__error.name == undefined && editrow.__error.dbObjectName == undefined;

    if(editrow.attributes != undefined){
      editrow.attributes.forEach(function(c){
            c.__error = {
              name: (c.name == undefined || c.name == "") ? msgRequiredField : undefined,
              type: c.typeId == 0 ? 
                ((c.type == undefined || c.type == "") ? msgRequiredField : undefined) :
                undefined,
              referenceEntityId: c.typeId == 1 ? 
                ((c.referenceEntityId == undefined || c.referenceEntityId == "") ? msgRequiredField : undefined) :
                undefined
            };
            if (c.isExtension && !editrow.extensionsContainerAttribute) {
                c.__error.isExtension = CloverAdminLang.msg.extensionscontainerfieldrequired;
                editrow.__error.extensionsContainerAttribute = CloverAdminLang.msg.extensionscontainerfieldrequired;
            }
            res &= c.__error.name == undefined && c.__error.type == undefined && c.__error.referenceEntityId == undefined && c.__error.isExtension == undefined;
        });
    }
    if(editrow.triggers != undefined){
      editrow.triggers.forEach(function(c){
          c.__error = {
            triggers: (Array.isArray(c.triggers) && c.triggers.length > 0) ? undefined : msgRequiredField,
            codeActionId: (c.codeActionId == undefined || c.codeActionId == "") ? msgRequiredField : undefined
          };
          res &= c.__error.triggers == undefined && c.__error.codeActionId == undefined;
      });
    }
    res &=  editrow.__error.extensionsContainerAttribute == undefined;
    return res;
  }
}