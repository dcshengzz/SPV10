import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Breadcrumb, Button, Modal } from 'semantic-ui-react'
import JSON5 from 'json5'
import CloverAdminRolePermissions from './rolepermissions'
import BaseComponent from "./../basecomponent"

export default class CloverAdminRoleEdit extends BaseComponent {
    constructor(props) {
        super(props);

        this.state = {};
    }

    validate(){
        return this.props.parent.validate();
    }

    render(){
        this.validate();

        var data = this.props.data;
        if(data.permissions == undefined)
            data.permissions = [];

        var onSave = this.props.onSave.bind(this.props.parent);
        var onCancel = this.props.onCancel.bind(this.props.parent);

        return (<div className="clover-formadmin-formedit">
            <Breadcrumb>
                <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>{CloverAdminLang.role.title}</Breadcrumb.Section>
                <Breadcrumb.Divider />
                <Breadcrumb.Section active>{this.props.data.name}</Breadcrumb.Section>
            </Breadcrumb>
            <div className="cloveradmin-toolbar-editform">
                <Button className="buttontype1" onClick={onSave}>{CloverAdminLang.button.save}</Button>
                <Button className="buttontype2" onClick={onCancel}>{CloverAdminLang.button.cancel}</Button>
            </div>
            <h1>{this.props.parent.title}</h1>
            <Form>
                <Form.Input name="code" label={CloverAdminLang.field.code} error={Boolean(data.__error.code)} value={data.code} onChange={this.handleChange.bind(this, data)} />
                <Form.Input name="name" label={CloverAdminLang.field.name} error={Boolean(data.__error.name)} value={data.name} onChange={this.handleChange.bind(this, data)} />
                <h1>Permissions</h1>
                <CloverAdminRolePermissions 
                    items={this.props.metadata.permissions} 
                    value={data.permissions}
                    parent={this} />
            </Form>
        </div>);
    }

    handleChange(obj, e, {name, value, checked}){
        var originalValue = obj[name];

        if(value == undefined){
            obj[name] = checked;
        }
        else{
            obj[name] = value;
        }
        if(name == "code"){
            if(originalValue == obj.name || obj.name == undefined){
                obj.name = obj.code;
            }
        }

        this.setUpdatedState(this.props.data);
        this.forceUpdate();
    }
}