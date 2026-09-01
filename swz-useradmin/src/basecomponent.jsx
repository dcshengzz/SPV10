import React from "react";
import ReactDOM from "react-dom";
import { Progress } from 'semantic-ui-react'
import { encodeHtml } from './security/utils.jsx'

export default class BaseComponent extends React.Component {
  constructor(props) {
    super(props);
  }

  GuidEmpty(){
    return "00000000-0000-0000-0000-000000000000";
  }

  setUpdatedState(item){
    if(item["__state"] == undefined)
      item["__state"] = "updated";
  }

  onSave(){
    var me = this;
    var changes = [];
    this.state.data.forEach(function(item){
      if(item["__state"] != undefined){
        changes.push({
          ...item,
          "__type": me.datatype
        });
      }
    });

    this.ChangeData(changes);
  }

  ChangeData(changes, successfunc){

    var me = this;
    var data = new Array();
    data.push({ name: 'operation', value: 'change' });
    data.push({ name: 'items', value: JSON.stringify(changes) });
    $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: true,
        type: "post",
        success: function (response) {
          if(response.success){
            const isSelfEdit = response.item;

            alertify.success(CloverAdminLang.msg.saveok);
            if(successfunc != undefined && !isSelfEdit){
              successfunc(response);
            }
            
            //relogin when user self edit/delete
            if(isSelfEdit)
            {
              window.setTimeout( () => window.location="/account/logoff", 1000);
            }

          }
          else{
            alertify.error(encodeHtml(response.message));
          }
        }
    });
  }

  СloneObj(obj) {
    if (null == obj || "object" != typeof obj) return obj;
    var copy = obj.constructor();
    for (var attr in obj) {
        if (obj.hasOwnProperty(attr)) copy[attr] = this.СloneObj(obj[attr]);
    }
    return copy;
  }

  ResetSystemProps(obj) {
    if(Array.isArray(obj)){
      for(var i=0; i < obj.length; i++){
        if(obj[i].__state == "deleted"){
          obj.splice(i, 1);
          i--;
        }
        else{
          this.ResetSystemProps(obj[i]);
        }
      }
    }
    
    if ("object" != typeof obj) return;
    for(var p in obj){
      if(p == "__state" || p == "__type" || p == "__error"){
        obj[p] = undefined;
      }
    }
  }

  NewGUID() {
    function s4() {
      return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
      s4() + '-' + s4() + s4() + s4();
  }

  updateQueryStringParameter(uri, key, value) {
    var re = new RegExp("([?&])" + key + "=.*?(&|#|$)", "i");
    if( value === undefined ) {
      if (uri.match(re)) {
          var res = uri.replace(re, '$1$2');
          if(res[res.length - 1] == '&')
            res = res.substring(0, res.length - 1);
          return res;
      } else {
          return uri;
      }
    } else {
      if (uri.match(re)) {
          return uri.replace(re, '$1' + key + "=" + value + '$2');
      } else {
        var hash =  '';
        if( uri.indexOf('#') !== -1 ){
            hash = uri.replace(/.*#/, '#');
            uri = uri.replace(/#.*/, '');
        }
        var separator = uri.indexOf('?') !== -1 ? "&" : "?";    
        return uri + separator + key + "=" + value + hash;
      }
    }  
  }

  getQueryString() {
    // This function is anonymous, is executed immediately and
    // the return value is assigned to QueryString!
    var query_string = {};
    var query = window.location.search.substring(1);
    var vars = query.split("&");
    for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split("=");
        // If first entry with this name
        if (typeof query_string[pair[0]] === "undefined") {
            query_string[pair[0]] = pair[1];
            // If second entry with this name
        } else if (typeof query_string[pair[0]] === "string") {
            var arr = [query_string[pair[0]], pair[1]];
            query_string[pair[0]] = arr;
            // If third or later entry with this name
        } else {
            query_string[pair[0]].push(pair[1]);
        }
    }
    return query_string;
  }

  getProcessLoadError(jqXHR, exception){
    var msg = ''
    if (jqXHR.status === 0) {
        msg = CloverAdminLang.requesterror.status0;
    } else if (jqXHR.status == 404) {
        msg = CloverAdminLang.requesterror.status404;
    } else if (jqXHR.status == 500) {
        msg = CloverAdminLang.requesterror.status500;
    } else if (exception === 'parsererror') {
        msg = CloverAdminLang.requesterror.parsererror;
    } else if (exception === 'timeout') {
        msg = CloverAdminLang.requesterror.timeout;
    } else if (exception === 'abort') {
        msg = CloverAdminLang.requesterror.abort;
    } else {
        msg = CloverAdminLang.requesterror.uncaught + '\n' + jqXHR.responseText;
    }
    return msg;
  }

  RenderLoading(){
    var me = this;

    if(!Boolean(this.state.progresserror)){
      if(this.state.progresspercent == undefined)
        this.state.progresspercent = 0;

      if(this.state.progresspercent < 100){
        var increment = 1;
        setTimeout(function(){
          me.setState({progresspercent: me.state.progresspercent + increment});
        }, 2000);
      }
      else{
        this.state.progresserror = true;
        this.state.progressmsg = CloverAdminLang.msg.checkerrors;
      }
    }

    return <div className="clover-formadmin-loadingscreen">
        <img className="clover-formadmin-loadingscreen-logo" src={this.state.brandingImagePath}/>
        <p>{this.state.progressmsg}</p>
        <div className="clover-formadmin-loadingscreen-progressbar">
          <Progress percent={this.state.progresspercent} error={Boolean(this.state.progresserror)} indicating />
        </div>
      </div>;
  }
}