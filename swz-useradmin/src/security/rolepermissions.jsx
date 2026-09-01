import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'

export default class CloverAdminRolePermissions extends React.Component {
  constructor(props) {
    super(props);

  }

  handleChange(permissionId, e, {name, value, checked}){
    var values = this.props.value;
    var isFind = false;
    for(var i=0; i < values.length; i++){
      if(values[i].id == permissionId){
        values[i].accessType = value;
        isFind = true;
        break;
      }
    }

    if(!isFind){
      this.props.value.push({id: permissionId, accessType: value});
    }

    this.props.parent.setUpdatedState(this.props.parent.props.data);
    this.forceUpdate();
  }

  setAccessType(group, accesstype){
    if(group == undefined || group.children == undefined)
      return;

    var values = this.props.value;
   
    for(var i=0; i < group.children.length; i++){
      var isFind = false;
      for(var j=0; j < values.length; j++){
        if(values[j].id == group.children[i].id){
          values[j].accessType = accesstype;
          isFind = true;
        }
      }

      if(!isFind){
        values.push({id: group.children[i].id, accessType: accesstype});
      }
    }

    this.props.parent.setUpdatedState(this.props.parent.props.data);
    this.forceUpdate();
  }

  render(){
    var grid = [];
    var items = this.props.items;
    
    for(var i=0; i < items.length; i++){
      var item = items[i];
      var field = item.name;
      if(item.code != item.name)
        field += " (" + item.code + ")";
      
      var key = "rolegroup_" + item.id;
      var griditem = (<Form.Group key={key} widths="16" className="clover-formadmin-item">
          <div className="field">
            <Form.Input key="groupName" value={field} readOnly></Form.Input>
            <div>
              <a onClick={this.setAccessType.bind(this, item, 0)}>{CloverAdminLang.role.resetbutton}</a>&nbsp;&nbsp;
              <a onClick={this.setAccessType.bind(this, item, 1)}>{CloverAdminLang.role.allowbutton}</a>&nbsp;&nbsp;
              <a onClick={this.setAccessType.bind(this, item, 2)}>{CloverAdminLang.role.denybutton}</a>
            </div>
          </div>
          <div>
            {this.renderChildren(item, this.props.value)}                    
          </div>
      </Form.Group>);

      grid.push(griditem);
    }
    
    return (<div>{grid}</div>);
  }

  renderChildren(group, values){    
    var res = [];
    for(var i=0; i < group.children.length; i++){
      var item = group.children[i];

      var field = item.name;
      if(item.Code != item.name)
        field += " (" + item.code + ")";
      
      var key = "roleperm_" + item.id;
      var accessType = this.getAccessType(item.id, values);
      var griditem = (<div key={key + "_div"}>
            <Form.Group key="group" className="clover-formadmin-rolepersmissionsgroup">
              <div key="c1" className="field">
                <label key="divlabel">{field}</label>
                <Form.Group key="divgroup" widths="equal">
                  <Form.Radio key="type0" name={key + "_type"} label={CloverAdminLang.role.inheritedtype} value={0} checked={accessType == 0 } onChange={this.handleChange.bind(this, item.id)} />
                  <Form.Radio key="type1" name={key + "_type"} label={CloverAdminLang.role.allowtype} value={1} checked={accessType == 1} onChange={this.handleChange.bind(this, item.id)} />
                  <Form.Radio key="type2" name={key + "_type"} label={CloverAdminLang.role.denytype} value={2} checked={accessType == 2} onChange={this.handleChange.bind(this, item.id)} />
                </Form.Group>
              </div>
            </Form.Group>
          </div>);
      res.push(griditem);
    }
    return res;
  }

  getAccessType(permissionId, values){
    var res = 0;

    if(values == undefined)
      return res;

    for(var i=0; i < values.length; i++){
      if(values[i].id == permissionId){
        res = values[i].accessType;
        break;
      }
    }
    return res;
  }
}