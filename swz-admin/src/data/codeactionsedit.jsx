import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Breadcrumb, Button, Modal, TextArea } from 'semantic-ui-react'
import JSON5 from 'json5'
import BaseComponent from "./../basecomponent"

export default class CloverAdminCodeActionsEdit extends BaseComponent {
    constructor(props) {
        super(props);

        this.state = {};

        if(props.data.__state == "inserted" && props.data.type == undefined){
            props.data.type = 0;
            props.data.usings = this.getDefaultUsings();
            props.data.source = this.getDefaultCodeByType(props.data.type, props.data.isAsync);
        }
    }

    validate(){
        return this.props.parent.validate();
    }

    componentDidMount() {
        this.redrawEditor();
    }

    redrawEditor(){
        var data = this.props.data == undefined ? [] : this.props.data;
        var w = $(window).width();
        var h = $(window).height();

        var editor = ace.edit("clover-admin-codeactions-editcode");
        editor.getSession().setMode("ace/mode/csharp");
        if(data.source != undefined)
            editor.setValue(data.source, -1);
    }

    render(){
        this.validate();
        var data = this.props.data;
        return (<div className="cloveradmin-toolbar-editform">
            <Breadcrumb>
                <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>{CloverAdminLang.codeaction.title}</Breadcrumb.Section>
                <Breadcrumb.Divider />
                <Breadcrumb.Section active>{data.name}</Breadcrumb.Section>
            </Breadcrumb>
            <div className="cloveradmin-toolbar-editform">
                <Button className="buttontype2" onClick={this.onCompile.bind(this)}>{CloverAdminLang.button.compile}</Button>
                <Button className="buttontype1" onClick={this.onSave.bind(this)}>{CloverAdminLang.button.save}</Button>
                <Button className="buttontype2" onClick={this.onCancel.bind(this)}>{CloverAdminLang.button.cancel}</Button>
            </div>
            <h1>{this.props.parent.title}</h1>
            <Form>
                <Form.Group widths="equal">
                    <Form.Input name="name" label={CloverAdminLang.field.name} error={Boolean(data.__error.name)} value={data.name} onChange={this.handleChange.bind(this, data)} />
                    <div className="field">
                        <label>{CloverAdminLang.field.type}</label>
                        <Form.Group widths="equal">
                            <Form.Radio name="type" label='Filter' value={0} checked={data.type === 0} onChange={this.handleChange.bind(this, data)} />
                            {/*<Form.Radio name="type" label='Action' value={1} checked={data.type === 1} onChange={this.handleChange.bind(this, data)} />*/}
                            <Form.Radio name="type" label='Trigger' value={2} checked={data.type === 2} onChange={this.handleChange.bind(this, data)} />
                            <Form.Checkbox name="isAsync" label='IsAsync' checked={data.isAsync} onChange={this.handleChange.bind(this, data)} />
                        </Form.Group>
                    </div>
                </Form.Group>
                <Form.Group widths="equal">
                    <Form.TextArea rows={6} name="usings" label={CloverAdminLang.codeaction.usingsfield} value={data.usings} onChange={this.handleChange.bind(this, data)} />
                    <Form.TextArea rows={6} name="comment" label={CloverAdminLang.field.comment} value={data.comment} onChange={this.handleChange.bind(this, data)} />
                </Form.Group>
            </Form>
            <span>{this.getDefine(data.name, data.type, data.isAsync)}</span>
            <div id="clover-admin-codeactions-editcode" style={{height:"415px"}} />
            {this.state.message != undefined && <TextArea className="clover-admin-codeactions-result" readOnly={true} value={this.state.message}/>}
        </div>);
    }

    onSave(){
        var editor = ace.edit("clover-admin-codeactions-editcode");
        var value = editor.getValue();
        var item = this.props.data;
        item.source = value;
        this.setUpdatedState(item);

        this.props.onSave.bind(this.props.parent)();
    }

    onCancel(){
        this.props.onCancel.bind(this.props.parent)();
        this.redrawEditor();
    }

    handleChange(obj, e, {name, value, checked}){
        var originalValue = obj[name];

        if(value == undefined){
            obj[name] = checked;
        }
        else{
            obj[name] = value;
        }

        if(name == "type"){
            var defaultSource = this.getDefaultCodeByType(value);
            var editor = ace.edit("clover-admin-codeactions-editcode");
            editor.setValue(defaultSource, -1);
        }

        this.setUpdatedState(this.props.data);
        this.forceUpdate();
    }

    onCompile(){
        var me = this;
        var editor = ace.edit("clover-admin-codeactions-editcode");
        var value = editor.getValue();
        this.props.data.source = value;

        var data = new Array();
        data.push({ name: 'operation', value: 'compile' });
        data.push({ name: 'item', value: JSON5.stringify(this.props.data) });
        $.ajax({
            url: me.props.apiUrl,
            data: data,
            async: true,
            type: "post",
            success: function (response) {
                if(response.success){
                    alertify.success(CloverAdminLang.msg.compileok);
                    me.setState({message: undefined});
                }
                else{
                    alertify.error(response.message);
                    me.setState({message: response.message});
                }
            }
        });
    }

    getDefaultUsings(){
        return "System;\nSystem.Collections;\nSystem.Collections.Generic;\nSystem.Linq;\nSystem.Threading;\nSystem.Threading.Tasks;\nswz.Workflow;\nswz.Workflow.Core.Runtime;\nswz.Workflow.Core.Model;\nswz.Clover.Core;\nswz.Clover.Core.Model;";
    }

    getDefaultCodeByType(type, isAsync){
        var source = "";
        if(type == 0){ //Filter
            source = "//TODO: Replace the emplty filter to your filter;\nreturn Filter.Empty;";
        }
        else if(type == 1){//Action
            source = "//TODO: Call your actons;\nreturn null;";
        }
        else if(type ==2){//Trigger
            source = "//TODO: Check your trigger;\nreturn (string.Empty,false);";
        }

        return source;
    }

    getDefine(name, type, isAsync){
        var prefix = "";
        var postfix = "";
        if(name == undefined)
            name = "____"

        if(type == 0){ //Filter
            if(isAsync){
                prefix = "public static async Task<Filter>";
            }
            else{
                prefix = "public static Filter";
            }
            postfix = "(EntityModel model, List<dynamic> entities, dynamic options)";
        }
        else if(type == 1){//Action
            if(isAsync){
                prefix = "public static async Task<dynamic>";
            }
            else{
                prefix = "public static dynamic";
            }
            postfix = "(dynamic request)";
        }
        else if(type ==2){//Trigger
            if(isAsync){
                prefix = "public static async Task<(string Message, bool IsCancelled)>";
            }
            else{
                prefix = "public static (string Message, bool IsCancelled)";
            }
            postfix = "(EntityModel model, List<dynamic> entities, dynamic options)";
        }

        return <span className="clover-admin-codeactions-define">
            {prefix} <span className="clover-admin-codeactions-definefunctionname">{name}</span>{postfix}
            </span>;
    }
}