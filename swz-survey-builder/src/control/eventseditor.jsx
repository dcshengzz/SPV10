import React, { Component } from 'react'
import { Form } from 'semantic-ui-react'
import CollectionEditor from './collectioneditor';

export default class EventsEditor extends React.Component {
  constructor(props){
    super(props);
    this.state = {}
  }
  
  render() {
    const me = this;
    var data = this.props.data;
    var events = this.props.events;
    var actionOptions = [];
    if(Array.isArray(this.props.actions)){
        this.props.actions.forEach(function(a){
            actionOptions.push({text: a, value: a});
        });
    }
    var targetOptions = [...this.props.targets];
   
    let res = [];
    events.forEach(function(e){
      let key = e + "_events";
      let event = data != undefined ? data[e] : undefined;
      if(event == undefined){
        event = {};
      }
     
      if(event.actions == undefined) event.actions = [];
      if(event.targets == undefined) event.targets = [];
      if(event.parameters == undefined) event.parameters = [];
      
      if(Array.isArray(event.actions)){
        event.actions.forEach(function(a){
            let isFind = false;
            for(let i = 0; i < actionOptions.length; i++){
                if(a == actionOptions[i].value){
                    isFind = true;
                    break;
                }
            }

            if(!isFind){
                actionOptions.push({text: a, value: a});
            }
        });
       }
      
       if(Array.isArray(event.targets)){
        event.targets.forEach(function(a){
            let isFind = false;
            for(let i = 0; i < targetOptions.length; i++){
                if(a == targetOptions[i].value){
                    isFind = true;
                    break;
                }
            }

            if(!isFind){
                targetOptions.push({text: a, value: a});
            }
        });
       }

      res.push(<div key={key}>
        <Form.Checkbox width={3} key="active" label={e} name="active" checked={event.active} onChange={me.handleChange.bind(me, e)} />
        <div key="divGroup" style={event.active ? {} : { display: 'none' }}>
            <Form.Group key="Group">
                <Form.Dropdown key="actions" label="Actions" multiple search selection allowAdditions 
                name="actions" options={actionOptions} value={event.actions} 
                onAddItem={me.actionsOnAddItem.bind(me)} onChange={me.handleChange.bind(me, e)} />
                <CollectionEditor key="parameters"
                    columns={['name', 'value']} 
                    label="Parameters" 
                    name="parameters" 
                    value={event.parameters}
                    onChange={me.handleChange.bind(me, e)}/>
                <Form.Dropdown key="targets" label="Targets" multiple search selection
                    name="targets" options={targetOptions} value={event.targets} 
                    onChange={me.handleChange.bind(me, e)}/>
            </Form.Group>
        </div>
     </div>);
    });
    
    return <div>{res}</div>;
  }

  handleChange(eventName, e, {name, value, checked}){
    var event = this.props.data[eventName];
    if(event == undefined){
        event = {};
        this.props.data[eventName] = event;
    }

    if(value == undefined && checked != undefined){
        event[name] = checked;
    }
    else{
        event[name] = value;

        if(value != undefined && value != ""){
            event.active = true;
        }
    }
    if(this.props.onChange != undefined)
        this.props.onChange(e, {name: this.props.name, value: this.props.data});
  }

  actionsOnAddItem(e, { value }){
      if(this.props.onAdditionActions != undefined)
        this.props.onAdditionActions(e, { value });
  }
}