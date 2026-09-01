import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Breadcrumb, Button, Modal } from 'semantic-ui-react'
import JSON5 from 'json5'
import BaseComponent from './../basecomponent'

export default class CloverAdminGroupEdit extends BaseComponent {
    constructor(props) {
        super(props);

        this.state = {};
    }

    validate(){
        return this.props.parent.validate();
    }

    render(){
        this.validate();

        var roles = [];
        for(var i=0; i < this.props.metadata.roles.length; i++ ){
            var r = this.props.metadata.roles;
            roles.push({text: r[i].name, value: r[i].id});
        }

        var data = this.props.data == undefined ? [] : this.props.data;
       
        //<Form.Input name="domainGroup" label="DomainGroup" error={Boolean(data.__error.domanGroup)} value={data.domainGroup} onChange={this.handleChange.bind(this, data)} />
        
        return (<Form>
            <Form.Input name="name" label={CloverAdminLang.field.name} error={Boolean(data.__error.name)} value={data.name} onChange={this.handleChange.bind(this, data)} />
            <Form.Dropdown label={CloverAdminLang.group.rolesfield} name="roles" error={Boolean(data.__error.roles)} multiple search selection options={roles} value={data.roles == undefined ? [] : data.roles} onChange={this.handleChange.bind(this, data)} />
       </Form>
        );
    }

    handleChange(obj, e, {name, value, checked}){
        var originalValue = obj[name];

        if(value == undefined){
            obj[name] = checked;
        }
        else{
            obj[name] = value;
        }
        
        this.setUpdatedState(this.props.data);
        this.forceUpdate();
    }
}