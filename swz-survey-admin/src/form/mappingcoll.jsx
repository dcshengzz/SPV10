import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./../basecomponent"
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm, Icon } from 'semantic-ui-react'
import JSON5 from 'json5'
import MappingAppribute from './mappingattribute'

export default class CloverAdminFormMappingColl extends BaseComponent {
  constructor(props) {
    super(props);

    this.state = {
      expanded: {}
    };
  }

  onExpand(key, value){
    this.state.expanded[key] = value;
    this.forceUpdate();
  }

  onCreate(){
    this.props.form.dataColl.push({id: this.NewGUID(), dataMap: []});
    this.props.parent.validate();
    this.forceUpdate();
  }

  onDelete(key){
    var coll = this.props.form.dataColl;
    var index;

    for(var i=0; i < coll.length; i++){
      if(coll[i].id == key){
        index = i;
        break;
      }
    }

    if(index != undefined){
      coll.splice(index, 1);
      this.props.parent.forceUpdate();
    }
  }

  render(){
    var coll = this.props.form.dataColl;
    return (<div className="clover-formmapping-collection">
      <h2>Collections</h2>
      <div className="clover-formmapping-collection-toolbar">
        <a onClick={this.onCreate.bind(this)}>{CloverAdminLang.button.create}</a>
      </div>
      {this.renderColl(coll)}
      </div>);
  }

  handleChanged(item, e, {name, value, checked}){ 
    if(name == "readOnly"){
      item[name] = checked;
    }else{
      item[name] = value; 
    }
    
    if(name == "entityId"){
      item.dataMap = this.props.parent.createDataMap(value, undefined, "", []);
    }


    this.props.parent.validate();
    this.forceUpdate();
  };
  
  renderColl(coll){
    var res = [];
    var me = this;

    coll.forEach(function(c){
      var key = c.id;

      var isexpanded = me.state.expanded[key];
      var icon;
      if(isexpanded){
        icon = <img onClick={me.onExpand.bind(me, key, false)} className="clover-formadmin-imgbutton" src="/images/collapse.svg"/>;
      }
      else{
        icon = <img onClick={me.onExpand.bind(me, key, true)} className="clover-formadmin-imgbutton" src="/images/expand.svg"/>;
      }
      
      var dropzoneForControl;
      if(c.control == undefined){
        dropzoneForControl = <div key="dz" className="clover-formmapping-zone" data-id={c.id}>Control...</div>
      }
      else{
        var mapdataObj = me.props.parent;
        dropzoneForControl = <div key="control" className="mapdatacontrol" draggable="true"
          onDragStart={mapdataObj.onDragStart.bind(mapdataObj, c.control)}
          onDragEnd={mapdataObj.onDragEnd.bind(mapdataObj, c.control)} 
          onDoubleClick={mapdataObj.onDoubleClick.bind(mapdataObj, c.control)} >
            <span key="span">{c.control}</span>
          </div>;
      }

      var content = <div key={key+"_div"} className="clover-formmapping-collection-row">
        <Form>
          <Form.Group>
            <div className="clover-formadmin-imgbuttondiv2">
              {icon}
            </div>
            <Form.Dropdown key="entityId" label={CloverAdminLang.datamap.collectionentityfield} name="entityId" options={me.props.entities} 
                value={c.entityId} onChange={me.handleChanged.bind(me, c)} error={Boolean(c.__error.entityId)} selection fluid search />
            <Form.Dropdown key="filter" label={CloverAdminLang.datamap.collectionfilterfield} name="filter" options={me.props.codeactions} 
                value={c.filter} onChange={me.handleChanged.bind(me, c)} error={Boolean(c.__error.filter)} selection fluid search />
            <Form.Input key="parameter" name="parameter" label={CloverAdminLang.field.parameter} value={c.parameter != null ? c.parameter : ""} onChange={me.handleChanged.bind(me, c)}/>
            {dropzoneForControl}
            <Form.Checkbox key="readOnly" label={CloverAdminLang.field.readonly} name="readOnly" checked={c.readOnly} onChange={me.handleChanged.bind(me, c)} />
            <div className="clover-formadmin-imgbuttondiv2">
              <img className="clover-formadmin-imgbutton" onClick={me.onDelete.bind(me, key)} src="/images/delete.svg" />
            </div>
          </Form.Group>
          {isexpanded && <div key={key+"_att"} className="field children">
            <label key={key+"_label"}>{CloverAdminLang.field.attributes}</label>
            {c.entityId != undefined && me.renderFields(c)}
          </div>}
        </Form>
      </div>;
      res.push(content);
    });

    return res;
  }

  renderFields(item){
    var res = [];
    var me = this;
    var options = undefined;
    var datalistid = undefined;
    if(item.control != undefined && this.props.formsource != undefined){
      options = this.getOptionsByControl(item.control, this.props.formsource);
      datalistid = item.id + "_datalist";
      var optValue = [];
      if(Array.isArray(options)){
        options.forEach(function(o){
          optValue.push(<option key={o} value={o} />);
        });
      }
      
      res.push(<datalist key={datalistid} id={datalistid}>{optValue}</datalist>);
    }
    item.dataMap.forEach(function(dm){
      if(dm.parentId == undefined){
        res.push(<MappingAppribute key={dm.id}
          collectionId={item.id}
          item={dm} 
          parent={me} 
          dataMap={item.dataMap} 
          hidedropzone={true} 
          datalist={datalistid} />);
      }
    });

    return res;
  }

  getOptionsByControl(controlKey, model){
    var modelControl = this.findControl(controlKey, model);
    if(modelControl == undefined)
      return undefined;
    
    if(Array.isArray(modelControl.columns)){
      let res = [];
      modelControl.columns.forEach(function(c){
        res.push(c.key);
      });
      return res;
    }
    return [];
  }

  findControl(controlKey, model){
    for(var i=0; i < model.length; i++){
      if(model[i].key == controlKey)
        return model[i];
      
      if(Array.isArray(model[i].children)){
        let tmp = this.findControl(controlKey, model[i].children);
        if(tmp != undefined)
          return tmp;
      }

      if(model[i].placeholders != undefined){
        for(let ph in model[i].placeholders){
          if(Array.isArray(model[i].placeholders[ph])){
            let tmp = this.findControl(controlKey, model[i].placeholders);
            if(tmp != undefined)
              return tmp;
          }
        }
      }
    }
    return undefined;
  }
}