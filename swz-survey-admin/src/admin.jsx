import React from "react";
import ReactDOM from "react-dom";
import JSON5 from 'json5'
import { Button, Sidebar, Segment, Modal } from 'semantic-ui-react'
import SideMenu from './sidemenu'
import SideBar from './swzsidemenu'
import SearchBox from "./searchbox"
import BaseComponent from "./basecomponent"
import Lang from "./lang.jsx"
import LocalizationControl from './localizationcontrol.jsx'
//Form
import Form from './form/form'
import FormMappingData from './form/mapdata'
import FormHandler from './form/handler'
import CssEditor from './form/csseditor'
import FormLogic from './form/swzformlogic'
import FileUploads from './form/files'
// import Localization from './form/localization'

export default class CloverAdmin extends BaseComponent {
  constructor(props) {
    super(props);
    var qs = this.getQueryString();

    this.state = {
      apanel: qs.apanel == undefined ? "forms" : qs.apanel,
      aid: qs.aid,
      isloadig: true,
      visible: false,
      isDirty: false,
      confirm: false,
      brandingImagePath: '',
    }

    this.mainDataLoaded = false;
    this.surveyDataLoaded = false;
    this.fileDataLoaded = false;

    var me = this;
    window.onpopstate = function(event) {
      var qs = me.getQueryString();
      me.setState({
        apanel: qs.apanel == undefined ? "forms" : qs.apanel,
        aid: qs.aid
      });
    };

    if(window.CloverAdminLang == undefined){
      window.CloverAdminLang = Lang;
    }
    
    this.load();
  }

  setLoadingFalse(){
    if(this.mainDataLoaded && this.surveyDataLoaded && this.fileDataLoaded){
      this.setState({isloadig: false});
    }
  }

  componentDidMount() {
    window.addEventListener("beforeunload", this.onUnload);
  }
    
  onUnload = (e) => { // the method that will be used for both add and remove event
    if(this.state.isDirty){
        e.preventDefault();
        e.returnValue = true;
    }
  }

  componentWillUnmount() {
    window.removeEventListener("beforeunload", this.onUnload);
  }

  isDirtyToggle = () => {
    console.log("Is Dirty Toggle");
    this.setState({isDirty: true});
  }

  isDirtyToggleOff = () => {
    this.setState({isDirty: false});
  }
  
  closeModal = (stayDirty) =>{
    this.setState({confirm: false, isDirty: stayDirty ? stayDirty : false})
  }

  showConfirm = (confirmhandle, stayDirty) => {
    var event = () => { confirmhandle(); this.closeModal(stayDirty);};
    if(this.state.isDirty)
        this.setState({ confirm: true, confirmhandle: event});
    else
        confirmhandle();
  }

  filterSurvey = (response) => {

    if (response.item == undefined)
      return
    var responseforms = response.item.forms     
    var formsArr = [];
    var formsOtherStructDivisionsArr = [];
    var webFormsArr = [];
    for(var i=0; i<responseforms.length; i++){
      if(responseforms[i].isSurvey){
	if(response.item.structDivisions.find( function( ele ) { return ele.id === responseforms[i].structDivisionId;} ))
        	formsArr.push(responseforms[i]);
	else
		formsOtherStructDivisionsArr.push(responseforms[i]);
		
      }else{
        webFormsArr.push(responseforms[i]);
      }
    }
      var itemObj = response.item;
      itemObj['forms'] = formsArr;
      itemObj['webForms'] = webFormsArr;
      itemObj['formsOtherStructDivisions'] = formsOtherStructDivisionsArr;
      var newResponse = {
        count: 0,
        item: itemObj,
        success: true
      }
  return newResponse 
  }

