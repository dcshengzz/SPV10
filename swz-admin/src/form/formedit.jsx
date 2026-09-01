import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Breadcrumb, Button, Modal } from 'semantic-ui-react'
import CloverFormBuilder from "./../../../swz-builder/src/builder";
import JSON5 from 'json5'
import BaseComponent from './../basecomponent'

export default class CloverAdminFormEdit extends BaseComponent {
    constructor(props) {
        super(props);

        this.state = {
            dropzoneactive: true
        };
    }

    componentDidMount() {
        this.loadform();
    }

    loadform(){
        var me = this;
        var isExists = false;
        me.state.id = me.props.data.name;
        this.props.metadata.forms.forEach(function(item){
            if(item.name == me.props.data.name) isExists = true;
        });

        if(!isExists){
            this.props.data.__state = "inserted";
            if(me.builder != undefined)
                me.builder.create();
            return;
        }
        
        var data = new Array();
        data.push({ name: 'operation', value: 'loadform' });
        data.push({ name: 'name', value: me.props.data.name });
        $.ajax({
            url: me.props.apiUrl,
            data: data,
            async: true,
            type: "post",
            success: function (response) {
                if(response.success){
                    var source = JSON.parse(response.item.source);
                    if(me.builder != undefined)
                        me.builder.loadData(source);
                    me.forceUpdate();
                }
                else{
                    alertify.error(response.message);
                }
            }
        });
    }

    messageClose(){
        this.setState({
            message: undefined
        });
    }

    getForm(name){
        var me = this;
        Pace.start();
        var data = new Array();
        data.push({ name: 'operation', value: 'loadform' });
        data.push({ name: 'name', value: name });
        var res = $.ajax({
            url: me.props.apiUrl,
            data: data,
            async: false,
            type: "post"}).responseJSON;
        Pace.stop();

        var formsource = undefined;
        if(res.success){
            if(res.item != undefined && res.item.source != undefined){
                formsource = JSON5.parse(res.item.source);
            }
            else{
                var msg = "FormBuilder: Incorrect source of '"  + name + "' form!"
                alertify.error(msg);
            }
        }
        else{
            alertify.error(res.message);
        }
        
        return formsource;
    }

    getFormList(){
        var list = [];
        this.props.metadata.forms.forEach(function(item){
            list.push(item.name);
        });
        return list;
    }

    getTemplateList(){
        let me = this;
        let list = [];
        this.props.metadata.forms.forEach(function(item){
            if(item.isTemplate && item.name !== me.props.data.name)
                list.push(item.name);
        });
        return list;
    }

    getAdditionalDataForControl(control,
        {startIndex, pageSize, filters, sort, model},
        callback)
    {
    
        var me = this;
        if(control.props["data-buildertype"] == "dictionary"){
            var items = [];
            var prefix = model == undefined ? "item": model;
            for(var i = 0 ; i < 3; i++){
                var obj = {};
                obj.key = model + "_" + i;
                obj.text = model + "_" + i;
                obj.value = i;
                items.push(obj);
            }
            callback({items});
        }
        else{
          var rowsCount = 5;
          var items = [];
          for(var i = 0 ; i < pageSize; i++){
            var obj = {};
            control.props.columns.forEach(function(c){
              obj[c.key] = c.key + "_" + (Number(startIndex) + Number(i));
            });
            items.push(obj);
          }
          callback({startIndex, pageSize, rowsCount, items});
        }
    }

