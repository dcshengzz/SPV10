import React from "react";
import ReactDOM from "react-dom";
import Toolbar from './toolbar'
import Navigatebar from './navigatebar'
import Preview from './preview'
import Store from './store'
import EditForm from './editform';
import CloverStore from './store';
import Lang from './lang.jsx'
import { Checkbox, Button, Modal, Dropdown } from 'semantic-ui-react'
import FormLogic from './FormLogic';
import PrintActions from './print';

export default class CloverFormBuider extends React.Component {
  constructor(props) {
    super(props);
     this.state = {
      defaultForm: props.defaultForm,
      apiurl: props.apiurl,
      imagefolder: props.imagefolder,
      actions: props.actions,
      dropzoneactive: true,
      onNavigatebar: false,
      pageItem: undefined,
      swzOnItemsEmpty: false,
      selectedTemplates: [],
      selectedTemplatesBlock: [],
      onCombineTemplates: true,
      selectedKey: '',
      isContentOnly: true
    } 
  }
  componentDidUpdate = (prevProps) => {
    if(this.props.onNavigatebar != prevProps.onNavigatebar){
      if(this.props.onNavigatebar != this.state.onNavigatebar){
          this.setState({onNavigatebar: this.props.onNavigatebar});
      }
    }
  }

  componentDidMount() {
    if(this.state.defaultForm != undefined)
      this.load(this.state.defaultForm);

    if(this.props.templates != undefined){
      var i = 0;
      var templates = [];
     
      while(i < this.props.templates.length){
        var obj = {
       
        };
        obj['key'] = i;
        obj['text'] = this.props.templates[i];
        obj['value'] = this.props.templates[i];
        templates.push(obj);
        i++;
      }
      this.setState({templates});
    }
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

    var getData = Store.getData();
    
  }

  addItems(items, onCombineTemplates,  key){
  
    if(!onCombineTemplates)
      Store.copyItems(items, key);
    else{
      Store.copyCombinedItems(items, key);
    }

  }

  addTemplateBlock(items, isContentOnly, key, selectedTemplatesBlock){
    const dataToCopy = this.findTemplatesBlock(items, selectedTemplatesBlock);
    if(!isContentOnly)
      Store.copyTemplatesBlock(dataToCopy, key);
    else{
      Store.copyTemplatesBlockContent(dataToCopy, key);
    }

  }

  findTemplatesBlock(forms, selectedTemplatesBlock){
    const res = [];
    if(forms !== undefined && forms[0] !== undefined && forms[0][0] !== undefined){
      const self = this;
      forms[0].forEach(function(page){
        page.children.filter(function(e) {
          return e['data-buildertype']==='block'}).forEach(function(item){
            self.getTemplatesBlock(item, selectedTemplatesBlock, res);
        });
      });
    }
    return res;
  }

  getTemplatesBlock(item, selectedTemplatesBlock, res){
    if(item.templateBlock !== undefined){
      item.templateBlock = false; //remove templateBlock property to avoid redundancy
    }
    
    if(item['data-buildertype']==='block' && selectedTemplatesBlock.indexOf(item.key) > -1){
      res.push(item);
    }
    if(item.children !== undefined && item.children.length > 0){
      const self = this;
      item.children.filter(function(e) {return e['data-buildertype']==='block'}).forEach(function(childItem){
        self.getTemplatesBlock(childItem, selectedTemplatesBlock, res);
      });
      
    }
  }

  create(){
    Store.setData([]);
    this.setBuilderMode(true);
  }

