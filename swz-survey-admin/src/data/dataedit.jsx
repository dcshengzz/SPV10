import React from "react";
import ReactDOM from "react-dom";
import JSON5 from 'json5'
import BaseComponent from "./../basecomponent"
import { Form, Input, Checkbox, Segment, Breadcrumb, Button, Modal, Image } from 'semantic-ui-react'
import Triggers from './trigger'

export default class CloverAdminDataEdit extends BaseComponent {
    constructor(props) {
        super(props);

        this.state = {
            showextensioncolumns: false
        }
    }

    validate(){
        return this.props.parent.validate();
    }

    render(){
        this.validate();

        var data = this.props.data;
        if(data.attributes == undefined)
            data.attributes = [];

        if(data.triggers == undefined)
            data.triggers = [];

        var entitylist = [];
        this.props.metadata.dataModel.forEach(function(m){
            entitylist.push({value: m.id, text: m.name});
        });

        var codeactions = [];
        this.props.metadata.codeActions.forEach(function(m){
            codeactions.push({value: m.name, text: m.name});
        });

        var tlist = [];
        this.props.metadata.additionalParams.Types.forEach(function(type){
            tlist.push({value: type, text: type});
        });
  
        var onSave = this.props.onSave.bind(this.props.parent);
        var onCancel = this.props.onCancel.bind(this.props.parent);

        return (<div className="clover-formadmin-formedit">
            <Breadcrumb>
                <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>{CloverAdminLang.data.title}</Breadcrumb.Section>
                <Breadcrumb.Divider />
                <Breadcrumb.Section active>{data.name}</Breadcrumb.Section>
            </Breadcrumb>
            <div className="cloveradmin-toolbar-editform">
                <Button className="buttontype1" onClick={onSave}>{CloverAdminLang.button.save}</Button>
                <Button className="buttontype2" onClick={onCancel}>{CloverAdminLang.button.cancel}</Button>
            </div>
            <h1>{this.props.parent.title}</h1>
            <Form>
                <Form.Group widths="equal">
                    <div className="field">
                        <Form.Input name="name" label={CloverAdminLang.field.name} error={Boolean(data.__error.name)} value={data.name} onChange={this.handleChange.bind(this, data)} />
                        <Form.Input name="dbObjectName" label={CloverAdminLang.data.dbobjectfield} error={Boolean(data.__error.dbObjectName)} value={data.dbObjectName} onChange={this.handleChange.bind(this, data)} />
                        <Form.Input name="schemaName" label={CloverAdminLang.data.schemenamefield} error={Boolean(data.__error.schemaName)} value={data.schemaName} onChange={this.handleChange.bind(this, data)} />
                    </div>
                    <div className="field">
                        <Form.Input name="primaryKeyAttribute" label={CloverAdminLang.data.primarykeyfield} placeholder="Id" error={Boolean(data.__error.primaryKeyAttribute)} value={data.primaryKeyAttribute} onChange={this.handleChange.bind(this, data)} />
                        <Form.Input name="extensionsContainerAttribute" label={CloverAdminLang.data.extensionscontainerfield} placeholder="Extensions" error={Boolean(data.__error.extensionsContainerAttribute)} value={data.extensionsContainerAttribute} onChange={this.handleChange.bind(this, data)} />
                        {/* <Form.Input name="logicalDeleteAttribute" placeholder="IsDeleted" error={Boolean(data.__error.logicalDeleteAttribute)} label={CloverAdminLang.data.isdeletedfield} value={data.logicalDeleteAttribute} onChange={this.handleChange.bind(this, data)} />
                        <Form.Input name="versionAttribute" placeholder="LockVersion" error={Boolean(data.__error.versionAttribute)} label={CloverAdminLang.data.lockversionfield} value={data.versionAttribute} onChange={this.handleChange.bind(this, data)} /> */}
                    </div>
                </Form.Group>
                {/* <h1>{CloverAdminLang.field.triggers}</h1>
                <div className="field" widths="16">
                    <Triggers data={data.triggers} types={[
                        "AfterSelect",
                        "BeforeInsert",
                        "AfterInsert",
                        "BeforeUpdate",
                        "AfterUpdate",
                        "BeforeDelete",
                        "AfterDelete"]}
                        codeactions={codeactions}
                        onChange={this.updateStateAndForce.bind(this)} />
                </div> */}
                <div>
                    <h1 className="clover-formadmin-dataedit-attributeheader">{CloverAdminLang.field.attributes}</h1> 
                    <Checkbox className="clover-formadmin-dataedit-attributeslider" slider checked={this.state.showextensioncolumns} onClick={this.onShowExtension.bind(this)} label={CloverAdminLang.data.showextensioncolumnsonly} />
                </div>
                <div className="field" widths="16">
                    {this.renderAttributes(data.attributes, entitylist, tlist)}
                </div>
            </Form>
        </div>);
    }

