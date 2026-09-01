import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Image, Breadcrumb, Button, Modal } from 'semantic-ui-react'
import JSON5 from 'json5'
import BaseComponent from './../basecomponent'
import CollectionEditor from './../../../swz-builder/src/control/collectioneditor'

export default class CloverAdminBusinessFlowEdit extends BaseComponent {
    constructor(props) {
        super(props);

        this.state = {
            statearray: []
        };

        var data = this.props.data;
        if(data != undefined && data.scheme != undefined && data.scheme != ""){
            this.updateStates(data.scheme);
        }
    }

    validate(){
        return this.props.parent.validate();
    }

    render(){
        this.validate();

        var data = this.props.data == undefined ? [] : this.props.data;
        if(data.map == undefined)
            data.map = [];

        var handleChange = this.handleChange.bind(this, data);

        var onSave = this.props.onSave.bind(this.props.parent);
        var onCancel = this.props.onCancel.bind(this.props.parent);

        var formarray = [];
        formarray.push({text: '...', value: ''});
        this.props.metadata.forms.forEach(function(entry){
            formarray.push({ text: entry.name, value: entry.name});
        });

        var rolearray = [];
        rolearray.push({ text: CloverAdminLang.businessflow.anyroleitem, value: "*"});
        this.props.metadata.roles.forEach(function(entry){
            rolearray.push({ text: entry.name, value: entry.code});
        });

        var workflowarray = [];
        this.props.metadata.workflow.forEach(function(entry){
            workflowarray.push({text: entry.code, value: entry.code});
        });

        var mappingcolumns = [
            {key: 'states', name: CloverAdminLang.businessflow.statescolumn, control: "dropdown", options: this.state.statearray, multiple: true},
            {key: 'roles', name: CloverAdminLang.businessflow.rolescolumn, control: "dropdown", options: rolearray, multiple: true},
            {key: 'form', name: CloverAdminLang.businessflow.formcolumn, control: "dropdown", options: formarray}
        ];


        return (<div className="clover-formadmin-formedit">
            <Breadcrumb>
                <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>{CloverAdminLang.businessflow.title}</Breadcrumb.Section>
                <Breadcrumb.Divider />
                <Breadcrumb.Section active>{data.name}</Breadcrumb.Section>
            </Breadcrumb>
            <div className="cloveradmin-toolbar-editform">
                <Button className="buttontype1" onClick={onSave}>{CloverAdminLang.button.save}</Button>
                <Button className="buttontype2" onClick={onCancel}>{CloverAdminLang.button.cancel}</Button>
            </div>
            <h1>{this.props.parent.title}</h1>
            <Form>
                <Form.Input name="name" label={CloverAdminLang.field.name} error={Boolean(data.__error.name)} value={data.name} onChange={handleChange} />
                <Form.Group widths="equal">
                    <Form.Dropdown name="scheme" label={CloverAdminLang.businessflow.schemecolumn} options={workflowarray} error={Boolean(data.__error.scheme)} value={data.scheme} onChange={handleChange} selection fluid search  />
                    <Form.Dropdown name="defaultForm" placeholder="..." search label={CloverAdminLang.businessflow.defaultformcolumn} error={Boolean(data.__error.defaultForm)} options={formarray} value={data.defaultForm} onChange={handleChange} selection fluid search />
                </Form.Group>
                <h2>{CloverAdminLang.businessflow.mappingfield}</h2>
                <CollectionEditor key="map"
                        columns={mappingcolumns} 
                        name="map" 
                        value={data.map}
                        onChange={handleChange}
                        error={data.__error.map} />
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
        if(name == "scheme"){
            this.updateStates(obj.scheme);
        }

        this.setUpdatedState(this.props.data);
        this.forceUpdate();
    }

    handleChildrenChange(obj, e, {name, value}){
        obj[name] = value;
        this.setUpdatedState(this.props.data);
        this.forceUpdate();
    }

    updateStates(scheme){
        var me = this;
        var data = new Array();

        data.push({ name: 'operation', value: 'workflow' });
        data.push({ name: 'suboperation', value: 'getstates' });
        data.push({ name: 'scheme', value: scheme });
        $.ajax({
            url: me.props.apiUrl,
            data: data,
            async: true,
            type: "post",
            success: function (response) {
                if(response.success){
                    if(!Array.isArray(response.item)){
                        alertify.error("Unknown format for getstates response!");
                    }
                    me.state.statearray = [
                        {text: CloverAdminLang.businessflow.anystateitem, value: "*"}
                    ];
                    response.item.forEach(function(s){
                        me.state.statearray.push({text: s, value: s});
                    });
                    me.forceUpdate();
                }
                else{
                    alertify.error(response.message);
                }
            }
        });
    }
}