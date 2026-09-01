
import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./basecomponent"
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'
import PanelBase from './panelbase'

export default class PanelExternal extends PanelBase {
  constructor(props) {
    super(props);

    this.state.popup = {};
  }

  renderToolbar(){
    var me = this;
    var buttons = [];
    if(this.hidebuttons != true){
        var showconfirmdelete = () => {me.setState({confirmdeleteshow: true})};
        var showconfirmcreate = () => {
            me.setState({
            popup: {
                show: true
            }
            });
        };
        var hideconfirmcreate = () => {me.setState({popup: {show: false}})};
        buttons.push(<Button key="btnCreate" className="buttontype1" onClick={showconfirmcreate}>{CloverAdminLang.button.create}</Button>);
        buttons.push(<Button key="btnDelete" className="buttontype2" onClick={showconfirmdelete}>{CloverAdminLang.button.delete}</Button>);
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
                    <Button className="buttontype2" content={CloverAdminLang.button.cancel} onClick={hideconfirmcreate} />
                    <Button className="buttontype1" content={CloverAdminLang.button.create} onClick={this.onCreate.bind(this)} />
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

  onCreate(){
    var aid = this.state.popup.name;
    if(aid == '' || aid == undefined){
        this.setState({
            popup : {
                ...this.state.popup,
                errors: CloverAdminLang.msg.fieldrequired
            }
        });
        return;
    }
    
    this.setState({popup: {}});
    this.props.parent.openpage(this.panelindex, aid);
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