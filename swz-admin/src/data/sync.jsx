import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./../basecomponent"
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'

export default class CloverAdminDataSync extends BaseComponent {
  constructor(props) {
    super(props);

    this.title = CloverAdminLang.datasync.title;
    this.state = {
      showsystemtables: false
    };
  }

  render(){
    var content;
    var changes = this.state.data;
    if(changes == undefined){
      content = <div>
          <div className="clover-formadmin-info"><br/><br/><a onClick={this.onRefresh.bind(this)}>{CloverAdminLang.datasync.analysingmsg}</a></div>
        </div>;
    }
    else if(changes.length == 0){
      content = <div>
      <div className="clover-formadmin-info"><br/><br/>{CloverAdminLang.datasync.noneedsyncmsg}<br/>
          <a onClick={this.onRefresh.bind(this)}>{CloverAdminLang.datasync.analysingagainmsg}</a></div>
      </div>;
    }
    else
    {
      content = this.renderChanges(changes);
    }
    return (<div>
      <h1>{this.title}</h1>
       {changes != undefined && <div className="cloveradmin-toolbar">
          <Button className="buttontype2" onClick={this.onRefresh.bind(this)}>{CloverAdminLang.button.refresh}</Button>
          <Button className="buttontype1" onClick={this.onApply.bind(this)}>{CloverAdminLang.button.applyselectedchanges}</Button>
          <Button className="buttontype2" onClick={this.massChangeSelect.bind(this, undefined, true)}>{CloverAdminLang.button.selectall}</Button>
          <Button className="buttontype2" onClick={this.massChangeSelect.bind(this, undefined, false)}>{CloverAdminLang.button.deselectall}</Button>
          <Checkbox slider checked={this.state.showsystemtables} onClick={this.onShowSystems.bind(this)} label={CloverAdminLang.datasync.showsystemtables} />
      </div>}
      {content}</div>);
  }

  renderChanges(changes){
    var grid = [];
    for(var i=0; i < changes.length; i++){
      var item = changes[i];

      if(this.state.showsystemtables == false && this.isSystem(item)){
        continue;
      }

      var key = item.id;
      var changeTitle = this.getChangedTitle(item.changedType);
      var griditem = (<div key={key} className="clover-formadmin-item">
        <Form key="form">
          <Form.Group key="formgroup" widths='equal'>
            <div key="formgroupdiv" className="field eight wide" >
              <Form.Group key="formgroup2" widths='equal' style={{ width: '400px;'}}>
                <Form.Checkbox width={1} name="select" key="check" checked={item.__select} onChange={this.handleSelectGroupChange.bind(this, item)} />
                <div className="field">
                  <Form.Input key="name" name="name" label={CloverAdminLang.field.name} value={item.name} readOnly/>
                  <Form.Input key="changeTitle" name="changeTitle" label={CloverAdminLang.datasync.changedtypefield} error={item.changedType == "deleted"} value={changeTitle} readOnly/>
                </div>
              </Form.Group>
              {(item.changes != undefined && item.changes.length > 0) && <div style={{marginTop:'10px'}}>
                  <a key="selectbutton" onClick={this.massChangeSelect.bind(this, item, true)}>{CloverAdminLang.button.select}</a>&nbsp;&nbsp;
                  <a key="deselectbutton" onClick={this.massChangeSelect.bind(this, item, false)}>{CloverAdminLang.button.deselect}</a>
              </div>}
            </div>
            <div key="childrendiv" className="field">
              {this.renderChildren(item)}
            </div>
          </Form.Group>
        </Form>
      </div>);
      grid.push(griditem);
    }
    return grid;
  }

  isSystem(item){
    if(item == null || item.name == undefined)
      return false;

    var systemObj = ["dwAppSettings", "dwSecurity", "dwUploadedFiles", "Workflow", "dwV_Security",
    "DWAPPSETTINGS", "DWSECURITY","DWUPLOADEDFILES","WORKFLOW","DWV_SECURITY"];
    for(let i=0; i < systemObj.length; i++){
      if(item.name.startsWith(systemObj[i]))
        return true;
    }

    return false;
  }

