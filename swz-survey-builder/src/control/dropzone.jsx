import React, { Component } from 'react'
import { Form, Dropdown, Button } from 'semantic-ui-react'
import DropzoneComponent from 'react-dropzone-component';

export default class Dropzone extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      commands: props.commands,
      states: props.states
    }
  }

  componentDidMount(){
    this.isMount = true;
  }

  componentWillUnmount(){
    this.isMount = false;
  }

  render() {
    var me = this;
    
    var data = this.props.additionalParams.data;
    var errors = this.props.additionalParams.errors;
    var parentItem = this.props.additionalParams.parentItem;
    var handleEvent = this.props.additionalParams.handleEvent;

    var iconFiletypes = undefined;
    if(this.props.iconFiletypes != undefined && this.props.iconFiletypes != ""){
      let types = this.props.iconFiletypes.split(",");
      if(Array.isArray(types) && types.length > 0){
        iconFiletypes = [];
        types.forEach(function(t){
          iconFiletypes.push(t.trim());
        });
      }
    }

    var djsConfig = {
      addRemoveLinks: this.props.addRemoveLinks,
      autoProcessQueue: this.props.autoProcessQueue && this.props.postUrl != undefined
    };

    var componentConfig = {
      iconFiletypes,
      showFiletypeIcon: this.props.showFiletypeIcon,
      postUrl: this.props.postUrl == undefined ? "no-url" : this.props.postUrl
    };

    
    var eventHandlers = {
      success: me.fileUploadSuccess.bind(this)
    };
    // if(handleEvent != undefined){
    //   var events = this.getEvents();
    //   events.forEach(function(e){
    //     eventHandlers[e] = handleEvent({ key: me.props.name, eventName: e});
    //   });
    // }

    let control = this.props.readOnly ? 
      <div></div> : 
      <DropzoneComponent config={componentConfig} eventHandlers={eventHandlers} djsConfig={djsConfig} ></DropzoneComponent>;
    
    let res = undefined;
    if(this.isForm(parentItem)){
      res = <div className="field">{control}</div>;
    }
    else{
      res = control;
    }
    return res;
  }

  isForm(m){
    return (m != null && 
        (m["data-buildertype"] == "form" || 
        m["data-buildertype"] == "formgroup"));
  };

  fileUploadSuccess(file, response){
    var handleEvent = this.props.additionalParams.handleEvent;
    if(handleEvent != undefined){
      handleEvent({key: this.props.name, 
        eventName: "success", 
        name: this.props.name, 
        value: response.message,
        parameters: {
          name: file.name,
          size: file.size,
          token: response.message
        }
      });

      setTimeout(function(){
        file._removeLink.click();
      },500);
    }
  }

  getEvents(){
    return ["drop", 
      "dragstart",
      "dragend",
      "dragenter",
      "dragover",
      "dragleave",
      "addedfile",
      "removedfile",
      "thumbnail",
      "error",
      "processing",
      "uploadprogress",
      "sending",
      "success",
      "complete",
      "canceled",
      "maxfilesreached",
      "maxfilesexceeded",
      "processingmultiple",
      "sendingmultiple",
      "successmultiple",
      "completemultiple",
      "canceledmultiple",
      "totaluploadprogress",
      "reset",
      "queuecompleted"];
  }
}