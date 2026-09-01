import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm, Breadcrumb } from 'semantic-ui-react'
import JSON5 from 'json5'
import BaseComponent from './../basecomponent'

export default class CloverAdminFormMappingLogic extends BaseComponent {
  constructor(props) {
    super(props);

    this.state = {};
  }

  redrawEditor(){
      if($("#clover-admin-formlogic-editcode").length > 0){
        if(this.editor == undefined){
          this.editor = ace.edit("clover-admin-formlogic-editcode");
          this.editor.getSession().setMode("ace/mode/javascript");
        }
        
        var sourcecode = this.state.form.javaScriptCode;
        if(sourcecode == undefined)
          sourcecode = " ";
        this.editor.setValue(this.state.form.javaScriptCode, -1);
      }
  }

  render(){
    var me = this;
    if(this.state.id != this.props.data.name)
    {  
      this.setForm(this.props.data.name);
      return null;
    }
    
    this.validate();
    return (<div>
        <Breadcrumb>
            <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>{CloverAdminLang.actionhandler.title}</Breadcrumb.Section>
            <Breadcrumb.Divider />
            <Breadcrumb.Section active>{this.props.data.name}</Breadcrumb.Section>
            <Breadcrumb.Divider icon='right angle' />
            <Breadcrumb.Section href={"?apanel=forms&aid=" + this.state.id} onClick={this.openBuilder.bind(this)}>{CloverAdminLang.actionhandler.builder}</Breadcrumb.Section>
            <Breadcrumb.Divider />
            <Breadcrumb.Section href={"?apanel=formdata&aid=" + this.state.id} onClick={this.openDataMap.bind(this)}>{CloverAdminLang.actionhandler.datamap}</Breadcrumb.Section>
        </Breadcrumb>
        <div className="cloveradmin-toolbar" style={{marginTop:"5px"}}>
            <Button className="buttontype1" onClick={this.onSave.bind(this)}>{CloverAdminLang.button.save}</Button>
            <Button className="buttontype2" onClick={this.onCancel.bind(this)}>{CloverAdminLang.button.cancel}</Button>
            <Button floated="right" className="buttontype2" onClick={this.onSetDefaultTemplate.bind(this)}>{CloverAdminLang.actionhandler.setdefaulttemplatebutton}</Button>
        </div>
        <div id="clover-admin-formlogic-editcode" style={{height:"calc(100vh - 180px)"}}/>
      </div>);
  }

  openDataMap(e){
    this.props.parent.props.parent.openpage("formdata", this.state.id);
    e.preventDefault();
  }

  openBuilder(e){
      this.props.parent.props.parent.openpage("forms", this.state.id);
      e.preventDefault();
  }

  setForm(formId){
    var me = this;
    this.loadform(formId, function(form){
      me.state.form = form;
      me.state.id = form.name;
      me.forceUpdate();
      me.redrawEditor();
    });
  }

  loadform(name, callfunc){
    var me = this;
    var data = new Array();
    me.state.id = me.props.data.name;
    data.push({ name: 'operation', value: 'loadform' });
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
            alertify.error(response.message);
          }
        }
    });
  }

  redirectToFormEdit(){
    this.props.parent.openpage("forms");
  }

  onSave(){
    var editor = ace.edit("clover-admin-formlogic-editcode");
    this.state.form.javaScriptCode = editor.getValue();
   
    var me = this;
    if(!this.validate()){
      alertify.error(CloverAdminLang.msg.checkerrorsonform);
      this.forceUpdate();
      return;
    }

    this.state.form.__type = "formcode";
    this.state.form.__state = "updated";
    this.ChangeData([this.state.form], function(response){
      me.ResetSystemProps(me.state.form);
      me.forceUpdate();
    });
  }

  onCancel(){
      this.props.onCancel.bind(this.props.parent)();
      this.redrawEditor();
  }

  validate(){
    var me = this;
    var res = true;
    var editrow = this.state.form;

    if(editrow == undefined)
      return false;
    
    editrow.__error = {};
    return res;
  }

  onSetDefaultTemplate(){
    var template = "{\n";
    template += "//  validate: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){\n\
//    var errors = {};\n\
//    //TODO: Insert your code for validation this form\n\
//    if(data.name == undefined || data.name == ''){\n\
//      errors.name = 'This field is requered!';\n\
//    }\n\
//    if(errors.name){\n\
//      throw {\n\
//          level: 1,\n\
//          message: 'Check errors on the form!',\n\
//          formerrors: {main: errors}\n\
//      };\n\
//    }\n\
//    return {};\n\
//  }";

    var controlActions = this.props.controlActions;
    if(controlActions == undefined) 
      controlActions = [];

    var actions = this.getControlsActions(JSON.parse(this.state.form.source));
    if(actions != undefined){
      for(let i=0;i<actions.length;i++){
        let isFind = false;
        for(let j=0; j< this.props.controlActions.length; j++){
          if(actions[i] == this.props.controlActions[j]){
            isFind = true;
            break;
          }
        }

        if(!isFind){
          template += ",\n\n";
          template += "  " + actions[i] + ": function (args){\n\
    //TODO: Insert your code\n\
  }";
        }
      }
    }
      
    template += "\n}";
    this.editor.setValue(template, -1);
  }

  getControlsActions(source){
    if(source == undefined || source.constructor != Array)
      return [];

    var me = this;
    var res = [];
    
    source.forEach(function(c){
      if(c.events != undefined){
        for(var e in c.events){
          var actions = c.events[e].actions;
          if(Array.isArray(actions)){
            actions.forEach(function(a){
              let isFind = false;
              for(let i=0;i<res.length; i++){
                if(a === res[i]){
                  isFind = true;
                  break;
                }
              }

              if(!isFind) res.push(a);
            });
          }
        }
      }

      if(c.children != undefined && c.children.length > 0){
        var actions = me.getControlsActions(c.children);
        actions.forEach(function(a){
          let isFind = false;
          for(let i=0;i<res.length; i++){
            if(a === res[i]){
              isFind = true;
              break;
            }
          }
          if(!isFind) res.push(a);
        });
      }
    });
    return res;
  }
}