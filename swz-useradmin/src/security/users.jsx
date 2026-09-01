import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm, Label, Header } from 'semantic-ui-react'
import JSON5 from 'json5'

import PanelPagerModal from './../panelpagermodal'
import CloverAdminUserEdit from './useredit'
import Papa from 'papaparse'
import { encodeHtml } from './utils.jsx'

export default class CloverAdminUsers extends PanelPagerModal {
  constructor(props) {
    super(props);

    this.dataindex = "users";
    this.panelindex = "users";
    this.idfield = "id";
    this.editform = CloverAdminUserEdit;
    this.datatype = "users";
    this.title = CloverAdminLang.user.title;

    this.rowHeight = 80;

     this.state={
      csvfile:undefined,
      importshow: undefined,
      open: false,
      openConfirm: false,
      gridKey: 0
    }
    
    this.updateData = this.updateData.bind(this);
  }

  open = () => this.setState({ openConfirm: true });
  
  close = () => this.setState({ openConfirm: false });

  gridColumns(){
    return [{
        key: 'name',
        name: CloverAdminLang.column.name,
        resizable: true
    },/*{
        key: 'email',
        name: CloverAdminLang.user.emailfield,
        resizable: true
    },*/{
      key: 'login',
      name: CloverAdminLang.user.loginfield,
      resizable: true,
      sortable: false
    },
    {
      key: 'email',
      name: 'Email',
      resizable: true,
      sortable: false
    },
    {
        key: 'rolesStr',
        name: CloverAdminLang.user.rolesfield,
        resizable: true,
        sortable: false
    },{
      key: 'isLocked',
      name: CloverAdminLang.user.lockedfield,
      resizable: true,
      type: 'checkbox'
    },{
      key: 'lastLoginDate',
      name: 'Last Login Date',
      resizable: true,
      type: 'datetime'
    },];
  }

  renderToolbar(){
    var me = this;
    //const {importshow} = this.state
    const { open, dimmer } = this.state;
    
    if(this.state.filter == undefined)
      this.state.filter = {};
     
    var showconfirmdelete = () => {me.setState({confirmdeleteshow: true})};
    var showconfirmcreate = () => {
        this.props.parent.openpage(this.panelindex, "new");
    };
   var show = dimmer => () => this.setState({ dimmer, open: true })
   var close = () => this.setState({ open: false })
  var onExportTemplate = () => {
      var data = 
      [["name", "login", "email", "password", "role", "isLocked"],
      ["Anthony", "anthony", "anthony@softworkz.net", "password123", "Data Editor", "FALSE"]]
  
      var csv = Papa.unparse(data);
      var downloadLink = document.createElement("a");
      var blob = new Blob(["\ufeff", csv]);
      var url = URL.createObjectURL(blob);
      downloadLink.href = url;
      downloadLink.download = "template.csv";
  
      document.body.appendChild(downloadLink);
      downloadLink.click();
      document.body.removeChild(downloadLink);
    }

    return <div className="cloveradmin-toolbar">
            <div className="cloveradmin-toolbarfilter">
              <Form>
                <Form.Group widths="equal">
                  <Form.Input name="filter" label={CloverAdminLang.field.name} value={this.state.filter.filter} onChange={this.handleFilterChange.bind(this)}/>
                  <Button className="buttontype2" content={CloverAdminLang.button.search} onClick={this.onSearch.bind(this)} />
                </Form.Group>
              </Form>
            </div>
            <Button className="buttontype1" onClick={showconfirmcreate}>{CloverAdminLang.button.create}</Button>
            <Button className="buttontype2" onClick={showconfirmdelete}>{CloverAdminLang.button.delete}</Button>   
          
            <Confirm
              open={this.state.openConfirm}
              onCancel={() => this.close()}
              onConfirm={() => this.resetSalt()}
              content="This will invalidate the existing 2FA keys for selected users and set new ones. Active users will be sent new key by email. Proceed?"
            />  
            <Button className="buttontype2" onClick={() => this.open()}>Reset Authenticator Key &amp; Send</Button>
          
            <label>
            <Button className="buttontype2" onClick={show(true)}>Import</Button>
            
            <Modal dimmer={dimmer} open={open} onClose={close} >
              <Header content='Import Users' />
              <Modal.Content>
                <div style={{width: '100%', 'margin-left': '1em'}} >
                    <div>
                      <Input
		      required
                      className="csv-input"
                      style={{
                      width: '50%',
                      'margin-top': '1em',
                      'margin-bottom': '1em'
                      }}
                      type="file"
                      ref={(input) => { this.filesInput = input }}
                      name="file"
                      //icon='file text outline'
                      //iconPosition={false}
                      label="Select CSV file"
                      labelPosition='left'
                      placeholder={null}
                      onChange={this.handleChange}
                      accept=".xlsx,.xls,.csv,.txt"
                      />
                    </div>
                    <label style={{cursor: 'pointer'}} onClick={onExportTemplate}><a>Download CSV Template</a></label>
                </div>
              </Modal.Content>
              <Modal.Actions>
                <Button className="buttontype2" onClick={close}>Cancel</Button>   
                <Button className="buttontype1" onClick={this.importCSV}>Save</Button>
              </Modal.Actions>
            </Modal>
      
            </label>  
          {/* <span>{CloverAdminLang.msg.totalcount} {me.state.rowsCount}</span> */}
        </div>;
  }

 

