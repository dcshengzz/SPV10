import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm, Breadcrumb } from 'semantic-ui-react'
import JSON5 from 'json5'
import BaseComponent from './../basecomponent'
import { encodeHtml } from './../utils.jsx'

export default class LocalizationEdit extends BaseComponent {
  constructor(props) {
    super(props);

    this.state = {};
  }

  redrawEditor(){
      if($("#clover-admin-localization").length > 0){
        if(this.editor == undefined){
          this.editor = ace.edit("clover-admin-localization");
          this.editor.getSession().setMode("ace/mode/javascript");
        }
        
        var sourcecode = this.state.obj.source;
        if(sourcecode == undefined)
          sourcecode = "{\n\n\n}";
        this.editor.setValue(sourcecode, -1);
      }
  }

  render(){
    var me = this;
    if(this.state.id != this.props.data.name)
    {  
      this.setObject(this.props.data.name);
      return null;
    }
    
    this.validate();
    return (<div>
        <Breadcrumb>
            <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>{CloverAdminLang.localization.title}</Breadcrumb.Section>
            <Breadcrumb.Divider />
            <Breadcrumb.Section active>{this.props.data.name}</Breadcrumb.Section>
        </Breadcrumb>
        <div className="cloveradmin-toolbar" style={{marginTop:"5px"}}>
            <Button className="buttontype1" onClick={this.onSave.bind(this)}>{CloverAdminLang.button.save}</Button>
            <Button className="buttontype2" onClick={this.onCancel.bind(this)}>{CloverAdminLang.button.cancel}</Button>
            <Button floated="right" className="buttontype2" onClick={this.onUpdateTemplate.bind(this)}>{CloverAdminLang.localization.updatetemplatebutton}</Button>
        </div>
        <div id="clover-admin-localization" style={{height:"calc(100vh - 180px)"}} />
      </div>);
  }

  setObject(local){
    var me = this;
    this.loadobject(local, function(localObj){
      me.state.obj = localObj;
      me.state.id = localObj.name;
      me.forceUpdate();
      me.redrawEditor();
    });
  }

  loadobject(name, callfunc){
    var me = this;
    var data = new Array();
    me.state.id = me.props.data.name;
    data.push({ name: 'operation', value: 'loadlocalization' });
    data.push({ name: 'name', value: name });
    $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: true,
        type: "post",
        success: function (response) {
          if(response.success){
            callfunc(response.item);
          }
          else{
            alertify.error(encodeHtml(response.message));
          }
        }
    });
  }

  onSave(){
    var editor = ace.edit("clover-admin-localization");
    this.state.obj.source = editor.getValue();
   
    var me = this;
    if(!this.validate()){
      alertify.error(CloverAdminLang.msg.checkerrorsonform);
      this.forceUpdate();
      return;
    }

    this.state.obj.__type = "localization";
    this.state.obj.__state = "updated";
    this.ChangeData([this.state.obj], function(response){
      me.ResetSystemProps(me.state.obj);
      me.forceUpdate();

      let isFind = false;
      me.props.metadata.localization.forEach(function(item){
        if(item.name == me.state.obj.name){
          isFind = true;
          return false;
        }
      });

      if(!isFind)
        me.props.metadata.localization.push({name: me.state.obj.name});
      
    });
  }

  onCancel(){
    this.props.onCancel.bind(this.props.parent)();
    this.redrawEditor();
  }

  validate(){
    return true;
  }

  onUpdateTemplate(){
    var me = this;
    var data = new Array();
    var editor = ace.edit("clover-admin-localization");
    var source = editor.getValue();
    data.push({ name: 'operation', value: 'localizationupdatetemplate' });
    data.push({ name: 'name', value: me.state.obj.name });
    data.push({ name: 'source', value: source });
    $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: true,
        type: "post",
        success: function (response) {
          if(response.success){
            me.editor.setValue(response.item, -1);
          }
          else{
            alertify.error(encodeHtml(response.message));
          }
        }
    });
    
  }
}