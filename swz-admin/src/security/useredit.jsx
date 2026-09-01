import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Breadcrumb, Button, Modal, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'
import BaseComponent from './../basecomponent'

export default class CloverAdminUserEdit extends BaseComponent {
    constructor(props) {
        super(props);

        this.state = {
            open: false //for the salt reset button's confirm
        };
    }

    validate(){
        return this.props.parent.validate();
    }

    open = () => this.setState({ open: true }); //for salt confirm
  
    close = () => this.setState({ open: false });

    render(){
        this.validate();

        var groups = [];
        for(var i=0; i < this.props.metadata.groups.length; i++ ){
            var g = this.props.metadata.groups;
            groups.push({text: g[i].name, value: g[i].id});
        }

        var roles = [];
        for(var i=0; i < this.props.metadata.roles.length; i++ ){
            var r = this.props.metadata.roles;
            roles.push({text: r[i].name, value: r[i].id});
        }

        var structDivisions = [];

        for(var i=0; i < this.props.metadata.structDivisions.length; i++ ){
            var r = this.props.metadata.structDivisions;
            structDivisions.push({text: r[i].name, value: r[i].id});
        }

        var data = this.props.data;

        const lastLoginDateData = (data.lastLoginDate===undefined || data.lastLoginDate==null || data.lastLoginDate=="")
            ? "N/A"
            : ""+data.lastLoginDate; //no moment here

        return (
            <Form>
                 <Form.Group widths="equal">
                    <div className="field">
                        <Form.Input name="name" label={CloverAdminLang.field.name} error={Boolean(data.__error.name)} value={data.name} onChange={this.handleChange.bind(this, data)} />
                        <Form.Input name="email" label={CloverAdminLang.user.emailfield} error={Boolean(data.__error.email)} value={data.email} onChange={this.handleChange.bind(this, data)} />
                        
                        {data.linkedDomainLogin ? 
                        <Form.Input name="domainLogin" label={CloverAdminLang.user.domainloginfield} error={Boolean(data.__error.domainLogin)} value={data.domainLogin} onChange={this.handleChange.bind(this, data)} disabled/>
                        :
                        <Form.Input name="domainLogin" label={CloverAdminLang.user.domainloginfield} error={Boolean(data.__error.domainLogin)} value={data.domainLogin} onChange={this.handleChange.bind(this, data)} />
                        }
                        
                        {data.domainLogin ? 
                        <Form.Input name="linkedDomainLogin" label={CloverAdminLang.user.linkeddomainloginfield} error={Boolean(data.__error.linkedDomainLogin)} value={data.linkedDomainLogin} onChange={this.handleChange.bind(this, data)} disabled/>
                        :
                        <Form.Input name="linkedDomainLogin" label={CloverAdminLang.user.linkeddomainloginfield} error={Boolean(data.__error.linkedDomainLogin)} value={data.linkedDomainLogin} onChange={this.handleChange.bind(this, data)} />
                        }

                        <Form.Input name="lastLoginDate" label={CloverAdminLang.user.lastlogindate} error={Boolean(data.__error.lastlogindate)} value={ lastLoginDateData } />
                        
                        <Form.Input name="localization" label={CloverAdminLang.user.localizationfield} error={Boolean(data.__error.localization)} value={data.localization} onChange={this.handleChange.bind(this, data)} />
                    </div>
                    <div className="field">
                        <Form.Input name="login-new" label={CloverAdminLang.user.loginfield} error={Boolean(data.__error.login)} value={data.login} onChange={this.handleChange.bind(this, data)} />
                        <Form.Input type="password" name="password-new" placeholder="*********" label={CloverAdminLang.user.passwordfield} error={Boolean(data.__error.password)} value={data.password} onChange={this.handleChange.bind(this, data)} />
                        <Form.Checkbox name="requireTotp" label={CloverAdminLang.user.requireTotp} error={Boolean(data.__error.requireTotp)} checked={data.requireTotp == 1} onChange={this.handleChange.bind(this, data)} />
                        {(data.__state != "inserted") &&
                            <div style={{marginBottom: "10px"}}>
                                <Button name="btnSendQrCode" className="ui button mini secondary" onClick={this.onSendQrCode.bind(this, data)}>{CloverAdminLang.common.sendqrcodebutton}</Button>
                                <Confirm
                                        open={this.state.open}
                                        onCancel={this.close}
                                        onConfirm={this.onResetSalt.bind(this, data)}
                                        content="This will invalidate the existing 2FA secret and set a new one. Are you sure?"
                                        />
                                <Button name="btnRandomizeSalt" className="ui button mini secondary" onClick={this.open}>{CloverAdminLang.common.randomizesalt}</Button>
                            </div>
                        }
                        <Form.Checkbox name="isLocked" label={CloverAdminLang.user.lockedfield} error={Boolean(data.__error.isLocked)} checked={data.isLocked == 1} onChange={this.handleChange.bind(this, data)} />
                    </div>
                </Form.Group>
                <Form.Group widths="equal">
                    <Form.Dropdown label={CloverAdminLang.user.structDivisionsfield} name="structDivisionId" error={Boolean(data.__error.structDivisionId)} search selection options={structDivisions} value={data.structDivisionId == undefined ? "" : data.structDivisionId} onChange={this.handleChange.bind(this, data)} />
                    <Form.Dropdown label={CloverAdminLang.user.groupsfield} name="groups" error={Boolean(data.__error.groups)} multiple search selection options={groups} value={data.groups == undefined ? [] : data.groups} onChange={this.handleChange.bind(this, data)} />
                    <Form.Dropdown label={CloverAdminLang.user.rolesfield} name="roles" error={Boolean(data.__error.roles)} multiple search selection options={roles} value={data.roles == undefined ? [] : data.roles} onChange={this.handleChange.bind(this, data)} />
                </Form.Group>
            </Form>
        );
    }

    handleChange(obj, e, {name, value, checked}){
        if(name == "login-new")
            name = "login";
        else if(name == "password-new")
            name = "password";

        var originalValue = obj[name];

        if(value == undefined){
            obj[name] = checked;
        }
        else{
            obj[name] = value;
        }
        
        this.setUpdatedState(this.props.data); //update __state (not react state)
        this.forceUpdate();
    }

    onSendQrCode(data){
	    const formData = new FormData();
	    formData.append("ids", data.id);
        formData.append("resetSalt","false");
        formData.append("sendEmail","true");
	    var url = "/account/manageAuthenticatorKey";
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
                    alertify.success(response.message, 30000)
	            } else {
	                alertify.error(response.message, 30000);
	            }
	        })
	        .catch(error => {
	            alertify.error(error.message, 30000);
	        });
    }

    onResetSalt(data){        
        this.close();    
	    const formData = new FormData();
        formData.append("ids", data.id);
        formData.append("resetSalt", "true");
        formData.append("sendEmail", "false");
    
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
	                alertify.error(response.message, 30000);
	            }
	        })
	        .catch(error => {
	            alertify.error(error.message, 30000);
	        });
    }
}