  load(){
    var me = this;
    var data = new Array();
    data.push({ name: 'operation', value: 'load' });
    $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: true,
        success: function (response) {
          var newResponse = me.filterSurvey(response);
          if(response.success){
            // me.setState({
            //   isloadig: false,
            //   data: me.CorrectData(newResponse.item)
            // });  
            const correctedData = me.CorrectData(newResponse.item);
            me.setState(prevState => ({
                //isloadig: false,
                data: {
                    ...correctedData,
                    forms: prevState.data !== undefined ? prevState.data.forms : [],
                    fileUploads: prevState.data !== undefined ? prevState.data.fileUploads : []
                }
                
            }));
          }
          else{
            let msg = response.message;
            if(msg == undefined){
              msg = CloverAdminLang.requesterror.configapi + ": " + me.props.apiUrl + "!";
              if(typeof response == "string"){
                console.error(CloverAdminLang.requesterror.configapi + ":", response);
                msg += " " + CloverAdminLang.msg.lookdevconsole;
              }
            }
            me.setState({
              progresserror: true,
              progressmsg: msg
            });
          }
          me.mainDataLoaded = true;
          me.setLoadingFalse();
        },
        error: function (jqXHR, exception){
          me.processLoadError(jqXHR, exception);
        }
    }).done(me.loadSurvey(), me.loadUploadedFiles());

    $.ajax({
      url: "/ui/brandingImagePath",
      async: true,
      type: "get",
      success: function (response) {
        me.setState({ brandingImagePath: '/' + response.item.BrandingImagePath + '/logo.png'});
      },
      error: function (jqXHR, exception) {
        alertify.error("Cannot get image path");
      }
    });
  }

  loadSurvey(){
    var me = this;
      $.ajax({
          url: me.props.surveyFormApi,
          async: true,
          success: function (response) {
            if(response.success){
              me.setState(prevState => ({
                data: {
                    ...prevState.data,
                    forms: response.item.forms
                }
                
            }));
            }
            else{
              let msg = response.message;
              if(msg == undefined){
                msg = CloverAdminLang.requesterror.configapi + ": " + me.props.surveyFormApi + "!";
                if(typeof response == "string"){
                  console.error(CloverAdminLang.requesterror.configapi + ":", response);
                  msg += " " + CloverAdminLang.msg.lookdevconsole;
                }
              }
              me.setState({
                progresserror: true,
                progressmsg: msg
              });
            }
            me.surveyDataLoaded = true;
            me.setLoadingFalse();
          },
          error: function (jqXHR, exception){
            me.processLoadError(jqXHR, exception);
          }
      });
  }

  loadUploadedFiles(){
    var me = this;
      $.ajax({
          url: me.props.fileStorageApi,
          async: true,
          success: function (response) {
            if(response.success){
              me.setState(prevState => ({
                data: {
                    ...prevState.data,
                    fileUploads: response.item.fileUploads
                }
              }));
            }
            else{
              let msg = response.message;
              if(msg == undefined){
                msg = CloverAdminLang.requesterror.configapi + ": " + me.props.fileStorageApi + "!";
                if(typeof response == "string"){
                  console.error(CloverAdminLang.requesterror.configapi + ":", response);
                  msg += " " + CloverAdminLang.msg.lookdevconsole;
                }
              }
              me.setState({
                progresserror: true,
                progressmsg: msg
              });
            }
            me.fileDataLoaded = true;
            me.setLoadingFalse();
          },
          error: function (jqXHR, exception){
            me.processLoadError(jqXHR, exception);
          }
      });
  }

  processLoadError(jqXHR, exception){
    var msg = this.getProcessLoadError(jqXHR, exception);
    this.setState({
      progresserror: true,
      progressmsg: msg
    });
  }

  CorrectData(obj){
    if(obj.modules == undefined)
      obj.modules = [];
    if(obj.dataModel == undefined)
      obj.dataModel = [];
    if(obj.localization == undefined)
      obj.localization = [];
    return obj;
  }

  handleErrEvent(message){
    if(this.props.eventerrfunc){
        this.props.eventerrfunc(this, message);
    }  
  }

  handleMenuItemClick = (e, {name}) => {
    this.showConfirm(() => {
      this.openpage(name, undefined) 
      }
    );
  }

  openpage(apanel, aid, copyid, condProps){
    
    var parameters = parameters == undefined ? parameters : null 
    var url = window.location.href;
    url = this.updateQueryStringParameter(url, 'apanel', apanel);
    url = this.updateQueryStringParameter(url, 'aid', aid);

    if(condProps !== undefined && condProps.control !== undefined && condProps.type !== undefined){
      url = this.updateQueryStringParameter(url, 'control', condProps.control); 
      url = this.updateQueryStringParameter(url, 'type', condProps.type);
    }else{
      url = this.updateQueryStringParameter(url, 'control', undefined); 
      url = this.updateQueryStringParameter(url, 'type', undefined);
    }

    history.pushState(undefined, undefined, url);
    //console.log("The url is", url);
    this.setState({
      apanel: apanel,
      aid: aid,
      copyid: copyid
    });
  }
  
  //Side Bar Function
  handleButtonClick = () => { 
    this.setState({ visible: !this.state.visible })
  }
  //Side Bar Function
  handleSidebarHide = () => {
    this.setState({ visible: false })
  }

  render() {
    
    const {visible, confirm, isDirty} = this.state;
    const confirmHandleCancel = () => this.setState({ confirm: false });

    if(this.state.isloadig)
      return this.RenderLoading();

    var apanel = this.state.apanel;
    var panel = undefined;
    var qs = this.getQueryString();
    var panelprops = {
      id: qs.aid,
      copyid: this.state.copyid,
      data: this.state.data,
      apiUrl: this.props.apiUrl,
      ruleApi: this.props.ruleApi,
      cssStyleApi: this.props.cssStyleApi,
      surveyFormNameApi: this.props.surveyFormNameApi,
      deltaWidth: this.props.deltaWidth,
      deltaHeight: this.props.deltaHeight,
      controlActions: this.props.controlActions,
      parent: this
    };
    
    if(apanel == "forms"){
      panel = <Form showConfirm={this.showConfirm} isDirtyToggleOff={this.isDirtyToggleOff} isDirtyToggle={this.isDirtyToggle} isDirty={isDirty} {...panelprops} />;
    }
    else if(apanel == "formlogic"){
      panel = <FormLogic {...panelprops} />;
    }
    else if(apanel == "filestorage"){
      panel = <FileUploads {...panelprops} />;
    }
    /* else if(apanel == "formdata"){
      panel = <FormMappingData {...panelprops} />;
    } */
    else if(apanel == "actionhandlers"){
      panel = <FormHandler {...panelprops} />;
    }
    else if(apanel == "formstyle"){
      panel = <CssEditor {...panelprops} />;
    }
    /*else if(apanel == "localization"){
      panel = <Localization {...panelprops} />;
    }*/
    else{
      panel = <div>The unknown part of CLOVER. Please, send the isssue to us via <a href="http://www.softworkz.net/Contact">Softworkz.net</a>.</div>;
    }

    return (<div className="clover-formadmin-container">
        <div className="clover-formadmin-header">
              <div className="clover-formadmin-header-left">
                <img className="clover-formadmin-header-logo" onClick={this.onApp.bind(this)} src={this.state.brandingImagePath}/>
                </div>
              <div className="clover-formadmin-header-right">
              <span className="username">{this.props.userName}</span>
            {/*<Button onClick={this.handleButtonClick}>Menu</Button>*/}
                <Button name="btnApp" className="buttontype2" onClick={this.onApp.bind(this)}>{CloverAdminLang.common.toolbarappbutton}</Button>
              </div>
        </div>
        <div className="clover-formadmin">
            <div className="clover-formadmin-menu">
              <SideMenu parent={this} activeItem={apanel} onApp={this.onApp} />
            </div>
            <div className="clover-formadmin-basecontent">
              <div className="clover-formadmin-top"></div>
              <div className="clover-formadmin-content">
                {panel}
              </div>
              <Modal size="small" open={confirm} dimmer="inverted" onClose={confirmHandleCancel}>
                <Modal.Header>
                  Confirm
                </Modal.Header>
                <Modal.Content>
                  <p>Close without save?</p>
                </Modal.Content>
                <Modal.Actions>
                  <Button className="buttontype1" onClick={this.state.confirmhandle} >Confirm</Button>
                  <Button className="buttontype2" onClick={confirmHandleCancel}>Cancel</Button>
                </Modal.Actions>
              </Modal>
            </div>
          </div>
    </div>);
  }

  onApp = () =>{
    if(this.props.returnToAppUrl != undefined)
      window.location = this.props.returnToAppUrl;
  }
}