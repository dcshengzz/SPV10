import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Breadcrumb, Button, Modal, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'
import moment from 'moment';
import BaseComponent from './../basecomponent'
import { encodeHtml } from './utils.jsx'

export default class CloverAdminUserEdit extends BaseComponent {
    constructor(props) {
        super(props);

        this.state = {
            open: false
        };
    }

    validate(){
        return this.props.parent.validate();
    }


    open = () => this.setState({ open: true });
  
    close = () => this.setState({ open: false });

    render(){
        this.validate();
        var isSystemDefault = false;
        if(this.props.metadata.structDivisions.some(structdivison => structdivison.id === "f6e34bdf-b769-42dd-a2be-fee67faf9045")){
            isSystemDefault = true;
        }

        var groups = [];
        for(var i=0; i < this.props.metadata.groups.length; i++ ){
            var g = this.props.metadata.groups;
            groups.push({text: g[i].name, value: g[i].id});
        }

        var roles = [];
        for(var i=0; i < this.props.metadata.roles.length; i++ ){
            var r = this.props.metadata.roles;
            if(!isSystemDefault && (r[i].name === "HelpEditor" || r[i].name === "AuditAdmin"))
                continue;
            roles.push({text: r[i].name, value: r[i].id});
        }

        var structDivisions = [];

        for(var i=0; i < this.props.metadata.structDivisions.length; i++ ){
            var r = this.props.metadata.structDivisions;
            structDivisions.push({text: r[i].name, value: r[i].id});
        }

        let datetimeformat = (window.CloverLang !== undefined && CloverLang.common !== undefined && window.CloverLang.common.dateFormat != undefined) 
                ? window.CloverLang.common.dateFormat + " " + 
                (window.CloverLang.common.timeFormat !== undefined ? window.CloverLang.common.timeFormat: "HH:mm")
                : "DD MMM YYYY HH:mm";

        var data = this.props.data;

        const lastLoginDateData = (data.lastLoginDate===undefined || data.lastLoginDate==null || data.lastLoginDate=="")
            ? "N/A"
            : moment(data.lastLoginDate).format(datetimeformat);

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
                        
                    </div>
                    <div className="field">
                        <Form.Input name="login-new" label={CloverAdminLang.user.loginfield} error={Boolean(data.__error.login)} value={data.login} onChange={this.handleChange.bind(this, data)} />
                        <Form.Input type="password" name="password-new" placeholder="*********" label={CloverAdminLang.user.passwordfield} error={Boolean(data.__error.password)} value={data.password} onChange={this.handleChange.bind(this, data)} />

                        <Form.Checkbox name="requireTotp" label={CloverAdminLang.user.requireTotp} error={Boolean(data.__error.requireTotp)} checked={data.requireTotp == 1} onChange={this.handleChange.bind(this, data)} />

                        {(data.__state != "inserted") &&
                            <div style={{marginBottom: "10px"}}>
                                
                                <Form.Checkbox name="isLocked" label={CloverAdminLang.user.lockedfield} error={Boolean(data.__error.isLocked)} checked={data.isLocked == 1} onChange={this.handleChange.bind(this, data)} disabled /> 
                                
                                <Button  className="ui button mini secondary" onClick={this.onUnlockUser.bind(this, data)}>{data.isLocked ? "Unlock User " : "Lock User"}</Button> 

                                {!data.isLocked && 
                                    <Button name="btnSendQrCode" className="ui button mini secondary" onClick={this.onSendQrCode.bind(this, data)}>{CloverAdminLang.common.sendqrcodebutton}</Button>
                                
                                }   
                                                             
                                <Confirm
                                        open={this.state.open}
                                        onCancel={this.close}
                                        onConfirm={this.onResetSalt.bind(this, data)}
                                        content="This will invalidate the existing 2FA secret and set a new one. Are you sure?"
                                        />                                        
                                <Button name="btnRandomizeSalt" className="ui button mini secondary" onClick={this.open}>{CloverAdminLang.common.randomizesalt}</Button>

                            </div>
                        }
                    </div>
                </Form.Group>
                <Form.Group widths="equal">
                    <Form.Dropdown label={CloverAdminLang.user.structDivisionsfield} name="structDivisionId" error={Boolean(data.__error.structDivisionId)} search selection options={structDivisions} value={data.structDivisionId == undefined ? "" : data.structDivisionId} onChange={this.handleChange.bind(this, data)} />
                    {/* <Form.Dropdown label={CloverAdminLang.user.groupsfield} name="groups" error={Boolean(data.__error.groups)} multiple search selection options={groups} value={data.groups == undefined ? [] : data.groups} onChange={this.handleChange.bind(this, data)} /> */}
                    <Form.Dropdown label={CloverAdminLang.user.rolesfield} name="roles" error={Boolean(data.__error.roles)} multiple search selection options={roles} value={data.roles == undefined ? [] : data.roles} onChange={this.handleChange.bind(this, data)} />
                </Form.Group>
            </Form>
        );
    }

    onUnlockUser(data){
        var onLock = data.isLocked ? false : true;
        var formData = new FormData();
            formData.append('id', data.id);
            formData.append('onLock', onLock);
        var url = '/account/unlockuser';
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
                alertify.success(response.message);
            
                var obj = {
                    name : 'isLocked',
                    value: response.isLocked
                }
                this.handleChange(data, null, obj); 

                } else {
                    alertify.error(encodeHtml(response.message));
                }
            })
            .catch(error => {
                alertify.error(encodeHtml(error.message));
            });
    
    }

    handleChange(obj, e, {name, value, checked}){
        
        if(name == "login-new")
            name = "login";
        else if(name == "password-new")
            name = "password";

        if(value == undefined){
            obj[name] = checked;
        }
        else{
            obj[name] = value;
        }
        
        this.setUpdatedState(this.props.data);
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
	                alertify.error(encodeHtml(response.message, 30000));
	            }
	        })
	        .catch(error => {
	            alertify.error(encodeHtml(error.message, 30000));
	        });

    }

    onResetSalt(data){        
        this.close();    
	    const formData = new FormData();
        formData.append("ids", data.id);
        formData.append("resetSalt", "true");
        formData.append("sendEmail","false");
    
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
}