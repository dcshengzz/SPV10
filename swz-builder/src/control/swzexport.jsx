import React, { Component } from 'react'
import { Form, Radio, Modal, Button, Input } from 'semantic-ui-react'
import Papa from 'papaparse'

     
export default class swzexport extends React.Component {
  constructor(props){
    super(props);
    this.state = {
        jsonData: this.props.swzData.data,
    }
  }
    
    buttonChange = (event) =>{   
      
      const { jsonData } = this.state;
    
      this.callFunction(event);
     var rows = [
        {Email: "Mat@yahoo.com", ActiveYN: "TRUE", Name: "Mat Tan", NumRetry: "34", Pwd: "5566"},
       {Email: "anthony@yahoo.com", ActiveYN: "TRUE", Name: "Anthony Chew", NumRetry: "35", Pwd: "5566"},
      {Email: "John ", ActiveYN: "TRUE", Name: "John ", NumRetry: "36", Pwd: "5566"},
      {Email: "Cathy", ActiveYN: "TRUE", Name: "Cathy", NumRetry: "37", Pwd: "5566"},
      {Email: "zBenedict", ActiveYN: "TRUE", Name: "zBenedict", NumRetry: "38", Pwd: "5566"},
     {Email: "zJane", ActiveYN: "TRUE", Name: "zJane", NumRetry: "39", Pwd: "5566"}];   

      var csv = Papa.unparse(rows);
     
      var downloadLink = document.createElement("a");
      var blob = new Blob(["\ufeff", csv]);
      var url = URL.createObjectURL(blob);
      downloadLink.href = url;
      downloadLink.download = "data.csv";

      document.body.appendChild(downloadLink);
      downloadLink.click();
      document.body.removeChild(downloadLink);
     
  }

  componentWillReceiveProps = () =>{
    const { jsonData } = this.state;
 
    var rcdData = this.props.swzData.data;
     if (this.props.swzData.data != jsonData){
     
      this.setState({jsonData: rcdData})
     }
  }
  
  callFunction = (e) =>{
  
    if(this.props.handleEvent !== undefined){
      this.props.handleEvent({syntheticEvent: e, key: this.props.name, eventName: "onClick"}); 
      }
  }

  render() {
    var buttonControl = {};
    for(var i in this.props.swzButton){   
     buttonControl[i] = this.props.swzButton[i];
    } 
    return (<div>
    <Button {...buttonControl} onClick={this.buttonChange}>Export</Button>
 
      </div>   
      );
  }
}