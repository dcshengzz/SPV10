import React from "react";
import ReactDOM from "react-dom";
import JSON5 from 'json5'
import { Form, Grid, Menu, Segment, Button } from 'semantic-ui-react'
import BaseComponent from "./../basecomponent"
import Settings from './settings'
import License from './license'

export default class Dashboard extends BaseComponent {
  constructor(props) {
    super(props);

    this.datatype = "appsettings";
    this.state = {};
    this.initData(props.data.appSettings);
  }

  onRequestRenewLicense()
  {
    window.open('http://softworkz.net/contact/');
  }

  initData(data){
    var res = this.СloneObj(data);
    res = res.sort(function(a,b){
      if(a.order != b.order)
        return a.order - b.order;
      
      if (a.groupName > b.groupName) {
        return 1;
      }
      if (a.groupName < b.groupName) {
        return -1;
      }

      if (a.name > b.name) {
        return 1;
      }
      if (a.name < b.name) {
        return -1;
      }
      return 0;

    });

    this.state.data = res;
  }

  onResetAppCache(){
    var me = this;
    var data = new Array();
    data.push({ name: 'operation', value: 'resetappcache' });
    $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: true,
        type: "post",
        success: function (response) {
          if(response.success){
            alertify.success(CloverAdminLang.msg.appcachereseted);
          }
          else{
            alertify.error(response.message);
          }
        }
    });
  }

  render() {
  return (<div>
      <h1>Dashboard</h1>
      <License data={this.props.data.licenseInfo} metadata={this.props.data} parent={this.props.parent} />
      <div className="clover-formadmin-dashboard-buttons">
        <a onClick={this.onResetAppCache.bind(this)}>{CloverAdminLang.button.resetappcache}</a>
      </div>
      <div className="cloveradmin-toolbar">
        <Button className="buttontype1" onClick={this.onSave.bind(this)}>{CloverAdminLang.button.save}</Button>
        <Button className="buttontype2" onClick={this.onCancel.bind(this)}>{CloverAdminLang.button.cancel}</Button>
      </div>
     <div><span>{CloverAdminLang.dashboard.integrationapiswagger}&nbsp;</span>
       <a className="ui button" target="_blank" href="/swagger">{CloverAdminLang.button.download}</a>
      </div>
      <Settings data={this.state.data} parent={this.props.parent} />
  </div>);
  }

  onCancel(){
    this.initData(this.props.data.appSettings);
    this.forceUpdate();
  }
}