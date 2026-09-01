import React, { Component } from 'react'
import ReactDatePicker from 'react-datepicker';
import {Input, Form} from 'semantic-ui-react'

import moment from 'moment';

export default class DatePicker extends React.Component {
  constructor(props){
    super(props);

    this.state = {};
  }

  render(){
    let type = this.props.type;
    let isForm = this.props.isForm;
    let date = this.props.value ? moment(this.props.value) : undefined;
    //let date = moment("2020-01-02T00:00:00+08:00"); //let date = moment("6542 6337");
    var isInvalid = false;
    if (date && !date.isValid()){
      isInvalid = true;
    }

    let controlProps = {};
    controlProps.readOnly = this.props.readOnly;

    let customDateTimeFormat = this.props.customDateTimeFormat ? this.props.customDateTimeFormat : undefined; 
    
      if(type === "date"){
        if(window.CloverLang !== undefined && window.CloverLang.common != undefined && window.CloverLang.common.dateFormat != undefined){
          controlProps.dateFormat = window.CloverLang.common.dateFormat;
        }
        else{
          controlProps.dateFormat = "DD MMM YYYY";
        }
      }
      else if(type === "time"){
        controlProps.showTimeSelect = true;
        controlProps.showTimeSelectOnly = true;
        controlProps.timeIntervals= 10;
        if(window.CloverLang !== undefined && window.CloverLang.common !== undefined && window.CloverLang.common.timeFormat != undefined){
          controlProps.dateFormat = window.CloverLang.common.timeFormat;
        } 
        else{
          controlProps.dateFormat = "HH:mm";
          controlProps.timeFormat="HH:mm"
        }
      }
      else if(type === "datetime"){
        controlProps.showTimeSelect = true;
        if(window.CloverLang !== undefined && window.CloverLang.common !== undefined && window.CloverLang.common.dateFormat != undefined){
          controlProps.timeFormat = window.CloverLang.common.timeFormat;
          controlProps.dateFormat = window.CloverLang.common.dateFormat + " " + 
            (window.CloverLang.common.timeFormat == undefined ? "HH:ss" : window.CloverLang.common.timeFormat);
        }
        else{
          controlProps.dateFormat = "yyyy-MM-dd HH:mm:ss";
          controlProps.timeFormat="HH:mm"
        }
      }  

    //Change input dateformat to custom dateformat, not changing date format of calendar
    if(customDateTimeFormat)
    {
      controlProps.dateFormat = customDateTimeFormat;
    }
    let control = '';

    if(!isInvalid){
        control = <ReactDatePicker {...controlProps}
          peekNextMonth
          showMonthDropdown
          showYearDropdown
          dropdownMode="select"
          isClearable={!this.props.readOnly}
          placeholderText={this.placeholder}
          selected={date}
          onChange={this.onChange.bind(this)}
          onChangeRaw={(event) =>
            this.handleChangeRaw(event.target.value)}
        />; 
    }else{
        controlProps.type = "input";
        controlProps.readOnly = this.props.readOnly ? true : false;
        controlProps.value = this.props.value;
     
        control= <Input {...controlProps} 
        onChange={this.onChange.bind(this)}></Input>;
    }

    let res = undefined;
    if(isForm){
      let divClass = "field" + " " + this.props.className;
      if(this.props.error)
        divClass += " error";
      res = <div className={divClass}>
        {this.props.label != undefined && <label>{this.props.label}</label>}
        <div data-buildertype={type} className="ui fluid input">
          {control}
        </div>
      </div>;
    }
    else{
      let divClass = "ui fluid labeled input" + " " +  this.props.className;
      if(this.props.error)
        divClass += " error";
      res = <div data-buildertype={type} className={divClass}>
        {this.props.label != undefined && <div className="ui label label">{this.props.label}</div>}
        {control}
      </div>;
    }

    return res;
  }

  handleChangeRaw(value) {
    let date = undefined;
    let type = this.props.type;
    date = moment(value, this.state.dateFormat);
    if (date && !date.isValid()){
      date = null;
    }
    this.onChange(date);
  }

  onChange(date){
    if(this.props.readOnly)
      return;
    if(this.props.onChange != undefined){
      let value = null;
      if(date != null && date != undefined){      
      	date.toJSON = function(){ return moment(this).format(); };
        let type = this.props.type;
        let customFormat = this.props.customDateTimeFormat;
        try{
          if(customFormat != null && customFormat != undefined)
          {
            value = date.format(this.props.customDateTimeFormat);
          }
          else
          {
            if(type === "date"){
              value = date.format(window.CloverLang.common.dateFormat);
            }else if(type === "time"){
              value = date.format(window.CloverLang.common.dateFormat + " " + window.CloverLang.common.timeFormat);
            }else if(type === "datetime"){
              value = date.format(window.CloverLang.common.dateFormat + " " + window.CloverLang.common.timeFormat);
            }
          }        
        }catch(e){};
      }
      this.props.onChange(null, {name: this.props.name, value });
    }
  }
}