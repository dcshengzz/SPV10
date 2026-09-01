import React, { Component } from 'react'
import {Menu, Statistic, Tab, Form, Grid, Card, Input, Dropdown, Checkbox, TextArea, Button, Icon, Message, Image, Label, Header, Item, Segment, Modal, Breadcrumb} from 'semantic-ui-react'
import Upload from './upload'
import JSON5 from 'json5'
import DatePicker from './datepicker'

export default class SemanticControl extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      isShuffled: false,
      autoSumVal: null
    }
  }

  componentDidMount() {
    if(this.props.disableupdownkey){
      var inputName = this.props.name;
      $(document).ready(function() {
        $("input[name=" + inputName + "]").on("focus", function() {
            $(this).on("keydown", function(event) {
                if (event.keyCode === 38 || event.keyCode === 40) {
                    event.preventDefault();
                }
            });
        });
      }); 
    }
  }

  roundNumber = (num, scale) => {
    return Number(parseFloat(Number(num)).toFixed(scale));
  }

  resetValue(){
    CloverApp.API.setDataField(this.props.name, '');
  }
  
  render() {
    let me = this;
    var propsControl = {}

    for(var p in this.props){
      if(p === "additionalParams" || p === "items") continue;
      propsControl[p] = this.props[p];
    }

    var model = this.props.additionalParams.model;
    var data = this.props.additionalParams.data;
    var errors = this.props.additionalParams.errors;
    var children = this.props.additionalParams.children;
    var parentItem = this.props.additionalParams.parentItem;
    var handleEvent = this.props.additionalParams.handleEvent;
    var type = model["data-buildertype"];
    var res;
    var items = this.props.randomise !== undefined && this.props.randomise && data !== undefined && !this.state.isShuffled? this.shuffle(model["data-elements"]) : model["data-elements"];
    
    var autoSumItems = this.props.additionalParams.items;
    var autoSumValue = '';
    var roundOffNo = this.props.roundoffno;
    var newPopulatedFields = [];
    if (data !== undefined){
      if(data["prePopulatedFields"] !== undefined) {
        var prePopulatedFields = data["prePopulatedFields"];
        propsControl.isPrePopulated = prePopulatedFields.includes(propsControl.name);
      }
    }

    propsControl.className = propsControl.isPrePopulated ? 'prepopulated-field' : '';


    
    if(type === 'input'){
      
      propsControl.defaultValue = model.defaultvalue;
      propsControl.size = model.size;
      
      if(model.label != undefined && model.label != "")
        propsControl.label = model.label;
      
      propsControl.labelPosition = model.labelPosition;
      propsControl.placeholder = model.placeholder;
      propsControl.type = model.type;
      propsControl.loading = model.loading;
      propsControl.inverted = model.inverted;
      propsControl.error = model.error; 
      propsControl.disabled = model.disabled;
      propsControl.transparent = model.transparent;
      propsControl.fluid = model.fluid;
      propsControl.readOnly = model.readOnly || this.props.readOnly;      
      
      if(this.props.isautosum && autoSumItems !== undefined && autoSumItems.length > 0 && data){
        var sum = 0;
        var prevOperator;

          for(let i = 0; i < autoSumItems.length; i++){
            let dataItem = Number(data[autoSumItems[i].control]?data[autoSumItems[i].control]:0);
            let operator = autoSumItems[i].operator !== "End" ?  autoSumItems[i].operator : '';
            
            if(i == 0)
              sum = sum + Number(dataItem);

            //IMDA-SIMS-04 Insecure Configuration of Content-Security-Policy (CSP) (unsafe-eval)
            //previous use of js eval, change to switch operator.
            if(i > 0){
              switch(prevOperator) {
                case "+":
                      sum = Number(sum)  + Number(dataItem);
                  break;
                case "-":
                      sum = Number(sum)  - Number(dataItem);
                  break;
                case "*":
                      sum = Number(sum)  * Number(dataItem);
                  break;
                case "/":
                      if(Number(dataItem) !== 0 )
                        sum = Number(sum)  / Number(dataItem);
                      else
                        sum = null;
                  break;
                default:
                  // do nothing
              }
            }

            prevOperator = operator;
          }
          autoSumValue = roundOffNo ? this.roundNumber(sum, roundOffNo) : sum;
     
        }


      if(handleEvent != null && this.props.isautosum !== true){
        propsControl.onChange = function(e, {name, value}){

          if(propsControl.autoSave)
          propsControl.autoSave(e);

          handleEvent({syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: value});
          if(data["prePopulatedFields"] !== undefined) {
            newPopulatedFields = data["prePopulatedFields"].filter(item => item !== propsControl.name);
            handleEvent({syntheticEvent: e, key: "prePopulatedFields", eventName: "onChange", name: "prePopulatedFields", value: newPopulatedFields});
          }

        };
      }

      if(data){
        if(this.props.isautosum && propsControl.type == "number"){
          propsControl.value = autoSumValue !== null ? autoSumValue : "" ;
        
          if(handleEvent != null && this.state.autoSumVal !== autoSumValue){
              handleEvent({key: propsControl.name, eventName: "onChange", name: propsControl.name, value: autoSumValue});
              this.setState({autoSumVal: autoSumValue});
          }
        }else{
          propsControl.value = data[propsControl.name];
        }
      }else
        propsControl.value = "";

      if(typeof errors === "object" && errors[model.key] !== undefined){
        propsControl.error = Boolean(errors[model.key]);
        propsControl.className = 'swz-error-highlight';
      }

      if(propsControl.type === "file" || propsControl.type == "imagefile"){
        //Benedict 240919
        propsControl.authorisedfiletypes = model.authorisedfiletypes;
        propsControl.filemaxsize = model.filemaxsize;
        propsControl.imagemaxwidth = model.imagemaxwidth;
        propsControl.imagemaxquality = model.imagemaxquality;
        
        propsControl.isForm = this.isForm(parentItem);
        res = <Upload {...propsControl}
          downloadUrl={this.props.additionalParams.downloadUrl}
          uploadUrl={this.props.additionalParams.uploadUrl} />;
      }
      else if(propsControl.type === "date" || propsControl.type === "time" || propsControl.type === "datetime") 
        {
        propsControl.isForm = this.isForm(parentItem);
        //what is the existing one use for
        propsControl.dateFormat = model.dateFormat;
        propsControl.customDateTimeFormat = model.customDateTimeFormat;
        res = <DatePicker {...propsControl} />
        //res = (<Form.Input error {...propsControl} />);  
        }
      else{
        if(propsControl.type === "number"){
          res = (<Form.Input className={propsControl.className} error {...propsControl} onWheel={(e) => e.target.blur()}       onKeyDown={(evt) => {
              if (["e", "E", "ArrowUp", "ArrowDown"].includes(evt.key)) {
                evt.preventDefault();
              }
            }}
          />);
        }
        else {
          res = (<Form.Input className={propsControl.className} error {...propsControl} />);
        }
        //if(this.isForm(parentItem)){
          //propsControl.className = 'error';

       // }
       // else{
          //res = (<Input error {...propsControl} />);
       // }
      }
    }
    else if(type === 'dropdown'){
      var options = [];
      if(model["data-elements"] !== undefined){
        if(Array.isArray(items)){
          options = items;
        }
        else{
          options = JSON5.parse(items);
        }
      }
      
      let builderMode = this.props.builderMode ? this.props.builderMode : false;
      if(!(builderMode)){
        options = options.flatMap(function(item) {
          let visibleCondition = item['visible-condition'] ? item['visible-condition'] : '';
          let isChecked = false;
          if(data !== undefined){
            if(item['value'] === data[propsControl.name])
              isChecked = true;
          }
          if(visibleCondition != '' && data != undefined){
            let args = 'data';
            let body = 'return ' + visibleCondition;
            let isDisplay = true;
            try { 
                isDisplay = new Function(args, body)(data); 
            }
            catch(err) {
                console.log('Logic error - condition ', this.props.name, err);
            }
            if(!isDisplay) {
              if(isChecked) {
                this.resetValue();
              }
              return [];
            }
          }
          return item;
        }, this);
      }
      
      if(model.label !== undefined && model.label !== "")
        propsControl.label = model.label;
        
      propsControl.defaultValue=model.defaultvalue;
      propsControl.placeholder=model.placeholder;
      propsControl.options=options;
      propsControl.loading=model.loading;
      propsControl.error=model.error;
      propsControl.fluid=model.fluid;
      propsControl.selection=model.selection;
      propsControl.multiple=model.multiple;
      propsControl.search=model.search;
      propsControl.disabled = model.disabled || model.readOnly || this.props.readOnly;

      if(data !== undefined)
        propsControl.value = data[propsControl.name];
        
      if(typeof errors === "object" && errors[model.key] !== undefined){
        propsControl.error = Boolean(errors[model.key]);
        propsControl.className = 'swz-error-highlight';
      }

      if(handleEvent !== null){
        propsControl.onChange = function(e, {name, value}){

          if(propsControl.autoSave)
          propsControl.autoSave(e);

          handleEvent({syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: value});
          if(data["prePopulatedFields"] !== undefined) {
            newPopulatedFields = data["prePopulatedFields"].filter(item => item !== propsControl.name);
            handleEvent({syntheticEvent: e, key: "prePopulatedFields", eventName: "onChange", name: "prePopulatedFields", value: newPopulatedFields});
          }
          var nextModels = propsControl.nextModels;
          var scrollKey = Array.isArray(nextModels) ? propsControl.getNextModelFromArr(propsControl.name, nextModels) : nextModels;                 
          
          if(scrollKey && model.onScrollNextControl)
            document.getElementsByName(scrollKey.key)[0].scrollIntoView({block: 'start',  behavior: 'smooth' });

        };
      }

      propsControl.allowAdditions = model.allowAddItems;
      if(propsControl.allowAdditions){
        propsControl.onAddItem = function(e, { value }){
          let v = propsControl.value;
          if(Array.isArray(v))
            v.push(value);
          else{
            v = [value];
          }

          propsControl.onChange(e, {name: propsControl.name, value: v});
        }
      }

      if(propsControl.multiple){
        if(propsControl.value === undefined || propsControl.value === null){
          propsControl.value = [];
        }

        if(!Array.isArray(propsControl.value)){
          let valueArray;
          try{
            valueArray = JSON5.parse(propsControl.value);
          } 
          catch(e){};

          if(!Array.isArray(valueArray)){
            valueArray = [propsControl.value];
          }
          
          propsControl.value = valueArray;
        }

        if(propsControl.allowAdditions){
          this.dropdownCheckAdditional(propsControl.value, propsControl.options);
        }
      }

      //if(this.isForm(parentItem)){
        
        //res = (<Form.Dropdown {...propsControl} />);
      /*}
      else{
        res = (<Dropdown {...propsControl} />);
      }*/
      res = (<Form.Dropdown className={propsControl.className} {...propsControl}  />);
    }
    else if(type === 'header'){
      res = <Header {...propsControl}
                      textAlign={model.textAlign} 
                      size={model.size} 
                      content={this.props.content}
                      subheader={this.props.subheader}/>;
    }
    else if(type === 'button'){
      propsControl.floated = model.floated;
      propsControl.size = model.size !== "" ? model.size : null;
      propsControl.content = model.content;
      propsControl.type = model.buttonType;
      propsControl.basic = model.basic;
      propsControl.circular = model.circular;
      propsControl.compact = model.compact;
      propsControl.disabled = model.disabled;
      propsControl.fluid = model.fluid;
      propsControl.inverted = model.inverted;
      propsControl.loading = model.loading;
      propsControl.primary = model.primary;
      propsControl.secondary = model.secondary;
      propsControl.toggle = model.toggle;

      if(handleEvent !== undefined){
        propsControl.onClick = function(e){
          return handleEvent({syntheticEvent: e, key: propsControl.name, eventName: "onClick"});
        };
      }

      if(this.isForm(parentItem)){
        res = <Form.Button {...propsControl}/>;
      }
      else{
        res = <Button {...propsControl}/>;
      }
    }
    else if(type === 'label'){
      res = (<Label {...propsControl}
                      size={model.size} 
                      content={this.props.content}
                      attached={model.attached}
                      basic={model.basic}
                      circular={model.circular}
                      corner={model.corner}
                      floating={model.floating}
                      horizontal={model.horizontal}
                      pointing={model.pointing}>
            </Label>);
    }
    else if(type === 'message'){
      res = (<Message {...propsControl}
                      floated={model.floated} 
                      size={model.size} 
                      content={this.props.content}
                      compact={model.compact}
                      error={model.error}
                      floating={model.floating}
                      info={model.info}
                      negative={model.negative}
                      positive={model.positive}
                      success={model.success}
                      warning={model.warning}
                      header={this.props.header}
                      >
            </Message>);
    }
    else if(type === 'textarea'){
      propsControl.placeholder = model.placeholder;
      propsControl.rows = (model.rows !== null && model.rows !== undefined) ? Number(model.rows) : undefined;

      if(model.label !== undefined && model.label !== "")
        propsControl.label = model.label;

      propsControl.autoHeight = model.autoHeight;
      propsControl.readOnly = model.readOnly || this.props.readOnly;

      if(handleEvent !== null){
        propsControl.onChange = function(e, {name, value}){

          if(propsControl.autoSave)
          propsControl.autoSave(e);

          handleEvent({syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: value});
          if(data["prePopulatedFields"] !== undefined) {
            newPopulatedFields = data["prePopulatedFields"].filter(item => item !== propsControl.name);
            handleEvent({syntheticEvent: e, key: "prePopulatedFields", eventName: "onChange", name: "prePopulatedFields", value: newPopulatedFields});
          }
        };
      }
      
      if(data != undefined)
        propsControl.value = data[propsControl.name];

      if(typeof errors === "object" && errors[model.key] !== undefined){
        propsControl.error = Boolean(errors[model.key]);
        propsControl.className = 'swz-error-highlight';
      }

      res = (<Form.TextArea {...propsControl} />);

      /* if(this.isForm(parentItem)){
        res = (<Form.TextArea {...propsControl} />);
      }
      else{
        res = (<TextArea {...propsControl} />);
      } */
    }
    else if(type === 'checkbox'){

      if(model.label !== undefined && model.label !== "")
        propsControl.label= model.label;

      propsControl.placeholder=model.placeholder;
      propsControl.type=model.type;
      propsControl.disabled=model.disabled;
      propsControl.fitted=model.fitted;
      propsControl.indeterminate=model.indeterminate; 
      propsControl.readOnly=model.readOnly || this.props.readOnly;
      propsControl.slider=model.slider;
      propsControl.toggle=model.toggle;
      
      if(handleEvent !== null){
        propsControl.onChange = function(e, {name, checked}){
          
          if(propsControl.autoSave)
              propsControl.autoSave(e);

          handleEvent({syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: checked?1:0});
          if(data["prePopulatedFields"] !== undefined) {
            newPopulatedFields = data["prePopulatedFields"].filter(item => item !== propsControl.name);
            handleEvent({syntheticEvent: e, key: "prePopulatedFields", eventName: "onChange", name: "prePopulatedFields", value: newPopulatedFields});
          }
        };
      }

      if(data !== undefined){
        if(typeof(variable) === "boolean"){
          propsControl.checked = data[propsControl.name];
        }
        else if(data[propsControl.name] === "true" || data[propsControl.name] === "1"){
          propsControl.checked = true;
        }
        else  if(data[propsControl.name] === "false" || data[propsControl.name] === "0"){
          propsControl.checked = false;
        }
        else{
          propsControl.checked = Boolean(data[propsControl.name]);
        }
      }

      if(typeof errors === "object" && errors[model.key] !== undefined){
        propsControl.error = Boolean(errors[model.key]);
        //propsControl.className = 'swz-error-highlight-border'; //Remove temp as there might be many checkbox tgt
      }
      res = (<Form.Checkbox {...propsControl} />);

      /* if(this.isForm(parentItem)){
        res = (<Form.Checkbox {...propsControl} />);
      }
      else{
        res = (<Checkbox {...propsControl} />);
      }  */
    }
    else if(type === 'statistic'){
      var items = [];
      if(model["data-elements"] !== undefined){
        if(Array.isArray(model["data-elements"])){
          items = model["data-elements"];
        }
        else{
          items = JSON5.parse(model["data-elements"]);
        }
      }

      res = (<Statistic.Group {...propsControl}
                    floated={model.floated}
                    horizontal={model.horizontal}
                    size={model.size}
                    items={items}/>);
    }
    else if(type === 'image'){
        res = (<Image {...propsControl}
                      avatar={model.avatar}
                      bordered={model.bordered}
                      centered={model.centered} 
                      disabled={model.disabled}
                      inline={model.inline}
                      href={this.props.href}
                      src={this.props.src}
                      floated={model.floated}
                      shape={model.shape}
                      spaced={model.spaced}
                      verticalAlign={model.verticalAlign}
                      height={model.height}
                      width={model.width} />);
    }
    else if(type === 'form'){
          res = (<Form {...propsControl}
                children={children}
                size={model.size} 
                loading={model.loading}
                error={model.error}
                inverted={model.inverted}
                reply={model.reply}
                success={model.success}
                warning={model.warning}>
            </Form>);
    }
    else if(type === 'formgroup'){
      var widths = model.widths;
      if(widths === "custom")
        widths = model.widthsCustom;
      
      if(model.orientation)
        propsControl[model.orientation] = true;

      res = (<Form><Form.Group {...propsControl}
                widths={widths}
                children={children}>
            </Form.Group></Form>);
    }
    else if(type === 'breadcrumb'){
      let children = [];
      if(Array.isArray(this.props.items)){
        for(let i=0; i < this.props.items.length; i++){
          let item = this.props.items[i];
          let childProps = {key: i};
          childProps.active = item.active;
          childProps.href = item.url;
          if(handleEvent !== null){
            childProps.onClick = function(e, {name, checked}){
              handleEvent({syntheticEvent: e, key: propsControl.name, eventName: "onItemClick", parameters: {target: item.url}});
              e.preventDefault();
            };
          }
          children.push(<Breadcrumb.Section {...childProps}>{item.text === undefined ? "<not set>" : item.text}</Breadcrumb.Section>);
          if(i < this.props.items.length - 1){
            let dividerProps = {
              key: i + "_d"
            };
            if(item.divider !== "")
              dividerProps.icon = item.divider;
            children.push(<Breadcrumb.Divider {...dividerProps} />);
          }
        }
      }
      res = <Breadcrumb {...propsControl} children={children} />;
    }
    else{
      res = <span>Unknow type '{type}' of '{this.props.name}' element.</span>;
    }
    return res;
  }

  shuffle = (array) => {
    var currentIndex = array.length, temporaryValue, randomIndex;
  
    // While there remain elements to shuffle...
    while (0 !== currentIndex) {
  
      // Pick a remaining element...
      randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex -= 1;
  
      // And swap it with the current element.
      temporaryValue = array[currentIndex];
      array[currentIndex] = array[randomIndex];
      array[randomIndex] = temporaryValue;
    }
    this.setState({isShuffled: true});
    return array;
  }
  
  isForm(m){
    return (m != null && 
        (m["data-buildertype"] === "form" || 
        m["data-buildertype"] === "formgroup"));
  }

  dropdownCheckAdditional(value, options){
    if(!Array.isArray(value))
      return;
    value.forEach(function(v){
      let isFind = false;
      for(let i=0; i < options.length; i++){
        let o = options[i];
        if(v === o.value){
          isFind = true;
          break;
        }
      }

      if(isFind == false){
        options.push({value: v, text: v});
      }
    });
  }
}