import React, { Component } from 'react'

export default class Upload extends React.Component {
  constructor(props){
    super(props);
    this.state = {}
  }

  render(){
    let type = this.props.type;
    let controls = [];
    let isForm = this.props.isForm;
    let token = this.props.value;
   
    if(token != undefined && token != null && token != ""){
      let downloadtext = "Download";
      let cleartext = "Clear";
      if(window.CloverAdminLang != undefined && window.CloverAdminLang.button != undefined){
        downloadtext = window.CloverAdminLang.button.download;
        cleartext = window.CloverAdminLang.button.clear;
      }

      let isHideClear = this.props.disabled || this.props.readOnly || this.props.hideClearButton;
      controls.push(<a key="download" className="ui button" target="blank" href={this.props.downloadUrl + token}>{downloadtext}</a>);
     
      if(!isHideClear){
        controls.push(<span key="sparator">&nbsp;&nbsp;</span>);
        controls.push(<button key="clear" className="ui button" onClick={this.onClear.bind(this)}>{cleartext}</button>);
      }
    }
    else{
      if(this.props.disabled || this.props.readOnly)
        controls.push(<span></span>);
      else  
        controls.push(<input key="uploadcontrol" type="file" name={this.props.name} onChange={this.onChange.bind(this)}/>);
    }

    let res = undefined;
    if(isForm){
      res = <div className="field">
        {this.props.label != undefined && <label>{this.props.label}</label>}
        <div data-buildertype={type}>
          {controls}
        </div>
      </div>;
    }
    else{
      res = <div data-buildertype={type}>
        {this.props.label != undefined && <div className="ui label label">{this.props.label}</div>}
        {controls}
      </div>;
    }

    return res;
  }

  onChange(e){
    var me = this;
    var formdata = new FormData();
    formdata.append(me.props.name, e.target.files[0]);

    if(me.props.onUploadBegin) {
      this.props.onUploadBegin(this, e);
    }

    $.ajax({
      url: me.props.uploadUrl,
      type: 'POST',
      processData: false,
      contentType: false,
      dataType : 'json',
      data: formdata,
      success: function(jsonData){
        if(me.props.onUploadEnd) {
          me.props.onUploadEnd(me, true, jsonData);
        }
        if(jsonData.success == true){
          if(me.props.onChange != undefined){
            me.props.onChange(e, {name: me.props.name, value: jsonData.message});
          }
        }
      },
      error: function(xhr, msg, err) {
        if(me.props.onUploadEnd) {
          me.props.onUploadEnd(me, false, xhr, msg, err);
        }
      },
    });
  }

  onClear(){
    if(this.props.onChange != undefined)
      this.props.onChange(undefined, {name: this.props.name, value: null});
  }
}