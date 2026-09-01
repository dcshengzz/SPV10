
import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./basecomponent"
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'
import PanelBase from './panelbase'
import Upload from './../../swz-survey-builder/src/control/upload'
import { encodeHtml } from './utils.jsx'

export default class PanelExternal extends PanelBase {
  constructor(props) {
    super(props);
    this.state = {
        open: false,
        data: {},
        modalOpen: false
    }

    this.state.popup = {};
  }

  refreshFileListing = (e, item) =>{
    this.props.parent.loadUploadedFiles();
    this.forceUpdate();
  }

  renderToolbar(){
    var me = this;
    var buttons = [];
    var data = {};
    
    const { open, dimmer } = this.state;
    var show = dimmer => () => this.setState({ dimmer, open: true })
    var close = () => {
        this.setState({ open: false });
    }

    var handleChange = function(e, {name, value}){
        if(value.item != undefined && value.message == "Successful"){
          alertify.hide;
          window.location.reload(false);
        } else if (value.item != null && value.message != "Successful"){
          alertify.error(encodeHtml(value.message));
        }
    }

    if(this.onfilestorage){
        var showconfirmdelete = () => {me.setState({confirmdeleteshow: true})};
        buttons.push(<Button floated="right" key="btnDelete" className="buttontype2 MarginRight20px" onClick={showconfirmdelete}>{CloverAdminLang.button.delete}</Button> );
        buttons.push(<Button floated="right" className="buttontype1" onClick={show(true)}>Import</Button>);
        buttons.push(<Button key="btnRefresh" className="buttontype2" onClick={this.refreshFileListing.bind(this)} style={{marginRight: '20px', marginBottom: '20px'}}>{CloverAdminLang.button.refresh}</Button>);
        buttons.push(
            <Modal dimmer={dimmer} open={open} onClose={close} >
              <Modal.Header content='Import File' />
              <Modal.Content>
                <div style={{width: '100%', 'margin-left': '1em'}} >
                    <div>
                      <Upload 
                      name="filename" 
                      value={this.state.data.filename}
                      type="file"
                      downloadUrl="/data/download/"
                      uploadUrl="/data/file/upload/"
                      onChange={handleChange}
                      islocalstorage={true}
                      refreshOnSuccess={false}
                      
                      //authorisedfiletypes = ".JPG,.jpg,.PNG,.png,.JPEG,.jpeg,.GIF,.gif"
                    />
                    </div>
                </div>
              </Modal.Content>
              <Modal.Actions>
                <Button className="buttontype2" onClick={close}>Cancel</Button>
              </Modal.Actions>
            </Modal>)

    }else {
        var showconfirmdelete = () => {me.setState({confirmdeleteshow: true})};
        var showconfirmcreate = () => {
            me.setState({
            popup: {
                show: true
            }
            });
        };
        var hideconfirmcreate = () => {me.setState({popup: {show: false}})};
        buttons.push(<Button floated="right" key="btnDelete" className="buttontype2 MarginRight20px MarginBottom20px" onClick={showconfirmdelete}>{CloverAdminLang.button.delete}</Button>);
        buttons.push(<Button floated="right" key="btnCreate" className="buttontype1" onClick={showconfirmcreate}>{CloverAdminLang.button.create}</Button>);
    }
    
    var popuperror;
    if(this.state.popup.errors != undefined){
      popuperror =(<Message negative>
            <p>{this.state.popup.errors}</p>
        </Message>);
    }

    return <div className="cloveradmin-toolbar">
            {buttons}
            <Modal dimmer={'blurring'} 
                open={this.state.popup.show} >
                <Modal.Header>Creating</Modal.Header>
                <Modal.Content>
                    <Form>
                        {popuperror}
                        <Form.Input key="name" name="newobjectname" label={CloverAdminLang.field.name} required
                            value={this.state.popup.name} 
                            onChange={this.handlePopupChange.bind(this)}
                            error={this.state.popup.errors != undefined} />
                    </Form>
                </Modal.Content>
                <Modal.Actions>
                    <Button className="buttontype1" content={CloverAdminLang.button.create} onClick={this.onCreate.bind(this)} />
                    <Button className="buttontype2" content={CloverAdminLang.button.cancel} onClick={hideconfirmcreate} />
                </Modal.Actions>
            </Modal>
        </div>;
  }

  handlePopupChange(e, {name, value, checked}){
    this.setState({
        popup : {
            ...this.state.popup,
            name: value
        }
    });
  }

  toPascalCase = (str) => {
    //var arr = str.split(/\s|_/); We allow underscores ONLY
    var arr = str.split(/\s|/);
    return arr.join("");
  }

  isSurveyFormNameExist(formname){
    var me = this;
    return $.ajax({
          url: me.props.surveyFormNameApi + "/" + encodeURI(formname),
          async: false,
          success: function (response) {
            if(response.success){
              return response.isExist;
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
            }
          },
          error: function (jqXHR, exception){
            me.processLoadError(jqXHR, exception);
          }
      });
  }

  onCreate(){
    var aid = (this.state.popup.name === undefined) ? "" : this.state.popup.name.trim();
    if(aid == '' || aid == undefined){
        this.setState({
            popup : {
                ...this.state.popup,
                errors: CloverAdminLang.msg.fieldrequired
            }
        });
        return;
    }

    if(aid.length > 240){
      alert("Name must not more than 240 characters");
      return
    }
    
    //Perform validation here
    //Instead check for the specific symbol (there are a lot more ©±∑≈¥), just check if is not the allowed character
    //var reg = /[!\s@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;
    var regSymbol = /[^A-Za-z0-9\_\-]/;
    if(regSymbol.test(aid)){
        this.setState({
            popup : {
                ...this.state.popup,
                errors: 'Except Underscores and Hyphen, other symbols and blank space is not allowed'
            }
        });
        return;
    }

    //To force user create a survey form named starts with a letter.
    //To avoid invalid syntax error for javascript variable naming, later when it auto build the businessobject.js
    const regLetter = /[a-zA-Z]/;
    if(!regLetter.test(aid[0])){
        this.setState({
            popup : {
                ...this.state.popup,
                errors: 'Name must begin with a letter'
            }
        });
        return;
    }

    let isSurveyFormNameExistResult = this.isSurveyFormNameExist(aid);

    if(isSurveyFormNameExistResult.responseJSON.isExist){
      this.setState({
        popup : {
          ...this.state.popup,
          errors: 'This form name is already in system, please change the form name. If the form name is not in the listing it means has been occupied by another organisation.'
        }
      });
      return;
    }
    var newAid = this.toPascalCase(aid);
    
    this.setState({popup: {}});
    this.props.parent.openpage(this.panelindex, newAid);
  }

  getEditRow(){
    var id = this.props.id;
    var data = this.props.data[this.dataindex];

    if(Array.isArray(data)){
        for(var i=0; i < data.length; i++){
            if(data[i][this.idfield] == id){
                return data[i];
            }
        }
    }

    var obj = {};
    obj[this.idfield] = id;
    return obj;
  }
}