  resetSalt = () => {
    
    this.close();
    
    if(this.grid == undefined)
      return

    var gridState = this.grid.state;
    var ids = [];
    var selectedIndexes = gridState.selectedIndexes;
    var items = gridState.items;

    if(selectedIndexes.length < 1 || items.length < 1)
      return alertify.error("Please select rows");

      for(let i = 0; i < selectedIndexes.length; i++){
        for(let j = 0; j < items.length; j ++){
          if(selectedIndexes[i] == j)
            ids.push(items[j]['id']);
        }
      }
      this.close();    
	    const formData = new FormData();
      formData.append("ids", ids);
      formData.append("resetSalt", "true");
      formData.append("sendEmail", "true");
    
      const url = "/account/manageAuthenticatorKey";
	    fetch(url,
	        {
	            credentials: 'same-origin',
	            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
	            method: 'post',
	            body: formData
	        })
	        .then(response => response.json())
	        .then(response => {
	            if (response.success) {
                    alertify.success(response.message, 30000);
	            } else {
	                alertify.error(encodeHtml(response.message, 30000));
	            }
	        })
	        .catch(error => {
	            alertify.error(encodeHtml(error.message, 30000));
	        });

  }

  handleChange = (event) => {
    var ext = event.target.files[0].name.match(/\.([^\.]+)$/)[1];
    switch (ext) {
      case 'csv':
        this.setState({
          csvfile: event.target.files[0]
        })
        break;
      default:
        alertify.error('File extension not allowed');
    }
  }

  importCSV = () => {
    const {csvfile} = this.state
    if(csvfile !== undefined){
      Papa.parse(csvfile, {
        complete: this.updateData,
        header:true,
      });
      this.setState({open:false, csvfile: undefined});
    }else{
      alertify.error("No file selected");	
    }
  }

  updateData(result) {
    var data = result.data;
    this.onImport(data)
  }

  getRoleId = (roleName) =>{
    if(this.props.parent.state.data.roles !== undefined){
      var parentRoles = this.props.parent.state.data.roles; 
      for(let j=0; j < parentRoles.length; j++){
        if(parentRoles[j].name == roleName){ //Role name as variable, not role code
          return parentRoles[j].id;
        }
      }
      return false //No such role exists
    }
  }

  getRoleIds = (roleName) =>{
    let roleIds = [] ;
    if(this.props.parent.state.data.roles !== undefined){
	let parentRoles = this.props.parent.state.data.roles; 
	let roleNameArray = roleName.split(",");
      for(let j=0; j < parentRoles.length; j++){
	roleNameArray.forEach(roleName => {
	        if(parentRoles[j].name.toLowerCase() == roleName.trim().toLowerCase()){ //Role name as variable, not role code
	          roleIds.push(parentRoles[j].id);
	        }
	});

      }
    }
    return roleIds;
  }

  onImport = (data) => {
      var me = this;  
      var csvdata = data
      var obj = {};
      var usersArr = [];
      var roleObj = {};
      if(csvdata.length==0){
	alertify.error("Invalid user data");
        return;	
      }
      for(var i=0; i<csvdata.length; i++){
	if(!csvdata[i].login || !csvdata[i].name){
		continue;
	}
        var newid = this.createNewObject();
        var roleName = csvdata[i].role;
        var role = [];

        if(roleName !== undefined && roleName !== ""){
          role = me.getRoleIds(roleName);
        }

        
         obj = {
            id: newid.id,
            name: csvdata[i].name,
            login: csvdata[i].login,
            password: csvdata[i].password,
            email: csvdata[i].email,
            isLocked: csvdata[i].isLocked,
            roles: role,
          
            __type: "users",
            __error: {},
            __state: "inserted"
         }
         usersArr.push(obj); 
      }
      if(usersArr.length==0){
	alertify.error("Invalid user data");
	document.getElementsByName("file").value = "";
        return;	
      }
      this.ChangeData(usersArr, function(response){
        me.grid.refresh();
        me.back();
      });
      
  }

  handleFilterChange(e, {name, value}){
    this.state.filter[name] = value;
    this.forceUpdate();
  }

onSearch(){
    this.setState(prevState => ({
        gridKey: prevState.gridKey + 1
    }), () => {
        this.grid.refresh();
    });
  }

