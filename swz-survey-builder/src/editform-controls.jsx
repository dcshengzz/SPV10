import React from 'react';
import {Menu, Form, Breadcrumb, Grid, Card, Input, Dropdown, Checkbox, TextArea, Button, Icon, Message, Image, Label, Header, Item, Segment, Modal} from 'semantic-ui-react'
import CollectionEditor from './control/collectioneditor'
import JSON5 from 'json5'
import EventsEditor from './control/eventseditor'
import RadioGroup from './control/radiogroup'
import { EditorState, convertToRaw , convertFromRaw, ContentState} from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import draftToHtml from 'draftjs-to-html';
import htmlToDraft from 'html-to-draftjs';
import Upload from './control/upload';
import {RulesModal} from './control/rulesModal';
import {CssStyleModal} from './control/CssStyleModal'

//------Edit Form-------------------
class BaseEditControl extends React.Component {
   constructor(props) {
    super(props);

    this.state = {
      activeItem: 'general'
    };

    this.menuItems = [
        {key:'general', name:'general', content: this.getLocalValue('generaltab', 'General'),  active: true, onClick: this.handleItemClick.bind(this)},
        {key:'style', name:'style', content: this.getLocalValue('styletab', 'Style'), active: false, onClick: this.handleItemClick.bind(this)},
        {key:'events', name:'events', content: this.getLocalValue('eventstab', 'Events'),  active: false, onClick: this.handleItemClick.bind(this)},
        {key:'other', name:'other', content: this.getLocalValue('othertab', 'Other'), active: false, onClick: this.handleItemClick.bind(this)}
    ];
  }

  getLocalValue(key, defaultvalue, formname){
    var local = this.props.localization;
    var block = formname != undefined ? formname : "base";

    if(local == undefined || local[block] == undefined ||  local[block][key] == undefined) {
     
      return defaultvalue;
    }
      
    return local[block][key];
  }

  handleItemClick(e, { name }){
    this.setState({ activeItem: name }); 
  }
  
  getDescription(){
    
    var activeItem = this.state.activeItem
    this.menuItems.forEach(function(item){
        item.active = item.name === activeItem;
    })

    return (<Modal.Description>
              <Menu key="descriptionMenu" pointing secondary items={this.menuItems}/>
              {this.getDetailDescription(activeItem)}
            </Modal.Description>);
  }

  getDetailDescription(activeItem){
    var segment;

    if(activeItem === 'general')
      segment = this.getGeneralDescription();
    else if(activeItem === 'style')
       segment = this.getStyleDescription();
    else if(activeItem === 'events')
       segment = this.getEventsDescription();
    else if(activeItem === 'other')
       segment = this.getOtherDescription();

    return segment;
  }

  getGeneralDescription(){
    var data = this.props.data;  
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    return (<Form key="generalDescriptionForm">
        <Form.Input key="name" label="Name" name="key" value={data.key} onChange={handleChange} />
        <Form.Input name="parentcontrols" style={{display: 'none'}} value={data.parentcontrols} onChange={handleChange} />
      </Form>);
  }

  

  getStyleDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var stylesource_ps = "/*** Example Code ***/\ncolor:red;\npaddingTop:5px;";

    var applyCssStyleToStyleSource = function(cssStyle){
      data["style-source"] = cssStyle;
      this.forceUpdate();
    }

    return (<Form key="styleDescriptionForm">
        <Form.Group widths="equal" >
          <Form.Input name="style-width" label={this.getLocalValue('widthfield', 'Width')} placeholder="100px" value={data["style-width"]} onChange={handleChange} />
          <Form.Input name="style-height" label={this.getLocalValue('heightfield', 'Height')} placeholder="100px" value={data["style-height"]} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <Form.Input name="style-marginTop" label={this.getLocalValue('margintopfield', 'Margin Top')} placeholder="0px" value={data["style-marginTop"]} onChange={handleChange} />
          <Form.Input name="style-marginBottom" label={this.getLocalValue('marginbottomfield', 'Margin Bottom')} placeholder="0px" value={data["style-marginBottom"]} onChange={handleChange} />
          <Form.Input name="style-marginLeft" label={this.getLocalValue('marginleftfield', 'Margin Left')} placeholder="0px" value={data["style-marginLeft"]} onChange={handleChange} />
          <Form.Input name="style-marginRight" label={this.getLocalValue('marginrightfield', 'Margin Right')} placeholder="0px" value={data["style-marginRight"]} onChange={handleChange} />
        </Form.Group>
        <Form.Input name="style-customcss" label={this.getLocalValue('customcssclassfield', 'Custom CSS class')} placeholder="clover-application-css (without '.')" value={data["style-customcss"]} onChange={handleChange} />
        <Form.TextArea name="style-source" label={this.getLocalValue('stylefield', 'Style')} placeholder={stylesource_ps} value={data["style-source"]} onChange={handleChange} />

        <CssStyleModal 
            styleApi ={this.props.cssStyleApi}  
            localization={CloverAdminLang.formbuilder.editforms.styleModal} 
            applyActionHandler={applyCssStyleToStyleSource.bind(this)} />

        <Form.Checkbox name="style-hidden" label={this.getLocalValue('hiddenfield', 'Hidden')} checked={data["style-hidden"]} onChange={handleChange} />
      </Form>);
  }

  getEventsList(){
    return [];
  }

  getEventsDescription(){
    var me = this;
    var data = this.props.data; 
    if(data.events == undefined)
      data.events = {};
    
    var handleChange = this.props.parent.handleChange.bind(this.props.parent); 
    
    var actions = this.props.actions;
    var events = this.getEventsList();
    var content;
    if(!Array.isArray(events) || events.length == 0){
      content = <Message icon>
          <Image src='./images/cloverbuilder-info.png' height="32px"/>
          <Message.Content>
          {this.getLocalValue('controlhasnoeventsmsg', 'This control has no events.')}
          </Message.Content>
        </Message>;
    }
    else{
      var controlsOnForm = this.props.parent.getControlsList();
      var listControls = [];
      for(var i=0; i < controlsOnForm.length; i++ ){
        if(data.key == controlsOnForm[i]) 
          continue;
        listControls.push({text: controlsOnForm[i], value: controlsOnForm[i]});
      }
      content = <EventsEditor
        key="events" name="events"
        data={data.events}
        events={events}
        actions={actions}
        targets={listControls}
        onAdditionActions={this.handleAdditionActions.bind(this)}
        onChange={handleChange} />;
    }
      let timeot = null;
      if (events.includes("onChange")) {
          timeot = <Form.Input name="onChangeTimeout"
                                   style={{width:100}}
                                   placeholder={"0"}
                                   type={"number"}
                                   label={this.getLocalValue("onchangetimeout","onChange timeout")}
                                   value={data.onChangeTimeout} onChange={handleChange}/>;
      }
    
    return (<Form key="eventsDescriptionForm">
        <Message icon>
          <Image src='./images/cloverbuilder-info.png' height="32px"/>
          <Message.Content>
            {this.getLocalValue('eventsinfomsg', 'These flags enable processing from this element.')}
          </Message.Content>
        </Message>
        {timeot}
        {content}
      </Form>);
  }

  getOtherDescription(){
    var me = this;
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var customvalidation_ps = "/*** Example Code ***/\nvalue > 10 ? true : 'Must be more 10'";
    var visibleconition_ps = "/*** Example Code ***/\ndata.type == 1 ? true : false";
    var readOnlyconition_ps = "/*** Example Code ***/\ndata.type == 1 ? true : false";
    var skipconition_ps = "/*** Example Code ***/\ndata.type == 1 ? 'controlname' : false";
    //Skip,ReadOnly,Visible,Validation,

    //Survey designer solely will throw error as it is not able to find openFormLogic
    //Using this function for the edit links will suppress that error in dev
    var goToFormLogic = function(e, condProps){
      if(this == undefined || this.props.openFormLogicControl == undefined) {
        console.error("openFormLogicControl is not available in this");
        return;
      }
      this.props.openFormLogicControl(e, condProps);      
    }

    var applyRuleToCustomValidation = function(validationRule){
      data["other-customValidation"] = validationRule;
      this.forceUpdate();
    }

    var goToCreateRule = function(){
      var targetPath = "/form/QNN_RULE";
      
      // origin: "http://localhost:48800"
      var targetURL = window.location.origin + targetPath;

      var dataValue = data["other-customValidation"];
      if(dataValue !== "" && dataValue !== undefined){
        var querystring = "?datavalidation=" + encodeURIComponent(dataValue);
        targetURL = window.location.origin + targetPath + querystring;
      }
      
      window.open(targetURL, '_blank').focus();
    }
    
    console.log('data["other-customValidation"]',data["other-customValidation"])
    return (<Form style={{'marginBottom': '10%'}} key="otherDescriptionForm">
        <Form.Checkbox name="other-required" label={this.getLocalValue('requiredfield', 'Required')} checked={data["other-required"]} onChange={handleChange} />
        {data["other-required"] &&
        <Form.Checkbox name="other-required-soft" label={this.getLocalValue('requiredfieldissoft', 'Do Not Enforce Required')} checked={data["other-required-soft"]} onChange={handleChange} />}
        
        
        
        <Form.Input name="defaultValue" label={this.getLocalValue('defaultvaluefield', 'Default value')} value={data["defaultValue"]} onChange={handleChange} />

        <Form.TextArea name="other-customValidation" label={this.getLocalValue('customvalidationfield', 'Custom Validation')} placeholder={customvalidation_ps} value={data["other-customValidation"]} onChange={handleChange} />
        <Breadcrumb.Section className="edit-form-go-to-logic-builder-breadcrumb" control={data['key']} type="Validation" onClick={goToFormLogic.bind(this)}>{this.getLocalValue('editbutton', 'Edit')}</Breadcrumb.Section>
        
        <RulesModal ruleApi ={this.props.ruleApi} key="other-rules" localization={this.props.localization.rulesModal} applyActionHandler={applyRuleToCustomValidation.bind(this)} />
        <Breadcrumb.Section className="edit-form-go-to-logic-builder-breadcrumb" style={{marginRight:'20px'}} control={data['key']} type="Validation" onClick={goToCreateRule.bind(this)}>{this.getLocalValue('addrulebutton', 'Add to library')}</Breadcrumb.Section>
        
        
        {data["other-customValidation"] !== "" && data["other-customValidation"] !== undefined ?
        <Form.Checkbox name="other-customValidation-soft" label={this.getLocalValue('customvalidationfieldisrequired', 'Do Not Enforce Custom Validation')} checked={data["other-customValidation-soft"]} onChange={handleChange} />
        : null}

        <Form.TextArea name="other-visibleConition" label={this.getLocalValue('visibleconditionfield', 'Visible condition')} placeholder={visibleconition_ps} value={data["other-visibleConition"]} onChange={handleChange} />
        <Breadcrumb.Section className="edit-form-go-to-logic-builder-breadcrumb" control={data['key']} type="Visible" onClick={goToFormLogic.bind(this)}>{this.getLocalValue('editbutton', 'Edit')}</Breadcrumb.Section>

        <Form.TextArea name="other-readOnlyConition" label={this.getLocalValue('readonlyconditionfield', 'ReadOnly condition')} placeholder={readOnlyconition_ps} value={data["other-readOnlyConition"]} onChange={handleChange} />
        <Breadcrumb.Section className="edit-form-go-to-logic-builder-breadcrumb" control={data['key']} type="ReadOnly" onClick={goToFormLogic.bind(this)}>{this.getLocalValue('editbutton', 'Edit')}</Breadcrumb.Section>        
        
        <Form.TextArea name="other-skipConition" label='Skip condition' value={data["other-skipConition"]} placeholder={skipconition_ps} onChange={handleChange} />
        <Breadcrumb.Section className="edit-form-go-to-logic-builder-breadcrumb" control={data['key']} type="Skip" onClick={goToFormLogic.bind(this)}>{this.getLocalValue('editbutton', 'Edit')}</Breadcrumb.Section>
        <div></div>
      </Form>);
  }

  render() {
    return (
      <Modal closeOnDimmerClick={false} dimmer='inverted' open={this.props.open} onClose={this.props.onClose.bind(this.props.parent)} >
          <Modal.Content>
            <Modal.Description>
              {this.getDescription()}
            </Modal.Description>
          </Modal.Content>
          <Modal.Actions>
            <Button className="buttontype1" onClick={this.props.onSave.bind(this.props.parent)}>{this.getLocalValue('savebutton', 'Save')}</Button>
            <Button className="buttontype2" onClick={this.props.onClose.bind(this.props.parent)}>{this.getLocalValue('cancelbutton', 'Cancel')}</Button>
          </Modal.Actions>
        </Modal>
    );
  }

  checkActionsList(value){
    var isExists = false;
    
    for(let i=0;i< this.props.actions.length; i++){
      if(this.props.actions[i] == value){
        isExists = true;
        break;
      }
    }

    if(!isExists){
      this.props.actions.push({ text: value, value});
    }
  }

  handleAdditionActions(e, { value }){
    this.checkActionsList(value);
    this.forceUpdate();
  }
}

class DplyChoiceQnnsEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "dplychoiceqnnsform")} value={data.key} onChange={handleChange} />
        </Form.Group>
      </Form>);
  }
}
class HeaderEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  
    var sizedata = [
      {text: this.getLocalValue('sizedefault', 'Default'), value: ''},
      {text: this.getLocalValue('sizemini', 'Mini'), value: 'mini'},
      {text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny'},
      {text: this.getLocalValue('sizesmall', 'Small'), value: 'small'},
      {text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium'},
      {text: this.getLocalValue('sizelarge', 'Large'), value: 'large'},
      {text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge'}];

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "headerform")} value={data.key} onChange={handleChange} />
          <Form.Dropdown name="size" selection fluid options={sizedata} placeholder="Default" label={this.getLocalValue('sizefield', 'Size', "header")} value={data.size} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <Form.TextArea name="content" label={this.getLocalValue('contentfield', 'Content', "headerform")} value={data.content} onChange={handleChange} />
          <div className="field">
            <label>{this.getLocalValue('textalignfield', 'Text Align', "headerform")}</label>
            <Form.Group widths="equal">
              <Form.Radio name="textAlign" label={this.getLocalValue('textalignleft', 'Left', "headerform")} value='left' checked={data.textAlign === 'left'} onChange={handleChange} />
              <Form.Radio name="textAlign" label={this.getLocalValue('textaligncenter', 'Center', "headerform")} value='center' checked={data.textAlign === 'center'} onChange={handleChange} />
              <Form.Radio name="textAlign" label={this.getLocalValue('textalignright', 'Right', "headerform")} value='right' checked={data.textAlign === 'right'} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
        <Form.Input name="subheader" label={this.getLocalValue('subheaderfield', 'Subheader', "headerform")} value={data.subheader} onChange={handleChange} />
      </Form>);
  }
}

class ButtonEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  
    
    var sizedata = [
      {text: this.getLocalValue('sizedefault', 'Default'), value: ''},
      {text: this.getLocalValue('sizemini', 'Mini'), value: 'mini'},
      {text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny'},
      {text: this.getLocalValue('sizesmall', 'Small'), value: 'small'},
      {text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium'},
      {text: this.getLocalValue('sizebig', 'Big'), value: 'big'},
      {text: this.getLocalValue('sizelarge', 'Large'), value: 'large'},
      {text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge'},
      {text: this.getLocalValue('sizemassive', 'Massive'), value: 'massive'}
    ];

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "buttonform")} value={data.key} onChange={handleChange} />
       {/*    <div className="field">
            <label>{this.getLocalValue('typefield', 'Type', "buttonform")}</label>
            <Form.Group>
              <Form.Radio name="buttonType" label={this.getLocalValue('typenonefield', 'None', "buttonform")} value='' checked={data.buttonType === '' || data.buttonType === undefined} onChange={handleChange} />
              <Form.Radio name="buttonType" label={this.getLocalValue('typesubmitfield', 'Submit', "buttonform")} value='submit' checked={data.buttonType === 'submit'} onChange={handleChange} />
            </Form.Group>
          </div> */}
        </Form.Group>
        <Form.Group widths="equal">
          <Form.Input name="content" label={this.getLocalValue('contentfield', 'Content', "buttonform")} value={data.content} onChange={handleChange} />
          <Form.Dropdown name="size" selection fluid options={sizedata} placeholder="Default" label={this.getLocalValue('sizefield', 'Size', "buttonform")} value={data.size} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "buttonform")}</label>
            <Form.Group>
              {/* <Form.Checkbox name="circular" label={this.getLocalValue('circularfield', 'Circular', "buttonform")} checked={data.circular } onChange={handleChange} />
              <Form.Checkbox name="compact" label={this.getLocalValue('compactfield', 'Compact', "buttonform")} checked={data.compact} onChange={handleChange} /> */}
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "buttonform")} checked={data.disabled } onChange={handleChange} />
              <Form.Checkbox name="fluid" label={this.getLocalValue('fluidfield', 'Fluid', "buttonform")} checked={data.fluid } onChange={handleChange} />
         {/*      <Form.Checkbox name="inverted" label={this.getLocalValue('invertedfield', 'Inverted', "buttonform")} checked={data.inverted } onChange={handleChange} /> */}
            </Form.Group>
            <Form.Group>
              {/* <Form.Checkbox name="loading" label={this.getLocalValue('loadingfield', 'Loading', "buttonform")} checked={data.loading } onChange={handleChange} /> */}
              <Form.Checkbox name="basic" label={this.getLocalValue('basicfield', 'Basic', "buttonform")} checked={data.basic} onChange={handleChange} />
              <Form.Checkbox name="primary" label={this.getLocalValue('primaryfield', 'Primary', "buttonform")} checked={data.primary } onChange={handleChange} />
              <Form.Checkbox name="secondary" label={this.getLocalValue('secondaryfield', 'Secondary', "buttonform")} checked={data.secondary } onChange={handleChange} />
            </Form.Group>
            {/* <Form.Group>
              <Form.Checkbox name="toggle" label={this.getLocalValue('togglefield', 'Toggle', "buttonform")} checked={data.toggle } onChange={handleChange} />
            </Form.Group> */}
          </div>
          <div className="field">
            <label>{this.getLocalValue('floatedfield', 'Floated', "buttonform")}</label>
            <Form.Group>
              <Form.Radio name="floated" label={this.getLocalValue('floateddefaultfield', 'Default', "buttonform")} value='' checked={data.floated === undefined || data.floated === ''} onChange={handleChange} />
              <Form.Radio name="floated" label={this.getLocalValue('floatedleftfield', 'Left', "buttonform")} value='left' checked={data.floated === 'left'} onChange={handleChange} />
              <Form.Radio name="floated" label={this.getLocalValue('floatedrightfield', 'Right', "buttonform")} value='right' checked={data.floated === 'right'} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
      </Form>);
  }

  getEventsList(){
    return ["onClick"];
  }
}

const insertHTML = '<p>Insert Content...</p>';
class SwzStaticContentEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }

componentDidMount = () =>{
    var data = this.props.data;
    var htmlContent;  
  if(data.content != null || data.content != undefined){
    htmlContent = data.content;
  }else{
    htmlContent = insertHTML;
  }
    var editorState = this.initEditorState(htmlContent);
    this.setState({editorState, htmlContent: htmlContent});
  }

  componentDidUpdate = (prevProps) => {
    if(prevProps.data.content != this.props.data.content){
      var editorState = this.initEditorState(this.props.data.content);
      var content
      {this.props.data.content != undefined ? content = this.props.data.content : content = insertHTML;}
      this.setState({editorState, htmlContent: content});
    }
  }

  onEditorStateChange = (editorState) => {
    this.setState({
      editorState,
    });
  }

  initEditorState = (content) => {
    var html;
    if(content != null || content != undefined){
      html = content
    }
    else{
      html = insertHTML;
    }
    var contentBlock = htmlToDraft(html);
    if (contentBlock) {
      var contentState  = ContentState.createFromBlockArray(contentBlock.contentBlocks);
      return EditorState.createWithContent(contentState);
    }
  }

  onContentStateChange = (contentState) => {
    var jsonConvert = convertFromRaw(contentState);
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var htmlContent = draftToHtml(convertToRaw(jsonConvert));
    this.setState({htmlContent});
    handleChange(this, { 'name': 'content', 'value': htmlContent, 'checked': undefined })
  }
  
  onHTMLChange = (e) =>{
    var htmlContent = e.target.value;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    this.setState({htmlContent, editorState: this.initEditorState(e.target.value)});
    handleChange(this, { 'name': 'content', 'value': htmlContent, 'checked': undefined })
  }

  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var content;
    {this.props.content == undefined ? content = insertHTML : content = data.content} 
    var data = this.props.data;  

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "staticcontentform")} value={data.key} onChange={handleChange} />
        </Form.Group>
        <div style={{"margin-left":"10px"}}>
          <Form.Group>
            <span>Design Editor</span> 
            <Form.Checkbox toggle name="toggle" label="HTML Editor" checked={data.toggle} onChange={handleChange} />  
          </Form.Group>
        </div>
        {!data.toggle ? 
        <div>     
          <Editor
            editorState={this.state.editorState}
            wrapperClassName="demo-wrapper"
            editorClassName="demo-editor"
            onEditorStateChange={this.onEditorStateChange}
            onContentStateChange={this.onContentStateChange}
            />
        </div> : <div><TextArea rows={6} autoHeight={true} name="content" 
        label={this.getLocalValue('contentfield', 'Content', "staticcontentform")} value={this.state.htmlContent} onChange={(e) => {this.onHTMLChange(e)}}
         /> </div>
      }        
       </Form>);
  }
}

class InputEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }

  getGeneralDescription(){
    
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    var sizedata = [
      {text: this.getLocalValue('sizedefault', 'Default'), value: ''},
      {text: this.getLocalValue('sizemini', 'Mini'), value: 'mini'},
      {text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny'},
      {text: this.getLocalValue('sizesmall', 'Small'), value: 'small'},
      {text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium'},
      {text: this.getLocalValue('sizelarge', 'Large'), value: 'large'},
      {text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge'},
      {text: this.getLocalValue('sizemassive', 'Massive'), value: 'massive'}
    ];

    var labelPositions = [
      {text: this.getLocalValue('labeldefault', 'Default'), value: ''},
      {text: this.getLocalValue('labelleft', 'Left'), value: 'left'},
      {text: this.getLocalValue('labelright', 'Right'), value: 'right'},
      {text: this.getLocalValue('labelleftcorner', 'Left corner'), value: 'left corner'},
      {text: this.getLocalValue('labelrightcorner', 'Right corner'), value: 'right corner'}
    ];
    
    let disableDateFormat = data.type !== "date" && data.type !== "datetime" && data.type !== "time";
    let numberControls =  this.props.parent.getNumberControlsList();

 
    var removeMyKey = function (key, arr) {
      var newArr = [];
      if(arr !== undefined && arr.length > 0){
        for(let i = 0; i < arr.length; i++){
          if(arr[i] !== key){
            newArr.push(arr[i]);
          }
        }
      }
      return newArr
    }
    let autoSumColumns =
      [{key: 'control', name: 'control', dataList: removeMyKey(data.key, numberControls)},
      {key: 'operator', name: 'operator', dataList:["+", "-", "*", "/", "End"]},
    ]

    let autoSumWithoutKey =
      [{key: 'control', name: 'control', dataList: numberControls},
      {key: 'operator', name: 'operator', dataList:["+", "-", "*", "/", "End"]},
    ]

      var str = '';
      var prevOperator;
      
      var getAutoSumString = function (autoSumItems){
        if(autoSumItems !== undefined && autoSumItems.length > 0){
          for(let i = 0; i < autoSumItems.length; i++){
            if(autoSumItems[i].operator !== undefined && autoSumItems[i].control !== undefined){
              let operator = autoSumItems[i].operator !== "End" ?  autoSumItems[i].operator : '';
              if(i == 0)
                str = autoSumItems[i].control + ' ' + operator;

              if(i > 0)
                str = str + ' ' + autoSumItems[i].control + ' ' + operator + ' ';
            } 
          }
                
          return str
        }
      }
       
      data['autosumstring'] = getAutoSumString(data['data-elements']);  

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "inputform")} value={data.key} onChange={handleChange} />
          <Form.Input name="reference" label={this.getLocalValue('referencefield', 'Reference', "textareaform")} value={data.reference} onChange={handleChange} />
          <Form.Input name="label" label={this.getLocalValue('labelfield', 'Label', "inputform")} value={data.label} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <div className="field">
            <label>{this.getLocalValue('typefield', 'Type', "inputform")}</label>
            <Form.Group widths="equal">
              <Form.Radio name="type" label={this.getLocalValue('typetext', 'Text', "inputform")} value='text' checked={data.type == undefined || data.type == 'text' } onChange={handleChange} />
              <Form.Radio name="type" label={this.getLocalValue('typenumber', 'Number', "inputform")} value='number' checked={data.type === 'number'} onChange={handleChange} />
              <Form.Radio name="type" label={this.getLocalValue('typepasswod', 'Password', "inputform")} value='password' checked={data.type === 'password'} onChange={handleChange} />
              <Form.Radio name="type" label={this.getLocalValue('typefile', 'File', "inputform")} value='file' checked={data.type === 'file'} onChange={handleChange} />
              <Form.Radio name="type" label='Image' value='imagefile' checked={data.type === 'imagefile'} onChange={handleChange} />
               </Form.Group>
            <Form.Group widths="equal">
              <Form.Radio name="type" label={this.getLocalValue('typedate', 'Date', "inputform")} value='date' checked={data.type === 'date'} onChange={handleChange} />
              <Form.Radio name="type" label={this.getLocalValue('typetime', 'Time', "inputform")} value='time' checked={data.type === 'time'} onChange={handleChange} />
              <Form.Radio name="type" label={this.getLocalValue('typedatetime', 'Date & Time', "inputform")} value='datetime' checked={data.type === 'datetime'} onChange={handleChange} />
            </Form.Group>
          </div>
          <div className="field">
            {/* <Form.Dropdown name="labelPosition" selection fluid placeholder={labelPositions[0].text} options={labelPositions} label={this.getLocalValue('labelpositionfield', 'Label position', "inputform")} value={data.labelPosition} onChange={handleChange} /> */}
            <Form.Input name="placeholder" label={this.getLocalValue('placeholderfield', 'Placeholder', "inputform")} value={data.placeholder} onChange={handleChange} />
          </div>
        </Form.Group>
        <Form.Group widths="equal">
        <div style={{display:  data.type == 'number' ? "block" : "none"}} className="field">
              <Form.Checkbox name="isautosum" label={'Auto Sum'} checked={data.isautosum} onChange={handleChange}/>
              <Form.Checkbox name="disableupdownkey" label={'Disable Up/Down Key Increment'} checked={data.disableupdownkey} onChange={handleChange}/>
        </div>
        </Form.Group>
        {/* Auto Sum */}
        <Form.Group>
         <div style={{display: 
                    data.isautosum && data.type == 'number' ? "block" 
                    : "none"}} className="field">
                
            <h3>Auto Sum</h3>
            <Form.Group widths="equal">
            <Form.Input type="number" name="roundoffno" disabled={!data.isautosum} label={'Round off decimal'} value={data.roundoffno} onChange={handleChange} />
            </Form.Group>          
            <Form.Group widths="equal">
              <Form.TextArea rows={2} value={data["autosumstring"]} disabled placeholder="Click add below to begin building auto sum" />
            </Form.Group>          
            <Form.Group widths="equal">
             <CollectionEditor
                key="data-elements" 
                draggable={true}
                columns={
                  data.key !== undefined && data.key !== null ? autoSumColumns : autoSumWithoutKey
                }
                useSpecialLabel={true}
                label="Auto Sum List"
                name="data-elements" 
                value={data["data-elements"]}
                onChange={handleChange}
              /> 
            </Form.Group>
          </div>
        </Form.Group>

        <Form.Group>
         <div style={{display: 
                    data.type == "file"? "block" 
                    : "none"}} className="field">
            <label>File Settings</label>
            <Form.Group widths="equal">
              <Form.Input type="number" name="filemaxsize" label='Maximum Size (kb)' value={data.filemaxsize} onChange={handleChange} />  
            </Form.Group>
            <Form.Group widths="equal">
             <Form.Input name="authorisedfiletypes" label='Authorised File Types (.xlsx,.xls,.csv)' value={data.authorisedfiletypes} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
        <Form.Group>
        <div style={{display: 
                    data.type == "imagefile" ? "block" 
                    : "none"}} className="field">
            <label>Image Settings</label>
            <Form.Group widths="equal">
              <Form.Input type="number" name="imagemaxwidth" label='Maximum Width/Height (px)' value={data.imagemaxwidth} onChange={handleChange} /> 
             </Form.Group>     
            <Form.Group widths="equal">
              <Form.Input type="number" name="imagemaxquality" label='Image Max Quality (%)' value={data.imagemaxquality} onChange={handleChange} />  
            </Form.Group>     
          </div>
        </Form.Group>

        {/* Date/Time/Date&Time Custom Format */}
        <Form.Group>
         <div style={{display: 
                    data.type == "date" || data.type == "time" || data.type == "datetime" ? "block" 
                    : "none"}} className="field">
            <Form.Group widths="equal">
              <Form.Input type="text" name="customDateTimeFormat" label={'Custom ' + data.type + ' format'} value={data.customDateTimeFormat} onChange={handleChange} />  
            </Form.Group>
          </div>
        </Form.Group>
        
        <Form.Group widths="equal">
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "inputform")}</label>
            {/*<Form.Group widths="equal">
              <Form.Checkbox name="loading" label={this.getLocalValue('loadingfield', 'Loading', "inputform")} checked={data.loading} onChange={handleChange} />
              <Form.Checkbox name="inverted" label={this.getLocalValue('invertedfield', 'Inverted', "inputform")} checked={data.inverted } onChange={handleChange} />
              <Form.Checkbox name="error" label={this.getLocalValue('errorfield', 'Error', "inputform")} checked={data.error } onChange={handleChange} />
            </Form.Group>*/}
            <Form.Group widths="equal">
              {/* <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "inputform")} checked={data.disabled } onChange={handleChange} />
              <Form.Checkbox name="transparent" label={this.getLocalValue('transparentfield', 'Transparent', "inputform")} checked={data.transparent } onChange={handleChange} />  */} 
              <Form.Checkbox name="fluid" label={this.getLocalValue('fluidfield', 'Fluid', "inputform")} checked={data.fluid } onChange={handleChange} />
            </Form.Group>
            <Form.Group widths="equal">
              <Form.Checkbox name="readOnly" label={this.getLocalValue('readonlyfield', 'Read only', "inputform")} checked={data.readOnly} onChange={handleChange} />
            </Form.Group>
          </div>
          <div className="field">
            <Form.Dropdown name="size" selection fluid options={sizedata} placeholder={sizedata[0].text} label={this.getLocalValue('sizefield', 'Size', "inputform")} value={data.size} onChange={handleChange} />
            {/*<Form.Input name="dateFormat" label={this.getLocalValue('dateformatfield', 'Date Format', "inputform")} value={data.dateFormat} disabled={disableDateFormat} onChange={handleChange} />*/}
          </div>
        </Form.Group>
      </Form>);
  }

  getEventsList(){
    return ["onClick", "onChange"];
  }
}

class TextAreaEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  
    return (<Form>
       <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "textareaform")} value={data.key} onChange={handleChange} />
          <Form.Input name="reference" label={this.getLocalValue('referencefield', 'Reference', "textareaform")} value={data.reference} onChange={handleChange} />
          <Form.Input name="label" label={this.getLocalValue('labelfield', 'Label', "textareaform")} value={data.label} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <Form.Input name="rows" placeholder="3" type="number" label={this.getLocalValue('rowsfield', 'Rows', "textareaform")} value={data.rows} onChange={handleChange} />
          <div className="field">
            <Form.Input name="placeholder" label={this.getLocalValue('placeholderfield', 'Placeholder', "textareaform")} value={data.placeholder} onChange={handleChange} />
            <label>{this.getLocalValue('placeholderfield', 'Options', "textareaform")}</label>
            <Form.Group widths="equal">
              <Form.Checkbox name="autoHeight" label={this.getLocalValue('autoheightfield', 'Auto height', "textareaform")} checked={data.autoHeight} onChange={handleChange} />
              <Form.Checkbox name="readOnly" label={this.getLocalValue('readonlyfield', 'Read only', "textareaform")} checked={data.readOnly } onChange={handleChange} />
            </Form.Group>
            <div className="field" style={{display:"none"}}>
              <Form.Input name="type" label="type" value={data.type} disabled={false} onChange={handleChange} />
            </div>
         </div>
        </Form.Group>
      </Form>);
  }

  getEventsList(){
    return ["onClick", "onChange", "onChangeTimeOut"];
  }
}

class CheckboxEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  
    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "checkboxform")} value={data.key} onChange={handleChange} />
          <Form.Input name="label" label={this.getLocalValue('labelfield', 'Label', "checkboxform")} value={data.label} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="2">
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "checkboxform")}</label>
            <Form.Group>
            {/*   <Form.Checkbox name="fitted" label={this.getLocalValue('fittedfield', 'Fitted', "checkboxform")} checked={data.fitted} onChange={handleChange} />
              <Form.Checkbox name="indeterminate" label={this.getLocalValue('indeterminatefield', 'Indeterminate', "checkboxform")} checked={data.indeterminate } onChange={handleChange} /> 
              <Form.Checkbox name="readOnly" label={this.getLocalValue('readonlyfield', 'ReadOnly', "checkboxform")} checked={data.readOnly } onChange={handleChange} />*/}
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "checkboxform")} checked={data.disabled } onChange={handleChange} />
             {/*  <Form.Checkbox name="slider" label={this.getLocalValue('sliderfield', 'Slider', "checkboxform")} checked={data.slider } onChange={handleChange} /> */}
              <Form.Checkbox name="toggle" label={this.getLocalValue('togglefield', 'Toggle', "checkboxform")} checked={data.toggle } onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
      </Form>);
  }

  getEventsList(){
    return ["onClick", "onChange", "onChangeTimeOut"];
  }
}

class DropdownEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }

  onBulkChoices(that){
    var me = that;
    var handleChange = me.props.parent.handleChange.bind(this.props.parent);
    var data = that.props.data;
    var bulkData = data['data-elements'].map(function(d){
      if(d.value == null || d.value === 'undefined') {
        return '"","",""';
      }
      var visible = '';
      if(!(d['visible-condition'] == null || d['visible-condition'] === 'undefined'))
        visible = d['visible-condition'];
      return '"' + d.value + '","' + d.text + '","' + visible + '"';
    }).join('\n');
    var open = function (){
      me.setState( {
        open: true,
    });
    }

    var close = function (){
      me.setState({
        open: false
      })
    }
    var taPlaceHolder =
`"1", "Item 1",""
"2", "Item 2",""
"3", "Item 3",""`;

    const trigger = 
    <Button 
        className="buttontype2" 
        onClick={() => open()} 
        content="Edit bulk data"/>;
    return(
      <Modal 
                open={this.state.open}
                dimmer="inverted"
                trigger={trigger}
                closeOnDimmerClick={true}
                onClose={() => close()} >
                <Modal.Header content="Bulk data" /> 
                <Modal.Content>
                <TextArea key="taData" name="taData"
                  label="Data" placeholder={taPlaceHolder}
                  value={data["taData"]} 
                  defaultValue={bulkData}
                  onChange={handleChange}
                  rows={10}>
                </TextArea>
                </Modal.Content>      
                <Modal.Actions>
                    <Button 
                        className="buttontype1"
                        content='Add' 
                        icon 
                        onClick={() => this.onTaClick(data["taData"])}>
                    </Button>
                    <Button 
                        className="buttontype2" 
                        onClick={() => close()} 
                        content='Cancel' />                
                </Modal.Actions>        
            </Modal>
    );
  }

  onTaClick = (elements) => {
    let dataElements = [];
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    
    if(elements == null || elements === 'undefined'){
      this.setState({
        open: false
      })
      return;
    } 

    try {
      //Split line break
      elements.split('\n').map(function(items) {
        let obj = {}
        //split commas. Ignore commans in inverted commas
        items.split(/,(?=(?:(?:[^"]*"){2})*[^"]*$)/).map(function(item, key) {

          if(key == 0)
            obj['value'] = item.replace(/['"]+/g, ''); //Remove inverted commas
          else if(key == 1)
            obj['text'] =  item.replace(/['"]+/g, '');
          else if(key == 2)
            obj['visible-condition'] =  item.replace(/['"]+/g, '');
        });
        dataElements.push(obj);
      })
    } catch (error) {
      console.log("Error on bulk data", error);
    }

    handleChange(this, { 'name': 'data-elements', 'value': dataElements, 'checked': undefined })
    this.setState({
      open: false
    })
    
    this.props.data["taData"] = null;
  }

  onToggle = () =>{
   
    var onToggle = !this.state.onToggle;
    this.setState({onToggle});
  }

  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  
        
    var dataColumns = [
      {key: 'value', name: this.getLocalValue('datavaluecolumn', 'Value', "dropdownform")},
      {key: 'text', name: this.getLocalValue('datatextcolumn', 'Text', "dropdownform")},
      {key: 'visible-condition', name: this.getLocalValue('datavisibleconditioncolumn', 'Visible Condition', "dropdownform")}
    ];
    


    
    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "dropdownform")} value={data.key} onChange={handleChange} />
          <Form.Input name="reference" label={this.getLocalValue('referencefield', 'Reference', "checkboxform")} value={data.reference} onChange={handleChange} />
          <Form.Input name="label" label={this.getLocalValue('labelfield', 'Label', "dropdownform")} value={data.label} onChange={handleChange} />
        </Form.Group>
    
        <Form.Group widths="equal">
          <CollectionEditor key="data-elements" 
            draggable={true}
            columns={dataColumns} 
            label={this.getLocalValue('datafield', 'Data', "dropdownform")}
            name="data-elements" 
            value={data["data-elements"]}
            onChange={handleChange} />
          <div className="field">
            <Form.Input name="placeholder" label="Placeholder" value={data.placeholder} onChange={handleChange} />
            <div className="field">
              <label>{this.getLocalValue('optionsfield', 'Options', "dropdownform")}</label>
              <Form.Group>
               {/*  <Form.Checkbox name="loading" label={this.getLocalValue('loadingfield', 'Loading', "dropdownform")} checked={data.loading} onChange={handleChange} />
                <Form.Checkbox name="error" label={this.getLocalValue('errorfield', 'Error', "dropdownform")} checked={data.error } onChange={handleChange} />*/}                
                <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "dropdownform")} checked={data.disabled } onChange={handleChange} />
                <Form.Checkbox name="fluid" label={this.getLocalValue('fluidfield', 'Fluid', "dropdownform")} checked={data.fluid } onChange={handleChange} />
              </Form.Group>
              <Form.Group>
                <Form.Checkbox name="multiple" label={this.getLocalValue('multiplefield', 'Multiple', "dropdownform")} checked={data.multiple } onChange={handleChange} />
                <Form.Checkbox name="search" label={this.getLocalValue('searchfield', 'Search', "dropdownform")} checked={data.search } onChange={handleChange} />
                <Form.Checkbox name="selection" label={this.getLocalValue('selectionfield', 'Selection', "dropdownform")} checked={data.selection } onChange={handleChange} />
              </Form.Group>
              <Form.Group>
                <Form.Checkbox name="onScrollNextControl" label={"Focus next control upon selection"} checked={data.onScrollNextControl} onChange={handleChange} />
              </Form.Group>
              <Form.Group>
                <Form.Checkbox name="randomise" label="Randomise" checked={data.randomise } onChange={handleChange} />
                <Form.Checkbox style={{display: 'none'}} name="isshuffled" label="isShuffled" checked={data.isshuffled } onChange={handleChange} />
               {/*  <Form.Checkbox name="readOnly" label={this.getLocalValue('readonlyfield', 'Read only', "dropdownform")} checked={data.readOnly } onChange={handleChange} />*/}                <Form.Checkbox name="allowAddItems" label={this.getLocalValue('allowAddItemsfield', 'Allow add items', "dropdownform")} disabled={!(data.search && data.multiple)} checked={data.allowAddItems } onChange={handleChange} />
              </Form.Group>
            </div>
          </div>
        </Form.Group>
            
        <Form.Group>
        {this.onBulkChoices(this)}
    
        </Form.Group>
      </Form>);
  }

  getEventsList(){
    return ["onClick", "onChange", "onChangeTimeOut"];
  }
}

class RadioGroupEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }

  
  onBulkChoices(that){
    var me = that;
    var handleChange = me.props.parent.handleChange.bind(this.props.parent);
    var data = that.props.data;
    var bulkData = data['data-elements'].map(function(d){
      if(d.value == null || d.value === 'undefined') {
        return '"","",""';
      }
      var visible = '';
      if(!(d['visible-condition'] == null || d['visible-condition'] === 'undefined'))
        visible = d['visible-condition'];
      return '"' + d.value + '","' + d.text + '","' + visible + '"';
    }).join('\n');
    var open = function (){
      me.setState( {
        open: true,
    });
    }

    var close = function (){
      me.setState({
        open: false
      })
    }
    var taPlaceHolder =
`"1", "Item 1",""
"2", "Item 2",""
"3", "Item 3",""`;

    const trigger = 
    <Button 
        className="buttontype2" 
        onClick={() => open()} 
        content="Edit bulk data"/>;
    return(
      <Modal 
                open={this.state.open}
                dimmer="inverted"
                trigger={trigger}
                closeOnDimmerClick={true}
                onClose={() => close()} >
                <Modal.Header content="Bulk data" /> 
                <Modal.Content>
                <TextArea key="taData" name="taData"
                  label="Data" placeholder={taPlaceHolder}
                  value={data["taData"]} 
                  defaultValue={bulkData}
                  onChange={handleChange}
                  rows={10}>
                </TextArea>
                </Modal.Content>      
                <Modal.Actions>
                    <Button 
                        className="buttontype1"
                        content='Add' 
                        icon 
                        onClick={() => this.onTaClick(data["taData"])}>
                    </Button>
                    <Button 
                        className="buttontype2" 
                        onClick={() => close()} 
                        content='Cancel' />                
                </Modal.Actions>        
            </Modal>
    );
  }

  onTaClick = (elements) => {
    let dataElements = [];
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    
    if(elements == null || elements === 'undefined'){
      this.setState({
        open: false
      })
      return;
    } 

    try {
      //Split line break
      elements.split('\n').map(function(items) {
        let obj = {}
        //split commas. Ignore commans in inverted commas
        items.split(/,(?=(?:(?:[^"]*"){2})*[^"]*$)/).map(function(item, key) {

          if(key == 0)
            obj['value'] = item.replace(/['"]+/g, ''); //Remove inverted commas
          else if(key == 1)
            obj['text'] =  item.replace(/['"]+/g, '');
          else if(key == 2)
            obj['visible-condition'] =  item.replace(/['"]+/g, '');
        });
        dataElements.push(obj);
      })
    } catch (error) {
      console.log("Error on bulk data", error);
    }
    
    handleChange(this, { 'name': 'data-elements', 'value': dataElements, 'checked': undefined })
    this.setState({
      open: false
    })

    this.props.data["taData"] = null;
  }

  onToggle = () =>{
   
    var onToggle = !this.state.onToggle;
    this.setState({onToggle});
  }

  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    var dataColumns = [
      {key: 'value', name: this.getLocalValue('datavaluecolumn', 'Value', "radiogroupform")},
      {key: 'text', name: this.getLocalValue('datatextcolumn', 'Text', "radiogroupform")},
      {key: 'visible-condition', name: this.getLocalValue('datavisibleconditioncolumn', 'Visible Condition', "radiogroupform")}
    ];
    
    return (<Form>
       <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "radiogroupform")} value={data.key} onChange={handleChange} />
          <Form.Input name="reference" label={this.getLocalValue('referencefield', 'Reference', "radiogroupform")} value={data.reference} onChange={handleChange} />
          <Form.Input name="label" label={this.getLocalValue('labelfield', 'Label', "radiogroupform")} value={data.label} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <CollectionEditor key="data-elements" 
              draggable={true}
              columns={dataColumns} 
              label={this.getLocalValue('datafield', 'Data', "radiogroupform")}
              name="data-elements" 
              value={data["data-elements"]}
              onChange={handleChange} />
          <div className="field">

          <div style={{display:  data.sliderForm == true ? "none" : "block"}} className="field">
              <label>{this.getLocalValue('groupdirectfield', 'Group direct', "radiogroupform")}</label>
              <Form.Radio name="direction" label="Horizontal" value='g' checked={data.direction === undefined || data.direction === 'g'} onChange={handleChange} />
              <Form.Radio name="direction" label={this.getLocalValue('directionverticalfield', 'Vertical', "radiogroupform")} value='v' checked={data.direction === 'v'} onChange={handleChange} />
          </div>
              <Form.Group>
              </Form.Group>  
              <Form.Group>
                <Form.Checkbox name="readOnly" label={this.getLocalValue('readonlyfield', 'Read only', "radiogroupform")} checked={data.readOnly } onChange={handleChange} />
              </Form.Group>
              <Form.Group>
                <Form.Checkbox name="onScrollNextControl" label={"Focus next control upon selection"} checked={data.onScrollNextControl} onChange={handleChange} />
              </Form.Group>
              <Form.Group>
                <Form.Checkbox name="randomise" label="Randomise" checked={data.randomise } onChange={handleChange} />
              </Form.Group>
              <Form.Group>
                <Form.Checkbox name="sliderForm" label="Slider" checked={data.sliderForm } onChange={handleChange} />
              </Form.Group>
          </div>
        </Form.Group>
        <Form.Group>
        {this.onBulkChoices(this)}
    
        </Form.Group>
        
      </Form>);
  }

  getEventsList(){
    return ["onClick", "onChange", "onChangeTimeOut"];
  }
}

class FormEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }

  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    var sizedata = [
      {text: this.getLocalValue('sizedefault', 'Default'), value: ''},
      {text: this.getLocalValue('sizemini', 'Mini'), value: 'mini'},
      {text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny'},
      {text: this.getLocalValue('sizesmall', 'Small'), value: 'small'},
      {text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium'},
      {text: this.getLocalValue('sizelarge', 'Large'), value: 'large'},
      {text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge'}
    ];

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "form")} value={data.key} onChange={handleChange} />
          <Form.Dropdown name="size" selection fluid options={sizedata} placeholder={sizedata[0].text} label={this.getLocalValue('sizefield', 'Size', "form")} value={data.size} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="2">
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "form")}</label>
            <Form.Group>
              <Form.Checkbox name="loading" label={this.getLocalValue('loadingfield', 'Loading', "form")} checked={data.loading} onChange={handleChange} />
              <Form.Checkbox name="error" label={this.getLocalValue('errorfield', 'Error', "form")} checked={data.error } onChange={handleChange} />
              <Form.Checkbox name="inverted" label={this.getLocalValue('invertedfield', 'Inverted', "form")} checked={data.inverted } onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="reply" label={this.getLocalValue('replyfield', 'Reply', "form")} checked={data.reply } onChange={handleChange} />
              <Form.Checkbox name="success" label={this.getLocalValue('successfield', 'Success', "form")} checked={data.success } onChange={handleChange} />
              <Form.Checkbox name="warning" label={this.getLocalValue('warningfield', 'Warning', "form")} checked={data.warning } onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
      </Form>);
  }

  getEventsList(){
    return ["onSubmit"];
  }
}

class FormGroupEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "formgroupform")} value={data.key} onChange={handleChange} />
          {/* <div className="field">
            <label>{this.getLocalValue('widthsfield', 'Widths', "formgroupform")}</label>
            <Form.Group>
              <Form.Radio name="widths" label={this.getLocalValue('widthsdefaultfield', 'Default', "formgroupform")} checked={ data.widths === undefined } onChange={handleChange} />
              <Form.Radio name="widths" label={this.getLocalValue('widthsequalfield', 'Equal', "formgroupform")} value='equal' checked={data.widths === 'equal'} onChange={handleChange} />
              <Form.Radio name="widths" label={this.getLocalValue('widthscustomfield', 'Custom (1 - 16)', "formgroupform")} value='custom' checked={data.widths === 'custom'} onChange={handleChange} />
            </Form.Group>
          </div> */}
        </Form.Group>
        <Form.Group widths="equal">
          <div className="field">
            <label>{this.getLocalValue('typefield', 'Type', "formgroupform")}</label>
            <Form.Group>
              <Form.Radio name="orientation" label={this.getLocalValue('orientationcolumnsfield', 'Columns', "formgroupform")} value="inline" checked={data.orientation === undefined || data.orientation === 'inline' } onChange={handleChange} />
              <Form.Radio name="orientation" label={this.getLocalValue('orientationrowsfield', 'Rows', "formgroupform")} value="grouped" checked={data.orientation === "grouped" } onChange={handleChange} />
            </Form.Group>
          </div>
          <Form.Input name="widthsCustom" disabled={data.widths !== 'custom'} placeholder="2" value={data.widthsCustom} onChange={handleChange}/>
        </Form.Group>
      </Form>);
  }
}

class ContainerEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);

    var floatdata = [
      {text: this.getLocalValue('floatnonefield', 'None', "containerform"), value: ''},
      {text: this.getLocalValue('floatleftfield', 'Left', "containerform"), value: 'left'},
      {text: this.getLocalValue('floatrightfield', 'Right', "containerform"), value: 'right'}
    ];

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "containerform")} value={data.key} onChange={handleChange} />
          <Form.Dropdown name="style-float" selection fluid options={floatdata} placeholder={floatdata[0].text} label={this.getLocalValue('floatfield', 'Float', "containerform")} value={data["style-float"]} onChange={handleChange} />
        </Form.Group>
        <Form.Input name="parentpage" style={{display: 'none'}} value={data.parentpage} onChange={handleChange} />
        <Form.Group>
              <Form.Checkbox name="randomise" label="Randomise" checked={data.randomise } onChange={handleChange} />
              <Form.Checkbox name="templateBlock" label="Template Block" checked={data.templateBlock} onChange={handleChange} />
        </Form.Group>
      </Form>);
  }
}

class ImageEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;
    var onFileStorage = data.filename !== undefined && data.filename !== '';
    var onDisplay = "block";
    var onDisabled = false;

    if(onFileStorage){
      onDisplay = "none";
      if (data.filename.item !== undefined && data.filename.message == "Successful") {
        var filename = data.filename.item;
        var fileUrl = "/data/file/view/" + filename;
        data.filename = filename;
        data.src = fileUrl;
        data.filestorage = true;
        onDisabled = true;
      }
      else if (data.filename.item !== undefined && data.filename.message !== "Successful"){
        var errorMsg = data.filename.message;
        alertify.error(errorMsg);
        data.filename = "";
      }
    }
    else if(data.filestorage){
      onDisplay = "none";
    }else{
      onDisplay = "true";
      data.src = "";
    }

    return (<Form>
         <Form.Group widths="equal">
          <div className="field">
            <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "imageform")} value={data.key} onChange={handleChange} />
            <Form.Input name="src" label={this.getLocalValue('srcfield', 'Src', "imageform")} value={data.src} onChange={handleChange} />
            <div className="field" style={{display: onDisplay}}>
              <label>Link</label>
              <Form.Input style={{display: onDisplay}} name="href" value={data.href} onChange={handleChange} />
            </div>
            <label>Import image</label>
            <Upload
                key={data.key} 
                name="filename" 
                value={data.filename}
                type="file"
                downloadUrl="/data/file/download/"
                uploadUrl="/data/file/upload/"
                onChange={handleChange}
                islocalstorage={true}
                authorisedfiletypes = ".JPG,.jpg,.PNG,.png,.JPEG,.jpeg,.GIF,.gif"
            />
          </div>
          <div className="field">
            <div className="field">
              <label>{this.getLocalValue('optionsfield', 'Options', "imageform")}</label>
              <Form.Group>
                <Form.Checkbox disabled={onDisabled} name="filestorage" label="File Storage" checked={data.filestorage} onChange={handleChange} />
              </Form.Group>
            </div>
            <div className="field">
              <label>{this.getLocalValue('optionsfield', 'Options', "imageform")}</label>
              <Form.Group>
                <Form.Checkbox name="avatar" label={this.getLocalValue('avatarfield', 'Avatar', "imageform")} checked={data.avatar} onChange={handleChange} />
                <Form.Checkbox name="bordered" label={this.getLocalValue('borderedfield', 'Bordered', "imageform")} checked={data.bordered } onChange={handleChange} />
                <Form.Checkbox name="centered" label={this.getLocalValue('centeredfield', 'Centered', "imageform")} checked={data.centered } onChange={handleChange} />
              </Form.Group>
              <Form.Group>
                <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "imageform")} checked={data.disabled } onChange={handleChange} />
                <Form.Checkbox name="inline" label={this.getLocalValue('inlinefield', 'Inline', "imageform")} checked={data.inline } onChange={handleChange} />
                <Form.Checkbox name="spaced" label={this.getLocalValue('spacedfield', 'Spaced', "imageform")} checked={data.spaced } onChange={handleChange} />
              </Form.Group>
            </div>
            <div className="field">
              <label>{this.getLocalValue('floatedfield', 'Floated', "imageform")}</label>
              <Form.Group>
                <Form.Radio name="floated" label={this.getLocalValue('floatedleftfield', 'Left', "imageform")} value='left' checked={ data.floated === 'left' || data.floated === '' } onChange={handleChange} />
                <Form.Radio name="floated" label={this.getLocalValue('floatedrightfield', 'Right', "imageform")} value='right' checked={data.floated === 'right'} onChange={handleChange} />
              </Form.Group>
              <label>{this.getLocalValue('verticalalignfield', 'Vertical align', "imageform")}</label>
              <Form.Group>
                <Form.Radio name="verticalAlign" label={this.getLocalValue('verticalaligntopfield', 'Top', "imageform")} value="top" checked={ data.verticalAlign === 'top' } onChange={handleChange} />
                <Form.Radio name="verticalAlign" label={this.getLocalValue('verticalalignmiddlefield', 'Middle', "imageform")} value='middle' checked={data.verticalAlign === 'middle'} onChange={handleChange} />
                <Form.Radio name="verticalAlign" label={this.getLocalValue('verticalalignbottomfield', 'Bottom', "imageform")} value='bottom' checked={data.verticalAlign === 'bottom'} onChange={handleChange} />
              </Form.Group>
            </div>
          </div>
        </Form.Group>
      </Form>);
  }
}

class GridEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    var pagertype = [
      {value: "", text: this.getLocalValue('pagertypenonefield', 'None', "gridform")},
      {value: "server", text: this.getLocalValue('pagertypeserverfield', 'Server', "gridform")},
    ];

    var editformtype = [
      {value: "", text: this.getLocalValue('editformtypedefaultfield', 'Default', "gridform")},
      //{value: "modal", text: this.getLocalValue('editformtypemodalfield', 'Modal', "gridform")},
    ];

    let columns = [
      {key: 'key', name: this.getLocalValue('keycolumn', 'Key', "gridform")},
      {key: 'name', name: this.getLocalValue('namecolumn', 'Name', "gridform")},
      {key: 'type', name: this.getLocalValue('typecolumn', 'Type', "gridform"), dataList:["", "number", "checkbox", "date", "datetime", "time", "custom"]},
      {key: 'width', name: this.getLocalValue('widthcolumn', 'Width', "gridform"), control: 'number'},
      {key: 'resizable', name: this.getLocalValue('resizablecolumn', 'Resizable', "gridform"), control: "checkbox"}]

    var editTypeItems = [
      {key: "form", text: "Form", value: undefined},
      {key: "flow", text: "Flow", value: "flow"}
    ];

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "gridform")} value={data.key} onChange={handleChange} />
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "gridform")}</label>
            <Form.Group>
              <Form.Checkbox name="multiselect" label={this.getLocalValue('multiselectfield', 'Multiselect', "gridform")} checked={data.multiselect} onChange={handleChange} />
              <Form.Checkbox name="disableSort" label={this.getLocalValue('disablesortfield', 'Disable sorting', "gridform")} checked={data.disableSort} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
        <Form.Group widths="equal">
          <div className="field">
            <Form.Group widths="equal">
              <RadioGroup 
                        name="editType"
                        label={this.getLocalValue('edittypefield', 'Edit type', "gridform")}
                        items={editTypeItems}
                        value={data.editType} 
                        onChange={handleChange} >
              </RadioGroup>
              {data.editType != "flow" && <Form.Input name="editForm" label={this.getLocalValue('editformfield', 'Edit form', "gridform")} disabled={data.inline == true} value={data.editForm} onChange={handleChange} />}
              {data.editType == "flow" && <Form.Input name="editFlow" label={this.getLocalValue('editflowfield', 'Edit flow', "gridform")} disabled={data.inline == true} value={data.editFlow} onChange={handleChange} />}
            </Form.Group>
            <Form.Input name="rowKey" label={this.getLocalValue('rowkeyfield', 'Row key', "gridform")} value={data.rowKey} onChange={handleChange} />
            <Form.Input name="pageSize" label={this.getLocalValue('pagesizefield', 'Page size', "gridform")} value={data.pageSize} onChange={handleChange} />
            <Form.Input name="defaultSort" label={this.getLocalValue('defaultsortfield', 'Default sort', "gridform")} placeholder="Name ASC" value={data.defaultSort} onChange={handleChange} />
          </div>
          <div className="field">
            <Form.Dropdown name="editFormShowType" selection fluid label={this.getLocalValue('editformshowtypefield', 'Edit form show type', "gridform")} placeholder={editformtype[0].text} options={editformtype} value={data.editFormShowType} onChange={handleChange} />
            <Form.Dropdown name="pagerType" selection fluid label={this.getLocalValue('pagertypefield', 'Pagination type', "gridform")} placeholder="None" options={pagertype} value={data.pagerType} onChange={handleChange} />
            <Form.Input name="rowHeight" label={this.getLocalValue('rowheightfield', 'Row height', "gridform")} value={data.rowHeight} onChange={handleChange} />
            <Form.Input name="minHeight" label={this.getLocalValue('minheightfield', 'Min height', "gridform")} value={data.minHeight} onChange={handleChange} />
            <Form.Group widths="equal">
              <Form.Checkbox name="autoHeight" label={this.getLocalValue('autoheightfield', 'Auto Height', "gridform")} checked={Boolean(data.autoHeight)} onChange={handleChange} />
              <Form.Input name="offSet" label={this.getLocalValue('offsetfield', 'OffSet', "gridform")} disabled={!Boolean(data.autoHeight)} value={data.offSet} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
        <div className="field">
            <CollectionEditor key="columns" 
                draggable={true}
                columns={columns} 
                label={this.getLocalValue('columnsfield', 'Columns', "gridform")}
                name="columns" 
                value={data["columns"]}
                onChange={handleChange} />
          </div>
      </Form>);
  }
  
  getEventsList(){
    return ["onRowClick", "onRowDblClick", "onSelectionChanged"];
  }
}
class CollectionEditorEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var me = this;
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    var columns = [
      {key: 'key', name: this.getLocalValue('keycolumn', 'Key', "collectioneditorform")}, 
      {key: 'name', name: this.getLocalValue('namecolumn', 'Name', "collectioneditorform")}, 
      {key: 'control', name: this.getLocalValue('controlcolumn', 'Control', "collectioneditorform"), dataList:["input", "checkbox", "span", "number", "file", "date", "datetime", "custom"]},
      {key: 'width', name: this.getLocalValue('widthcolumn', 'Width', "collectioneditorform")}
    ];

    var sizedata = [
      {text: this.getLocalValue('sizedefault', 'Default'), value: ''},
      {text: this.getLocalValue('sizemini', 'Mini'), value: 'mini'},
      {text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny'},
      {text: this.getLocalValue('sizesmall', 'Small'), value: 'small'},
      {text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium'},
      {text: this.getLocalValue('sizelarge', 'Large'), value: 'large'},
      {text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge'}];

  

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "collectioneditorform")} value={data.key} onChange={handleChange} />
          <Form.Input name="idField" label={this.getLocalValue('idfield', 'Id field', "collectioneditorform")} disabled={data.hierarchical != true} value={data.idField} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "collectioneditorform")}</label>
            <Form.Group>
              <Form.Checkbox name="readOnly" label={this.getLocalValue('readonlyfield', 'ReadOnly', "collectioneditorform")} checked={data.readOnly} onChange={handleChange} />
              <Form.Checkbox name="draggable" label={this.getLocalValue('draggablefield', 'Draggable', "collectioneditorform")} checked={data.draggable} onChange={handleChange} />
              <Form.Checkbox name="hierarchical" label={this.getLocalValue('hierarchicalfield', 'Hierarchical', "collectioneditorform")} checked={data.hierarchical} onChange={handleChange} />
        
            </Form.Group>
            <Form.Group>
            <Form.Checkbox name="disableAdd" label={this.getLocalValue('disableAdd', 'Disable Add', "collectioneditorform")} checked={data.disableAdd} onChange={handleChange} />
            <Form.Checkbox name="disableDelete" label={this.getLocalValue('disableDelete', 'Disable Delete', "collectioneditorform")} checked={data.disableDelete} onChange={handleChange} /> 
              <Form.Checkbox name="collapseAll" label={this.getLocalValue('collapseallfield', 'Collapse all', "collectioneditorform")} disabled={data.hierarchical != true} checked={data.collapseAll} onChange={handleChange} />
            </Form.Group>
            
            <Form.Group>
            <Form.Checkbox name="header" label="Display Header" checked={data.header} onChange={handleChange} />
            </Form.Group>
            
            <Form.Group widths="equal">
            <Form.Input name="headerTitle" label="Header" value={data.headerTitle} disabled={data.header != true} onChange={handleChange} />
            <Form.Dropdown name="headerSize" selection fluid options={sizedata} placeholder="Coming soon" label={this.getLocalValue('sizefield', 'Size', "header")} value={data.headerSize} disabled={true} onChange={handleChange} />
            </Form.Group>
          </div>
          <div className="field">
            <Form.Input name="parentIdField" label={this.getLocalValue('parentidfield', 'ParentId field', "collectioneditorform")} disabled={data.hierarchical != true} value={data.parentIdField} onChange={handleChange} />
            <Form.Input name="childrenField" label={this.getLocalValue('childrenField', 'Children field', "collectioneditorform")} disabled={data.hierarchical != true || (data.parentIdField !== undefined && data.parentIdField !== "")} value={data.childrenField} onChange={handleChange} />
          </div>
        </Form.Group>
        <CollectionEditor key="columns" 
              columns={columns}
              label={this.getLocalValue('columnsfield', 'Columns', "collectioneditorform")}
              name="columns" 
              value={data["columns"]}
              height="200px"
              onChange={handleChange} />
      </Form>);
  }

  getEventsList(){
    return ["onChange", "onAdd", "onDelete"];
  }
}

class CustomEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  
    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "customform")} value={data.key} onChange={handleChange} />
          <Form.Input name="type" label={this.getLocalValue('typefield', 'Type control', "customform")} value={data.type} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <Form.TextArea key="props" label={this.getLocalValue('propsfield', 'Props', "customform")} name="props" 
              value={data["props"]} 
              onChange={handleChange}
              rows={5} />
          <Form.TextArea key="children" label={this.getLocalValue('childrenfield', 'Children', "customform")} name="children" 
              value={data["children"]} 
              onChange={handleChange}
              rows={5} />
          </Form.Group>
        </Form>);
  }
}

class CustomBlockEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  
  
    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "customblockform")} value={data.key} onChange={handleChange} />
          <div className="field">
            <label>{this.getLocalValue('sourcetypefield', 'Source type', "customblockform")}</label>
            <Form.Group>
              <Form.Radio name="sourceType" label={this.getLocalValue('sourcetypeformfield', 'Form name', "customblockform")} value="form" checked={data.sourceType === undefined || data.sourceType == 'form' } onChange={handleChange} />
              <Form.Radio name="sourceType" label={this.getLocalValue('sourcetypejsonfield', 'JSON source', "customblockform")} value="source" checked={data.sourceType === 'source'} onChange={handleChange} />
              <Form.Radio name="sourceType" label={this.getLocalValue('placeholderfield', 'Placeholder', "customblockform")} value="placeholder" checked={data.sourceType === 'placeholder'} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
        <Form.Input name="formname" label={this.getLocalValue('formnamefield', 'Form name', "customblockform")} value={data.formname} onChange={handleChange} 
            disabled={data.sourceType != undefined && data.sourceType != 'form'} />
        <Form.TextArea key="source" label={this.getLocalValue('sourcefield', 'JSON source', "customblockform")} name="source" 
            value={data["source"]} onChange={handleChange} rows={10}
            disabled={data.sourceType != 'source'}  />
        </Form>);
  }
}

class MenuEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    var columns = [
      {key: 'target', name: this.getLocalValue('itemstargetcolumn', 'Target', "menuform"), width: 150},
      {key: 'title', name: this.getLocalValue('itemstitlecolumn', 'Title', "menuform")},
    //{key: 'visibleCondition', name: this.getLocalValue('visibleConditioncolumn', 'Visible Condition', "menuform")}
    ];
    return (<Form>
      <Form.Group widths="equal">
        <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "menuform")} value={data.key} onChange={handleChange} />
        <Form.Input name="activeitem" label={this.getLocalValue('activeitemfield', 'Active Item', "menuform")} value={data.activeitem} onChange={handleChange} />
      </Form.Group>
      <div className="field">
          <label>{this.getLocalValue('optionsfield', 'Options', "menuform")}</label>
          <Form.Group>
            <Form.Checkbox name="pointing" label={this.getLocalValue('pointingfield', 'Pointing', "menuform")} checked={data.pointing} onChange={handleChange} />
            <Form.Checkbox name="secondary" label={this.getLocalValue('secondaryfield', 'Secondary', "menuform")} checked={data.secondary } onChange={handleChange} />
            <Form.Checkbox name="tabular" label={this.getLocalValue('tabularfield', 'Tabular', "menuform")} checked={data.tabular } onChange={handleChange} />
            <Form.Checkbox name="fluid" label={this.getLocalValue('fluidfield', 'Fluid', "menuform")} checked={data.fluid } onChange={handleChange} />
            <Form.Checkbox name="vertical" label={this.getLocalValue('verticalfield', 'Vertical', "menuform")} checked={data.vertical } onChange={handleChange} />
            {/* <Form.Checkbox name="link" label={this.getLocalValue('linkfield', 'Link', "menuform")} checked={data.link } onChange={handleChange} /> */}
          </Form.Group>
      </div>
      <CollectionEditor key="items" 
              draggable={true}
              hierarchical={true}
              childrenField="children"
              columns={columns} 
              label={this.getLocalValue('itemsfield', 'Items', "menuform")}
              name="items" 
              value={data["items"]}
              onChange={handleChange} />
      </Form>);
  }

  getEventsList(){
    return ["onItemClick"];
  }
}

class BreadcrumbEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    var columns = [
      {key: 'text', name: this.getLocalValue('itemstextcolumn', 'Text', "breadcrumbform")},
      {key: 'url', name: this.getLocalValue('itemsurlcolumn', 'Url', "breadcrumbform")},
      {key: 'active', control:'checkbox', name: this.getLocalValue('itemsactivecolumn', 'Active', "breadcrumbform")},
      {key: 'divider', name: this.getLocalValue('itemsiconcolumn', 'Divider Icon', "breadcrumbform"), dataList:["right angle", "right chevron"]}
    ];
    return (<Form>
      <Form.Group widths="equal">
        <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "breadcrumbform")} value={data.key} onChange={handleChange} />
      </Form.Group>
      <CollectionEditor key="items" 
              draggable={true}
              columns={columns} 
              label={this.getLocalValue('itemsfield', 'Items', "breadcrumbform")}
              name="items" 
              value={data["items"]}
              onChange={handleChange} />
      </Form>);
  }

  getEventsList(){
    return ["onItemClick"];
  }
}

class DropdownTriggerEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    var columns = [
      {key: 'target', name: this.getLocalValue('itemstargetcolumn', 'Target', "dropdowntriggerform")},
      {key: 'title', name: this.getLocalValue('itemstitlecolumn', 'Title', "dropdowntriggerform")},
      {key: 'visibleCondition', name: this.getLocalValue('itemsvisibleconditioncolumn', 'Visible Condition', "dropdowntriggerform")}
    ];

    return (<Form>
      <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "dropdowntriggerform")} value={data.key} onChange={handleChange} />
      <Form.Input name="defaultValue" label={this.getLocalValue('defaultvaluefield', 'Default Value', "dropdowntriggerform")} value={data.defaultValue == undefined ? "": data.defaultValue} onChange={handleChange} />
      <Form.Input name="imageUrl" label={this.getLocalValue('imageurlfield', 'ImageUrl', "dropdowntriggerform")} value={data.imageUrl == undefined ? "": data.imageUrl} onChange={handleChange} />
      <CollectionEditor key="items" 
              draggable={true}
              columns={columns} 
              label={this.getLocalValue('itemsfield', 'Items', "dropdowntriggerform")} 
              name="items" 
              value={data["items"]}
              onChange={handleChange} />
      </Form>);
  }

  getEventsList(){
    return ["onItemClick"];
  }
}

