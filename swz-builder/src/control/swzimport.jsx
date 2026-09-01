import React, { Component } from 'react'
import { Form, Radio, Modal, Button, Input } from 'semantic-ui-react'
import Papa from 'papaparse'

     
export default class swzimport extends React.Component {
  constructor(props){
    super(props);
    this.state = {
        csvfile:undefined,
        csvdata:null,
        errorMsg: null
    }
  }
  
  handleChange = (event) => {
    //console.log(event.target.files[0].name);
    var fname = event.target.files[0].name; 
    var re = /(\.csv)$/i;
    if(!re.exec(fname)){
    var err = "File extension not supported!";
      this.setState({errorMsg:err})
     // console.log(err);
    }  
    else if (re.exec(fname)){
    //  console.log("File targeted")
      this.setState({
      csvfile: event.target.files[0]
    })
    
    Papa.parse(event.target.files[0], {
      complete: this.updateData,
      header:true,
      skipEmptyLines:true,
      error: this.errorFunction
    });
    }  
  }

  errorFunction = (error, file) =>{
    
  }

  updateData = (result) => {
    var data = result.data;
    this.setState({
      csvdata:data
    })
    }
    
 
    

  render() {
    return (<div>
    <Input name={this.props.name} 
          className="csv-input" 
          type="file"
          ref={(input) => { this.filesInput = input }}
          name="file"
          label= {null}
          labelPosition ="left"
          placeholder={null}
          onChange={this.handleChange}
          style={this.props.style}
          data-buildertype={this.props.databuildertype}
          accept=".csv"
          ></Input>
      </div>   
      );
  }
}