import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Breadcrumb, Button, Modal } from 'semantic-ui-react'
import CloverFormBuilder from "./../../../swz-survey-builder/src/builder";
import JSON5 from 'json5'
import BaseComponent from './../basecomponent'
import { encodeHtml } from './../utils.jsx'

export default class CloverAdminFormEdit extends BaseComponent {
    constructor(props) {
        super(props);
        this.state = {
          //dropzoneactive: true
          onLoading: true
        };
    }

    componentDidMount() {
        this.loadform();
        window.addEventListener("beforeunload", this.onUnload);
    }

    onUnload = (e) => { // the method that will be used for both add and remove event
        e.preventDefault();
        e.returnValue = true;
    }

    componentWillUnmount() {
        window.removeEventListener("beforeunload", this.onUnload);
    }

    loadform(){
        this.setState({onLoading: true});
        var me = this;
        var webExists = false;
      	var otherExists = false;
        me.state.id = me.props.data.name;
        
         /*Swz*/
        this.props.metadata.webForms.forEach(function(webItem){
            if(webItem.name.toLowerCase() == me.props.data.name.toLowerCase()) webExists = true;
        });
        this.props.metadata.formsOtherStructDivisions.forEach(function(item){
            if(item.name.toLowerCase() == me.props.data.name.toLowerCase()) otherExists = true;
        });
        if(webExists || otherExists){
            this.setState({onLoading: false});
            alertify.error("Form name is not valid");
            this.props.parent.props.parent.openpage("forms");
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
                me.setState({onLoading: false});
                if(response.success){
                    var source = JSON.parse(response.item.source);
                    if(me.builder != undefined)
                        me.builder.loadData(source);
                    me.forceUpdate();
                }
                else{
                    alertify.error(encodeHtml(response.message));
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
                alertify.error(encodeHtml(msg));
            }
        }
        else{
            alertify.error(encodeHtml(res.message));
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
        const { onLoading } = this.state;
        if(this.state.id != this.props.data.name)
            this.loadform();
            
            var containerClass = "clover-admin-formbuilder-container";

            let testQuery = "&control=Weather&condtype=visible";

        return (<div>
            <div>
                <div className="clover-admin-formheader-breadcrumb">
                    <Breadcrumb>
                        <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>Form logic</Breadcrumb.Section>
                        <Breadcrumb.Divider />
                        <Breadcrumb.Section active>{this.props.data.name}</Breadcrumb.Section>
                        <Breadcrumb.Divider icon='right angle'/>
                        <Breadcrumb.Section href={"?apanel=forms&aid=" + this.state.id} onClick={this.openForms.bind(this)}>Forms</Breadcrumb.Section>
                        <Breadcrumb.Divider />
                        <Breadcrumb.Section href={"?apanel=formstyle&aid=" + this.state.id} onClick={this.openFormStyle.bind(this)}>Form style</Breadcrumb.Section>
                      {/*     <Breadcrumb.Divider icon='right angle'/>
                      <Breadcrumb.Section href={"?apanel=formlogic&aid=" + this.state.id + testQuery} onClick={this.openFormLogicControl.bind(this)}>URL</Breadcrumb.Section> */}
                    </Breadcrumb>
                </div>
            </div>
            <div className="clover-admin-formheader-parameters">
                   <span>&nbsp;&nbsp;</span>
            </div>
            <div id="formbuildercontainer" className={containerClass}>
                <div>
                    <div className="clover-admin-form-buttons">
                   {    <Button className="buttontype1" onClick={this.onSaveCond.bind(this)}>{CloverAdminLang.button.save}</Button>   }
                        <Button className="buttontype2" onClick={this.props.parent.back.bind(this.props.parent)}>Cancel</Button>
                        <Button className="buttontype2" onClick={this.loadNewForm.bind(this)}>Clear logic</Button>            
                        <Button className="buttontype2" onClick={this.onAddConditionGroup.bind(this)}>Create group</Button>
                        <div style={{display: 'inline', float: 'right'}} >
                            {/*Add buttons*/}
                        </div>
                    </div>
                    {!onLoading ? 
                    <CloverFormBuilder 
                        getFormFunc={this.getForm.bind(this)}
                        getFormList={this.getFormList.bind(this)}
                        getAdditionalDataForControl={this.getAdditionalDataForControl.bind(this)}
                        ref={(builder) => { this.builder = builder; }}
                        localization={window.CloverAdminLang.formbuilder} 
                        templates={undefined}
                        onFormLogic={true}
                        openFormLogicControl={this.openFormLogicControl.bind(this)}
                        onSave={this.onSave.bind(this)}
                         /> : <div className="loader-container"></div> }
 
                </div>
            </div>
        </div>);
    }
    
    onAddConditionGroup(){
        this.builder.onAddConditionGroup();
    }
    
    onSaveCond(){
        this.builder.onSaveCond();
    }

    loadNewForm(){
        this.builder.loadNewForm();
    }

    openFormLogicControl(condProps){   
        
        var condProps = {
            control: condProps.control, 
            type: condProps.type
        }
        
        this.props.parent.props.parent.openpage("formlogic", this.state.id, null, condProps);
        //e.preventDefault();
    }
 
    openForms(e){
        this.props.parent.props.parent.openpage("forms", this.state.id);
        e.preventDefault();
    }

    openFormStyle(e){
        this.props.parent.props.parent.openpage("formstyle", this.state.id);
        e.preventDefault();
    }

    onSave(){
        /*Swz*/
        var prevState = this.builder.swzBefSaveShowAll();
        var me = this;
        this.props.data.source = JSON.stringify(this.builder.getData());
        me.setUpdatedState(this.props.data);
        this.props.data.IsSurvey = true;
        this.props.data.DataUrl = this.props.parent.props.parent.props.surveyApi;
        this.props.data.DataSourceType = "url";
        this.props.data.__type = this.props.parent.datatype;
        this.props.data.structDivisionId = this.props.data.structDivisionId;
        this.ChangeData([this.props.data], function(response){
            var state = me.props.data.__state;
            me.ResetSystemProps(me.props.data);
            me.props.parent.applyeditrow();
        });
       /*Swz*/
        this.builder.loadPrevState(prevState);
    }
}