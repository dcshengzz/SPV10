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
        var p = { processid: this.props.data.id, readonly: true};
        if (this.wfdesigner.exists(p))
            this.wfdesigner.load(p);
        else{
            alertify.error("The process '" + p.processid + "' is not found!");
        }

        this.state.id = this.props.data.id;
    }

    render(){
        var me = this;
        if(this.wfdesigner != undefined && this.state.id != this.props.data.id)
            this.loadscheme();

        var showsetstate = () => {me.setState({opensetstate: true});};
        var hidesetstate = () => {me.setState({opensetstate: false, newstateerror: undefined, newstate: undefined});};
        var showsetstatus = () => {me.setState({opensetstatus: true});};
        var hidesetstatus = () => {me.setState({opensetstatus: false});};
        
        var messageopen = this.state.message != undefined;        
        return (<div>
            <Breadcrumb>
                <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>{CloverAdminLang.workflowinstance.title}</Breadcrumb.Section>
                <Breadcrumb.Divider />
                <Breadcrumb.Section active>{this.props.data.id} ({this.getInstanceStatus(this.props.data.instanceStatus)})</Breadcrumb.Section>
                <Breadcrumb.Divider icon='right angle' />
                <Breadcrumb.Section href={"?apanel=workflow&aid=" + this.state.id} onClick={this.openScheme.bind(this)} link>{this.props.data.schemeCode}</Breadcrumb.Section>
            </Breadcrumb>
            <div className="clover-admin-wfdesigner-buttons">
                <Button className="buttontype1" onClick={showsetstate}>{CloverAdminLang.workflowinstance.setstatebutton}</Button>
                <Button className="buttontype2" onClick={showsetstatus}>{CloverAdminLang.workflowinstance.setinstancestatusbutton}</Button>
            </div>
            <div id="clover-admin-wfdesigner"/>
            <Modal dimmer={'blurring'} 
                open={this.state.opensetstate} >
                <Modal.Header>{CloverAdminLang.workflowinstance.setstatebutton}</Modal.Header>
                <Modal.Content>
                  <Input label={CloverAdminLang.workflowinstance.statefield} fluid={true} name="newstate" 
                  value={this.state.newstate} 
                  error={Boolean(this.state.newstateerror)}
                  onChange={this.handleStateChange.bind(this)} />
                </Modal.Content>
                <Modal.Actions>
                    <Button className="buttontype1" content={CloverAdminLang.workflowinstance.setstatebutton} onClick={this.onSetState.bind(this)} />
                    <Button className="buttontype2" content={CloverAdminLang.button.cancel} onClick={hidesetstate} />
                </Modal.Actions>
            </Modal>
            <Modal dimmer={'blurring'} 
                open={this.state.opensetstatus} >
                <Modal.Header>{CloverAdminLang.workflowinstance.setinstancestatusbutton}</Modal.Header>
                <Modal.Content>
                   <Button content="Initialized" onClick={this.onSetInstanceStatus.bind(this, 0)} />
                   <Button content="Running" onClick={this.onSetInstanceStatus.bind(this, 1)} />
                   <Button content="Idled" onClick={this.onSetInstanceStatus.bind(this, 2)} />
                   <Button content="Finalized" onClick={this.onSetInstanceStatus.bind(this, 3)} />
                </Modal.Content>
                <Modal.Actions>
                    <Button className="buttontype2" content={CloverAdminLang.button.cancel} onClick={hidesetstatus} />
                </Modal.Actions>
            </Modal>
        </div>);
    }

    handleStateChange(e, {name, value}){
        this.state[name] = value;
        this.forceUpdate();
      }

    openScheme(e){
        this.props.parent.props.parent.openpage("workflow", this.props.data.schemeCode);
        e.preventDefault();
    }

    onSetState(){
        const newstate = this.state.newstate;
        if(newstate == undefined || newstate == ""){
            this.state.newstateerror = "error";
            this.forceUpdate();
            return;
        }
        else{
            this.state.newstateerror = undefined;
        }

        const me = this;
        const data = new Array();

        data.push({ name: 'operation', value: 'workflow' });
        data.push({ name: 'suboperation', value: 'setstate' });
        data.push({ name: 'processId', value: me.props.data.id });
        data.push({ name: 'state', value: newstate });
        $.ajax({
            url: me.props.apiUrl,
            data: data,
            async: true,
            type: "post",
            success: function (response) {
                me.setState({opensetstate: false, newstateerror: undefined, newstate: undefined});
                if(response.success){
                    alertify.success(CloverAdminLang.workflowinstance.statechangedmsg);
                    me.props.parent.reload();
                    me.wfdesigner.refresh();
                }
                else{
                    alertify.error(response.message);
                }
            }
        });
    }

    onSetInstanceStatus(status){
        const me = this;
        const data = new Array();

        data.push({ name: 'operation', value: 'workflow' });
        data.push({ name: 'suboperation', value: 'setinstancestatus' });
        data.push({ name: 'processId', value: me.props.data.id });
        data.push({ name: 'status', value: status });
        $.ajax({
            url: me.props.apiUrl,
            data: data,
            async: true,
            type: "post",
            success: function (response) {
                me.setState({opensetstatus: false});
                if(response.success){
                    alertify.success(CloverAdminLang.workflowinstance.instancestatuschangedmsg);
                    me.props.parent.reload();
                }
                else{
                    alertify.error(response.message);
                }
            }
        });
    }

    getInstanceStatus(status){
        if(status === undefined)
            return "";

        if(status == 255) return "NotFound";
        if(status == 254) return "Unknown";
        if(status == 0) return "Initialized";
        if(status == 1) return "Running";
        if(status == 2) return "Idled";
        if(status == 3) return "Finalized";
        if(status == 4) return "Terminated";
        if(status == 5) return "Error";
        return status;
    }
}