  loadData(data){
    Store.setData(data);
    this.setBuilderMode(true);
    /*SWZ BuilderModeOn */
    Store.swzOnBuilderMode();
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

  swzBefSaveShowAll(){

    var prevState = Store.swzBefSaveShowAll();
    return prevState;
  }

  loadPrevState(prevState){
    Store.swzLoadPrevState(prevState);
  }
  
  download(defaultFormName){
    const local = this.getCurrentLocalization();
    if(defaultFormName == undefined || defaultFormName == null || defaultFormName.trim().length == 0){
      defaultFormName = "form.json";
    }
    let formname = null;
    while(formname == null){
      let inputformname = prompt(local.provideNameToDownload, defaultFormName);
      if(inputformname == null || inputformname == undefined){
        return;
      }else if(inputformname.trim().length == 0 ){
        alert(local.provideName);
      }else{
        formname = inputformname;
      }
    }
    
    var data = CloverStore.getData();
    var json = JSON.stringify(data, null, 2),
        blob = new Blob([json], {type: "octet/stream"}),
        encodedUri = window.URL.createObjectURL(blob);

    if (typeof window.navigator.msSaveBlob !== 'undefined') {
      window.navigator.msSaveBlob(blob, formname);
    } else {
      var link = document.createElement("a");
      link.setAttribute("href", encodedUri);
      link.setAttribute("download", formname);
      document.body.appendChild(link);
      link.click();
    }
  }

  upload(form, successFunc, finalFunc){
    var file = form.files[0];
    var reader = new FileReader();
    reader.onload = (
        function(theFile) {
            return function(e) {
              try{
                var data = JSON.parse(e.target.result);
                CloverStore.setData(data);
                if(successFunc != undefined){
                  successFunc();
                }
              }catch(e){
                console.error('Failed to upload', e);
                alertify.error('Failed to upload.');
              }finally{
                if(finalFunc != undefined){
                  finalFunc();
                }
              }
            };
        }
    )(file);

    reader.readAsText(file);
  }

  handleShowDropzonesClick(e, {name, checked}){
    this.setBuilderMode(checked);
    this.setState({onNavigatebar: true})
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
    this.download(this.props.formName);
  }

  showsample1(){
    this.load("invoiceform");
  }

  showsample2(){
    this.load("projectform");
  }

  getHeader(){
    console.log(this);
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
      {//!this.state.dropzoneactive ? (
      <div className="clover-formbuilder-selector">
          <span className={spanSelectorStyle}>Page Controls</span>
          <Checkbox toggle name="cbShowDropzones" label="Builder Controls" checked={!this.state.onNavigatebar} onChange={this.toggleNavigate.bind(this)}/>
      </div>
      //): null 
       }
        <div className="clover-formbuilder-selector">
          <span className={spanSelectorStyle}>Preview Mode</span>
          <Checkbox toggle name="cbShowDropzones" label="Builder Mode" checked={this.state.dropzoneactive} onChange={this.handleShowDropzonesClick.bind(this)}/>
        </div>
        {<Button name="btnPrint" className="buttontype2" onClick={PrintActions.print.bind(this.getData(), null, 'formbuilder')}>Print</Button>
         }<Button name="btnUpload" className="buttontype2" onClick={this.onChooseFileUpload.bind(this)}>{local.uploadbutton}</Button>
        <Button name="btnDownload" className="buttontype2" onClick={this.onDownload.bind(this)}>{local.downloadbutton}</Button>
        <form action="/" method="post" id="builderUploadForm" style={{display: "none"}} onSubmit={this.onUpload.bind(this)}>
          <input type="file" id="builderUploadFile" onChange={this.onChangeFileUpload.bind(this) } />
          <input type="submit" id="builderUploadSubmit" />
        </form>
      </div>
    </div>);
  }

  showNavigate = () => {
    if(this.state.onNavigatebar == false){
      this.setState({onNavigatebar: true})
    }
  }

  toggleNavigate = () => {
    if(this.state.onNavigatebar == true){
      this.setState({onNavigatebar: false}) 
    }
    else{
      this.setState({onNavigatebar: true}) 
    }
  }

  handleEmpty = (bool) => {

    var data = [{
      key: "Page_1",
      ['data-buildertype']: "swzPage",
      headerlabel: "Insert page header name",
      back: true,
      next: true,
      save:true,
      cancel:true,
      onpagedisplay:true,
      buildermode: true,
      onstatusbar: true,
      events: {
        onClickBack: {active: true, actions: ["swzBack"]},
        onClickNext: {active: true, actions: ["swzSinglePageValidate","swzSilentSave","swzNext"]},
        onClickNextNonUpdatedSurvey: {active: true, actions: ["swzNext"]},
        onClickSave: {active: true, actions: ["swzSave"]},
        onPageValidationStatus: {active: true, actions: ["swzPageValidationStatus"]},
        onClickSaveExit: {active: true, actions: ["swzSave", "swzExit"]},
        onClickExit: {active: true, actions: ["confirm", "swzExit"]},
        onClickCancel: {active: true, actions: ["confirm", "swzReturnToPreviousPage"]},
        onClickSubmit: {active: true, actions: ["swzSubmit","swzExit"]},
        onClickItem: {active: true, actions: ["swzPageValidationStatus","swzSinglePageValidate","swzItemClick"]},
        onPageInit: {active: true, actions: ["swzPageInit"]},
        onClickLastSaved: {active: true, actions: ["swzClearRadio"]},
        onClickPrint: {active: true, actions: ["swzPrint"]}
      }
    }];
   var getData = Store.getData();
  
    if(bool){
      if(getData == undefined || getData.length == 0){
        Store.setData(data);
        this.setState({
          code: data
        }); 
        this.setBuilderMode(true);
        this.setState({swzOnItemsEmpty: true});
      }

      if(!this.state.swzOnItemsEmpty){
        Store.setData(data);
        this.setState({
          code: data
        }); 
      this.setBuilderMode(true);
      this.setState({swzOnItemsEmpty: true});
      }
    }else{
      if(this.state.swzOnItemsEmpty !== bool){
        this.setState({swzOnItemsEmpty: false});
      }
    }
    
  }

