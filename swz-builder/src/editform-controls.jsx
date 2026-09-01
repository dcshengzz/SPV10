import React from 'react';
import {Menu, Form, Grid, Card, Input, Dropdown, Checkbox, TextArea, Button, Icon, Message, Image, Label, Header, Item, Segment, Modal} from 'semantic-ui-react'
import CollectionEditor from './control/collectioneditor'
import JSON5 from 'json5'
import EventsEditor from './control/eventseditor'
import RadioGroup from './control/radiogroup'


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

    if(local == undefined || local[block] == undefined ||  local[block][key] == undefined)
      return defaultvalue;
    return local[block][key];
  }

  handleItemClick(e, { name }){
    this.setState({ activeItem: name }); 
  }

  getDescription(){
    var activeItem = this.state.activeItem;
    
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
      </Form>);
  }

  getStyleDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var stylesource_ps = "/*** Example Code ***/\ncolor:red;\npaddingTop:5px;";
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
          <Image src='/images/cloverbuilder-info.png' height="32px"/>
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
          <Image src='/images/cloverbuilder-info.png' height="32px"/>
          <Message.Content>
            {this.getLocalValue('eventsinfomsg', 'These flags enable processing from this element.')}
          </Message.Content>
        </Message>
        {timeot}
        {content}
      </Form>);
  }

  getOtherDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var customvalidation_ps = "/*** Example Code ***/\nvalue > 10 ? true : 'Must be more 10'";
    var visibleconition_ps = "/*** Example Code ***/\ndata.type == 1 ? true : false";
    var readOnlyconition_ps = "/*** Example Code ***/\ndata.type == 1 ? true : false";

    return (<Form key="otherDescriptionForm">
        <Form.Checkbox name="other-required" label={this.getLocalValue('requiredfield', 'Required')} checked={data["other-required"]} onChange={handleChange} />
        <Form.Checkbox name="other-required-soft" label={this.getLocalValue('requiredfieldissoft', 'Not Enforced')} checked={data["other-required-soft"]} onChange={handleChange} />

        <Form.Input name="defaultValue" label={this.getLocalValue('defaultvaluefield', 'Default value')} value={data["defaultValue"]} onChange={handleChange} />
        <Form.TextArea name="other-customValidation" label={this.getLocalValue('customvalidationfield', 'Custom Validation')} placeholder={customvalidation_ps} value={data["other-customValidation"]} onChange={handleChange} />
        <Form.Checkbox name="other-customValidation-soft" label={this.getLocalValue('customvalidationfieldisrequired', 'Not Enforced')} checked={data["other-customValidation-soft"]} onChange={handleChange} />

        <Form.TextArea name="other-visibleConition" label={this.getLocalValue('visibleconditionfield', 'Visible condition')} placeholder={visibleconition_ps} value={data["other-visibleConition"]} onChange={handleChange} />
        <Form.TextArea name="other-readOnlyConition" label={this.getLocalValue('readonlyconditionfield', 'ReadOnly condition')} placeholder={readOnlyconition_ps} value={data["other-readOnlyConition"]} onChange={handleChange} />
      </Form>);
  }

  render() {
    return (
      <Modal closeOnDimmerClick={false} dimmer='inverted' open={this.props.open} onClose={this.props.onClose.bind(this.props.parent)}>
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

class WordCloudEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "wordcloud")} value={data.key} onChange={handleChange} />
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
          <div className="field">
            <label>{this.getLocalValue('typefield', 'Type', "buttonform")}</label>
            <Form.Group>
              <Form.Radio name="buttonType" label={this.getLocalValue('typenonefield', 'None', "buttonform")} value='' checked={data.buttonType === '' || data.buttonType === undefined} onChange={handleChange} />
              <Form.Radio name="buttonType" label={this.getLocalValue('typesubmitfield', 'Submit', "buttonform")} value='submit' checked={data.buttonType === 'submit'} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
        <Form.Group widths="equal">
          <Form.Input name="content" label={this.getLocalValue('contentfield', 'Content', "buttonform")} value={data.content} onChange={handleChange} />
          <Form.Dropdown name="size" selection fluid options={sizedata} placeholder="Default" label={this.getLocalValue('sizefield', 'Size', "buttonform")} value={data.size} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "buttonform")}</label>
            <Form.Group>
              <Form.Checkbox name="basic" label={this.getLocalValue('basicfield', 'Basic', "buttonform")} checked={data.basic} onChange={handleChange} />
              <Form.Checkbox name="circular" label={this.getLocalValue('circularfield', 'Circular', "buttonform")} checked={data.circular } onChange={handleChange} />
              <Form.Checkbox name="compact" label={this.getLocalValue('compactfield', 'Compact', "buttonform")} checked={data.compact} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "buttonform")} checked={data.disabled } onChange={handleChange} />
              <Form.Checkbox name="fluid" label={this.getLocalValue('fluidfield', 'Fluid', "buttonform")} checked={data.fluid } onChange={handleChange} />
              <Form.Checkbox name="inverted" label={this.getLocalValue('invertedfield', 'Inverted', "buttonform")} checked={data.inverted } onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="loading" label={this.getLocalValue('loadingfield', 'Loading', "buttonform")} checked={data.loading } onChange={handleChange} />
              <Form.Checkbox name="primary" label={this.getLocalValue('primaryfield', 'Primary', "buttonform")} checked={data.primary } onChange={handleChange} />
              <Form.Checkbox name="secondary" label={this.getLocalValue('secondaryfield', 'Secondary', "buttonform")} checked={data.secondary } onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="toggle" label={this.getLocalValue('togglefield', 'Toggle', "buttonform")} checked={data.toggle } onChange={handleChange} />
            </Form.Group>
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

class LabelEditControl extends BaseEditControl{
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