  validate(){
    var res = true;
    var editrow = this.state.editrow;
    var nameRegex = /^[a-zA-Z0-9 !@#\$%\^\&'*\)\(+=._-]{3,30}$/g;
    var emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    var loginRegex = /^[a-zA-Z0-9]{3,30}$/;
      
    
    editrow.__error = {
          name: (editrow.name == undefined || editrow.name == "") ? 
                CloverAdminLang.msg.namerequired : !nameRegex.test(editrow.name) ? 
                CloverAdminLang.msg.nameFormat : undefined,
          login: (editrow.login == undefined || editrow.login == "") ? 
                CloverAdminLang.msg.loginrequired : !loginRegex.test(editrow.login) ?
                CloverAdminLang.msg.loginFormat : undefined,
          email: (editrow.email == undefined || editrow.email == "") ? 
                CloverAdminLang.msg.emailrequired : !emailRegex.test(editrow.email) ? 
                CloverAdminLang.msg.emailformat : undefined ,
    };
    res &= editrow.__error.name == undefined;
    res &= editrow.__error.login == undefined;
    res &= editrow.__error.email == undefined;

    return res;
  }

  applyeditrow(){
    var me = this;
    var id = this.state.editrow[this.idfield];
    var index = -1;

    var coll = this.props.data[this.dataindex];
    for(var i = 0; i < coll.length; i++){
        if(id === coll[i][this.idfield]){
            index = i;
            break;
        }
    }

    this.state.editrow["password"] = undefined;

    if(index >= 0){
        this.props.data[this.dataindex][index] = this.state.editrow;
    }
    else{
        this.props.data[this.dataindex].unshift(this.state.editrow);
    }
  }

getAdditionalDataForControl(control, 
    {startIndex, pageSize, filters, sort}, 
    callback){
    var me = this;
    var data = new Array();

    data.push({ name: 'operation', value: 'users' });
    data.push({ name: 'suboperation', value: 'loadlist' });
    data.push({ name: 'skip', value: startIndex });
    data.push({ name: 'take', value: pageSize });
    data.push({ name: 'sort', value: sort });
    data.push({ name: 'filteradmin', value: this.props.superAdminRoles[0] });//Filter admin
    
    if(me.state.filter.filter != undefined && me.state.filter.filter != "")
      data.push({ name: 'filter', value: me.state.filter.filter });
    console.log("apiUrl:", me.props.apiUrl);
    $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: true,
        type: "post",
        success: function (response) {
          console.log("response:", response);
          if(response.success){
            console.log("response items:", response.item.users);

            // ➡️ CRITICAL CHECK (from prior fix): Ensure totalCount is 0 if no results are found.
            let totalCount = parseInt(response.item.count, 10);
            if (!response.item.users || response.item.users.length === 0) {
                totalCount = 0;
            }
            
            var obj = {
                sIndex: startIndex,
                pSize: pageSize,
                rowsCount: totalCount, 
                items: response.item.users || []
            };
            
            callback(obj);

            me.setState({
                rowsCount: totalCount
              });
          }
          else{
            console.log("error message:", response.message);
            alertify.error(encodeHtml(response.message));
          }
        }
    }); 
  }
  
  filterRole = (respUsers) => {
      var usersArr = [];
      var superAdminRoles = this.props.superAdminRoles
      var roleObj = {};

    for(var i=0; i<respUsers.length; i++){
      for(let j=0; j<superAdminRoles.length; j++){
        if(roleObj[i] == undefined){
          if(this.containsWord(respUsers[i].rolesStr, superAdminRoles[j]) == true || respUsers[i].rolesStr == superAdminRoles[j]){
              roleObj[i] = 'RoleExcluded';              
          }
        }
      }
      if(roleObj[i] !== 'RoleExcluded'){
          usersArr.push(respUsers[i]);
      }
    }
    return usersArr
  }

  containsWord = (str, word) => {
    return str.match(new RegExp("\\b" + word + "\\b")) != null;
  }

  getEditRow(){
    var id = this.props.id;

    if(id == "new"){
      const newObject = this.createNewObject();
      newObject.requireTotp = true;
      return newObject;
    }

    var me = this;
    var data = new Array();
    data.push({ name: 'operation', value: 'users' });
    data.push({ name: 'suboperation', value: 'load' });
    data.push({ name: 'id', value: id });
 
    var response = $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: false,
        type: "post"
    }).responseJSON; 

    if(response.success){
      if(response.item == undefined){
        alertify.error(CloverAdminLang.msg.objectnotfound);
        me.back();
        return {};
      }
      else{
        return response.item;
      }
    }
    else{
      alert(response.message);
    }
    
    return undefined;
  }

  recalcSizeParams(){
    if(!this._isMounted)
        return;
    var h = $(window).height();
  
    this.setState({
        gridHeight: h - 280 - this.props.deltaHeight
    });
  }
}