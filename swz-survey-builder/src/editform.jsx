import React from "react";
import ReactDOM from "react-dom";
import CloverStore from './store';
import BuilderActions from './actions';
import CloverFormControls from './controls';
import {Form, Grid, Card, Input, Dropdown, Checkbox, TextArea, Button, Icon, Message, Image, Label, Header, Item, Segment, Modal, Confirm} from 'semantic-ui-react'

export default class EditForm extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      key: undefined,
      item: undefined,
      open: false
    };

    CloverStore.listenTo(BuilderActions.showEditForm, this.onShow.bind(this));
  }

  handleChange(e, { name, value, checked }){
    var data = this.state.item;  
    if(value == undefined)
      data[name] = checked;
    else
      data[name] = value;

    this.setState({item: data});
  }

  onShow(key){
     var data = CloverStore.getByKey(key);
     
     var item = {};
     for(var i in data){
       if(typeof(data[i]) == "object"){
        item[i] = JSON.parse(JSON.stringify(data[i]));
       }
       else{
        item[i] = data[i];
       }
     }

     this.setState({
      key: key,
      item: item,
      open: true
    });
  }

  isChangedItem(){
    var data = CloverStore.getByKey(this.state.key);
    var item = this.state.item;

    for(var i in item){
      if(JSON.stringify(item[i]) != JSON.stringify(data[i]))
        if(i == "events" &&
          (item[i] == undefined || JSON.stringify(item[i]) == "{}") &&
          (data[i] == undefined || JSON.stringify(data[i]) == "{}")){
          continue;
        }
        else {
          return true;
        }
    }
    return false;
  }

  getControlsList(){
    return CloverStore.getAllKeys(CloverStore.getData());
  }

  getNumberControlsList(){
    return CloverStore.getAllNumberKeys(CloverStore.getData());
  }

  showConfirm(text, confirmHandle){
    this.setState({ confirm: true, confirmtext: text, confirmHandle: confirmHandle });
  }

  onClose(e) {
    var ischanged = this.isChangedItem();
    if(ischanged){
        let msg = "Close without save?";
        if(this.props.localization != undefined){
          msg = this.props.localization.base.closewithoutsavequestion;
        }

        this.showConfirm(msg, this.onCloseConfirmed.bind(this));
    }
    else
    {
      this.onCloseConfirmed();
    }
  }

  checkUniqueKey(key, controlsList){
    if(key == '' || key == null){
      return false
    }
    if(controlsList !== undefined && controlsList.length > 0){
        for(let i = 0; i < controlsList.length; i++){
            if(key == controlsList[i]){
                //Exist in list
                return false
            }
        }
    }
    return true
}

  onSave() {
    const newName = (this.state.item.key===undefined) ? "" : this.state.item.key.trim();

    if(!this.checkUniqueKey(newName, this.getControlsList()) && (newName !== this.state.key)){
      alert("Name \"" + newName + "\" already exists, please enter a different name");
      return
    }

    if(newName.length > 150){
      alert("Name must not more than 150 characters");
      return
    }
    
    var regSymbol = /[^A-Za-z0-9\_]/;
    if(regSymbol.test(newName)){
      alert("Except Underscores, other symbols and blank space is not allowed");
      return;
    }

    //To force user create name starts with a letter.
    //To avoid invalid syntax error for javascript
    const regLetter = /[a-zA-Z]/;
    if(!regLetter.test(newName[0])){
      alert("Name must begin with a letter");
      return;
    }
    this.state.item.key = newName;

    CloverStore.updateItemByKey(this.state.key, this.state.item);
    
    if(!this.props.isDirty)
      this.props.isDirtyToggle();

    this.onCloseConfirmed();
  }

  onCloseConfirmed() {
    this.setState({ open: false, confirm: false });
  }

  createError(text){

    var closebtn = "Close";
    if(this.props.localization != undefined){
      closebtn = this.props.localization.base.closebutton;
    }

    return (<Modal closeOnDimmerClick={false} open={this.state.open} onClose={this.onClose.bind(this)}>
          <Modal.Header>
            Error
          </Modal.Header>
          <Modal.Content>
            <p>{text}</p>
          </Modal.Content>
          <Modal.Actions>
            <Button onClick={this.onClose.bind(this)}>
              {closebtn}
            </Button>
          </Modal.Actions>
        </Modal>);
  }

  render() {
    if(this.state.item == undefined)
        return (<div/>); 

    var editForm = CloverFormControls.getEditControlByType(this.state.item["data-buildertype"]);
    if(editForm == undefined)
    {
      return this.createError("EditForm is not found for this control!");
    }

    var okbtn = "OK";
    if(this.props.localization != undefined){
      okbtn = this.props.localization.base.okbutton;
    }
    var cancelbtn = "Cancel";
    if(this.props.localization != undefined){
      cancelbtn = this.props.localization.base.cancelbutton;
    }
    var questiontitle = "Question";
    if(this.props.localization != undefined){
      questiontitle = this.props.localization.base.questiontitle;
    }
    var confirmHandleCancel = () => this.setState({ confirm: false });
    return (<div>
        {React.createElement(editForm, { key: "editform", 
          data: this.state.item, 
          parent: this,
          open: this.state.open,
          onSave: this.onSave,
          onClose: this.onClose,
          actions: this.props.actions,
          className: "clover-formbuilder-editform",
          localization: this.props.localization,
          openFormLogicControl: this.props.openFormLogicControl,
          ruleApi: this.props.ruleApi,
          cssStyleApi: this.props.cssStyleApi
        })}
        <Modal closeOnDimmerClick={false} size="small" open={this.state.confirm} dimmer="inverted" onClose={confirmHandleCancel}>
          <Modal.Header>
            {questiontitle}
          </Modal.Header>
          <Modal.Content>
            <p>{this.state.confirmtext}</p>
          </Modal.Content>
          <Modal.Actions>
            <Button className="buttontype1" onClick={this.state.confirmHandle}>{okbtn}</Button>
            <Button className="buttontype2" onClick={confirmHandleCancel}>{cancelbtn}</Button>
          </Modal.Actions>
        </Modal>
        </div>
    )
  }
}