    render(){
        if(this.state.id != this.props.data.name)
            this.loadform();

        //TODO Get Actions from maplogic
        var actions = this.props.parent.props.controlActions;
        if(actions == undefined){
            actions = [];
        }
        
        var workflowarray = [];
        this.props.metadata.workflow.forEach(function(item){
            workflowarray.push({text: item.code, value: item.code});
        });

        var messageopen = this.state.message != undefined;
        var spanSelectorStyle = this.state.dropzoneactive ? "" : "clover-formbuilder-selector-preview";
        var workflowopenfunc = () => { this.setState({ workflowopen: true }); };
        var workflowclosefunc = () => { this.setState({ workflowopen: false }); };

        var securityopenfunc = () => { this.setState({ securityopen: true }); };
        var securityclosefunc = () => { this.setState({ securityopen: false }); };

        var containerClass = this.state.isFullScreen ?
        "clover-admin-formbuilder-container-fullscreen":
        "clover-admin-formbuilder-container";
         

        return (<div>
            <div>
                <div className="clover-admin-formheader-breadcrumb">
                    <Breadcrumb>
                        <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>{CloverAdminLang.form.title}</Breadcrumb.Section>
                        <Breadcrumb.Divider />
                        <Breadcrumb.Section active>{this.props.data.name}</Breadcrumb.Section>
                        <Breadcrumb.Divider icon='right angle' />
                        <Breadcrumb.Section href={"?apanel=formdata&aid=" + this.state.id} onClick={this.openDataMap.bind(this)}>{CloverAdminLang.form.datamap}</Breadcrumb.Section>
                        <Breadcrumb.Divider />
                        <Breadcrumb.Section href={"?apanel=actionhandlers&aid=" + this.state.id} onClick={this.openActionHandlers.bind(this)}>{CloverAdminLang.form.actionhandler}</Breadcrumb.Section>
                    </Breadcrumb>
                </div>
                <div className="clover-admin-formheader-parameters">
                    <Checkbox name="isTemplate" label={CloverAdminLang.form.template} checked={this.props.data.isTemplate} onChange={this.handleChange.bind(this)} />
                </div>
            </div>
            <div id="formbuildercontainer" className={containerClass}>
                <div>
                    <div className="clover-admin-form-buttons">
                        <Button className="buttontype1" onClick={this.onSave.bind(this)}>{CloverAdminLang.button.save}</Button>  
                        <Button className="buttontype2" onClick={this.onDownload.bind(this)}>{CloverAdminLang.button.download}</Button>  
                        <Button className="buttontype2" onClick={this.onUpload.bind(this)}>{CloverAdminLang.button.upload}</Button> 
                        <Button className="buttontype2" onClick={workflowopenfunc}>{CloverAdminLang.button.workflow}</Button> 
                        <Button className="buttontype2" onClick={securityopenfunc}>{CloverAdminLang.button.security}</Button> 
                        <div style={{display: 'inline', float: 'right'}} >
                            <div className="clover-formbuilder-selector">
                                <span className={spanSelectorStyle}>{CloverAdminLang.form.preview}</span>
                                <Checkbox toggle name="cbShowDropzones" label={CloverAdminLang.form.builder} checked={this.state.dropzoneactive} onChange={this.handleShowDropzonesClick.bind(this)}/>
                            </div>
                            <Button className="buttontype2" onClick={this.onFullscreen.bind(this)}>{CloverAdminLang.form.fullscreenbutton}</Button>
                            <Button className="buttontype2" onClick={this.onClearForm.bind(this)}>{CloverAdminLang.form.clearformbutton}</Button>
                        </div>
                    </div>
                    <form action="" id="cloveradmin-form-uploadform" method="post" style={{display:"none"}} encType="multipart/form-data" onSubmit={this.onEmpty.bind(this)}>
                        <input type="file" name="cloveradmin-form-uploadfile" id="cloveradmin-form-uploadfile" onChange={this.onUpload_onchange.bind(this)} />
                    </form>
                    <CloverFormBuilder 
                        actions={actions} 
                        getFormFunc={this.getForm.bind(this)}
                        getFormList={this.getFormList.bind(this)}
                        getAdditionalDataForControl={this.getAdditionalDataForControl.bind(this)}
                        ref={(builder) => { this.builder = builder; }}
                        localization={window.CloverAdminLang.formbuilder} 
                        templates={this.getTemplateList()} />
                    <Modal closeOnDimmerClick={false}
                        dimmer={'blurring'}
                        open={messageopen}
                        onClose={this.messageClose.bind(this)}>
                        <Modal.Header>{CloverAdminLang.form.messagetitle}</Modal.Header>
                        <Modal.Content>
                            <p>{this.state.message}</p>
                        </Modal.Content>
                        <Modal.Actions>
                            <Button icon='check' content={CloverAdminLang.button.ok} onClick={this.messageClose.bind(this)} />
                        </Modal.Actions>
                    </Modal>
                    <Modal closeOnDimmerClick={false}
                        dimmer={'blurring'}
                        open={this.state.workflowopen}
                        onClose={workflowclosefunc}>
                        <Modal.Header>{CloverAdminLang.form.workflowwindowtitle}</Modal.Header>
                        <Modal.Content>
                            <p>{CloverAdminLang.form.workflowinfoblock}</p>
                            <Form.Dropdown label={CloverAdminLang.form.workflowschemesfield} name="schemes" multiple search selection options={workflowarray} value={this.props.data.schemes == undefined ? [] : this.props.data.schemes} onChange={this.handleChange.bind(this)} />
                        </Modal.Content>
                        <Modal.Actions>
                            <Button className="buttontype1" content={CloverAdminLang.button.apply} onClick={workflowclosefunc} />
                        </Modal.Actions>
                    </Modal>
                    <Modal closeOnDimmerClick={false}
                        dimmer={'blurring'}
                        open={this.state.securityopen}
                        onClose={securityclosefunc}>
                        <Modal.Header>{CloverAdminLang.form.securitywindowtitle}</Modal.Header>
                        <Modal.Content>
                            <p>{CloverAdminLang.form.securityinfoblock}</p>
                            <Form.Input label={CloverAdminLang.form.permissionsgroupfield} name="securityGroup" value={this.props.data.securityGroup} onChange={this.handleChange.bind(this)} />
                        </Modal.Content>
                        <Modal.Actions>
                            <Button className="buttontype1" content={CloverAdminLang.button.apply} onClick={securityclosefunc} />
                        </Modal.Actions>
                    </Modal>
                </div>
            </div>
        </div>);
    }

