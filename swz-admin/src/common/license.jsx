import React from "react";
import ReactDOM from "react-dom";
import JSON5 from 'json5'
import BaseComponent from "./../basecomponent"
import { Form, Input } from 'semantic-ui-react'

export default class CloverAdminLicense extends BaseComponent {
  constructor(props) {
    super(props);
    
  }

  render() {
    var item = this.props.data;
    var limits = [];
    for(var i in item.limits){
      var val = item.limits[i] == "-1" ? "∞": item.limits[i];

      var usedVal = undefined;
      if(i == "Users"){
        usedVal = this.props.metadata.users.length;
      }
      else if(i == "Workflow"){
        usedVal = this.props.metadata.workflow.length;
      }
      else if(i == "Forms"){
        usedVal = this.props.metadata.forms.length;
      }

      var hasError = false;
      if(usedVal != undefined){
        hasError = Boolean(usedVal > val);
        val = usedVal + " / " + val;
      }

      limits.push(<Form.Input key={i} label={i} error={hasError} readOnly={true} value={val}/>);
    }

    var msg = [];
    if(item.holder.includes("_Trial")){
      msg.push(<b key="trialmsg">This is a trial version of Clover. Don't forget to purchase the commercial license via <a href="http://softworkz.net">web-site</a>.</b>);
    }
    // else if(item.licenseExpiry != undefined){
    //   msg = <span>You have 10 days left. You can <a onClick={this.onUpload.bind(this)}>upload a license</a> or create a <a href="http://softworkz.net/contact/">request renewal license</a>.</span>;
    // }

    msg.push(<br key="br"/>);
    msg.push(<span key="purchasemsg">You can <a onClick={this.onUpload.bind(this)}>upload a license</a> or create a <a href="http://softworkz.net/contact/">request a new license</a>.</span>);

    return (<div>
      <Form>
        <Form.Input label="License holder" readOnly={true} value={item.holder}/>
        <Form.Group widths="equal">
          {item.licenseExpiry != undefined && <Form.Input label={CloverAdminLang.license.expipedlabel} readOnly={true} value={item.licenseExpiry}/>}
          {item.releaseExpiry != undefined && <Form.Input label={CloverAdminLang.license.freeupdatedatalabel} readOnly={true} value={item.releaseExpiry}/>}
          <Form.Input label={CloverAdminLang.license.licensechecktype} readOnly={true} value={item.licenseCheckType}/>
        </Form.Group>
        <div className="field">
          {msg}
        </div>
        <Form.Group>
          {limits}
        </Form.Group>
      </Form>
      <form is action="" id="cloveradmin-license-uploadform" method="post" style={{display:"none"}} enctype="multipart/form-data" onsubmit="tmp()">
          <input type="file" name="cloveradmin-license-uploadfile" id="cloveradmin-license-uploadfile" onChange={this.onUpload_onchange.bind(this)} />
      </form>
    </div>);
  }

  onUpload(){
    var file = $('#cloveradmin-license-uploadfile');
    file.trigger('click');
  }

  onUpload_onchange(){
      var me = this;
      this.uploadLicense($('#cloveradmin-license-uploadform')[0], function () {
          alertify.success('The file is uploaded!');
          location.reload();
      });
  }

  uploadLicense (form, successFunc) {
      var iframeid = 'clover-formadmin-uploadiframe';
      var me = this;
      // Create the iframe...
      var iframe = document.createElement("iframe");
      iframe.setAttribute("id", iframeid);
      iframe.setAttribute("name", iframeid);
      iframe.setAttribute("width", "0");
      iframe.setAttribute("height", "0");
      iframe.setAttribute("border", "0");
      iframe.setAttribute("style", "width: 0; height: 0; border: none;");

      // Add to document...
      form.parentNode.appendChild(iframe);
      window.frames[iframeid].name = iframeid;

      var iframeById = document.getElementById(iframeid);

      // Add event...
      var eventHandler = function () {

          if (iframeById.detachEvent) iframeById.detachEvent("onload", eventHandler);
          else iframeById.removeEventListener("load", eventHandler, false);

          let content = "";
          // Message from server...
          if (iframeById.contentDocument) {
              //content = iframeById.contentDocument.body.innerHTML;
              content = iframeById.contentDocument.body.innerText;
          } else if (iframeById.contentWindow) {
              content = iframeById.contentWindow.document.body.innerHTML;
          } else if (iframeById.document) {
              content = iframeById.document.body.innerHTML;
          }

          // Del the iframe...
          setTimeout(function () {iframeById.parentNode.removeChild(iframeById)}, 250);

          if (successFunc)
              successFunc(me, content);
      }

      if (iframeById.addEventListener) iframeById.addEventListener("load", eventHandler, true);
      if (iframeById.attachEvent) iframeById.attachEvent("onload", eventHandler);

      form.setAttribute("target", iframeid);
      form.setAttribute("action", this.createurl('uploadlicense'));
      form.setAttribute("method", "post");
      form.setAttribute("enctype", "multipart/form-data");
      form.setAttribute("encoding", "multipart/form-data");

      form.submit();
  };

  createurl = function(operation){
      var url = this.props.parent.props.apiUrl;
      var separator = '?';
      if (url.indexOf('?') >= 0)
          separator = '&';

      url += separator + "operation=" + operation;
      return url;
  };

  
}