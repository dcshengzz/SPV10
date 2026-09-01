import React from "react";
import ReactDOM from "react-dom";
import JSON5 from 'json5'
import { Button, Sidebar, Segment } from 'semantic-ui-react'
import SideBar from './swzsidemenu'
import SideMenu from './sidemenu'
import SearchBox from "./searchbox"
import BaseComponent from "./basecomponent"
import Lang from "./lang.jsx"

//Common
import Dashboard from './common/dashboard'
//Modules
import Modules from './module/modules'
//Data
import Data from './data/data'
import DataSync from './data/sync'
import CodeActions from './data/codeactions'
//Form
import Form from './form/form'
import FormMappingData from './form/mapdata'
import FormHandler from './form/handler'
import Localization from './form/localization'
//Workflow
import Workflow from './workflow/workflow'
import WorkflowInstances from './workflow/instances'
import BusinessFlow from './workflow/businessflow'
//Security
import Users from './security/users'
import Roles from './security/roles'
import Groups from './security/groups'
import Permissions from './security/permissions'

export default class CloverAdmin extends BaseComponent {
  constructor(props) {
    super(props);
    var qs = this.getQueryString();

    this.state = {
      apanel: qs.apanel == undefined ? "dashboard" : qs.apanel,
      aid: qs.aid,
      isloadig: true,
      visible: false
    }
    var me = this;
    window.onpopstate = function(event) {
      var qs = me.getQueryString();
      me.setState({
        apanel: qs.apanel == undefined ? "dashboard" : qs.apanel,
        aid: qs.aid
      });
    };

    if(window.CloverAdminLang == undefined){
      window.CloverAdminLang = Lang;
    }

    this.load();
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
          if(response.success){
            me.setState({
              isloadig: false,
              data: me.CorrectData(response.item)
            });  
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

  handleMenuItemClick(e, {name}){
    this.openpage(name, undefined);
  }

  openpage(apanel, aid, copyid){
    var url = window.location.href;
    url = this.updateQueryStringParameter(url, 'apanel', apanel);
    url = this.updateQueryStringParameter(url, 'aid', aid);
   
    history.pushState(undefined, undefined, url);
   
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
      deltaWidth: this.props.deltaWidth,
      deltaHeight: this.props.deltaHeight,
      controlActions: this.props.controlActions,
      parent: this
    };

    const {visible} = this.state;
    
    if(apanel === "dashboard"){
      panel = <Dashboard {...panelprops} />;
    }
    else if(apanel === "datamodel"){
      panel = <Data {...panelprops}/>;
    }
    else if(apanel === "datasync"){
      panel = <DataSync {...panelprops}/>;
    }
    else if(apanel === "codeactions"){
      panel = <CodeActions {...panelprops}/>;
    }    
    else if(apanel == "workflow"){
      panel = <Workflow {...panelprops} workflowApi={this.props.workflowApi} />;
    }
    else if(apanel == "businessflow"){
      panel = <BusinessFlow {...panelprops} workflowApi={this.props.workflowApi} />;
    }
    else if(apanel == "forms"){
      panel = <Form {...panelprops} />;
    }
    else if(apanel == "formdata"){
      panel = <FormMappingData {...panelprops} />;
    }
    else if(apanel == "actionhandlers"){
      panel = <FormHandler {...panelprops} />;
    }
    else if(apanel == "localization"){
      panel = <Localization {...panelprops} />;
    }
    else if(apanel == "users"){
      panel = <Users {...panelprops} />;
    }
    else if(apanel == "groups"){
      panel = <Groups {...panelprops} />;
    }
    else if(apanel == "roles"){
      panel = <Roles {...panelprops} />;
    }
    else if(apanel == "permissions"){
      panel = <Permissions {...panelprops} />;
    }
    else if(apanel == "modules"){
      panel = <Modules {...panelprops} />;
    }
    else if(apanel == "workflowinstances"){
      panel = <WorkflowInstances {...panelprops} workflowApi={this.props.workflowApi} />;
    }
    else{
      panel = <div>The unknown part of Clover. Please, send the isssue to us via <a href="https://softworkz.net">softworkz.net contact form</a>.</div>;
    }

    return (
      <div> 
        <div className="clover-formadmin-header">
            <div className="clover-formadmin-header-left">
                  <div >
                        <img className="clover-formadmin-header-logo" onClick={this.onApp.bind(this)} src={this.state.brandingImagePath}/>
                        <label className="sidebarbutton">
                         <Button onClick={this.handleButtonClick}>Menu</Button>
                       </label>
                       </div>
                      </div>
       
                      <div className="clover-formadmin-header-center">
                        <SearchBox data={this.state.data} parent={this}/>
                      </div>
                      <div className="clover-formadmin-header-right">
                        <Button name="btnApp" className="buttontype2" onClick={this.onApp.bind(this)}>{CloverAdminLang.common.toolbarappbutton}</Button>
                        <span className="username">{this.props.userName}</span>
                      </div>
          </div>
          <div className="sidesegment">
            <Sidebar.Pushable as={Segment}>
              <div className="sidesegment child">
                <SideBar parent={this} activeItem={apanel} visible={visible}// hide={visible}
                 />
                  <Sidebar.Pusher onClick={this.handleSidebarHide}>
                    <Segment basic>
                      
                      <div className="clover-formadmin">
                          <div className="clover-formadmin-menu">
                          <SideMenu parent ={this} activeItem={apanel}/>
          
                          </div>
                          <div className="clover-formadmin-basecontent">
                            <div className="clover-formadmin-top"></div>
                            <div className="clover-formadmin-content">
                              {panel}
                            </div>
                          </div>
                        </div>
                    </Segment>
              
                  </Sidebar.Pusher>
               
                </div>
              </Sidebar.Pushable>
              </div>
        </div>);
  }

  onApp(){
    if(this.props.returnToAppUrl != undefined)
      window.location = this.props.returnToAppUrl;
  }
}