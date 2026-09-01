import React from "react";
import ReactDOM from "react-dom";
import JSON5 from 'json5'
import { Button } from 'semantic-ui-react'
import SideMenu from './sidemenu'
import BaseComponent from "./basecomponent"
import Lang from "./lang.jsx"
import LocalizationControl from './localizationcontrol.jsx'

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
      apanel: qs.apanel == undefined ? "users" : qs.apanel,
      aid: qs.aid,
      isloadig: true,
      roles: [],
      brandingImagePath: '',
    }
    var me = this;
    window.onpopstate = function(event) {
      var qs = me.getQueryString();
      me.setState({
        apanel: qs.apanel == undefined ? "users" : qs.apanel,
        aid: qs.aid
      });
    };

    if(window.CloverAdminLang == undefined){
      window.CloverAdminLang = Lang;
    }

    this.load();
  }
  
  filterRole = (response) => {
      var responseRole = response.item.roles      
      var rolesArr = [];
      var superAdminRoles = this.props.superAdminRoles
      var roleObj = {};
      var superAdminObj = {}; //1 Role to 1 Super Admin Role hence we use object to avoid repetition

      for(var i=0; i<responseRole.length; i++){
        for(let j=0; j<superAdminRoles.length; j++){
          if(roleObj[i] == undefined && superAdminObj[j] == undefined){
            if(responseRole[i].code == superAdminRoles[j]){
              roleObj[i] = 'RoleExcluded';
              superAdminObj[j] = 'RoleExcluded';
            }
          }
        }
        if(roleObj[i] !== 'RoleExcluded'){
         //console.log(responseRole[i].code, "This role is not excluded")
          rolesArr.push(responseRole[i]);
        }
      }
        var itemObj = response.item;
        itemObj['roles'] = rolesArr;
        
        var newResponse = {
          count: 0,
          item: itemObj,
          success: true
        }
        //console.log("The new response are", newResponse['item']);
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
          if(response.success){
            var newResponse = me.filterRole(response);
            me.setState({
              isloadig: false,
              data: me.CorrectData(newResponse.item),
              roles: newResponse.item.roles//response.item)
            }); 
          }
          else{
            let msg = newResponse//response.message;
            if(msg == undefined){
              msg = CloverAdminLang.requesterror.configapi + ": " + me.props.apiUrl + "!";
             //var response = response;
             var response = newResponse;
              if(typeof response == "string"){
                console.error(CloverAdminLang.requesterror.configapi + ":", newResponse/*response*/);
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
      parent: this,
      superAdminRoles: this.props.superAdminRoles
    };
    
    
    if(apanel == "users"){
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

    return (<div className="clover-formadmin-container">
        <div className="clover-formadmin-header">
              <div className="clover-formadmin-header-left">
                <img className="clover-formadmin-header-logo" onClick={this.onApp.bind(this)} src={this.state.brandingImagePath}/>
              </div>
         
              <div className="clover-formadmin-header-right">
                <Button name="btnApp" className="buttontype2" onClick={this.onApp.bind(this)}>{CloverAdminLang.common.toolbarappbutton}</Button>
                {/*
                 <span className="username">{this.props.userName}</span> 
                <LocalizationControl folder={this.props.localizationFolder} locale={this.props.locale} parent={this} />
              */}
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
            </div>
          </div>
    </div>);
  }

  onApp = ()=>{
    if(this.props.returnToAppUrl != undefined)
      window.location = this.props.returnToAppUrl;
  }
}