import React, { Component } from 'react'
import { Trigger, Dropdown, Image } from 'semantic-ui-react'

export default class DropdownTrigger extends React.Component {
  constructor(props){
    super(props);

    this.state = {};
  }

  render() {
    var me = this;
    
    var controlProps = {};
    for(var p in this.props){
        if(p == "imageUrl" || 
            p == "defaultValue" ||
            p == "value" ||
            p == "handleEvent" ||
            p == "items" )
            continue;
        controlProps[p] = this.props[p];
    }

    controlProps.options = [];
    this.props.items.forEach(function(item){

      let isSkip = false;
      if(item.visibleCondition !== undefined && item.visibleCondition !== null && item.visibleCondition !== ""){
        let args = '';
        let body = 'return ' + item.visibleCondition;
        try{
            if(!new Function(args, body)()){
              isSkip = true;
            }
        }
        catch(e){};
      }

      if(!isSkip)
        controlProps.options.push({value: item.target, text: item.title, target: item.target});
        
    });
    controlProps.onChange = this.onChange.bind(this);
    controlProps.trigger = <span>
        {this.props.imageUrl != undefined && <Image avatar src={this.props.imageUrl} />} {this.props.value != undefined ? this.props.value : this.props.defaultValue}
    </span>;
    return <Dropdown {...controlProps}
      onMouseDown={this.onMouseDown.bind(this)}
    />;
  }

  onChange(e, { name, value }){
    if(this.state.opendialog == true){
      this.state.opendialog = false;
      return;
    }

    if(this.props.handleEvent != undefined){
        this.props.handleEvent({e, key: this.props.name, eventName: "onItemClick", parameters: { target: value }});
    }
  }

  onMouseDown(e){
    this.state.opendialog = !Boolean(this.state.opendialog);
  }
}