import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Breadcrumb, Button, Modal, Icon, Header } from 'semantic-ui-react'
import CloverFormBuilder from "./../../../swz-survey-builder/src/builder";
import PrintActions from "./../../../swz-survey-builder/src/print";
import JSON5 from 'json5'
import BaseComponent from './../basecomponent'
import { encodeHtml } from './../utils.jsx'

export default class CloverAdminFormEdit extends BaseComponent {
    constructor(props) {
        super(props);
        this.state = {
            dropzoneactive: true,
            onLoading: true,
            openFunction: false,
            openMerge: false,
            onFixedHeader: false,
            switchStatus: false
        };
    }

    componentDidMount() {
        this.loadform();
        var me = this;
        window.addEventListener("scroll", function() {
            var elementTarget = document.getElementById("formbuttons");
            if (window.scrollY > (elementTarget && elementTarget.offsetTop ? elementTarget.offsetTop:0 + elementTarget && elementTarget.offsetHeight ? elementTarget.offsetHeight:0)) {
               me.toggleFixedHeader(true);
            }else{
                me.toggleFixedHeader(false);
            }
          });
        
          window.addEventListener("beforeunload", this.onUnload);
    }

    toggleFixedHeader = (bool) => {
        const { onFixedHeader } = this.state;

        if(onFixedHeader !== bool)
            this.setState({onFixedHeader: bool})
    }

    loadTemplate = (templates, onCombineTemplates, key) => {
        
        if(!(templates && templates.length > 0)) 
            return alert("No templates selected");

        var me = this;
        var data = new Array();
        data.push({ name: 'operation', value: 'loadforms' });
        data.push({ name: 'names', value: templates }); 
         $.ajax({
            url: me.props.apiUrl,
            data: data,
            async: true,
            type: "post",
            success: function (response) {
                if(response.success){
                    var sources = [];
                    for(var i in response.item){
                        sources.push(JSON.parse(response.item[i].source)); 
                    }
                        me.builder.addItems(sources, onCombineTemplates, key);                                
                }
                else{
                    alertify.error(encodeHtml(response.message));
                }
            }
        }); 
    }

    loadTemplateBlock = (templates, templatesblock, isContentOnly, key) => {
        
        if(!(templates && templates.length > 0)) 
            return alert("No templates selected");
        
        if(!(templatesblock && templatesblock.length > 0)) 
            return alert("No templates block selected");

        var me = this;
        var data = new Array();
        data.push({ name: 'operation', value: 'loadforms' });
        data.push({ name: 'names', value: templates }); 
         $.ajax({
            url: me.props.apiUrl,
            data: data,
            async: true,
            type: "post",
            success: function (response) {
                if(response.success){
                    var sources = [];
                    for(var i in response.item){
                        sources.push(JSON.parse(response.item[i].source)); 
                    }
                        me.builder.addTemplateBlock(sources, isContentOnly, key, templatesblock);                                
                }
                else{
                    alertify.error(encodeHtml(response.message));
                }
            }
        }); 
    }

