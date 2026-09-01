import React, { Component } from 'react'
import {Menu, Statistic, Tab, Form, Grid, Card, Input, Dropdown, Checkbox, TextArea, Button, Icon, Message, Image, Label, Header, Item, Segment, Modal, Breadcrumb} from 'semantic-ui-react'
import Upload from './upload'
import JSON5 from 'json5'
import DatePicker from './datepicker'

export default class SemanticControl extends React.Component {
  constructor(props){
    super(props);
    this.state = {}
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
    if(type === 'header'){
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
      propsControl.disabled = model.disabled || model.readOnly || this.props.readOnly;
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
    else if(type === 'input'){
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
      
      if(handleEvent != null){
        propsControl.onChange = function(e, {name, value}){
          handleEvent({syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: value});
        };
      }

      if(data != undefined && data != null){
        propsControl.value = data[propsControl.name];
      }
      else
        propsControl.value = "";

      if(typeof errors === "object" && errors[model.key] !== undefined){
        propsControl.error = Boolean(errors[model.key]);
      }

      if(propsControl.type === "file"){
        propsControl.isForm = this.isForm(parentItem);
        res = <Upload {...propsControl}
          downloadUrl={this.props.additionalParams.downloadUrl}
          uploadUrl={this.props.additionalParams.uploadUrl}
          onUploadBegin={model.onUploadBegin ? model.onUploadBegin : null} 
          onUploadEnd={model.onUploadEnd ? model.onUploadEnd : null} />;
      }
      else if(propsControl.type === "date" || 
          propsControl.type === "time" ||
          propsControl.type === "datetime"){
        propsControl.isForm = this.isForm(parentItem);
       // propsControl.dateFormat = model.dateFormat;
        res = <DatePicker {...propsControl} />
      }
      else{
        if(this.isForm(parentItem)){
          res = (<Form.Input {...propsControl} />);
        }
        else{
          res = (<Input {...propsControl} />);
        }
      }
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
          handleEvent({syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: value});
        };
      }
      
      if(data != undefined)
        propsControl.value = data[propsControl.name];

      if(typeof errors === "object" && errors[model.key] !== undefined){
        propsControl.error = Boolean(errors[model.key]);
      }

      if(this.isForm(parentItem)){
        res = (<Form.TextArea {...propsControl} />);
      }
      else{
        res = (<TextArea {...propsControl} />);
      }
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
          handleEvent({syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: checked?1:0});
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
      }

      if(this.isForm(parentItem)){
        res = (<Form.Checkbox {...propsControl} />);
      }
      else{
        res = (<Checkbox {...propsControl} />);
      } 
    }
    else if(type === 'dropdown'){
      var options = [];
      if(model["data-elements"] !== undefined){
        if(Array.isArray(model["data-elements"])){
          options = model["data-elements"];
        }
        else{
          options = JSON5.parse(model["data-elements"]);
        }
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
      }

      if(handleEvent !== null){
        propsControl.onChange = function(e, {name, value}){
          handleEvent({syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: value});
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

      if(this.isForm(parentItem)){
        res = (<Form.Dropdown {...propsControl} />);
      }
      else{
        res = (<Dropdown {...propsControl} />);
      }
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

      res = (<Form.Group {...propsControl}
                widths={widths}
                children={children}>
            </Form.Group>);
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