import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'
import { encodeHtml } from './../utils.jsx'
import PanelExternal from './../panelexternal'
import CloverAdminFormEdit from './formedit';

export default class CloverAdminForm extends PanelExternal {
  constructor(props) {
    super(props);

    this.editform = CloverAdminFormEdit;
    this.dataindex = "forms";
    this.idfield="name";
    this.panelindex = "forms";
    this.datatype = "form";
    this.title = CloverAdminLang.form.title;
    this.destFormName = ""; //Store the name of the form for copy dialog outside state to avoid redraws
    this.filter = {       
      isTemplate: false,
      isArchived: false
    };
    this.filterAny ={
      name: '',
      createdByUsername: '',
      updatedByUsername: '',
      updatedDate: ''
    }
  }

  
toggleTemplateFilter = (e, item) => {
  this.filter.isTemplate = item.checked;
  this.forceUpdate();
}

toggleisArchivedFilter = (e, item) => {
  this.filter.isArchived = item.checked;
  this.forceUpdate();
}

  searchFilter = (e, item) =>{
    //this.filter.searchValue = item.value.trim();
    this.filterAny.name = item.value.trim();
    this.filterAny.createdByUsername = item.value.trim();
    this.filterAny.updatedByUsername = item.value.trim();
    this.filterAny.updatedDate = item.value.trim();
    this.forceUpdate();
  }

  refreshSurveyFormListing = (e, item) =>{
    this.props.parent.loadSurvey();
    this.forceUpdate();
  }


