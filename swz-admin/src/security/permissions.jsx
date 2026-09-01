import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./../basecomponent"
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm, Image } from 'semantic-ui-react'
import JSON5 from 'json5'

export default class CloverAdminPermissions extends BaseComponent {
  constructor(props) {
    super(props);

    this.datatype = "permissions";
    this.state = {};
    this.initData(props.data.permissions);
  }

  initData(data){
    var res = this.СloneObj(data);

    var softFunc = function(a,b){
      if (a.name > b.name) return 1;
      if (a.name < b.name) return -1;
      return 0;
    };

    res.forEach(function(item){
      if(item.children != undefined){
        item.children = item.children.sort(softFunc);
      }
    });
    res = res.sort(softFunc);

    this.state.data = res;
  }

  render(){
    this.validate();

    var grid = [];
    var groups = this.state.data;
    
    for(var i=0; i < groups.length; i++){
      var data = groups[i];
      if(data["__state"] == "deleted")
        continue;
        
      var griditem = (<div key={"g_" + groups[i].id} className="clover-formadmin-item">
        <Form key="form">
          <Form.Group key="group">
            <div key="div" className="field" widths="6">
              <Form.Input key="code" name="code" label={CloverAdminLang.field.code} error={Boolean(data.__error.code)} value={data.code} onChange={this.handleChange.bind(this, data)} />
              <Form.Input key="name" name="name" label={CloverAdminLang.field.name} error={Boolean(data.__error.name)} value={data.name} onChange={this.handleChange.bind(this, data)} />
              <div key="buttons" style={{marginTop:'10px'}}>
                  <a key="btndelete" onClick={this.onDeleteGroup.bind(this, groups[i].id)}>{CloverAdminLang.permission.deletegroupbutton}</a>&nbsp;&nbsp;
                  <a key="btncreatepermission" onClick={this.onCreatePermission.bind(this, groups[i].id)}>{CloverAdminLang.permission.createpermissionbutton}</a>
              </div>
            </div>
            <div key="children" className="field" widths="10">
              {this.renderChildren(groups[i])}
            </div>
          </Form.Group>
        </Form>
      </div>);

      grid.push(griditem);
    }
    
    return (<div>
       <h1>{CloverAdminLang.permission.managepermissionsfield}</h1>
       <div className="cloveradmin-toolbar">
          <Button className="buttontype1" onClick={this.onCreateGroup.bind(this)}>{CloverAdminLang.permission.creategroupbutton}</Button>
          {this.state.ischanged && <Button className="buttontype1" onClick={this.onSave.bind(this)}>{CloverAdminLang.button.save}</Button>}
          {this.state.ischanged && <Button className="buttontype2" onClick={this.onCancel.bind(this)}>{CloverAdminLang.button.cancel}</Button>}
      </div>
    {grid}
    </div>);
  }

  renderChildren(group){
    if(group.children == undefined || group.children.length == 0)
      return;

    var res = [];
    for(var i=0; i < group.children.length; i++){
      var data = group.children[i];
      
      var griditem = (<Form.Group key={"group_" + data.id} widths="equal">
          <Form.Input key="code" name="code" label={CloverAdminLang.field.code} error={Boolean(data.__error.code)} value={data.code} onChange={this.handleChange.bind(this, data)} />
          <Form.Input key="name" name="name" label={CloverAdminLang.field.name} error={Boolean(data.__error.name)} value={data.name} onChange={this.handleChange.bind(this, data)} />            
          <Image className="clover-buttonimage" key="btndelete" src="/images/clover-delete.png" onClick={this.onDeletePermission.bind(this, group, data.id)} />
        </Form.Group>);

      res.push(griditem);
    }
    return res;
  }

  handleChange(obj, e, {name, value, checked}){
    var originalValue = obj[name];
    obj[name] = value;
    if(name == "code"){
      if(originalValue == obj.name || obj.name == undefined){
        obj.name = obj.code;
      }
    }

    this.setUpdatedState(obj);
    this.state.ischanged = true;
    this.forceUpdate();
  }

  validate(){
    var res = true;

    this.state.data.forEach(function(g){
      var msgRequiredField = CloverAdminLang.msg.fieldrequired;
      g.__error = {
        code: (g.code == undefined || g.code == "") ? msgRequiredField : undefined,
        name: (g.name == undefined || g.name == "") ? msgRequiredField : undefined
      };

      res &= g.__error.code == undefined && g.__error.name == undefined;

      if(g.children != undefined){
        g.children.forEach(function(c){
          c.__error = {
            code: (c.code == undefined || c.code == "") ? msgRequiredField : undefined,
            name: (c.name == undefined || c.name == "") ? msgRequiredField : undefined
          };

          res &= c.__error.code == undefined && c.__error.name == undefined;
        });
      }
    });

    return res;
  }

  onSave(){
    var me = this;
    
    if(!this.validate()){
      alertify.error(CloverAdminLang.msg.checkerrorsonform);
      return;
    }

    var changes = [];
    this.state.data.forEach(function(item){
      if(item["__state"] != undefined){
        changes.push({
          ...item,
          isGroup: true,
          "__type": me.datatype
        });
      }
      else if(item.children != undefined){
        var isChanged = false;
        item.children.forEach(function(child){
          if(child["__state"] != undefined){
            isChanged = true;
          }});

        if(isChanged){
          changes.push({
            ...item,
            isGroup: true,
            "__state": "updated",
            "__type": me.datatype
          });
        }
      }
    });

    this.ChangeData(changes, function(response){
      me.ResetSystemProps(me.state.data);
      me.props.data.permissions = me.state.data;
      me.onCancel();
    });
  }

  onCancel(){
    this.initData(this.props.data.permissions);
    this.state.ischanged = false;
    this.forceUpdate();
  }

  onCreateGroup(){
    var groups = this.state.data;
    groups.unshift({id: this.NewGUID(), '__state': "inserted"});
    this.state.ischanged = true;
    this.forceUpdate();
  }

  onDeleteGroup(id){
    var groups = this.state.data;
    var index = undefined;
    for(var i=0; i < groups.length; i++){
      if(groups[i].id == id){
        index = i;
        break;
      }
    }

    if(index != undefined){
      if(groups[i]["__state"] == "inserted")
        groups.splice(index, 1);
      else
        groups[i]["__state"] = "deleted";
    }
    this.state.ischanged = true;
    this.forceUpdate();
  }

  onCreatePermission(id){
    var groups = this.state.data;
    for(var i=0; i < groups.length; i++){
      if(groups[i].id == id){
        if(groups[i].children == undefined) 
            groups[i].children = [];
        
        var array = groups[i].children;
        array.unshift({id: this.NewGUID(), '__state': "inserted"});
        break;
      }
    }
    this.state.ischanged = true;
    this.forceUpdate();
  }

  onDeletePermission(group, permissionId){
    var groups = this.state.data;
    var index = undefined;
    for(var i=0; i < group.children.length; i++){
      if(group.children[i].id == permissionId){
        index = i;
        break;
      }
    }

    if(index != undefined){
      group.children.splice(index, 1);
      if(group.__state === undefined || group.__state === null)
        group.__state = "updated";
    }

    this.state.ischanged = true;
    this.forceUpdate();
  }
}