    loadform(){
        this.setState({onLoading: true});

        var me = this;
        var isExists = false;
        var webExists = false;
	    var otherExists = false;
        me.state.id = me.props.data.name;
        this.props.metadata.forms.forEach(function(item){
            if(item.name == me.props.data.name) isExists = true;
        });

         /*Swz*/
        this.props.metadata.webForms.forEach(function(webItem){
            if(webItem.name.toLowerCase() == me.props.data.name.toLowerCase()) webExists = true;
        });
        this.props.metadata.formsOtherStructDivisions.forEach(function(item){
            if(item.name.toLowerCase() == me.props.data.name.toLowerCase()) otherExists = true;
        });
        if(webExists || otherExists){
            alertify.error("Form name is not valid");
            this.props.parent.props.parent.openpage("forms");

            return;
        }
        /*Swz*/
        if(!isExists){
            this.setState({onLoading: false});
            this.props.data.__state = "inserted";
            this.props.data.isTemplate = this.props.parent.filter.isTemplate ?? false;
            this.props.data.isArchived = this.props.parent.filter.isArchived ?? false;
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

    getRuleList(){
        return this.props.metadata.rules;
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

    getTemplateBlock(blockItem, templateBlockArr){
        if(String(blockItem['data-buildertype']) === 'block' && blockItem.templateBlock === true ){
            templateBlockArr.push(blockItem.key);
        }
        if(blockItem.children !== undefined && blockItem.children.length > 0){
            const self = this;
            blockItem.children.filter(function(e) {return e['data-buildertype']==='block'}).forEach(function(childBlockItem){
                self.getTemplateBlock(childBlockItem, templateBlockArr);
            });
        }
    }

    getTemplateBlockList(form){
        const templateBlockArr = [];
        const self = this;
        form.forEach(function(swzPageItem){
            swzPageItem.children.filter(function(e) {return e['data-buildertype']==='block'}).forEach(function(blockItem){
                self.getTemplateBlock(blockItem, templateBlockArr);
            });
        });
        return templateBlockArr;
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

    showFunctionModal = () => {
        if(this.state.openFunction == false){
          this.setState({ openFunction: true});
        }
        
        if(!this.props.isDirty)
            this.props.isDirtyToggle();
    }

    closeModal = () => {
        this.setState({openMerge: false});
        this.setState({openFunction: false});
    }

    headerContent = (para) => {
        var dimmer = para.dimmer;
        var standardIconCss = para.standardIconCss;
        var spanSelectorStyle = para.spanSelectorStyle;
        var openFunction = para.openFunction;
        var standardFontCss = para.standardFontCss;

        return (
            <React.Fragment>
                <Button className="buttontype1" onClick={this.onSave.bind(this)}>{CloverAdminLang.button.save}</Button>  
                <Button className="buttontype2" onClick={() => this.props.showConfirm(() => this.props.parent.back(this.props.parent))}>Cancel</Button>
                <Button className="buttontype2" onClick={this.onFullscreen.bind(this)}>{CloverAdminLang.form.fullscreenbutton}</Button>
                <Button className="buttontype2" onClick={() => this.showFunctionModal()}>More</Button>
                <Modal closeOnDimmerClick={false} dimmer={dimmer} open={openFunction} onClose={() => this.closeModal()} size={"small"} >
                    <Header content='More' />
                    <Modal.Content>
                        <div>
                            <Form>
                            <Form.Group widths="equal">
                            <div className="clover-formbuilder-item-toolbar-header-buttons-table" >
                                <div className="clover-formbuilder-item-toolbar-header-title">
                                {this.props.text}
                            </div>
                                <div onClick={() => {this.onClearForm(), this.closeModal()}} title="Clear Form" style={standardFontCss}><img style={standardIconCss} src="/images/cloverbuilder-delete.svg" height="16px" />Clear Form</div>
                                <div onClick={() => {this.closeModal(), this.onClearLogic('required')}} title="Clear Required" style={standardFontCss}><img style={standardIconCss} src="/images/cloverbuilder-delete.svg" height="16px" />Clear Required</div>
                                <div onClick={() => {this.closeModal(), this.onClearLogic('validation')}} title="Clear Validations" style={standardFontCss}><img style={standardIconCss} src="/images/cloverbuilder-delete.svg" height="16px" />Clear Validations</div>
                                <div onClick={() => {this.closeModal(), this.onClearLogic('visible')}} title="Clear Visible Conditions" style={standardFontCss}><img style={standardIconCss} src="/images/cloverbuilder-delete.svg" height="16px" />Clear Visible Conditions</div>
                                <div onClick={() => {this.closeModal(), this.onClearLogic('readonly')}} title="Clear ReadOnly Conditions" style={standardFontCss}><img style={standardIconCss} src="/images/cloverbuilder-delete.svg" height="16px" />Clear ReadOnly Conditions</div>
                                <div onClick={() => {this.closeModal(), this.onClearLogic('skip')}} title="Clear Skip Conditions" style={standardFontCss}><img style={standardIconCss} src="/images/cloverbuilder-delete.svg" height="16px" />Clear Skip Conditions</div>
                                <div onClick={() => {this.closeModal(), this.onHighlight('onHighlightR')}} title="Highlight Required" style={standardFontCss}><img style={standardIconCss} src="/images/cloverbuilder-edit.svg" height="16px" />Highlight Required</div>
                                <div onClick={() => {this.closeModal(), this.onHighlight('onHighlightV')}} title="Highlight Validations" style={standardFontCss}><img style={standardIconCss} src="/images/cloverbuilder-edit.svg" height="16px" />Highlight Validations</div>
                                <div onClick={() => {this.closeModal(), this.onHighlight('onHighlightC')}} title="Highlight Visible Conditions" style={standardFontCss}><img style={standardIconCss} src="/images/cloverbuilder-edit.svg" height="16px" />Highlight Visible Conditions</div>
                                <div onClick={() => {this.closeModal(), this.onHighlight('onHighlightRd')}} title="Highlight ReadOnly Conditions" style={standardFontCss}><img style={standardIconCss} src="/images/cloverbuilder-edit.svg" height="16px" />Highlight ReadOnly Conditions</div>
                                <div onClick={() => {this.closeModal(), this.onHighlight('onHighlightS')}} title="Highlight Skip Conditions" style={standardFontCss}><img style={standardIconCss} src="/images/cloverbuilder-edit.svg" height="16px" />Highlight Skip Conditions</div>
                                <div onClick={() => {this.closeModal(), this.onSwitch('required', true)}} title="Switch On Required" style={standardFontCss}><img style={{'margin-right': '5px'}} src="/images/wfe.parameters.png" height="16px" />Switch On Required</div>
                                <div onClick={() => {this.closeModal(), this.onSwitch('required', false)}} title="Switch Off Required" style={standardFontCss}><img style={{'margin-right': '5px'}} src="/images/wfe.parameters.png" height="16px" />Switch Off Required</div>
                                <div onClick={() => {this.closeModal(), this.onSwitch('focus', true)}} title="Switch On Focus Next Control Upon Selection" style={standardFontCss}><img style={{'margin-right': '5px'}} src="/images/wfe.parameters.png" height="16px" />Switch On Focus Next Control Upon Selection</div>
                                <div onClick={() => {this.closeModal(), this.onSwitch('focus', false)}} title="Switch Off Focus Next Control Upon Selection" style={standardFontCss}><img style={{'margin-right': '5px'}} src="/images/wfe.parameters.png" height="16px" />Switch Off Focus Next Control Upon Selection</div>
                            </div>
                            </Form.Group>
                            </Form>
                        </div>
                    </Modal.Content>
                    <Modal.Actions>
                        <Button className="buttontype2" onClick={() => this.closeModal()}>Cancel</Button>   
                    </Modal.Actions>
                </Modal>
                         <div style={{float: 'right'}} >
                            {this.state.dropzoneactive ? (     
                                    <div className="clover-formbuilder-selector">
                                        <span className={spanSelectorStyle}>Page Controls</span>
                                        <Checkbox toggle name="cbShowDropzones" label="Builder Controls" checked={!this.state.onNavigatebar} onChange={this.toggleNavigate.bind(this)}/>
                                    </div>
                            ): null }
                                {/* <div className="clover-formbuilder-selector">
                                    <span className={spanSelectorStyle}>{CloverAdminLang.form.preview}</span>
                                    <Checkbox toggle name="cbShowDropzones" label={CloverAdminLang.form.builder} checked={this.state.dropzoneactive} onChange={this.handleShowDropzonesClick.bind(this)}/>
                                </div> */}
                                <Button className="buttontype2" onClick={() => this.onPreview()}>Preview</Button>   
                                <Button className="buttontype2" onClick={this.onDownload.bind(this)}>Export</Button>     
                                <Button className="buttontype2" onClick={this.onUpload.bind(this)}>Import</Button> 
                        </div>
            </React.Fragment>
        );
    }

    render(){
        if(this.state.id != this.props.data.name)
            this.loadform();

        const { onLoading, openFunction, dimmer, onFixedHeader } = this.state;
  
        //TODO Get Actions from maplogic
        var actions = this.props.parent.props.controlActions;
        if(actions == undefined){
            actions = [];
        }

        var standardIconCss = {
            opacity: 0.8,
            'margin-right': '5px'
        }

        var standardFontCss = {           
            cursor:'pointer',
            fontSize: '16px',
            color: '#2E2E2E',
            'margin-bottom': '15px'
        }

        var workflowarray = [];
        this.props.metadata.workflow.forEach(function(item){
            workflowarray.push({text: item.code, value: item.code});
        });

        var messageopen = this.state.message != undefined;
        var spanSelectorStyle = this.state.dropzoneactive ? "" : "clover-formbuilder-selector-preview";

        var para = {
            dimmer,
            standardIconCss,
            spanSelectorStyle,
            openFunction,
            standardFontCss
        }

        var containerClass = this.state.isFullScreen ?
        "clover-admin-formbuilder-container-fullscreen":
        //"clover-admin-form-container-fullscreen":
        "clover-admin-formbuilder-container";
        return (
        <div>
            <div>
                <div className="clover-admin-formheader-breadcrumb">
                    <Breadcrumb>
                    <Breadcrumb.Section onClick={() => this.props.showConfirm(() => this.props.parent.back(this.props.parent))} link>{CloverAdminLang.form.title}</Breadcrumb.Section>
                        <Breadcrumb.Divider />
                        <Breadcrumb.Section active>{this.props.data.name}{this.props.isDirty && "*" } </Breadcrumb.Section>
                        <Breadcrumb.Divider icon='right angle'/>
                        <Breadcrumb.Section  href={"?apanel=formlogic&aid=" + this.state.id} onClick={() => this.props.showConfirm(() => this.openFormLogic(this) )}>Form logic
                        </Breadcrumb.Section>
                        <Breadcrumb.Divider />
                        <Breadcrumb.Section  href={"?apanel=formstyle&aid=" + this.state.id} onClick={() => this.props.showConfirm(() => this.openFormStyle(this) )}>Form style
                        </Breadcrumb.Section>
                        {/* <Breadcrumb.Section href={"?apanel=formdata&aid=" + this.state.id} onClick={this.openDataMap.bind(this)}>{CloverAdminLang.form.datamap}
                        </Breadcrumb.Section> 
                        <Breadcrumb.Divider />*/}
                        {/* <Breadcrumb.Section href={"?apanel=actionhandlers&aid=" + this.state.id} onClick={this.openActionHandlers.bind(this)}> */}{/*CloverAdminLang.form.actionhandler*/}{/* Validation</Breadcrumb.Section>
                   */     }
                    </Breadcrumb>
                </div>
                <div className="clover-admin-formheader-parameters">
               {/*    <span>&nbsp;&nbsp;</span> */}
               <Checkbox name="isTemplate" label={CloverAdminLang.form.template} checked={this.props.data.isTemplate} onChange={this.handleChange.bind(this)} />
               <Checkbox name="isArchived" style={{ marginLeft: '20px'}} label={CloverAdminLang.form.archived} checked={this.props.data.isArchived} onChange={this.handleChange.bind(this)} />
               </div>
            </div>
            <div id="formbuildercontainer" className={containerClass}>
                <div id="formbuttons" className="clover-admin-form-buttons">
                    {this.headerContent(para)}
                </div>
                {<div className={onFixedHeader ? "clover-admin-form-buttons-fixed-active" : "clover-admin-form-buttons-fixed-inactive"}>
                    <div className="clover-admin-form-buttons-group">
                    {this.headerContent(para)}
                    </div>
                </div>
                }
                <div>
                    <form action="" id="cloveradmin-form-uploadform" method="post" style={{display:"none"}} encType="multipart/form-data" onSubmit={this.onEmpty.bind(this)}>
                        <input type="file" name="cloveradmin-form-uploadfile" id="cloveradmin-form-uploadfile" onChange={this.onUpload_onchange.bind(this)} />
                    </form>
                    {!onLoading ? 
                    <CloverFormBuilder 
                        downloadUrl="/download.html?file=" 
                        uploadUrl="/upload.html?file="
                        onNavigatebar={this.state.onNavigatebar}
                        actions={actions} 
                        getFormFunc={this.getForm.bind(this)}
                        getFormList={this.getFormList.bind(this)}
                        getAdditionalDataForControl={this.getAdditionalDataForControl.bind(this)}
                        ref={(builder) => { this.builder = builder; }}
                        localization={window.CloverAdminLang.formbuilder}
                        isDirty={this.props.isDirty}
                        isDirtyToggle={this.props.isDirtyToggle}
                        templates={this.getTemplateList()} 
                        ruleApi={this.props.parent.props.parent.props.ruleApi}
                        cssStyleApi={this.props.parent.props.parent.props.cssStyleApi}
                        loadTemplate={this.loadTemplate.bind(this)}
                        loadTemplateBlock={this.loadTemplateBlock.bind(this)}
                        getTemplateBlockList = {this.getTemplateBlockList.bind(this)}
                        openFormLogicControl={this.openFormLogicControl.bind(this)}/> : <div className="loader-container"></div> /*<Icon loading name='spinner' /> */ }
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
                </div>
            </div>
        </div>);
    }
  
    
    openFormLogic = (e) => {
        this.props.parent.props.parent.openpage("formlogic", this.state.id);
        //e.preventDefault();
    }

    openFormStyle = (e) => {
        this.props.parent.props.parent.openpage("formstyle", this.state.id);
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
        this.builder.handleEmpty(true);
    }

    onClearLogic(type){
        this.builder.handleClearLogic(type);
    }

    onHighlight(type){
        var elements = document.getElementsByName(type);
        if(elements && elements.length > 0){           
            var onHighlight = !elements[0].className ? 'clover-formbuilder-item-toolbar-header-title-highlight' : '';
            for(let i = 0; i <= elements.length; i++){
                if(elements[i])
                    elements[i].className = onHighlight;
            }
        }
    }

    onSwitch(type, switchStatus){
        if(type == "focus"){
            this.builder.handleSwitchType(switchStatus, type);
        }else if(type == "required")
            this.builder.handleSwitchType(switchStatus, type);
    }
    onSave() {
        /*Swz*/
        var prevState = this.builder.swzBefSaveShowAll();
        var me = this;
        var currentData = this.builder.getData();
        this.props.data.source = JSON.stringify(currentData);
        var proceedWithSave = function () {
            me.setUpdatedState(me.props.data);
            me.props.data.IsSurvey = true;
            me.props.data.DataUrl = me.props.parent.props.parent.props.surveyApi;
            me.props.data.DataSourceType = "url";
            me.props.data.__type = me.props.parent.datatype;
            me.props.data.structDivisionId = me.props.data.structDivisionId;
            me.ChangeData([me.props.data], function (response) {
                var state = me.props.data.__state;
                me.ResetSystemProps(me.props.data);
                me.props.parent.applyeditrow();
                me.props.isDirtyToggleOff();
            });
        };

        PrintActions.printForm(currentData, {}, null, 'formbuildercontainer').then(function (htmlStringPDF) {
            if (htmlStringPDF) {
                htmlStringPDF = htmlStringPDF.replace(/nextmodels=["'][^"']*["']/g, '');
            }
            me.props.data.HtmlContent = htmlStringPDF;

            var dwMetadata = [{
                filename: me.props.data.name + "-pdftemplate.html",
                source: htmlStringPDF
            }];
            me.props.data.dwMetadata = JSON.stringify(dwMetadata);
            proceedWithSave();
        }).catch(function (error) {
            console.error("Error generating HTML form content:", error);
            proceedWithSave();
        });

        /*Swz*/
        this.builder.loadPrevState(prevState);
    }

    openFormLogicControl(e, condProps){   
        
      //Skip,ReadOnly,Visible,Validation,
      if(condProps == undefined)
        return alert("Could not find component, please save before moving forward");

        var condProps = {
            control: condProps.control, 
            type: condProps.type
        }
        this.props.parent.props.parent.openpage("formlogic", this.state.id, null, condProps);
        e.preventDefault();
    }

    onPreview = () => {
        var me = this;
        var onPreviewUrl = function (){
            if(me.state.id){
                var url = window.location.origin + '/form/' + me.state.id + '/preview';
                var win = window.open(url, '_blank');
                win.focus();
            }
        }
        
        if(this.props.isDirty){
            this.props.showConfirm(onPreviewUrl, true);
        }else{
            onPreviewUrl();
        }

        
    }

    onDownload(){
        this.builder.download(this.props.data.name+".json");
    }

    onUpload(){
        var file = $('#cloveradmin-form-uploadfile');
        file.trigger('click');
    }

    onUpload_onchange(){
        var me = this;
        this.builder.upload($('#cloveradmin-form-uploadfile')[0]);//, function () {alertify.success(CloverAdminLang.msg.fileupoaded);});
        
        if(!this.props.isDirty)
            this.props.isDirtyToggle();
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
        if(!this.state.onNavigatebar){
            this.setState({onNavigatebar: true})
        }
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

    toggleNavigate = () => {
        if(this.state.onNavigatebar == true){
          this.setState({onNavigatebar: false}) 
        }
        else{
          this.setState({onNavigatebar: true}) 
        }
    }
}