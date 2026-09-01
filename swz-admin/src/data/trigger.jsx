import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./../basecomponent"
import { Form, Input, Dropdown, Message, Image} from 'semantic-ui-react'
import JSON5 from 'json5'

export default class Triggers extends BaseComponent {
    constructor(props) {
        super(props);

    }

    render(){
        var data = this.props.data;
        var types = [];
        this.props.types.forEach(function(t){
            types.push({value: t, text: t});
        })

        var content = [];
        for(var i=0; i < data.length; i++){
            var item = data[i];
            var __error = item.__error == undefined ? {} : item.__error;
            
            var key = "trigger_" + i;
            
            var griditem = (<Form.Group key={key} widths="equal" className="clover-formadmin-item">
                    <Form.Dropdown label={CloverAdminLang.field.triggers} error={Boolean(__error.triggers)} name="triggers" options={types} 
                            multiple selection fluid search value={item.triggers} onChange={this.handleChange.bind(this, item)} />
                    <Form.Dropdown key="codeaction" label={CloverAdminLang.field.action} name="codeAction" selection fluid search options={this.props.codeactions} 
                        value={item.codeAction} onChange={this.handleChange.bind(this, item)} error={Boolean(__error.codeAction)} />
                    <Form.Input key="parameter" name="parameter" label={CloverAdminLang.field.parameter} value={item.parameter} onChange={this.handleChange.bind(this, item)}/>
                    <Image className="clover-buttonimage" key="btndelete" src="/images/clover-delete.png" onClick={this.onDelete.bind(this, i)} />
                </Form.Group>);
            content.push(griditem);
        }

        if(content.length == 0)
            content.push(<div className="clover-formadmin-info" key="message">
                {CloverAdminLang.data.notriggersmsg}<br/>
                {CloverAdminLang.msg.click} <a key="btnadd2" onClick={this.onAdd.bind(this)}>{CloverAdminLang.msg.here}</a> {CloverAdminLang.data.forcreatetingtriggersmsg}</div>);
               
        return <div><a key="btnadd" onClick={this.onAdd.bind(this)}>{CloverAdminLang.data.addtrigger}</a>
            {content}</div>;
    }

    handleChange(obj, e, {name, value, checked}){
        
        if(value == undefined){
            obj[name] = checked;
        }
        else{
            obj[name] = value;
        }

        if(this.props.onChange != undefined){
            this.props.onChange(undefined, {name: this.props.name, value: this.props.data});
        }

        this.forceUpdate();
    }

    onAdd(){
        var data = this.props.data;
        data.push({});

        if(this.props.onChange != undefined){
            this.props.onChange(undefined, {name: this.props.name, value: this.props.data});
        }

        this.forceUpdate();
    }

    onDelete(index){
        var data = this.props.data;
        data.splice(index, 1);

        if(this.props.onChange != undefined){
            this.props.onChange(undefined, {name: this.props.name, value: this.props.data});
        }

        this.forceUpdate();
    }
}