  renderToolbar(){
    var me = this;
    var buttons = [];

    if(this.hidebuttons != true){
        var showconfirmdelete = () => 
          {
            var deleterows = [];
            if (this.grid && this.grid.state !== undefined && this.grid.state !== null) {
                var selectedRowArray = this.grid.state.selectedIndexes;
                if (selectedRowArray !== null && selectedRowArray !== undefined) {
                  for (var i = 0; i < selectedRowArray.length; i++) {
                    deleterows.push(this.grid.state.items[selectedRowArray[i]]);
                  }
                }
            }
            if(deleterows.length > 0) {
              me.setState({confirmdeleteshow: true})
            }
            else {
              alertify.error("Please select at least one record");
            }
          };
        var showconfirmcreate = () => {
            me.setState({
            popup: {
                show: true
            }
            });
        };
        var hideconfirmcreate = () => {me.setState({popup: {show: false}})};
        buttons.push(<Button floated="right" key="btnDelete" className="buttontype2 MarginRight20px" onClick={showconfirmdelete}>{CloverAdminLang.button.delete}</Button>);
        buttons.push(<Button floated="right" key="btnCreate" className="buttontype1" onClick={showconfirmcreate}>{CloverAdminLang.button.create}</Button>);
        buttons.push(<Button key="btnRefresh" className="buttontype2" onClick={this.refreshSurveyFormListing.bind(this)} style={{marginRight: '20px', marginBottom: '20px'}}>{CloverAdminLang.button.refresh}</Button>);

        buttons.push(<Input key="txtSearch" placeholder="Search..." style={{width: '300px', marginRight: '20px', marginBottom: '20px'}}
          onChange={this.searchFilter.bind(this)}></Input>);
          
        buttons.push(<Checkbox
          label="Templates" className="cloveradmin-toolbar-templates" 
          toggle onChange={this.toggleTemplateFilter.bind(this)} checked={this.filter.isTemplate}/>)

        buttons.push(<Checkbox
          label="Archived" className="cloveradmin-toolbar-templates" style={{ marginLeft: '20px'}}
          toggle onChange={this.toggleisArchivedFilter.bind(this)} checked={this.filter.isArchived}/>)
     }
    var popuperror;
    if(this.state.popup.errors != undefined){
      popuperror =(<Message negative>
            <p>{this.state.popup.errors}</p>
        </Message>);
    }

    return <div className="cloveradmin-toolbar">
            {buttons}
            <Modal closeOnDimmerClick={false} dimmer={'blurring'} 
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

  handleClose = () => { 
    this.destFormName = "";
    this.setState({modalOpen: false, sourceForm: null, popup: {}}); 
  }

  onCopyClicked = () => {

    const dfn = (this.destFormName===undefined) ? "" : this.destFormName.trim();
    if(dfn == ''){
        this.setState({
            popup : {
                ...this.state.popup,
                errors: CloverAdminLang.msg.fieldrequired
            }
        });
        return;
    }
    
    if(dfn.length > 240){
      alert("Name must not more than 240 characters");
      return
    }
    
    //Perform validation here
    //Instead check for the specific symbol (there are a lot more ©±∑≈¥), just check if is not the allowed character
    //var reg = /[!\s@#$%^&*()+\-=\[\]{};':"\\|,.<>\/?]/;
    var regSymbol = /[^A-Za-z0-9\_\-]/;
    if(regSymbol.test(dfn)){
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
    if(!regLetter.test(dfn[0])){
        this.setState({
            popup : {
                ...this.state.popup,
                errors: 'Name must begin with a letter'
            }
        });
        return;
    }

    //character limit 255, max with 240 due to -settings.json taken 14 characters

    let isSurveyFormNameExistResult = this.isSurveyFormNameExist(dfn);

    if(isSurveyFormNameExistResult.responseJSON.isExist){
      this.setState({
        popup : {
          ...this.state.popup,
          errors: 'This form name is already in system, please change the form name. If the form name is not in the listing it means has been occupied by another organisation.'
        }
      });
      return;
    }

    const destForm = this.toPascalCase(dfn);
    const sourceForm = this.state.sourceForm;
    const postParams = new FormData();
    postParams.append("operation","duplicate-form");
    postParams.append("sourceForm", sourceForm);
    postParams.append("destForm", destForm);
    
    //alertify.success("DEBUG: onCopyClicked. destForm=" + destForm + ", sourceForm=" + this.state.sourceForm);

    const me = this;
    fetch(this.props.apiUrl, {
      credentials: "same-origin",
      method: "post",
      body: postParams,
    }).then( response => {
          return response.ok ? response.json() : Promise.reject("Failed to get data from server: " + response.status);
        }, reason => {
          Promise.reject(reason);
        } 
    ).then( responseData => {
          return responseData.success ? responseData.message : Promise.reject(responseData.message);
        }, reason => {
          return Promise.reject(reason);
        } 
    ).then(
        data => {
          alertify.success("Created " + data);
          this.destFormName = "";
          this.handleClose();
          this.setState({popup: {}}); 
          this.props.parent.load(); 
        }, reason => {
          console.error(reason);
          alertify.error(encodeHtml(reason));
        }
    );
  }

  handleOpen = (e, val) => {
    e.stopPropagation(); //We don't want the form to be opened here
    const me = this;
    this.setState({modalOpen: true, sourceForm: val.sourceform, popup : {
      ...me.state.popup,
      name: "",
      errors: null,
    }});     
  }

  //Handle onChanges for the name field in the copy dialog
  handleNameChange(e, {name, value, checked}){
    this.destFormName = value;
  }

  gridColumns(){
    const me = this;
    const { dimmer } = me.state;
    return [{
        key: 'name',
        name: CloverAdminLang.column.name,
        resizable: true
    } , {
      key: 'updatedDate',
      name: CloverAdminLang.column.lastUpdate,
      resizable: true,
      type: 'datetime',
    } ,{
      key: 'updatedByUsername',
      name: CloverAdminLang.column.updatedBy,
      resizable: true,
    } ,{
      key: 'createdByUsername',
      name: CloverAdminLang.column.createdBy,
      resizable: true,
    } ,
    {
      key: 'action',
      name: 'Action',  
      resizable: true,
      type: "custom",
      customFormatter: function( {row, value, column} ){
        var popuperror;
        if(me.state.popup.errors != undefined){
          popuperror =(<Message negative>
                <p>{me.state.popup.errors}</p>
            </Message>);
        }

        const aid = row.name;
        const res =(    
            <div onClick={e => e.stopPropagation()}>
            <Modal closeOnDimmerClick={false} key={value} open={me.state.modalOpen} dimmer={dimmer} onClose={me.handleClose} apiurl={me.props.apiUrl}
             trigger={<Button className="buttontype2" compact sourceform={aid}
                        onClick={(event, data) => me.handleOpen(event, data)} >Copy</Button>}>
              <Modal.Header content='Copy Form' />  
              <Modal.Content>
                <Form>
                  {popuperror}
                  <Form.Input key="newformname" name="newformname" label={CloverAdminLang.field.copyname} required
                    onChange={me.handleNameChange.bind(me)}
                    error={me.state.popup.errors != undefined}
                    defaultValue={this.destFormName}
                  />
                </Form>
              </Modal.Content>      
              <Modal.Actions>
                <Button className="buttontype1" content={CloverAdminLang.button.copy} onClick={me.onCopyClicked} />
                <Button className="buttontype2" content={CloverAdminLang.button.cancel} onClick={me.handleClose} />                
              </Modal.Actions>
            </Modal>
            </div>
        );
        return res;
      }
    } 
    ];
  }
}