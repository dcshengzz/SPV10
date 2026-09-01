
import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./basecomponent"
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'
import PanelPager from './panelpager'

export default class PanelPagerModal extends PanelPager {
  constructor(props) {
    super(props);
    this.state.openmodal = false;
  }

  back(){
    this.state.openmodal = false;
    super.back();
  }

  render(){
    if(this.state.editrowid != this.props.id){
        this.loadeditrow();
    }
    
    return (<div>
      {this.renderMainForm()}
      {this.renderEditFormModal()}
    </div>);
  }

  renderEditFormModal(){
    if(this.props.id != undefined){
        this.state.openmodal = true;
    }

    return <Modal dimmer='inverted' closeOnDimmerClick={false} open={this.state.openmodal} onClose={this.onModalFormClose.bind(this)}>
        <Modal.Content>
            <Modal.Description>
            {this.renderEditForm()}
            </Modal.Description>
        </Modal.Content>
        <Modal.Actions>
            <Button className="buttontype1" onClick={this.onModalFormSave.bind(this)}>{CloverAdminLang.button.save}</Button>
            <Button className="buttontype2" onClick={this.onModalFormClose.bind(this)}>{CloverAdminLang.button.close}</Button>
        </Modal.Actions>
    </Modal>;
  }

  onModalFormSave(){
    var me = this;
    if(!this.validate()){
        var editrow = this.state.editrow;
        if (editrow.__error.name != undefined)
            alertify.error(editrow.__error.name);
        if (editrow.__error.login != undefined)
            alertify.error(editrow.__error.login);
        if (editrow.__error.email != undefined)
            alertify.error(editrow.__error.email);
        if (editrow.__error.gaSalt != undefined)
            alertify.error(editrow.__error.gaSalt);
        return;
    }

    var me = this;
    if(me.state.editrow["__state"] != undefined){
        me.state.editrow["__type"] = this.datatype;
        this.ChangeData([me.state.editrow], function(response){
            me.ResetSystemProps(me.state.editrow);
            //me.applyeditrow();
            me.grid.refresh();
            me.back();
        });
    }
    else{
      this.onModalFormClose();
    }
  }

  onModalFormClose(){
    this.back();
  }

}