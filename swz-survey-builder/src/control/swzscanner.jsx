import React, { Component } from 'react'
import { Form, Radio, Modal, Button } from 'semantic-ui-react'
import { BrowserMultiFormatReader } from '@zxing/library';

export default class SwzScanner extends React.Component {
  constructor(props){
    super(props);
    this.videoTag = React.createRef();
    this.state = {
      showVideo: false,
      onCamera: false,
      value: props.scanValue,
    
    }
  }

onStart(bool) {
  this.setState({showVideo: bool });
  this.setState({onCamera: true});
 
}

shouldComponentUpdate(nextProps, nextState) {
  return (this.state.value != nextState.value  || this.state.showVideo != nextState.showVideo /*|| this.state.onCamera != nextState.onCamera */);
}

getValue(result){
  
  var handleEvent = this.props.additionalParams.handleEvent;
  console.log(result);
  this.setState({value: result})
  if(handleEvent !== undefined){
        return handleEvent({syntheticEvent: null, key:  this.props.additionalParams.model.key, eventName: "onChange"});
    };
}

  render() {
    var me = this;
    var model = this.props.additionalParams.model;
    var propsControl = {};
    propsControl.name = model.key;
    propsControl.size = model.size !== "" ? model.size : null;
    propsControl.basic = model.basic;
    propsControl.compact = model.compact;
    propsControl.disabled = model.disabled;
    propsControl.inverted = model.inverted;
    propsControl.primary = model.primary;
    propsControl.secondary = model.secondary;
    
    const { showVideo, onCamera } = this.state;
    const codeReader = new BrowserMultiFormatReader();

   /*  var getValue = function(result){
      console.log(result.text);
      me.setState({value: result.text})
      if(handleEvent !== undefined){
          console.log("Run function");
            return handleEvent({syntheticEvent: null, key: propsControl.name, eventName: "onChange"});
        };
    } */

    var displayError = function(msg){
      console.log(msg);
      alert('Camera is invalid');
    }

    
    if(showVideo){
      if(!onCamera){
        navigator.mediaDevices
        .getUserMedia({video: true})
        .then(stream => this.videoTag.current.srcObject = stream)
        .catch(displayError());

      codeReader
      .listVideoInputDevices()
      .then(videoInputDevices => {
        videoInputDevices.forEach(device =>
          console.log(`${device.label}, ${device.deviceId}`)
        );
      })
      .catch(err => alert.error(err));
      }
      
      codeReader
        .decodeFromInputVideoDevice(undefined, 'video')
        .then(result => me.getValue(result.text))
        .catch(err => console.error(err));
    }
    
  return (<div>
            {!showVideo ?
            <Button {...propsControl} onClick={() => this.onStart(true)}>Start</Button>
            :<Button {...propsControl} onClick={() => this.onStart(false)}>Stop</Button>
            }
            {showVideo &&
            <video
              id="video"
              /* ref={this.videoTag}*/
              width="300"
              height="200"/* 
              muted
              autoPlay */
              ></video>
            }
            </div> 
      );
  }
}

/*    
      var test = function(){
      var codeReader = new BrowserQRCodeReader();
      var img = document.getElementById('img');
    
      try {
          var result = codeReader.decodeFromImage(img);
      } catch (err) {
          console.error(err);
      }
    
      console.log(result);
    }
*/

{/*<Button onClick={() => test()}> Hit me </Button> */}
{/*  <img
    id="img"
    src="..\..\images\helloworld.png"
    width={"200"}
    height={"300"}
 />  */}