    var attacheddata = [
      {text: this.getLocalValue('attachednone', 'None'), value: ''},
      {text: this.getLocalValue('attachedtop', 'Top'), value: 'top'},
      {text: this.getLocalValue('attachedbottom', 'Bottom'), value: 'bottom'},
      {text: this.getLocalValue('attachedtopright', 'Top right'), value: 'top right'},
      {text: this.getLocalValue('attachedtopleft', 'Top left'), value: 'top left'},
      {text: this.getLocalValue('attachedbottomleft', 'Bottom left'), value: 'bottom left'},
      {text: this.getLocalValue('attachedbottomright', 'Bottom right'), value: 'bottom right'}
    ];

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "labelform")} value={data.key} onChange={handleChange} />
          <Form.Dropdown name="attached" selection fluid options={attacheddata} placeholder={attacheddata[0].text} label={this.getLocalValue('attachedfield', 'Attached', "labelform")} value={data.attached} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="equal">
          <div className="field">
            <Form.Input name="content" label={this.getLocalValue('contentfield', 'Content', "labelform")} value={data.content} onChange={handleChange} />
            <Form.Dropdown name="size" selection fluid options={sizedata} placeholder="Default" label={this.getLocalValue('sizefield', 'Size', "labelform")} value={data.size} onChange={handleChange} />
          </div>
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "labelform")}</label>
            <Form.Group>
              <Form.Checkbox name="basic" label={this.getLocalValue('basicfield', 'Basic', "labelform")} checked={data.basic} onChange={handleChange} />
              <Form.Checkbox name="circular" label={this.getLocalValue('circularfield', 'Circular', "labelform")} checked={data.circular} onChange={handleChange} />
              <Form.Checkbox name="corner" label={this.getLocalValue('cornerfield', 'Corner', "labelform")} checked={data.corner} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="floating" label={this.getLocalValue('floatingfield', 'Floating', "labelform")} checked={data.floating} onChange={handleChange} />
              <Form.Checkbox name="horizontal" label={this.getLocalValue('horizontalfield', 'Horizontal', "labelform")} checked={data.horizontal} onChange={handleChange} />
              <Form.Checkbox name="pointing" label={this.getLocalValue('pointingfield', 'Pointing', "labelform")} checked={data.pointing} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
      </Form>);
  }
}

class StaticContentEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  
    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "staticcontentform")} value={data.key} onChange={handleChange} />
          <Form.Input name="style-font-size" placeholder="20px" label={this.getLocalValue('fontsizefield', 'Font size', "staticcontentform")} value={data["style-font-size"]} onChange={handleChange} />
        </Form.Group>
        <Form.Checkbox name="isHtml" label={this.getLocalValue('allowhtmlfield', 'Allow HTML', "staticcontentform")} checked={data.isHtml} onChange={handleChange} />
        <Form.Checkbox name="isPre" label={this.getLocalValue('isprefield', 'Is Pre', "staticcontentform")} checked={data.isPre} onChange={handleChange} />
        <Form.Checkbox name="fetchData" label="Fetch Data" checked={data.fetchData} onChange={handleChange} />
        <TextArea rows={6} autoHeight={true} name="content" label={this.getLocalValue('contentfield', 'Content', "staticcontentform")} value={data.content} onChange={handleChange} />
      </Form>);
  }
}

class MessageEditControl extends BaseEditControl{
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
          <div className="field">
            <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "messageform")} value={data.key} onChange={handleChange} />
            <Form.Input name="header" label={this.getLocalValue('headerfield', 'Header', "messageform")} value={data.header} onChange={handleChange} />
          </div>
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "messageform")}</label>
            <Form.Group>
              <Form.Checkbox name="compact" label={this.getLocalValue('compactfield', 'Compact', "messageform")} checked={data.compact} onChange={handleChange} />
              <Form.Checkbox name="error" label={this.getLocalValue('errorfield', 'Error', "messageform")} checked={data.error} onChange={handleChange} />
              <Form.Checkbox name="floating" label={this.getLocalValue('floatingfield', 'Floating', "messageform")} checked={data.floating} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="info" label={this.getLocalValue('infofield', 'Info', "messageform")} checked={data.info} onChange={handleChange} />
              <Form.Checkbox name="negative" label={this.getLocalValue('negativefield', 'Negative', "messageform")} checked={data.negative} onChange={handleChange} />
              <Form.Checkbox name="positive" label={this.getLocalValue('positivefield', 'Positive', "messageform")} checked={data.positive} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="success" label={this.getLocalValue('successfield', 'Success', "messageform")} checked={data.success} onChange={handleChange} />
              <Form.Checkbox name="warning" label={this.getLocalValue('warningfield', 'Warning', "messageform")} checked={data.warning} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
        <Form.Group widths="equal">
          <Form.TextArea name="content" label={this.getLocalValue('contentfield', 'Content', "messageform")} value={data.content} onChange={handleChange} />
          <Form.Dropdown name="size" selection fluid options={sizedata} placeholder={sizedata[0].text} label={this.getLocalValue('sizefield', 'Size', "messageform")} value={data.size} onChange={handleChange} />
        </Form.Group>
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
    
    const customPostUrlJsx = (data.type=='file') 
      ? (<Form.Input name="customPostUrl" label={this.getLocalValue('customPostUrl', 'Custom Post URL', "inputform")} 
                     value={data.customPostUrl ? data.customPostUrl : ""} onChange={handleChange} 
                     placeholder="/myController" />)
      : "";

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "inputform")} value={data.key} onChange={handleChange} />
          <Form.Input name="reference" label={this.getLocalValue('referencefield', 'Reference', "inputform")} value={data.reference} onChange={handleChange} />
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
              <Form.Radio name="type" label='swzFile' value='swzfile' checked={data.type === 'swzfile'} onChange={handleChange} />          
            </Form.Group>
            <Form.Group widths="equal">
              <Form.Radio name="type" label={this.getLocalValue('typedate', 'Date', "inputform")} value='date' checked={data.type === 'date'} onChange={handleChange} />
              <Form.Radio name="type" label={this.getLocalValue('typetime', 'Time', "inputform")} value='time' checked={data.type === 'time'} onChange={handleChange} />
              <Form.Radio name="type" label={this.getLocalValue('typedatetime', 'Date & Time', "inputform")} value='datetime' checked={data.type === 'datetime'} onChange={handleChange} />
            </Form.Group>
          </div>
          <div className="field">
            <Form.Dropdown name="labelPosition" selection fluid placeholder={labelPositions[0].text} options={labelPositions} label={this.getLocalValue('labelpositionfield', 'Label position', "inputform")} value={data.labelPosition} onChange={handleChange} />
            <Form.Input name="placeholder" label={this.getLocalValue('placeholderfield', 'Placeholder', "inputform")} value={data.placeholder} onChange={handleChange} />
            {customPostUrlJsx}
          </div>
        </Form.Group>
        <Form.Group widths="equal">
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "inputform")}</label>
            <Form.Group widths="equal">
              <Form.Checkbox name="loading" label={this.getLocalValue('loadingfield', 'Loading', "inputform")} checked={data.loading} onChange={handleChange} />
              <Form.Checkbox name="inverted" label={this.getLocalValue('invertedfield', 'Inverted', "inputform")} checked={data.inverted } onChange={handleChange} />
              <Form.Checkbox name="error" label={this.getLocalValue('errorfield', 'Error', "inputform")} checked={data.error } onChange={handleChange} />
            </Form.Group>
            <Form.Group widths="equal">
              <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "inputform")} checked={data.disabled } onChange={handleChange} />
              <Form.Checkbox name="transparent" label={this.getLocalValue('transparentfield', 'Transparent', "inputform")} checked={data.transparent } onChange={handleChange} />
              <Form.Checkbox name="fluid" label={this.getLocalValue('fluidfield', 'Fluid', "inputform")} checked={data.fluid } onChange={handleChange} />
            </Form.Group>
            <Form.Group widths="equal">
              <Form.Checkbox name="readOnly" label={this.getLocalValue('readonlyfield', 'Read only', "inputform")} checked={data.readOnly } onChange={handleChange} />
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
         </div>
        </Form.Group>
      </Form>);
  }

  getEventsList(){
    return ["onClick", "onChange"];
  }
}

class SearchEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  
    return (<Form>
        <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "searchform")} value={data.key} onChange={handleChange} />
        <Form.Input name="url" label={this.getLocalValue('urlfield', 'Url', "searchform")} value={data.url} onChange={handleChange} />
        <Form.Checkbox name="category" label={this.getLocalValue('categoryfield', 'Enable Categories', "searchform")} checked={Boolean(data.category)} onChange={handleChange} />
      </Form>);
  }

  getEventsList(){
    return ["onSelect"];
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
          <Form.Input name="reference" label={this.getLocalValue('referencefield', 'Reference', "checkboxform")} value={data.reference} onChange={handleChange} />
          <Form.Input name="label" label={this.getLocalValue('labelfield', 'Label', "checkboxform")} value={data.label} onChange={handleChange} />
        </Form.Group>
        <Form.Group widths="2">
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "checkboxform")}</label>
            <Form.Group>
              <Form.Checkbox name="fitted" label={this.getLocalValue('fittedfield', 'Fitted', "checkboxform")} checked={data.fitted} onChange={handleChange} />
              <Form.Checkbox name="indeterminate" label={this.getLocalValue('indeterminatefield', 'Indeterminate', "checkboxform")} checked={data.indeterminate } onChange={handleChange} />
              <Form.Checkbox name="readOnly" label={this.getLocalValue('readonlyfield', 'ReadOnly', "checkboxform")} checked={data.readOnly } onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "checkboxform")} checked={data.disabled } onChange={handleChange} />
              <Form.Checkbox name="slider" label={this.getLocalValue('sliderfield', 'Slider', "checkboxform")} checked={data.slider } onChange={handleChange} />
              <Form.Checkbox name="toggle" label={this.getLocalValue('togglefield', 'Toggle', "checkboxform")} checked={data.toggle } onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
      </Form>);
  }

  getEventsList(){
    return ["onClick", "onChange"];
  }
}

class DropdownEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  
    
    var labelPositions = [
      {text: this.getLocalValue('labeldefault', 'Default'), value: ''},
      {text: this.getLocalValue('labelleft', 'Left'), value: 'left'},
      {text: this.getLocalValue('labelright', 'Right'), value: 'right'},
      {text: this.getLocalValue('labelleftcorner', 'Left corner'), value: 'left corner'},
      {text: this.getLocalValue('labelrightcorner', 'Right corner'), value: 'right corner'}
    ];
    
    var dataColumns = [
      {key: 'value', name: this.getLocalValue('datavaluecolumn', 'Value', "dropdownform")},
      {key: 'text', name: this.getLocalValue('datatextcolumn', 'Text', "dropdownform")}
    ];

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "dropdownform")} value={data.key} onChange={handleChange} />
          <Form.Input name="reference" label={this.getLocalValue('referencefield', 'Reference', "dropdownform")} value={data.reference} onChange={handleChange} />
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
                <Form.Checkbox name="loading" label={this.getLocalValue('loadingfield', 'Loading', "dropdownform")} checked={data.loading} onChange={handleChange} />
                <Form.Checkbox name="error" label={this.getLocalValue('errorfield', 'Error', "dropdownform")} checked={data.error } onChange={handleChange} />
                <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "dropdownform")} checked={data.disabled } onChange={handleChange} />
                <Form.Checkbox name="fluid" label={this.getLocalValue('fluidfield', 'Fluid', "dropdownform")} checked={data.fluid } onChange={handleChange} />
              </Form.Group>
              <Form.Group>
                <Form.Checkbox name="multiple" label={this.getLocalValue('multiplefield', 'Multiple', "dropdownform")} checked={data.multiple } onChange={handleChange} />
                <Form.Checkbox name="search" label={this.getLocalValue('searchfield', 'Search', "dropdownform")} checked={data.search } onChange={handleChange} />
                <Form.Checkbox name="selection" label={this.getLocalValue('selectionfield', 'Selection', "dropdownform")} checked={data.selection } onChange={handleChange} />
              </Form.Group>
              <Form.Group>
                <Form.Checkbox name="readOnly" label={this.getLocalValue('readonlyfield', 'Read only', "dropdownform")} checked={data.readOnly } onChange={handleChange} />
                <Form.Checkbox name="allowAddItems" label={this.getLocalValue('allowAddItemsfield', 'Allow add items', "dropdownform")} disabled={!(data.search && data.multiple)} checked={data.allowAddItems } onChange={handleChange} />
              </Form.Group>
            </div>
          </div>
        </Form.Group>
      </Form>);
  }

  getEventsList(){
    return ["onClick", "onChange"];
  }
}

class DictionaryEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var filterPlaceholder = '[{"column":"columnName","value":"columnValue","term":"="}]';

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "dictionaryform")} value={data.key} onChange={handleChange} />
          <Form.Input name="label" label={this.getLocalValue('labelfield', 'Label', "dictionaryform")} value={data.label} onChange={handleChange} />
          <Form.Input name="reference" label={this.getLocalValue('referencefield', 'Reference', "radiogroupform")} value={data.reference} onChange={handleChange} />
        
        </Form.Group>
        <Form.Group widths="equal">
          <Form.Input name="dataModel" label={this.getLocalValue('datamodelfield', 'Data model', "dictionaryform")} value={data.dataModel} onChange={handleChange} />
          <Form.Input name="placeholder" label={this.getLocalValue('placeholderfield', 'Placeholder', "dictionaryform")} value={data.placeholder} onChange={handleChange} />
        </Form.Group>  
        <Form.Group widths="equal">
          <div className="field">
            <Form.Input name="columns" label={this.getLocalValue('columnsfield', 'Columns (Name ASC, Email)', "dictionaryform")} value={data.columns} onChange={handleChange} />
            <Form.Input name="filters" label={this.getLocalValue('filtersfield', 'Filters', "dictionaryform")} value={data.filters} onChange={handleChange} placeholder={filterPlaceholder} />
            <Form.Input name="pageSize" label={this.getLocalValue('pagesizefield', 'Page Size', "dictionaryform")} disabled={!data.paging} value={data.pageSize} placeholder="100" onChange={handleChange} />
          </div>
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "dictionaryform")}</label>
            <Form.Group>
              <Form.Checkbox name="paging" label={this.getLocalValue('pagingfield', 'Server pagination', "dictionaryform")} checked={data.paging} onChange={handleChange} />
              <Form.Checkbox name="search" label={this.getLocalValue('searchfield', 'Search', "dictionaryform")} checked={data.search } onChange={handleChange} />
              <Form.Checkbox name="multiple" label={this.getLocalValue('multiplefield', 'Multiple', "dictionaryform")} checked={data.multiple } onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Checkbox name="readOnly" label={this.getLocalValue('readonlyfield', 'Read only', "dictionaryform")} checked={data.readOnly } onChange={handleChange} />
              <Form.Checkbox name="disabled" label={this.getLocalValue('disabledfield', 'Disabled', "dictionaryform")} checked={data.disabled } onChange={handleChange} />
              <Form.Checkbox name="clearable" label={this.getLocalValue('clearablefield', 'Clearable', "dictionaryform")} checked={data.clearable } onChange={handleChange} />
              <Form.Checkbox name="selection" label={this.getLocalValue('selectionfield', 'Selection', "dictionaryform")} checked={data.selection } onChange={handleChange} />
            </Form.Group>
            <Form.Group>
                <Form.Checkbox name="fluid" label={this.getLocalValue('fluidfield', 'Fluid', "dictionaryform")} checked={data.fluid } onChange={handleChange} />
                <Form.Checkbox name="error" label={this.getLocalValue('errorfield', 'Error', "dictionaryform")} checked={data.error } onChange={handleChange} />
                <Form.Checkbox name="loading" label={this.getLocalValue('loadingfield', 'Loading', "dictionaryform")} checked={data.loading} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
      </Form>);
  }

  getEventsList(){
    return ["onChange"];
  }
}

class RadioGroupEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);

    var dataColumns = [
      {key: 'value', name: this.getLocalValue('datavaluecolumn', 'Value', "radiogroupform")},
      {key: 'text', name: this.getLocalValue('datatextcolumn', 'Text', "radiogroupform")}
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
              <label>{this.getLocalValue('groupdirectfield', 'Group direct', "radiogroupform")}</label>
              <Form.Radio name="direction" label={this.getLocalValue('directiongorizontalfield', 'Gorizontal', "radiogroupform")} value='g' checked={data.direction === undefined || data.direction === 'g'} onChange={handleChange} />
              <Form.Radio name="direction" label={this.getLocalValue('directionverticalfield', 'Vertical', "radiogroupform")} value='v' checked={data.direction === 'v'} onChange={handleChange} />
              <Form.Group>
                <Form.Checkbox name="readOnly" label={this.getLocalValue('readonlyfield', 'Read only', "radiogroupform")} checked={data.readOnly } onChange={handleChange} />
              </Form.Group>
          </div>
        </Form.Group>
        
        
      </Form>);
  }

  getEventsList(){
    return ["onClick", "onChange"];
  }
}

class FormEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }

  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);

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
          <div className="field">
            <label>{this.getLocalValue('widthsfield', 'Widths', "formgroupform")}</label>
            <Form.Group>
              <Form.Radio name="widths" label={this.getLocalValue('widthsdefaultfield', 'Default', "formgroupform")} checked={ data.widths === undefined } onChange={handleChange} />
              <Form.Radio name="widths" label={this.getLocalValue('widthsequalfield', 'Equal', "formgroupform")} value='equal' checked={data.widths === 'equal'} onChange={handleChange} />
              <Form.Radio name="widths" label={this.getLocalValue('widthscustomfield', 'Custom (1 - 16)', "formgroupform")} value='custom' checked={data.widths === 'custom'} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
        <Form.Group widths="2">
          <div className="field">
            <label>{this.getLocalValue('typefield', 'Type', "formgroupform")}</label>
            <Form.Group inline>
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
    var data = this.props.data;  

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
    
    return (<Form>
         <Form.Group widths="equal">
          <div className="field">
            <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "imageform")} value={data.key} onChange={handleChange} />
            <Form.Input name="src" label={this.getLocalValue('srcfield', 'Src', "imageform")} value={data.src} onChange={handleChange} />
            <Form.Input name="href" label={this.getLocalValue('hreffield', 'Href', "imageform")} value={data.href} onChange={handleChange} />
          </div>
          <div className="field">
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

class StatisticEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    
    var sizedata = [
      {text: this.getLocalValue('sizedefault', 'Default'), value: ''},
      {text: this.getLocalValue('sizemini', 'Mini'), value: 'mini'},
      {text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny'},
      {text: this.getLocalValue('sizesmall', 'Small'), value: 'small'},
      {text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium'},
      {text: this.getLocalValue('sizelarge', 'Large'), value: 'large'},
      {text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge'}
    ];
    
    var datacolumns = [
      {key: 'label', name: this.getLocalValue('datakeycolumn', 'Label', "statisticform")},
      {key: 'value', name: this.getLocalValue('datavaluecolumn', 'Value', "statisticform")}
    ];

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "statisticform")} value={data.key} onChange={handleChange} />
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "statisticform")}</label>
            <Form.Group>
              <Form.Checkbox name="floated" label={this.getLocalValue('floatedfield', 'Floated', "statisticform")} checked={data.floated} onChange={handleChange} />
              <Form.Checkbox name="horizontal" label={this.getLocalValue('horizontalfield', 'Horizontal', "statisticform")} checked={data.horizontal} onChange={handleChange} />
            </Form.Group>
          </div>
        </Form.Group>
        <Form.Group widths="equal">
          <CollectionEditor key="data-elements" 
              columns={datacolumns} 
              label={this.getLocalValue('datafield', 'Data', "statisticform")}
              name="data-elements" 
              value={data["data-elements"]}
              onChange={handleChange} />
          <Form.Dropdown name="size" selection fluid options={sizedata} placeholder={sizedata[0].text} label={this.getLocalValue('sizefield', 'Size', "statisticform")} value={data.size} onChange={handleChange} />
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
      {key: 'resizable', name: this.getLocalValue('resizablecolumn', 'Resizable', "gridform"), control: "checkbox"},
      {key: 'sortable', name: this.getLocalValue('sortablecolumn', 'Sortable', "gridform"), control: 'checkbox'}]
      
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
            <Form.Input name="headerRowHeight" label={"Header row height"} value={data.headerRowHeight} onChange={handleChange} />   
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
class GridWithActionsEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    //console.log("gridwithactions");
   //console.log(data);
    var pagertype = [
      {value: "", text: this.getLocalValue('pagertypenonefield', 'None', "gridform")},
      {value: "server", text: this.getLocalValue('pagertypeserverfield', 'Server', "gridform")},
    ];

    var editformtype = [
      {value: "", text: this.getLocalValue('editformtypedefaultfield', 'Default', "gridform")},
      {value: "modal", text: this.getLocalValue('editformtypemodalfield', 'Modal', "gridform")},
    ];

    let columns = [
      {key: 'key', name: this.getLocalValue('keycolumn', 'Key', "gridform")},
      {key: 'name', name: this.getLocalValue('namecolumn', 'Name', "gridform")},
      {key: 'type', name: this.getLocalValue('typecolumn', 'Type', "gridform"), dataList:["", "number", "checkbox", "link", "date", "datetime", "time","buttons"]},
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
              {data.editType != "flow"  ? <div><Form.Input name="editForm" label={this.getLocalValue('editformfield', 'Edit form', "gridform")} disabled={data.inline == true} value={data.editForm} onChange={handleChange} />  <Form.Input name="reviewForm" label={this.getLocalValue('reviewformfield', 'Review form', "gridform")} disabled={data.inline == true} value={data.reviewForm} onChange={handleChange} /></div> :""}
              {data.editType == "flow" && <Form.Input name="editFlow" label={this.getLocalValue('editflowfield', 'Edit flow', "gridform")} disabled={data.inline == true} value={data.editFlow} onChange={handleChange} />}
            </Form.Group>
            <Form.Input name="rowKey" label={this.getLocalValue('rowkeyfield', 'Row key', "gridform")} value={data.rowKey} onChange={handleChange} />
            <Form.Input name="pageSize" label={this.getLocalValue('pagesizefield', 'Page size', "gridform")} value={data.pageSize} onChange={handleChange} />
            <Form.Input name="defaultSort" label={this.getLocalValue('defaultsortfield', 'Default sort', "gridform")} placeholder="Name ASC" value={data.defaultSort} onChange={handleChange} />
          </div>
          <div className="field">
            <Form.Dropdown name="editFormShowType" label={this.getLocalValue('editformshowtypefield', 'Edit form show type', "gridform")} placeholder={editformtype[0].text} options={editformtype} value={data.editFormShowType} onChange={handleChange} />
            <Form.Dropdown name="pagerType" label={this.getLocalValue('pagertypefield', 'Pagination type', "gridform")} placeholder="None" options={pagertype} value={data.pagerType} onChange={handleChange} />
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

    var columns = [
      {key: 'key', name: this.getLocalValue('keycolumn', 'Key', "collectioneditorform")}, 
      {key: 'name', name: this.getLocalValue('namecolumn', 'Name', "collectioneditorform")}, 
      {key: 'control', name: this.getLocalValue('controlcolumn', 'Control', "collectioneditorform"), dataList:["input", "textarea", "checkbox", "span", "number", "file", "date", "datetime", "custom"]},
      {key: 'width', name: this.getLocalValue('widthcolumn', 'Width', "collectioneditorform")}
    ];

    var sizedata = [
      {text: this.getLocalValue('sizedefault', 'Default'), value: ''},
      {text: this.getLocalValue('sizemini', 'Mini'), value: 'mini'},
      {text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny'},
      {text: this.getLocalValue('sizesmall', 'Small'), value: 'small'},
      {text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium'},
      {text: this.getLocalValue('sizelarge', 'Large'), value: 'large'},
      {text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge'}
    ];

    var layoutOption = [
      {key: 'horizontal', text: 'Horizontal', value: 'horizontal'},
      {key: 'vertical', text: 'Vertical', value: 'vertical'}
    ];

  

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "collectioneditorform")} value={data.key} onChange={handleChange} />
          <Form.Input name="idField" label={this.getLocalValue('idfield', 'Id field', "collectioneditorform")} value={data.idField} onChange={handleChange} />
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

            <Form.Group>
            <Form.Dropdown name="layoutOption" selection options={layoutOption} label={"Layout Option"} value={data.layoutOption} onChange={handleChange} defaultValue="horizontal"/>
            </Form.Group>
          </div>
          <div className="field">
            <Form.Input name="parentIdField" label={this.getLocalValue('parentidfield', 'ParentId field', "collectioneditorform")} disabled={!data.hierarchical || data.childrenField} value={data.parentIdField} onChange={handleChange} />
            <Form.Input name="childrenField" label={this.getLocalValue('childrenField', 'Children field', "collectioneditorform")} disabled={!data.hierarchical || data.parentIdField} value={data.childrenField} onChange={handleChange} />
          </div>
        </Form.Group>
        <CollectionEditor key="columns" 
              draggable={true}
              columns={columns}
              label={this.getLocalValue('columnsfield', 'Columns', "collectioneditorform")}
              name="columns" 
              value={data["columns"]}
              height="200px"
              onChange={handleChange} />
      </Form>);
  }

  getEventsList(){
    return ["onChange", "onAdd", "onDelete", "onCopy"];
  }
}
class CardGridEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);

    var pagertype = [
      {value: "", text: this.getLocalValue('pagertypenonefield', 'None', "cardgridform")},
      {value: "server", text: this.getLocalValue('pagertypeserverfield', 'Server', "cardgridform")},
    ];

    let columns = [
      {key: 'key', name: this.getLocalValue('keycolumn', 'Key', "cardgridform")},
      {key: 'name', name: this.getLocalValue('namecolumn', 'Name', "cardgridform")},
      {key: 'type', name: this.getLocalValue('typecolumn', 'Type', "cardgridform"), dataList:["", "number", "checkbox", "date", "datetime", "time", "custom"]},
      {key: 'icon', name: this.getLocalValue('iconcolumn', 'Icon', "cardgridform")},
      {key: 'group', name: this.getLocalValue('groupcolumn', 'Group', "cardgridform"), dataList:["", "header", "body", "footer"]}]
      
    var editTypeItems = [
      {key: "form", text: "Form", value: undefined},
      {key: "flow", text: "Flow", value: "flow"}
    ];

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "cardgridform")} value={data.key} onChange={handleChange} />
          <div className="field">
            <label>{this.getLocalValue('optionsfield', 'Options', "cardgridform")}</label>
            <Form.Group>
            </Form.Group>
          </div>
        </Form.Group>
        <Form.Group widths="equal">
          <div className="field">
            <Form.Group widths="equal">
              <RadioGroup 
                        name="editType"
                        label={this.getLocalValue('edittypefield', 'Edit type', "cardgridform")}
                        items={editTypeItems}
                        value={data.editType} 
                        onChange={handleChange} >
              </RadioGroup>
              {data.editType != "flow" && <Form.Input name="editForm" label={this.getLocalValue('editformfield', 'Edit form', "cardgridform")} disabled={data.inline == true} value={data.editForm} onChange={handleChange} />}
              {data.editType == "flow" && <Form.Input name="editFlow" label={this.getLocalValue('editflowfield', 'Edit flow', "cardgridform")} disabled={data.inline == true} value={data.editFlow} onChange={handleChange} />}
            </Form.Group>
            <Form.Input name="rowKey" label={this.getLocalValue('rowkeyfield', 'Row key', "cardgridform")} value={data.rowKey} onChange={handleChange} />
            <Form.Input name="pageSize" label={this.getLocalValue('pagesizefield', 'Page size', "cardgridform")} value={data.pageSize} onChange={handleChange} />
            <Form.Input name="defaultSort" label={this.getLocalValue('defaultsortfield', 'Default sort', "cardgridform")} placeholder="Name ASC" value={data.defaultSort} onChange={handleChange} />
          </div>
          <div className="field">
            <Form.Dropdown name="pagerType" selection fluid label={this.getLocalValue('pagertypefield', 'Pagination type', "cardgridform")} placeholder="None" options={pagertype} value={data.pagerType} onChange={handleChange} />
          </div>
        </Form.Group>
        <div className="field">
            <CollectionEditor key="columns" 
                draggable={true}
                columns={columns} 
                label={this.getLocalValue('columnsfield', 'Columns', "cardgridform")}
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
class CustomEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);

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

    var columns = [
      {key: 'target', name: this.getLocalValue('itemstargetcolumn', 'Target', "menuform"), width: 150},
      {key: 'title', name: this.getLocalValue('itemstitlecolumn', 'Title', "menuform")},      

      {key: 'distype', name: this.getLocalValue('displaytypecolumn', 'Display Type', "menuform"), dataList:["text", "dropdown", "dropdownheader"]},
      {key: 'icon', name: 'icon'},      

      {key: 'visibleCondition', name: this.getLocalValue('visibleConditioncolumn', 'Visible Condition', "menuform")}
    ];
    return (<Form>
      <Form.Group widths="equal">
        <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "menuform")} value={data.key} onChange={handleChange} />
        <Form.Input name="activeItem" label={this.getLocalValue('activeitemfield', 'Active Item', "menuform")} value={data.activeItem} onChange={handleChange} />
      </Form.Group>
      <div className="field">
          <label>{this.getLocalValue('optionsfield', 'Options', "menuform")}</label>
          <Form.Group>
            <Form.Checkbox name="pointing" label={this.getLocalValue('pointingfield', 'Pointing', "menuform")} checked={data.pointing} onChange={handleChange} />
            <Form.Checkbox name="secondary" label={this.getLocalValue('secondaryfield', 'Secondary', "menuform")} checked={data.secondary } onChange={handleChange} />
            <Form.Checkbox name="tabular" label={this.getLocalValue('tabularfield', 'Tabular', "menuform")} checked={data.tabular } onChange={handleChange} />
            <Form.Checkbox name="fluid" label={this.getLocalValue('fluidfield', 'Fluid', "menuform")} checked={data.fluid } onChange={handleChange} />
            <Form.Checkbox name="vertical" label={this.getLocalValue('verticalfield', 'Vertical', "menuform")} checked={data.vertical } onChange={handleChange} />
            <Form.Checkbox name="link" label={this.getLocalValue('linkfield', 'Link', "menuform")} checked={data.link } onChange={handleChange} />
            <Form.Checkbox name="compact" label={'Compact'} checked={data.compact } onChange={handleChange} />
            <Form.Checkbox name="icon" label={'Icon'} checked={data.icon } onChange={handleChange} />
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

class TabEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);

    var columns = [
      {key: 'title', name: this.getLocalValue('itemstitlecolumn', 'Title', "tab")}
    ];
    return (<Form>
      <Form.Group widths="equal">
        <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "tab")} value={data.key} onChange={handleChange} />
        <Form.Input name="activeItem" label={this.getLocalValue('activeitemfield', 'Active Item', "tab")} value={data.activeItem} onChange={handleChange} />
      </Form.Group>
      <div className="field">
          <label>{this.getLocalValue('optionsfield', 'Options', "tab")}</label>
          <Form.Group>
            <Form.Checkbox name="pointing" label={this.getLocalValue('pointingfield', 'Pointing', "tab")} checked={data.pointing} onChange={handleChange} />
            <Form.Checkbox name="secondary" label={this.getLocalValue('secondaryfield', 'Secondary', "tab")} checked={data.secondary } onChange={handleChange} />
            <Form.Checkbox name="tabular" label={this.getLocalValue('tabularfield', 'Tabular', "tab")} checked={data.tabular } onChange={handleChange} />
            <Form.Checkbox name="fluid" label={this.getLocalValue('fluidfield', 'Fluid', "tab")} checked={data.fluid } onChange={handleChange} />
            <Form.Checkbox name="vertical" label={this.getLocalValue('verticalfield', 'Vertical', "tab")} checked={data.vertical } onChange={handleChange} />
            <Form.Checkbox name="compact" label={this.getLocalValue('compactfield', 'Compact', 'tab')} checked={data.compact} onChange={handleChange} />
            <Form.Checkbox name="isDisplayCount" label={this.getLocalValue('isdisplaycountfield', 'Count', 'tab')} checked={data.isDisplayCount} onChange={handleChange} />
          </Form.Group>
      </div>
      <CollectionEditor key="items" 
              draggable={true}
              hierarchical={true}
              childrenField="children"
              columns={columns} 
              label={this.getLocalValue('itemsfield', 'Items', "tab")}
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

class DropzoneEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    return (<Form>
      <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "uploadform")} value={data.key} onChange={handleChange} />
      <Form.Input name="customPostUrl" label={this.getLocalValue('customPostUrl', 'Custom Post URL', "uploadform")} placeholder="/myController" value={data.customPostUrl == undefined ? "" : data.customPostUrl} onChange={handleChange} />
      <Form.Input name="iconFiletypes" label={this.getLocalValue('iconFiletypes', 'Icon file types', "uploadform")} placeholder="*.png, *.jpg, *.gif" value={data.iconFiletypes == undefined ? "" : data.iconFiletypes} onChange={handleChange} />
      <Form.Group>
        <Form.Checkbox name="showFiletypeIcon" label={this.getLocalValue('showFiletypeIcon', 'Show file type icon', "uploadform")} checked={data.showFiletypeIcon } onChange={handleChange} />
        <Form.Checkbox name="autoProcessQueue" label={this.getLocalValue('autoProcessQueue', 'Auto process queue', "uploadform")} checked={data.autoProcessQueue } onChange={handleChange} />
        <Form.Checkbox name="addRemoveLinks" label={this.getLocalValue('addRemoveLinks', 'Add remove links', "uploadform")} checked={data.addRemoveLinks} onChange={handleChange} />
      </Form.Group>
    </Form>);
  }

  getEventsList(){
    return ["success"];
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

//----------
//Workflow
//----------
class WorkflowBarEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);

    return (<Form>
        <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "workflowform")} value={data.key} onChange={handleChange} />
        <Form.Input name="setStateButton" label={this.getLocalValue('setstatebuttonfield', 'Set state button', "workflowform")} value={data.setStateButton} onChange={handleChange} />
        <Form.Checkbox name="blockSetState" label={this.getLocalValue('blocksetstatefield', 'Block SetState', "workflowform")} checked={Boolean(data.blockSetState)} onChange={handleChange} />
      </Form>);
  }

  getEventsList(){
    return ["onCommandClick", "onSetStateClick", "onReceivedCommands"];
  }
}