    renderAttributes(attributes, entitylist, typeList){
        var res = [];
        res.push(<a key="btnadd" onClick={this.onAddAttribute.bind(this, attributes)}>{CloverAdminLang.data.addattbutton}</a>);

        for(var i=0; i < attributes.length; i++){
            var data = attributes[i];
            
            if(this.state.showextensioncolumns === true && data.isExtension === false){
                continue;
            }

            var key = "att_" + data.id;
           
            var isRef = data.typeId == 1;
            var typecontrol;
            if(isRef){
                typecontrol = <Form.Dropdown key="type" 
                    name="referenceEntityId"  selection fluid search
                    label={CloverAdminLang.data.refentityfield} 
                    value={data.referenceEntityId} 
                    error={Boolean(data.__error.referenceEntityId)}
                    options={entitylist}
                    onChange={this.handleChange.bind(this, data)} />;
            }
            else{
                typecontrol = <Form.Dropdown key="type"
                    options={typeList}  selection fluid search
                    name="type" 
                    label={CloverAdminLang.data.datatypefield}
                    placeholder="Choose a data type" 
                    error={Boolean(data.__error.type)}
                    value={data.type} 
                    onChange={this.handleChange.bind(this, data)} />;
            }
            
            var griditem = (<Form.Group key={key} widths="equal" className="clover-formadmin-item">
                    <div key="c1" className="field">
                        <Form.Input key="name" name="name" label={CloverAdminLang.field.name} error={Boolean(data.__error.name)} value={data.name} onChange={this.handleChange.bind(this, data)} />            
                        <label key="c1label">{CloverAdminLang.data.optionsfield}</label>
                        <Form.Group widths="equal">
                            <Form.Checkbox name="isNullable" label={CloverAdminLang.data.nullablefield} error={Boolean(data.__error.isNullable)} checked={data.isNullable } onChange={this.handleChange.bind(this, data)} />
                            {/* <Form.Checkbox name="isVirtual" label={CloverAdminLang.data.virtualfield} error={Boolean(data.__error.isVirtual)} checked={data.isVirtual } onChange={this.handleChange.bind(this, data)} /> */}
                            <Form.Checkbox name="isCalculated" label={CloverAdminLang.data.calculatefield} error={Boolean(data.__error.isCalculated)} checked={data.isCalculated } onChange={this.handleChange.bind(this, data)} />
                            <Form.Checkbox name="isExtension" label={CloverAdminLang.data.extensionfield} error={Boolean(data.__error.isExtension)} checked={data.isExtension } onChange={this.handleChange.bind(this, data)} />
                        </Form.Group>
                    </div>
                    <div key="c2" className="field">
                        <label key="c2label">{CloverAdminLang.field.type}</label>
                        <Form.Group key="c2g">
                            <Form.Radio key="typeColumn" name={key + "_typeId"} error={Boolean(data.__error.typeId)} label={CloverAdminLang.data.columnfield} value={0} checked={isRef === false} onChange={this.handleChangeTypeId.bind(this, data)} />
                            <Form.Radio key="typeRef" name={key + "_typeId"} error={Boolean(data.__error.typeId)} label={CloverAdminLang.data.reffield} value={1} checked={isRef} onChange={this.handleChangeTypeId.bind(this, data)} />
                        </Form.Group>
                        {typecontrol}
                    </div>
                    <Image className="clover-buttonimage" key="btndelete" src="/images/clover-delete.png" onClick={this.onDeleteAttribute.bind(this, attributes, data.id)} />
                </Form.Group>);
            res.push(griditem);
        }

        if(attributes.length == 0)
            res.push(<div className="clover-formadmin-info" key="message">
                {CloverAdminLang.data.noattributesmsg}<br/>
                {CloverAdminLang.msg.click} <a key="btnadd2" onClick={this.onAddAttribute.bind(this, attributes)}>{CloverAdminLang.msg.here}</a> {CloverAdminLang.data.forcreatetingmsg}</div>);
        
        return res;
    }

    handleChangeTypeId(obj, e, {name, value}){
        this.handleChange(obj, e, {name: "typeId", value});    
    }

    handleChange(obj, e, {name, value, checked}){
        var originalValue = obj[name];

        if(value == undefined){
            obj[name] = checked;

            if(name == "isCalculated" && checked){
                obj["isExtension"] = false;
            }
            else if(name == "isExtension" && checked){
                obj["isCalculated"] = false;
            }
        }
        else{
            obj[name] = value;
        }
        
        this.updateStateAndForce();
    }

    onAddAttribute(attributes){
        var newatt = {
            id: this.NewGUID(), 
            type: "String",
            typeId: 0, 
            isExtension: this.state.showextensioncolumns
        };
        attributes.unshift(newatt);
        this.updateStateAndForce();
    }

    onDeleteAttribute(attributes, id){
        var index = undefined;
        for(var i=0; i < attributes.length; i++){
          if(attributes[i].id == id){
            index = i;
            break;
          }
        }
    
        if(index != undefined){
          attributes.splice(index, 1);
        }

        this.updateStateAndForce();
    }

    updateStateAndForce(){
        this.setUpdatedState(this.props.data);
        this.forceUpdate();
    }

    onShowExtension(){
        this.setState({
            showextensioncolumns: !this.state.showextensioncolumns
        });
    }
}