//----------
//Chart
//----------
class ChartEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);

    var legendPositionOptions = [
      {value: "", text: this.getLocalValue('legendpositiondefaultfield', 'Default', "chartform")},
      {value: "top", text: this.getLocalValue('legendpositiontopfield', 'Top', "chartform")},
      {value: "left", text: this.getLocalValue('legendpositionleftfield', 'Left', "chartform")},
      {value: "bottom", text: this.getLocalValue('legendpositionbottomfield', 'Bottom', "chartform")},
      {value: "right", text: this.getLocalValue('legendpositionrightfield', 'Right', "chartform")}
    ];
   
    var disableCustom = data.datasetCustom == "" || data.datasetCustom == undefined;
    return (<Form>
        <Form.Group widths="equal">
          <div className="field">
            <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "chartform")} value={data.key} onChange={handleChange} />
            <Form.Input name="title" label={this.getLocalValue('titlefield', 'Title', "chartform")} value={data.title} onChange={handleChange} />
            <Form.Input name="titleSize" label={this.getLocalValue('titlesizefield', 'Title size', "chartform")} value={data.titleSize} onChange={handleChange} />
            <Form.Dropdown name="legendPosition" selection fluid label={this.getLocalValue('legendpositionfield', 'Legend position', "chartform")} placeholder={legendPositionOptions[0].text} options={legendPositionOptions} value={data.legendPosition} onChange={handleChange} />
          </div> 
          <div className="field">
            <Form.Checkbox name="responsive" label={this.getLocalValue('responsivefield', 'Responsive', "chartform")} checked={data.responsive} onChange={handleChange} />
            <Form.Checkbox name="datasetCustom" label={this.getLocalValue('datasetcustomfield', 'Dataset custom', "chartform")} checked={data.datasetCustom} onChange={handleChange} />
            <Form.Input name="dataLabels" style={{paddingTop: "5px"}} disabled={disableCustom} placeholder={this.getLocalValue('datalabelsplaceholder', 'Q1, Q2, Q3, Q4', "chartform")} 
                    label={this.getLocalValue('datalabelsfield', 'Data labels', "chartform")} value={data.dataLabels} onChange={handleChange} />
            <Form.Input name="datasetLabel" disabled={disableCustom} label={this.getLocalValue('datasetlabelfield', 'Dataset Label', "chartform")} value={data.datasetLabel} onChange={handleChange} />
            <Form.Input name="datasetBackgroundColor" disabled={disableCustom} label={this.getLocalValue('datasetbackgroundcolorfield', 'Dataset BackgroundColor', "chartform")} value={data.datasetBackgroundColor} onChange={handleChange} />
          </div>
        </Form.Group>
      </Form>);
  }
}

class SwzPageEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  
    var onImage = data.onimage ? 'block' : 'none';
    var onFileStorage = data.filetoken !== undefined && data.filetoken !== '';
    if(onFileStorage){
      var fileUrl = "/data/download/" + data.filetoken;
      data.imagesrc = fileUrl;
    }
    
    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "containerform")} value={data.key} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <div className="field">
            <Form.Group widths="equal">
              <Form.Input name="headerlabel" label="Header label" value={data.headerlabel} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="onstatusbar" label="Display status bar" checked={data.onstatusbar} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="onmenu" label="Display page menu" checked={data.onmenu} onChange={handleChange} />
            </Form.Group>
            {/* <Form.Group>
              <Form.Checkbox name="onimage" label="Display image" checked={data.onimage} onChange={handleChange} />
            </Form.Group> */}
            <div style={{display: onImage}}>
            <Form.Group>
              <Form.Input name="imagesrc" label="Image source" value={data.imagesrc} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Input type="number" name="imagewidth" label="Image width (px)" value={data.imagewidth} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <div className="field">
              <label>Import image</label>
                <Upload
                    key={data.key} 
                    name="filetoken" 
                    value={data.filetoken}
                    type="file"
                    downloadUrl="/data/download/"
                    uploadUrl="/data/upload/"
                    islocalstorage={true}
                    onChange={handleChange}
                    authorisedfiletypes = ".JPG,.jpg,.PNG,.png,.JPEG,.jpeg,.GIF,.gif"
                />
              </div>
            </Form.Group>
            </div>
            <label>Header display buttons</label>
            <Form.Group>
              <Form.Checkbox name="lastsaved" label="Skip to last saved" checked={data.lastsaved} onChange={handleChange} />
              <Form.Checkbox name="print" label="Print" checked={data.print} onChange={handleChange} />
            </Form.Group>
            </div>
          </Form.Group>

        <Form.Group widths="equal">
          <div className="field">
            <Form.Group widths="equal">
              <Form.Input name="footerlabel" label="Footer label" value={data.footerlabel} onChange={handleChange} />
            </Form.Group>
            <label>Footer Display Buttons</label>
            <Form.Group>
              <Form.Checkbox name="back" label="Back" checked={data.back} onChange={handleChange} />
              <Form.Checkbox name="next" label="Next" checked={data.next} onChange={handleChange} />
              <Form.Checkbox name="exit" label="Exit" checked={data.exit} onChange={handleChange} />
              <Form.Checkbox name="cancel" label="Cancel" checked={data.cancel} onChange={handleChange} />
              </Form.Group>
            <Form.Group>
              <Form.Checkbox name="save" label="Save" checked={data.save} onChange={handleChange} />
              <Form.Checkbox name="saveexit" label="Save and exit" checked={data.saveexit} onChange={handleChange} />
              <Form.Checkbox name="submit" label="Submit" checked={data.submit} onChange={handleChange} />
            </Form.Group>
            </div>
          </Form.Group>
          <Form.Group widths="equal">
            <div className="field" style={{display:"none"}}>
              <label>Page Display</label>
              <Form.Checkbox name="onpagedisplay" label="Main page" checked={data.onpagedisplay} disabled={false} onChange={handleChange} />
              <Form.Checkbox name="onscrolltoview" label="Scroll Into View" checked={data.onscrolltoview} disabled={false} onChange={handleChange} />
              <Form.Checkbox name="buildermode" label="Builder Mode" checked={data.buildermode} disabled={false} onChange={handleChange} />
              <Form.Input name="items" label="Menu Items" value={data.items} disabled={false} onChange={handleChange} />
              <Form.Input name="validatedpages" label="Validated Pages" value={data.validatedpages} disabled={false} onChange={handleChange} />
            </div>
          </Form.Group>
      </Form>);
  }
  getEventsList(){
    return ["onClickBack", "onClickNext", "onClickNextNonUpdatedSurvey", "onClickExit", "onClickCancel", "onClickSave", "onClickSaveExit", "onClickSubmit", "onPageValidationStatus", "onClickLastSaved", "onClickItem", "onClickPrint", "onPageInit"];
  }
}

class SwzTableEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }

  getTableIndex = (rows, columns, action) => {
    var data = this.props.data;
    if(data.tableindex !== undefined && data.tableindex.length > 0){
      return data.tableindex
    }else{
      var tableIndex = [];
      var item;
      var tableIndexObj = {};
      
      if(action == "array"){
        if(rows < 0 || columns < 0)
          return
        for(let i = 0; i < rows; i++){
          for(let j = 0; j < columns; j++){
            let row = i + 1;
            let column = j + 1
            item = row + '_' + column
            tableIndex.push(item);
          }
        }
        return tableIndex
      }else{
          if(action == "dictionary"){
            if(rows < 0 || columns < 0)
            return
          for(let i = 0; i < rows; i++){
            for(let j = 0; j < columns; j++){
              let row = i + 1;
              let column = j + 1
              item = row + '_' + column
              tableIndexObj[item] = true;
            }
          }
          return tableIndexObj
          }
      }
    }
  }

  validation = (value) => {
    if(value > 20){
      alert("Select a number below 20");
      return 0
    }else{
      return value
    }
  }

  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    var numberdata = [
      {text: 1, value: 1},
      {text: 2, value: 2},
      {text: 3, value: 3},
      {text: 4, value: 4},
      {text: 5, value: 5},
      {text: 6, value: 6},
      {text: 7, value: 7},
      {text: 8, value: 8},
      {text: 9, value: 9},
      {text: 10, value: 10},
      {text: 11, value: 11},
      {text: 12, value: 12},
      {text: 13, value: 13},
      {text: 14, value: 14},
      {text: 15, value: 15},
      {text: 16, value: 16},
      {text: 17, value: 17},
      {text: 18, value: 18},
      {text: 19, value: 19},
      {text: 20, value: 20},
      {text: 21, value: 21},
      {text: 22, value: 22},
      {text: 23, value: 23},
      {text: 24, value: 24},
      {text: 25, value: 25},
      {text: 26, value: 26},
      {text: 27, value: 27},
      {text: 28, value: 28},
      {text: 29, value: 29},
      {text: 30, value: 30},
      {text: 31, value: 31},
      {text: 32, value: 32},
      {text: 33, value: 33},
      {text: 34, value: 34},
      {text: 35, value: 35},
      {text: 36, value: 36},
      {text: 37, value: 37},
      {text: 38, value: 38},
      {text: 39, value: 39},
      {text: 40, value: 40},
      {text: 41, value: 41},
      {text: 42, value: 42},
      {text: 43, value: 43},
      {text: 44, value: 44},
      {text: 45, value: 45},
      {text: 46, value: 46},
      {text: 47, value: 47},
      {text: 48, value: 48},
      {text: 49, value: 49},
      {text: 50, value: 50},
      {text: 51, value: 51},
      {text: 52, value: 52},
      {text: 53, value: 53},
      {text: 54, value: 54},
      {text: 55, value: 55},
      {text: 56, value: 56},
      {text: 57, value: 57},
      {text: 58, value: 58},
      {text: 59, value: 59},
      {text: 60, value: 60},
      {text: 61, value: 61},
      {text: 62, value: 62},
      {text: 63, value: 63},
      {text: 64, value: 64},
      {text: 65, value: 65},
      {text: 66, value: 66},
      {text: 67, value: 67},
      {text: 68, value: 68},
      {text: 69, value: 69},
      {text: 70, value: 70},
      {text: 71, value: 71},
      {text: 72, value: 72},
      {text: 73, value: 73},
      {text: 74, value: 74},
      {text: 75, value: 75},
      {text: 76, value: 76},
      {text: 77, value: 77},
      {text: 78, value: 78},
      {text: 79, value: 79},
      {text: 80, value: 80},
      {text: 81, value: 81},
      {text: 82, value: 82},
      {text: 83, value: 83},
      {text: 84, value: 84},
      {text: 85, value: 85},
      {text: 86, value: 86},
      {text: 87, value: 87},
      {text: 88, value: 88},
      {text: 89, value: 89},
      {text: 90, value: 90},
      {text: 91, value: 91},
      {text: 92, value: 92},
      {text: 93, value: 93},
      {text: 94, value: 94},
      {text: 95, value: 95},
      {text: 96, value: 96},
      {text: 97, value: 97},
      {text: 98, value: 98},
      {text: 99, value: 99},
      {text: 100, value: 100},
    ];
    var tablealigndata = [
      {text: 'Left', value: 'left'},
      {text: 'Center', value: 'center'},
      {text: 'Right', value: 'right'},
    ];
    var bordertypedata = [
      {text: 'None', value: 'none'},
      {text: 'Solid', value: 'solid'},
      {text: 'Dotted', value: 'dotted'},
      {text: 'Dashed', value: 'dashed'}
    ];
    var borderlinedata = [
      {text: 'Full border', value: 'border'},
      {text: 'Border top', value: 'border-top'},
      {text: 'Border bottom', value: 'border-bottom'},
      {text: 'Border left', value: 'border-left'},
      {text: 'Border right', value: 'border-right'}
    ];
    var onTableProperties = data.columns == undefined|| data.rows == undefined ? {
      "display": "none"
      } : {
      "display": "block"
      }
    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "containerform")} value={data.key} onChange={handleChange} />
        </Form.Group>
        <Form.Group>
          <Form.Dropdown style={{width: "200px"}} name="columns" selection fluid options={numberdata} label="No. of Columns" value={data.columns} onChange={handleChange} /> 
        </Form.Group>
        <Form.Group>
          <Form.Dropdown style={{width: "200px"}} name="rows" selection fluid options={numberdata} label="No. of Rows" value={data.rows} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
        <div className="field" style={{...onTableProperties}}>
          <label>Table Styling</label>
            <Form.Group>
              <Form.Input name="tableheight" label="Height (px)" value={data['tableheight']} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Input name="tablewidth" label="Width (px)" value={data['tablewidth']} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Input type="number" name="cellpadding" label="Cell Padding (px)" value={data['cellpadding']} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Dropdown style={{width: "200px"}} name="tablealign" selection fluid options={tablealigndata} label="Alignment" value={data.tablealign} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Dropdown style={{width: "200px"}} name="bordertype" selection fluid options={bordertypedata} label="Border Type" value={data.bordertype} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Dropdown style={{width: "200px"}} name="borderline" selection fluid options={borderlinedata} label="Border Line" value={data.borderline} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Input disabled={data.bordertype == "none" || data.bordertype == undefined || data.bordertype == null} type="number" name="borderwidth" label="Border Width (px)" value={data['borderwidth']} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Input disabled={data.bordertype == "none" || data.bordertype == undefined || data.bordertype == null} name="bordercolor" label="Border Color" value={data['bordercolor']} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
        <Form.Group widths="equal">
            <div className="field" style={{display:"none"}}>
              {/* <label>Page Display</label> */}
              <Form.Input disabled={true} name="tableindex" label="Table Index" value={data['tableindex'] = this.getTableIndex(data.rows, data.columns, "array")} onChange={handleChange} />
              <Form.Input disabled={true} name="uniqueRowsColumns" label="Table Index Dictionary" value={/* data['tableindexdict'] = this.getTableIndex(data.rows, data.columns, "dictionary") */ data.uniqueRowsColumns} onChange={handleChange} />
              <Form.Input disabled={true} name="spandict" label="Table Span Dictionary" value={/* data['tableindexdict'] = this.getTableIndex(data.rows, data.columns, "dictionary") */ data.spandict} onChange={handleChange} />
            </div>
          </Form.Group>
      </Form>);
  }
}

class SwzModalEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;

    var displaydata = [
      {text: this.getLocalValue('displaynonefield', 'None', "swzcontainerform"), value: 'none'},
      {text: this.getLocalValue('displayblockfield', 'Block', "swzcontainerform"), value: 'block'},
    ]

    var sizedata = [
      {text: this.getLocalValue('sizedefault', 'Default'), value: ''},
      {text: this.getLocalValue('sizemini', 'Mini'), value: 'mini'},
      {text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny'},
      {text: this.getLocalValue('sizesmall', 'Small'), value: 'small'},
      {text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium'},
      {text: this.getLocalValue('sizebig', 'Big'), value: 'big'},
      {text: this.getLocalValue('sizelarge', 'Large'), value: 'large'},
      {text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge'},
      {text: this.getLocalValue('sizemassive', 'Massive'), value: 'massive'}
    ];

    return (
      <Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "swzcontainerform")} value={data.key} onChange={handleChange} />
          <Form.Dropdown name="style-display" options={displaydata} placeholder={null} label={this.getLocalValue('displayfield', 'Display', "swzcontainerform")} value={data["style-display"]} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <Form.Input name="content" label={this.getLocalValue('contentfield', 'Content', "buttonform")} value={data.content} onChange={handleChange} />
          <Form.Dropdown name="size" options={sizedata} placeholder="Default" label={this.getLocalValue('sizefield', 'Size', "buttonform")} value={data.size} onChange={handleChange} />
        </Form.Group>
        <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "buttonform")}</label>
            <Form.Group>
              <Form.Checkbox name="basic" label={this.getLocalValue('basicfield', 'Basic', "buttonform")} checked={data.basic} onChange={handleChange} />
              <Form.Checkbox name="compact" label={this.getLocalValue('compactfield', 'Compact', "buttonform")} checked={data.compact} onChange={handleChange} />
              <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "buttonform")} checked={data.disabled } onChange={handleChange} />
            </Form.Group>
            <Form.Group>
             <Form.Checkbox name="inverted" label={this.getLocalValue('invertedfield', 'Inverted', "buttonform")} checked={data.inverted } onChange={handleChange} />
             <Form.Checkbox name="primary" label={this.getLocalValue('primaryfield', 'Primary', "buttonform")} checked={data.primary} onChange={handleChange} />
              <Form.Checkbox name="secondary" label={this.getLocalValue('secondaryfield', 'Secondary', "buttonform")} checked={data.secondary } onChange={handleChange} />
           
            </Form.Group>
          </div>
        
        <Form.Group widths="equal">
        <div className="field">
          <label>{"Modal State"}</label>
           {/* <Form.Checkbox name="isOpen" label={this.getLocalValue('openModal', 'isOpen', "swzcontainerform")} checked={data.isOpen} onChange={handleChange} />
           */ }<Form.Input name="isOpen" label={this.getLocalValue('openModal', 'isOpen', "swzcontainerform")}value={data.isOpen} onChange={handleChange} />
         </div>
        </Form.Group>
      </Form>
      );
      
  }
  getEventsList(){
    return ["onClick"];
  }
}

class SwzScannerEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;

    var displaydata = [
      {text: this.getLocalValue('displaynonefield', 'None', "swzcontainerform"), value: 'none'},
      {text: this.getLocalValue('displayblockfield', 'Block', "swzcontainerform"), value: 'block'},
    ]

    var sizedata = [
      {text: this.getLocalValue('sizedefault', 'Default'), value: ''},
      {text: this.getLocalValue('sizemini', 'Mini'), value: 'mini'},
      {text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny'},
      {text: this.getLocalValue('sizesmall', 'Small'), value: 'small'},
      {text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium'},
      {text: this.getLocalValue('sizebig', 'Big'), value: 'big'},
      {text: this.getLocalValue('sizelarge', 'Large'), value: 'large'},
      {text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge'},
      {text: this.getLocalValue('sizemassive', 'Massive'), value: 'massive'}
    ];

    return (
      <Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "swzcontainerform")} value={data.key} onChange={handleChange} />
          <Form.Dropdown name="style-display" options={displaydata} placeholder={null} label={this.getLocalValue('displayfield', 'Display', "swzcontainerform")} value={data["style-display"]} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <Form.Dropdown name="size" options={sizedata} placeholder="Default" label={this.getLocalValue('sizefield', 'Size', "buttonform")} value={data.size} onChange={handleChange} />
        </Form.Group>
        <Form.Group style={{display: 'none'}} widths="equal">
          <Form.Input name="scanValue" label={"Scanned Value"} value={data.scanValue} onChange={handleChange} />
        </Form.Group>
        <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "buttonform")}</label>
            <Form.Group>
              <Form.Checkbox name="basic" label={this.getLocalValue('basicfield', 'Basic', "buttonform")} checked={data.basic} onChange={handleChange} />
              <Form.Checkbox name="compact" label={this.getLocalValue('compactfield', 'Compact', "buttonform")} checked={data.compact} onChange={handleChange} />
              <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "buttonform")} checked={data.disabled } onChange={handleChange} />
            </Form.Group>
            <Form.Group>
             <Form.Checkbox name="inverted" label={this.getLocalValue('invertedfield', 'Inverted', "buttonform")} checked={data.inverted } onChange={handleChange} />
             <Form.Checkbox name="primary" label={this.getLocalValue('primaryfield', 'Primary', "buttonform")} checked={data.primary} onChange={handleChange} />
              <Form.Checkbox name="secondary" label={this.getLocalValue('secondaryfield', 'Secondary', "buttonform")} checked={data.secondary } onChange={handleChange} />     
            </Form.Group>
          </div>
      </Form>
      );
      
  }
  getEventsList(){
    return ["onChange", "onChangeTimeOut"];
  }
}

class SwzCaptchaEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;

    var sizedata = [
      {text: this.getLocalValue('sizedefault', 'Default'), value: ''},
      {text: this.getLocalValue('sizemini', 'Mini'), value: 'mini'},
      {text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny'},
      {text: this.getLocalValue('sizesmall', 'Small'), value: 'small'},
      {text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium'},
      {text: this.getLocalValue('sizebig', 'Big'), value: 'big'},
      {text: this.getLocalValue('sizelarge', 'Large'), value: 'large'},
      {text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge'},
      {text: this.getLocalValue('sizemassive', 'Massive'), value: 'massive'}
    ];

    return (
      <Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "swzcontainerform")} value={data.key} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <Form.Dropdown name="size" options={sizedata} placeholder="Default" label={this.getLocalValue('sizefield', 'Size', "buttonform")} value={data.size} onChange={handleChange} />
        </Form.Group>
        <Form.Group style={{display: 'none'}} widths="equal">
          <Form.Input name="scanValue" label={"Scanned Value"} value={data.scanValue} onChange={handleChange} />
        </Form.Group>
        <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "buttonform")}</label>
            <Form.Group>
              <Form.Checkbox name="basic" label={this.getLocalValue('basicfield', 'Basic', "buttonform")} checked={data.basic} onChange={handleChange} />
              <Form.Checkbox name="compact" label={this.getLocalValue('compactfield', 'Compact', "buttonform")} checked={data.compact} onChange={handleChange} />
              <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "buttonform")} checked={data.disabled } onChange={handleChange} />
            </Form.Group>
            <Form.Group>
             <Form.Checkbox name="inverted" label={this.getLocalValue('invertedfield', 'Inverted', "buttonform")} checked={data.inverted } onChange={handleChange} />
             <Form.Checkbox name="primary" label={this.getLocalValue('primaryfield', 'Primary', "buttonform")} checked={data.primary} onChange={handleChange} />
              <Form.Checkbox name="secondary" label={this.getLocalValue('secondaryfield', 'Secondary', "buttonform")} checked={data.secondary } onChange={handleChange} />     
            </Form.Group>
          </div>
      </Form>
      );
      
  }
  getEventsList(){
    return ["onChange", "onChangeTimeOut"];
  }
}

module.exports = {
  BaseEditControl,
  HeaderEditControl,
  ButtonEditControl,
  InputEditControl,
  TextAreaEditControl,
  DropdownEditControl,
  RadioGroupEditControl,
  CheckboxEditControl,
  FormEditControl,
  FormGroupEditControl,
  ImageEditControl, 
  GridEditControl,
  CustomEditControl,
  MenuEditControl,
  ChartEditControl,
  ContainerEditControl,
  SwzStaticContentEditControl,
  CollectionEditorEditControl,
  CustomBlockEditControl,
  DropdownTriggerEditControl,
  BreadcrumbEditControl,
  SwzModalEditControl,
  SwzPageEditControl,
  SwzTableEditControl,
  SwzScannerEditControl,
  SwzCaptchaEditControl,
  DplyChoiceQnnsEditControl
}