class SwzGridEditControl extends BaseEditControl{
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
      {value: "modal", text: this.getLocalValue('editformtypemodalfield', 'Modal', "gridform")},
    ];

    let columns = [
      {key: 'key', name: this.getLocalValue('keycolumn', 'Key', "gridform")},
      {key: 'name', name: this.getLocalValue('namecolumn', 'Name', "gridform")},
      {key: 'type', name: this.getLocalValue('typecolumn', 'Type', "gridform"), dataList:["", "number", "checkbox", "link", "date", "datetime", "time", "swzbuttons"  ]},
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
            <Form.Dropdown name="editFormShowType" label={this.getLocalValue('editformshowtypefield', 'Edit form show type', "gridform")} placeholder={editformtype[0].text} options={editformtype} value={data.editFormShowType} onChange={handleChange} />
            <Form.Dropdown name="pagerType" label={this.getLocalValue('pagertypefield', 'Pagination type', "gridform")} placeholder="None" options={pagertype} value={data.pagerType} onChange={handleChange} />
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

class SwzHtmlEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    var displaydata = [
      {text: this.getLocalValue('displaynonefield', 'None', "swzcontainerform"), value: 'none'},
      {text: this.getLocalValue('displaydisplayfield', 'Display', "swzcontainerform"), value: 'block'},
    ] 

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "containerform")} value={data.key} onChange={handleChange} />
         {/* <Form.Dropdown name="style-display" options={displaydata} placeholder={null} label={this.getLocalValue('displayfield', 'Display', "swzcontainerform")} value={data["style-display"]} onChange={handleChange} />
              */}
        </Form.Group>
        <Form.Group widths="equal">
        <div className="field">
     
        <label>{"HTML Output"}</label>
        <Form.Dropdown name="hideOutput" options={displaydata} label={this.getLocalValue('displayOutput', 'Display', "swzcontainerform")} value={data.hideOutput} onChange={handleChange}/>     
       </div>
       </Form.Group>
       <Form.Group widths="equal">
       <Form.Input name="editorState" label={this.getLocalValue('editorState', 'Editor State', "swzcontainerform")} value={data.editorState} onChange={handleChange} />
       </Form.Group>
      </Form>);  
  }
    getEventsList(){
      return ["onChange"];
    }
}


class SwzHtmlViewEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    var displaydata = [
      {text: this.getLocalValue('displaynonefield', 'None', "swzcontainerform"), value: 'none'},
      {text: this.getLocalValue('displaydisplayfield', 'Display', "swzcontainerform"), value: 'block'},
    ] 

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "containerform")} value={data.key} onChange={handleChange} />
         {/* <Form.Dropdown name="style-display" options={displaydata} placeholder={null} label={this.getLocalValue('displayfield', 'Display', "swzcontainerform")} value={data["style-display"]} onChange={handleChange} />
              */}
        </Form.Group>
     <Form.Group widths="equal">
        <div className="field">
     
        <label>{"HTML Output"}</label>
        <Form.Dropdown name="hideOutput" options={displaydata} label={this.getLocalValue('displayOutput', 'Display', "swzcontainerform")} value={data.hideOutput} onChange={handleChange}/>     
       </div>
       </Form.Group>
       <Form.Group widths="equal">
       <Form.Input name="viewState" label={this.getLocalValue('viewState', 'View State', "swzcontainerform")} value={data.viewState} onChange={handleChange} />
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

class SwzImportEditControl extends BaseEditControl{
  constructor(props) {
    super(props);
  }
  getGeneralDescription(){
    var data = this.props.data;
    var handleChange = this.props.parent.handleChange.bind(this.props.parent);
    var data = this.props.data;  

    return (<Form>
        <Form.Group widths="equal">
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "containerform")} value={data.key} onChange={handleChange} />
           </Form.Group>
      </Form>);
  }
}

class SwzExportEditControl extends BaseEditControl{
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
          <Form.Input name="key" label={this.getLocalValue('namefield', 'Name', "containerform")} value={data.key} onChange={handleChange} />
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
            <Form.Input name="jsonData" label="JsonData"  value={data.jsonData} onChange={handleChange} />
         </div>
        </Form.Group>
      </Form>);
  }
  getEventsList(){
    return ["onClick"];
  }
}
module.exports = {
  BaseEditControl,
  HeaderEditControl,
  ButtonEditControl,
  LabelEditControl,
  MessageEditControl,
  InputEditControl,
  TextAreaEditControl,
  DropdownEditControl,
  DictionaryEditControl,
  RadioGroupEditControl,
  CheckboxEditControl,
  FormEditControl,
  FormGroupEditControl,
  ImageEditControl, 
  StatisticEditControl,
  GridEditControl,
  GridWithActionsEditControl,
  CustomEditControl,
  MenuEditControl,
  TabEditControl,
  ChartEditControl,
  WorkflowBarEditControl,
  ContainerEditControl,
  StaticContentEditControl,
  CollectionEditorEditControl,
  CardGridEditControl,
  CustomBlockEditControl,
  DropdownTriggerEditControl,
  DropzoneEditControl,
  BreadcrumbEditControl,
  SearchEditControl,
  SwzGridEditControl,
  SwzImportEditControl,
  SwzExportEditControl,
  SwzModalEditControl,
  SwzHtmlEditControl,
  SwzHtmlViewEditControl,
  DplyChoiceQnnsEditControl,
  WordCloudEditControl
}