  handleClearLogic = (type) => {
    Store.swzClearLogic(type);
  }

  handleSwitchType = (status, type) => {
    Store.swzSwitchType(status, type);
  }
  
  renderAddTemplateModal(){
    return(
      <Modal closeOnDimmerClick={false} dimmer='inverted' open={this.state.openmodal} onClose={this.onModalClose.bind(this)}>  
        <Modal.Header>Select templates</Modal.Header>
        <Modal.Content>
            <Modal.Description>
              <Dropdown
                placeholder=''
                fluid
                multiple
                search
                selection
                options={this.state.templates}
                onChange={this.onTemplatesChange.bind(this)}
              />
              <div style={{marginBottom: '1em'}}className="field"></div>
               <Checkbox
                name={'onCombineTemplates'}
                label={"Combine all templates"}
                value={this.state.onCombineTemplates}
                defaultChecked
                fluid
                onChange={this.onTemplatesChange.bind(this)}
                />
              <div style={{marginBottom: '1em'}}className="field"></div>
              <span><i>Duplicate names in imported components will be amended.</i></span>
            </Modal.Description>
        </Modal.Content>
        <Modal.Actions>
            <Button className="buttontype1" onClick={this.onModalSave.bind(this)}>Save</Button>
            <Button className="buttontype2" onClick={this.onModalClose.bind(this)}>Cancel</Button>
        </Modal.Actions>
    </Modal>);
  }

  renderAddTemplateBlockModal(){
    return(
      <Modal closeOnDimmerClick={false} dimmer='inverted' open={this.state.openmodaltemplateblock} onClose={this.onModalCloseTemplateBlock.bind(this)}>  
        <Modal.Header>Select templates block</Modal.Header>
        <Modal.Content>
            <Modal.Description>
              <Dropdown
                placeholder={"Select Template Form"}
                fluid
                search
                selection
                options={this.state.templates}
                onChange={this.onTemplateBlockChangeForm.bind(this)}
              />
              <div style={{marginBottom: '1em'}}className="field"></div>
              <Dropdown
                placeholder={"Select Template Block"}
                fluid
                multiple
                search
                selection
                options={this.state.templatesBlock}
                value={this.state.selectedTemplatesBlock}
                onChange={this.onTemplateBlockChange.bind(this)}
              />
              <div style={{marginBottom: '1em'}}className="field"></div>
               <Checkbox
                name={'isContentOnly'}
                label={"Content only"}
                value={this.state.isContentOnly}
                defaultChecked
                fluid
                onChange={this.onTemplateBlockChange.bind(this)}
                />
              <div style={{marginBottom: '1em'}}className="field"></div>
              <span><i>Duplicate names in imported components will be amended.</i></span>
            </Modal.Description>
        </Modal.Content>
        <Modal.Actions>
            <Button className="buttontype1" onClick={this.onModalSaveTemplateBlock.bind(this)}>Save</Button>
            <Button className="buttontype2" onClick={this.onModalCloseTemplateBlock.bind(this)}>Cancel</Button>
        </Modal.Actions>
    </Modal>);
  }

  onTemplatesChange = (e, item) => {
    
    var value = item.value;
    var checked = item.checked;
    var name = item.name;

    if(name == 'onCombineTemplates')
      this.setState({onCombineTemplates: checked});
    else if(value)
      this.setState({selectedTemplates: value});
    
  }

  onTemplateBlockChangeForm = (e, item) => {
    const value = item.value;
    if(value !== this.state.selectedTemplates){
      const selectedform = this.props.getFormFunc(value);
      const optionArr = this.props.getTemplateBlockList(selectedform);
      const optionObj = [];
      if(optionArr !== undefined && optionArr.length > 0){
        optionArr.forEach(function(item){
          let newOption = {};
          newOption.key = item;
          newOption.text = item;
          newOption.value = item;
          optionObj.push(newOption);
        });
      }
      this.setState({selectedTemplatesBlock: [], templatesBlock: optionObj, selectedTemplates: value});
    }
  }