  renderChildren(obj){
    if(obj.changes == undefined || obj.changes.length == 0)
      return;

    var res = [];
    for(var i=0; i < obj.changes.length; i++){
      var item = obj.changes[i];
      var key = item.id;

      var changevalue;
      if(item.originalValue == undefined){
        changevalue = this.getChangedTitle(item.changedType);
      }
      else{
        changevalue = item.originalValue + " -> " + item.newValue;
      }

      var griditem = (<Form.Group key={key} widths='equal'>
          <Form.Checkbox name="changeselect" width={1} key="check" checked={item.__select} onChange={this.handleSelectChange.bind(this, obj, item)} />
          <Form.Input name="parameter" width={5} key="parameter" label={CloverAdminLang.field.parameter} value={item.parameter} readOnly />   
          <Form.Input name="change" width={10} key="value" label={CloverAdminLang.datasync.chages} error={item.changedType == "deleted"} value={changevalue} readOnly />         
        </Form.Group>);

      res.push(griditem);
    }
    return res;
  }

  getChangedTitle(type){
    if(type == "new") return CloverAdminLang.datasync.changestypenew;
    if(type == "changed") return CloverAdminLang.datasync.changetypechanged;
    if(type == "deleted") return CloverAdminLang.datasync.changetypedeleted;
  }

  onApply(){
    var me = this;
    var changes = this.getChangesForApply(this.state.data);
    if(changes.length == 0){
      alertify.error(CloverAdminLang.msg.needtoselectitems);
      return;
    }

    this.ChangeData(changes, function(response){
      me.onRefresh();
    });
  }

  getChangesForApply(items){
    var me = this;
    var res = [];
    items.forEach(function(item){
      if(item.__select){
        res.push({
          ...item,
          __type: "datasync",
          __state: "inserted"
        });
      }
      else if(item.changes != undefined && item.changes.length > 0){
        var children = [];
        item.changes.forEach(function(itemDetail){
          if(itemDetail.__select) children.push(itemDetail);
        });

        if(children.length > 0){
          res.push({
            ...item,
            changes: children,
            __type: "datasync",
            __state: "inserted"
          });
        }
      }
    });

    return res;
  }

  onRefresh(){
    var me = this;
    var data = new Array();
    data.push({ name: 'operation', value: 'analysedb' });
    $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: true,
        type: "post",
        success: function(response){
          if(response.success){
            me.setState({
              isloadig: false,
              data: response.items
            });

            me.props.parent.load();
          }
          else{
              alertify.error(response.message);
          }
        },
        error: function(jqXHR, exception){
          var msg = me.getProcessLoadError(jqXHR, exception);
          alertify.error(msg);
        }
    });
  }

  onSelectAll(){
    this.massChangeSelect(undefined, true);
  }

  onDeselectAll(){
    this.massChangeSelect(undefined, false);
  }

  onSelectGroup(item){
    this.massChangeSelect(item, true);
  }

  onShowSystems(){
    this.setState({
      showsystemtables: !this.state.showsystemtables
    });
  }

  onDeselectGroup(item){
    this.massChangeSelect(item, false);
  }

  massChangeSelect(item, checked){
    if(item != undefined){
      item.__select = checked;

      if(item.changes != undefined){
        item.changes.forEach(function(c){
          c.__select = checked;
        });
      }
    }
    else{
      this.state.data.forEach(function(item){
        item.__select = checked;
        
        if(item.changes != undefined){
          item.changes.forEach(function(c){
            c.__select = checked;
          });
        }
      })
    }
    
    this.forceUpdate();
  }

  handleSelectChange(obj, item, e, {checked}){
    item.__select = checked;
    if(obj.changes != undefined && obj.changes.length > 0){
      var flag = true;
      obj.changes.forEach(function(c){
        flag &= c.__select;
      })
      obj.__select = flag;
    }

    this.forceUpdate();
  }

  handleSelectGroupChange(item, e, {checked}){
    item.__select = checked;
    if(item.changes != undefined){
      item.changes.forEach(function(c){
        c.__select = checked;
      })
    }

    this.forceUpdate();
  }
}