    openDataMap(e){
        this.props.parent.props.parent.openpage("formdata", this.state.id);
        e.preventDefault();
    }

    openActionHandlers(e){
        this.props.parent.props.parent.openpage("actionhandlers", this.state.id);
        e.preventDefault();
    }

    onClearForm(){
        this.builder.create();
    }

    onSave(){
        var me = this;
        this.props.data.source = JSON.stringify(this.builder.getData());
        me.setUpdatedState(this.props.data);
        this.props.data.__type = this.props.parent.datatype;

        this.ChangeData([this.props.data], function(response){
            var state = me.props.data.__state;
            me.ResetSystemProps(me.props.data);
            me.props.parent.applyeditrow();
        });
    }

    onDownload(){
        this.builder.download();
    }

    onUpload(){
        var file = $('#cloveradmin-form-uploadfile');
        file.trigger('click');
    }

    onUpload_onchange(){
        var me = this;
        this.builder.upload($('#cloveradmin-form-uploadfile')[0], function () {
            alertify.success(CloverAdminLang.msg.fileupoaded);
        });
    }

    onFullscreen(){
        this.setState({
            isFullScreen: !Boolean(this.state.isFullScreen)
        })
    }

    handleShowDropzonesClick(e, {name, checked}){
        this.builder.setBuilderMode(checked);
        this.setState({
            dropzoneactive: checked
        });
    }

    handleChange(e, {name, value, checked}){
        if(checked !== undefined){
            this.props.data[name] = checked;
        }
        else{
            this.props.data[name] = value;
        }
        this.forceUpdate();
    }

    onEmpty(){
        
    }
}