  onTemplateBlockChange = (e, item) => {
    
    var value = item.value;
    var checked = item.checked;
    var name = item.name;
    
    if(name == 'isContentOnly')
      this.setState({isContentOnly: checked});
    else if(value)
      this.setState({selectedTemplatesBlock: value});
    
  }

  openModal = (selectedKey) => {
    this.onClearState();
    this.setState({openmodal: true});
    this.setState({selectedKey: selectedKey});
  }

  openModalTemplateBlock = (selectedKey) => {
    this.onClearState();
    this.setState({openmodaltemplateblock: true});
    this.setState({selectedKey: selectedKey});
  }

  onModalSave(){
    this.setState({openmodal: false});
    this.props.loadTemplate(this.state.selectedTemplates, this.state.onCombineTemplates, this.state.selectedKey);
  }

  onModalSaveTemplateBlock(){
    this.setState({openmodaltemplateblock: false});
    this.props.loadTemplateBlock(this.state.selectedTemplates, this.state.selectedTemplatesBlock , this.state.isContentOnly, this.state.selectedKey);
  }

  onModalClose(){
    this.setState({openmodal: false});
  }

  onModalCloseTemplateBlock(){
    this.setState({openmodaltemplateblock: false});
  }

  onClearState(){
    this.setState({selectedKey: null,
      onCombineTemplates: true, 
      isContentOnly: true, 
      selectedTemplates: [],
      selectedTemplatesBlock: []});
  }

  render() {
    var me = this;
    if(!this.props.onFormLogic){  
      var localization = this.getCurrentLocalization();
      var className = "clover-formbuilder";
      if(this.state.dropzoneactive)
        className += " clover-formbuilder-dropzoneactive";
      
      var contentClassName = "clover-formbuilder-swzcontentnav";
      if(this.state.onNavigatebar){
        contentClassName = "clover-formbuilder-swzcontentnav";
      }
      var builder = (<div className={className}>
        
      {/*Swz*/}
      {this.state.onNavigatebar ? (
          <Navigatebar/>
        ):  <Toolbar isDirty={this.props.isDirty} isDirtyToggle={this.props.isDirtyToggle} pageItem ={this.addPageBlock} localization={localization.toolbar} templates={this.props.templates} />
        }
        <div className={contentClassName}>
          <Preview 
            getFormFunc={this.props.getFormFunc} 
            getFormFist={this.props.getFormFist}
            getAdditionalDataForControl={this.props.getAdditionalDataForControl}
            isDirty={this.props.isDirty}
            isDirtyToggle={this.props.isDirtyToggle}
            localization={localization.preview}
            downloadUrl={this.props.downloadUrl}
            uploadUrl={this.props.uploadUrl}
            loadTemplate={this.openModal.bind(this)}
            loadTemplateBlock={this.openModalTemplateBlock.bind(this)}
            handleEmpty={this.handleEmpty} 
            />
          <EditForm isDirty={this.props.isDirty} isDirtyToggle={this.props.isDirtyToggle} ruleApi={this.props.ruleApi} cssStyleApi={this.props.cssStyleApi} actions={this.state.actions} localization={localization.editforms} openFormLogicControl={this.props.openFormLogicControl}/>
          {this.renderAddTemplateModal()}
          {this.renderAddTemplateBlockModal()}
        </div>      

      </div>);
      if(this.props.showHeader){
        return (<div>{this.getHeader()}{builder}</div>);
      }

      return builder;
    }else{
      return ( <div>
                <div className={contentClassName}>
                <FormLogic
                  getFormFunc={this.props.getFormFunc} 
                  getFormFist={this.props.getFormFist}
                  getAdditionalDataForControl={this.props.getAdditionalDataForControl}
                  downloadUrl={this.props.downloadUrl}
                  uploadUrl={this.props.uploadUrl}
                  handleEmpty={this.handleEmpty}
                  openFormLogicControl={me.props.openFormLogicControl}
                  onSave={this.props.onSave}
                  ref={(formlogic) => { this.formlogic = formlogic; }}
                   />
              </div>
            </div>)
    }
  }

  getCurrentLocalization(){
    if(this.props.localization != undefined){
      return this.props.localization;
    }

    return Lang;
  }

  onAddConditionGroup(){
    this.formlogic.addConditionGroup();
  }

  onSaveCond(){
    this.formlogic.onSaveCond();
  }
  
  loadNewForm(){
    this.formlogic.loadNewForm();
  }
}