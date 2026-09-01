import React, { Component } from 'react'
import { Form, Dropdown, Button } from 'semantic-ui-react'

export default class WorkflowBar extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      commands: props.commands,
      states: props.states
    }

    this.checkGetAdditionalDataForControl();
  }

  componentDidMount(){
    this.isMount = true;
  }

  componentWillUnmount(){
    this.isMount = false;
  }

  checkGetAdditionalDataForControl(){
    if(this.props.getAdditionalDataForControl == undefined && 
      this.props.commands == undefined && 
      this.props.states == undefined){
        if(console != undefined){
            console.log("WorkflowBar: This control requres getAdditionalDataForControl or commands and states not undefined parameters!");
        }
    }
    else{
        var me = this;
        this.props.getAdditionalDataForControl(this, {}, function({commands, states}){
            me.state.commands = commands;
            me.state.states = states;

            if(me.props.handleEvent != undefined){
              me.props.handleEvent({key: me.props.name, eventName: "onReceivedCommands", 
                      parameters: { 
                        commands: me.state.commands, 
                        states: me.state.states
                      } 
              });
            }

            if(me.isMount)
                me.forceUpdate();
        });
    }
  }
  
  render() {
    var className = this.props.className + " clover-workflowbar";
    var style = this.props.style;

    var commands = this.state.commands != undefined ? this.state.commands : this.props.commands;
    var states = this.state.states != undefined ? this.state.states : this.props.states;

    return <div className={className} style={style}>
      <Form.Group>
        {this.renderCommands(commands)}
        {this.renderSetState(states)}
      </Form.Group>
    </div>;
  }

  renderCommands(commands){
    if(Array.isArray(commands) && commands.length > 0)
    {
      var me = this;
      var res = [];

      commands.forEach(function(b){
        res.push(<Button key={b.value} className={"buttontype" + b.type} onClick={me.onCommand.bind(me, b)}>{b.text}</Button>);
      });

      return res;
    }
    return undefined;
  }

  renderSetState(states){
    if(Boolean(this.props.blockSetState)){
      return;
    }
    
    if(Array.isArray(states) && states.length > 0){
      var disableClick = this.state["setstate"] == undefined || this.state["setstate"] == "";

      var setStateButton = "Set state";
      
      if(this.props.setStateButton != undefined && this.props.setStateButton != "" ){
        setStateButton = this.props.setStateButton;
      }
      else{
        if(window.CloverAdminLang != undefined && window.CloverAdminLang.workflowbar != undefined){
          setStateButton = window.CloverAdminLang.workflowbar.setstate;
        }
      }

      return [<Form.Dropdown 
        key="setstate"
        name="setstate" 
        className="setstate"
        placeholder="States" 
        options={states}  
        onChange={this.handleChanged.bind(this)} 
        selection fluid search />,
        <Button key="btnsetstate" disabled={disableClick} className="buttontype2" onClick={this.onSetState.bind(this)}>{setStateButton}</Button>
      ];
    }
    return undefined;
  }

  onCommand(button){
    if(this.props.handleEvent != undefined){
      this.props.handleEvent({key: this.props.name, eventName: "onCommandClick", parameters: { command: button } });
    }
  }

  onSetState(){
    if(this.props.handleEvent != undefined){

      var states = this.state.states != undefined ? this.state.states : this.props.states;
      var currentState = undefined;
      for(let i = 0; i < states.length; i++){
        if(states[i].value == this.state.setstate){
          currentState = states[i];
          break;
        }
      }

      this.props.handleEvent({key: this.props.name, eventName: "onSetStateClick", parameters: { state: currentState }});
    }
  }

  handleChanged(e, {name, value}){
    this.state[name] = value;
    this.forceUpdate();
  }
}