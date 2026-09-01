import React, { Component } from 'react'
import { Form, Radio, Modal, Button } from 'semantic-ui-react'

export default class SwzModal extends React.Component {
  constructor(props){
    super(props);
    this.state = {
        open: props.swzData.isOpen,
    }
  }
  
 openModal = (e) =>  {
  this.setState({open:true});
  if(this.props.handleEvent !== undefined){
   this.props.handleEvent({syntheticEvent: e, key: this.props.name, eventName: "onClick"}); 
   }
 
 }

 close = () => this.setState({ open: false })

  render() {
    var buttonControl = {};
    for(var i in this.props.swzButton){   
     buttonControl[i] = this.props.swzButton[i];
    }
 
 // console.log(this.props.swzData)
  return (<div><Button {...buttonControl} onClick={this.openModal}></Button><div name={this.props.name} className={this.props.className} style={this.props.style} data-buildertype={this.props.databuildertype} children={this.props.children}></div>
  <Modal dimmer='inverted' open={this.state.open} onClose={this.close}>
  <Modal.Content>{this.props.children}</Modal.Content>
  </Modal>
      </div>   
      );
  }
}