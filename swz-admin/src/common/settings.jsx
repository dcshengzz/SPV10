import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./../basecomponent"
import { Form, Input, Checkbox, Segment } from 'semantic-ui-react'

export default class CloverAdminSettings extends BaseComponent {
  constructor(props) {
    super(props);
  }

  onChange(item, e,  {name, checked, value}){
    if(item.editorType == "checkbox"){
        item.value = checked;
    }
    else{
        item.value = value;
    }
    if(item["__state"] != "inserted")
        item["__state"] = "updated";

    this.forceUpdate();
  }

  render(){
    var coll = this.props.data;
    var items = {};
    for(var i=0; i < coll.length; i++){
        var item = coll[i];
        if(items[item.groupName] == undefined){
            items[item.groupName] = [];
        }
        
        var res = undefined;
        var itemProps = {
            key: i.toString(),
            name: i.toString(),
            label: item.paramName
        };
        
        if(item.editorType == "readonly")
            res = <Form.Input {...itemProps} disabled={true} value={item.value} onChange={this.onChange.bind(this, item)}/>;
        else if(item.editorType == "number")
            res = <Form.Input {...itemProps} type="number" value={item.value} onChange={this.onChange.bind(this, item)} />;
        else if(item.editorType == "password")
            res = <Form.Input {...itemProps} type="password" value={item.value} onChange={this.onChange.bind(this, item)} />;
        else if(item.editorType == "checkbox"){
            res = <Form.Checkbox {...itemProps} checked={this.stringToBoolean(item.value)} onChange={this.onChange.bind(this, item)} />;
        }
        else 
            res = <Form.Input {...itemProps} value={item.value} onChange={this.onChange.bind(this, item)} />;
        
        items[item.groupName].push(res);
    }

    var renderItems = [];
    for(var group in items){
        renderItems.push(<div className="clover-formadmin-segment" key={group}>
             <h1>{group}</h1>
             <Form> 
                {items[group]} 
             </Form>
         </div>);
    }

    return (<div>{renderItems}</div>);
  }

  stringToBoolean(string){
    if(string.toLowerCase == undefined)
        return Boolean(string);
        
    switch(string.toLowerCase().trim()){
        case "true": case "yes": case "1": return true;
        case "false": case "no": case "0": case null: return false;
        default: return Boolean(string);
    }
  }
}