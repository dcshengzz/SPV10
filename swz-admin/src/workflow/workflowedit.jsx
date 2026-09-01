import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Breadcrumb, Button, Modal } from 'semantic-ui-react'
import JSON5 from 'json5'
import BaseComponent from './../basecomponent'

export default class CloverAdminWorkflowEdit extends BaseComponent {
    constructor(props) {
        super(props);

        this.state = {};
    }

    componentDidMount() {
        window.addEventListener("resize", this.redrawDesigner.bind(this));
        this.redrawDesigner();
    }

    componentWillUnmount(){
        if(this.wfdesigner != undefined)
            this.wfdesigner.destroy();
    }

    redrawDesigner(){
        if(this.props.parent.props.id == undefined)
            return;
        
        var w = $(window).width();
        var h = $(window).height();
        WorkflowDesignerConstants.FormMaxHeight = 600;

        var data;
        if (this.wfdesigner != undefined) {
            data = this.wfdesigner.data;
            this.wfdesigner.destroy();
        }
        
        this.wfdesigner = new WorkflowDesigner({
            name: 'clover-admin-wfdesigner',
            apiurl: this.props.workflowApi,
            renderTo: 'clover-admin-wfdesigner',
            imagefolder: '/images/',
            graphwidth: w - 285 - this.props.deltaWidth,
            graphheight: h - 185 - this.props.deltaHeight
        });
       
        if (data == undefined) {
            this.loadscheme();
        }
        else {
            this.wfdesigner.data = data;
            this.wfdesigner.render();
        }
    }

    loadscheme(){
        var p = { schemecode: this.props.data.code, processid: undefined};
        if (this.wfdesigner.exists(p))
            this.wfdesigner.load(p);
        else{
            this.wfdesigner.create();
            this.props.data.__state = "inserted";
        }

        this.state.id = this.props.data.code;
    }

    onClearScheme(){
        this.wfdesigner.create();
    }

    onSave(){
        var me = this;
        me.wfdesigner.schemecode = me.props.data.code;
        var err = this.wfdesigner.validate();
        if (err != undefined && err.length > 0) {
            alertify.error(err);
        }
        else {
            this.wfdesigner.save(function () {
                var state = me.props.data.__state;
                me.ResetSystemProps(me.props.data);
                me.props.parent.applyeditrow();
                alertify.success(CloverAdminLang.workflow.schemesaved);
            });
        }
    }

    onDownload(){
        this.wfdesigner.downloadscheme();
    }

    onUpload(){
        var file = $('#cloveradmin-workflow-uploadfile');
        file.trigger('click');
    }

    onUpload_onchange(){
        var me = this;
        this.wfdesigner.uploadscheme($('#cloveradmin-workflow-uploadform')[0], function () {
            alertify.success(CloverAdminLang.msg.fileupoaded);
        });
    }

    messageClose(){
        this.setState({
            message: undefined
        });
    }

    render(){
        if(this.wfdesigner != undefined && this.state.id != this.props.data.code)
            this.loadscheme();

        var messageopen = this.state.message != undefined;        
        return (<div>
            <Breadcrumb>
                <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>{CloverAdminLang.workflow.title}</Breadcrumb.Section>
                <Breadcrumb.Divider />
                <Breadcrumb.Section active>{this.props.data.code}</Breadcrumb.Section>
            </Breadcrumb>
            <div className="clover-admin-wfdesigner-buttons">
                <Button className="buttontype2" floated='right' onClick={this.onClearScheme.bind(this)}>{CloverAdminLang.workflow.clearschemebutton}</Button>
                <Button className="buttontype1" onClick={this.onSave.bind(this)}>{CloverAdminLang.button.save}</Button>  
                <Button className="buttontype2" onClick={this.onDownload.bind(this)}>{CloverAdminLang.button.download}</Button>  
                <Button className="buttontype2" onClick={this.onUpload.bind(this)}>{CloverAdminLang.button.upload}</Button>   
            </div>
            <div id="clover-admin-wfdesigner"/>
            <form is action="" id="cloveradmin-workflow-uploadform" method="post" style={{display:"none"}} enctype="multipart/form-data" onsubmit="tmp()">
                <input type="file" name="cloveradmin-workflow-uploadfile" id="cloveradmin-workflow-uploadfile" onChange={this.onUpload_onchange.bind(this)} />
            </form>
            <Modal
                dimmer={'blurring'}
                open={messageopen}
                onClose={this.messageClose.bind(this)}>
                <Modal.Header>{CloverAdminLang.workflow.messagetitle}</Modal.Header>
                <Modal.Content>
                    <p>{this.state.message}</p>
                </Modal.Content>
                <Modal.Actions>
                    <Button icon='check' content={CloverAdminLang.button.ok} onClick={this.messageClose.bind(this)} />
                </Modal.Actions>
            </Modal> 
        </div>);
    }
}