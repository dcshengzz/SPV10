import React from "react";
import ReactDOM from "react-dom";
import Toolbar from './toolbar'
import Preview from './preview'
import Store from './store'
import EditForm from './editform';
import CloverStore from './store';
import JSON5 from 'json5'
import Lang from './lang.jsx'

import { Tab, Menu, Checkbox, Button } from 'semantic-ui-react'

export default class CloverFormBuider extends React.Component {
  constructor(props) {
    super(props);
     this.state = {
      defaultForm: props.defaultForm,
      apiurl: props.apiurl,
      imagefolder: props.imagefolder,
      actions: props.actions,
      dropzoneactive: true
    } 
  }

  componentDidMount() {
    if(this.state.defaultForm != undefined)
      this.load(this.state.defaultForm);
  }

  exists(code){
    return Store.exists(code);
  }

  setBuilderMode(enabled){
    if(enabled){
      $('.clover-formbuilder-zone').show();
      $('.clover-formbuilder-item-toolbar-header').show();
    }
    else{
      $('.clover-formbuilder-zone').hide();
      $('.clover-formbuilder-item-toolbar-header').hide();
    }

    this.setState({
      dropzoneactive: enabled
    });

  }

  create(){
    Store.setData([]);
    this.setBuilderMode(true);
  }

  loadData(data){
    Store.setData(data);
    this.setBuilderMode(true);
  }

  getData(){
    return CloverStore.getData();
  }

  load(code){
    var data = this.props.getFormFunc(code);
    Store.setData(data);
    this.setState({
      code: code
    });

    this.setBuilderMode(true);
  }

  download(){
      const filename = "form.json";
    var data = CloverStore.getData();
      var json = JSON.stringify(data, null, 2),
          blob = new Blob([json], {type: "octet/stream"}),
          encodedUri = window.URL.createObjectURL(blob);

      if (typeof window.navigator.msSaveBlob !== 'undefined') {
        window.navigator.msSaveBlob(blob, filename);
      } else {
        var link = document.createElement("a");
        link.setAttribute("href", encodedUri);
        link.setAttribute("download", filename);
        document.body.appendChild(link);
        link.click();
      }
  }

  upload(form, successFunc){
    var file = form.files[0];
    var reader = new FileReader();
    reader.onload = (function(theFile) {
      return function(e) {
        var data = JSON.parse(e.target.result);
        CloverStore.setData(data);
      };
    })(file);

    reader.readAsText(file);
  }

  handleShowDropzonesClick(e, {name, checked}){
    this.setBuilderMode(checked);
  }

  onChooseFileUpload(e){
    $('#builderUploadFile').click();
  }

  onChangeFileUpload(e){
    $('#builderUploadSubmit').click();
  }

  onUpload(e){
    e.preventDefault();
    this.upload(document.getElementById("builderUploadFile"));
  }

  onDownload(e){
    this.download();
  }

  showsample1(){
    this.load("invoiceform");
  }

  showsample2(){
    this.load("projectform");
  }

  getHeader(){
    var local = this.getCurrentLocalization();

    var spanSelectorStyle = this.state.dropzoneactive ? "" : "clover-formbuilder-selector-preview";
    return (<div className="clover-formbuilder-header">
      <div className="clover-formbuilder-header-left">
        <img className="clover-formbuilder-header-logo" src=""/>
      </div>
      <div className="clover-formbuilder-header-center">
        <Button name="btnEmpty" className="buttontype2" onClick={this.create.bind(this)}>{local.clearbutton}</Button>
        <Button name="btnSample1" className="buttontype1" onClick={this.showsample1.bind(this)}>Sample 1</Button>
        <Button name="btnSample1" className="buttontype1" onClick={this.showsample2.bind(this)}>Sample 2</Button>
      </div>
      <div className="clover-formbuilder-header-right">
        <div className="clover-formbuilder-selector">
          <span className={spanSelectorStyle}>Preview</span>
          <Checkbox toggle name="cbShowDropzones" label="Builder" checked={this.state.dropzoneactive} onChange={this.handleShowDropzonesClick.bind(this)}/>
        </div>
        <Button name="btnUpload" className="buttontype2" onClick={this.onChooseFileUpload.bind(this)} >{local.uploadbutton}</Button>
        <Button name="btnDownload" className="buttontype2" onClick={this.onDownload.bind(this)}>{local.downloadbutton}</Button>
        <form action="/" method="post" id="builderUploadForm" style={{display: "none"}} onSubmit={this.onUpload.bind(this)}>
          <input type="file" id="builderUploadFile" onChange={ this.onChangeFileUpload.bind(this) } />
          <input type="submit" id="builderUploadSubmit" />
        </form>
      </div>
    </div>);
  }

  render() {
    var localization = this.getCurrentLocalization();

    var className = "clover-formbuilder";
    if(this.state.dropzoneactive){
      className += " clover-formbuilder-dropzoneactive";
    }

    var builder = <div className={className}>
      <div className="clover-formbuilder-content">
        <Preview 
          getFormFunc={this.props.getFormFunc} 
          getFormFist={this.props.getFormFist}
          getAdditionalDataForControl={this.props.getAdditionalDataForControl}
          localization={localization.preview}
          downloadUrl={this.props.downloadUrl}
          uploadUrl={this.props.uploadUrl} />
        <EditForm actions={this.state.actions} localization={localization.editforms} />
      </div>
      <Toolbar localization={localization.toolbar} templates={this.props.templates} />
    </div>;

    if(this.props.showHeader){
      return (<div>{this.getHeader()}{builder}</div>);
    }

    return builder;
  }

  getCurrentLocalization(){
    if(this.props.localization != undefined){
      return this.props.localization;
    }

    return Lang;
  }
}