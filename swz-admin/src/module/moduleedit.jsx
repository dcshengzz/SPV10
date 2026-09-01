import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./../basecomponent"
import { Form, Input, Checkbox, Segment, Breadcrumb, Button } from 'semantic-ui-react'

export default class ModuleEdit extends BaseComponent {
    constructor(props) {
        super(props);

        this.state = {};
    }

    validate(){
        return this.props.parent.validate();
    }

    render(){
        this.validate();
        var forms = this.props.metadata.forms;
        var formlist = [];
        if(forms != undefined){
            for(var i=0; i < forms.length; i++){
            var form = forms[i];
            formlist.push({text: form.code, value: form.code });
            }
        }

        var entities = this.props.metadata.dataModel;
        var entitylist = [];
        if(entities != undefined){
            for(var i=0; i < entities.length; i++){
            var entity = entities[i];
            entitylist.push({text: entity.name, value: entity.id });
            }
        }

        var codeactions = this.props.metadata.codeActions;
        var calist = [];
        if(codeactions != undefined){
            for(var i=0; i < codeactions.length; i++){
            var ca = codeactions[i];
            calist.push({text: ca.name, value: ca.id });
            }
        }
        var schemes = this.props.metadata.workflow;
        var schemelist = [];
        if(schemes != undefined){
            for(var i=0; i < schemes.length; i++){
            var s = schemes[i];
            schemelist.push({text: s.code, value: s.code });
            }
        }

        var businessflows = this.props.metadata.businessFlow;
        var bflist = [];
        if(businessflows != undefined){
            for(var i=0; i < businessflows.length; i++){
            var s = businessflows[i];
            bflist.push({text: s.name, value: s.id });
            }
        }

        var roles = this.props.metadata.roles;
        var rolelist = [];
        if(roles != undefined){
            for(var i=0; i < roles.length; i++){
            var s = roles[i];
            rolelist.push({text: s.name, value: s.id });
            }
        }
        
        var data = this.props.data == undefined ? [] : this.props.data;
        this.correctData(data);
        var onSave = this.props.onSave.bind(this.props.parent);
        var onCancel = this.props.onCancel.bind(this.props.parent);

        return (<div className="clover-formadmin-formedit">
            <Breadcrumb>
                <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>Modules</Breadcrumb.Section>
                <Breadcrumb.Divider />
                <Breadcrumb.Section active>{data.name}</Breadcrumb.Section>
            </Breadcrumb>
            <div className="cloveradmin-toolbar-editform">
                <Button className="buttontype1" onClick={onSave}>{CloverAdminLang.button.save}</Button>
                <Button className="buttontype2" onClick={onCancel}>{CloverAdminLang.button.cancel}</Button>
            </div>
            <h1>{this.props.parent.title}</h1>
            <Form>
                <Form.Input name="name" label={CloverAdminLang.field.name} error={Boolean(data.__error.name)} value={data.name} onChange={this.handleChange.bind(this, data)} />
                <Form.TextArea autoHeight name="commnet" label="Comment" error={Boolean(data.__error.comment)} onChange={this.handleChange.bind(this, data)} />
                {/* <h1>Parameters</h1>
                <a onClick={this.onAddParameter.bind(this, data.parameters)}>Add parameter</a>
                {this.renderParams(data.parameters)} */}
                <h1>Objects</h1>
                 <Form.Group widths="equal">
                    <Form.Dropdown label="Roles" error={Boolean(data.__error.roles)} name="roles" search options={rolelist} 
                            multiple value={data.roles} onChange={this.handleChange.bind(this, data)} />    
                    <Form.Dropdown label="Business flow" error={Boolean(data.__error.businessFlows)} name="businessFlows" search options={bflist} 
                    multiple value={data.businessFlows} onChange={this.handleChange.bind(this, data)} />
                </Form.Group>
                <Form.Group widths="equal">
                    <Form.Dropdown label="Forms" name="forms" error={Boolean(data.__error.forms)} search options={formlist} 
                        multiple value={data.forms} onChange={this.handleChange.bind(this, data)} />
                    <Form.Dropdown label="Worflow schemes" error={Boolean(data.__error.schemes)} name="schemes" search options={schemelist} 
                    multiple value={data.schemes} onChange={this.handleChange.bind(this, data)} />
                </Form.Group>
                <Form.Group widths="equal">
                    <Form.Dropdown label="Entities" error={Boolean(data.__error.entities)} name="entities" search options={entitylist} 
                        multiple value={data.entities} onChange={this.handleChange.bind(this, data)} />
                    <Form.Dropdown label="CodeActions" error={Boolean(data.__error.codeActions)} name="codeActions" search options={calist} 
                            multiple value={data.codeActions} onChange={this.handleChange.bind(this, data)} />
                      
                </Form.Group>
            </Form>
        </div>);
    }

    correctData(data){
        if(data.roles == undefined)
            data.roles = [];

        if(data.businessFlows == undefined)
            data.businessFlows = [];

        if(data.forms == undefined)
            data.forms = [];

        if(data.schemes == undefined)
            data.schemes = [];

        if(data.entities == undefined)
            data.entities = [];

        if(data.codeActions == undefined)
            data.codeActions = [];
    }

    // renderParams(params){
    //     var res = [];
    //     if(params != undefined){
    //         for(var p in params){
    //             res.push(<Form.Group key={p + "_group"} widths="equal">
    //                 <Form.Input key="name" name="name" label={CloverAdminLang.field.name} value={p} readOnly={true} />
    //                 <Form.Input key="value" name={p} label="Value" value={params[p]} onChange={this.handleChange.bind(this, params)}  />
    //                 <Image className="clover-buttonimage" key="btndelete" src="/images/clover-delete.png" onClick={this.onDeleteParameter.bind(this, params, params.name)} />
    //             </Form.Group>);
    //         };
    //     }

    //     return res;
    // }

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