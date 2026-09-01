import React, { Component } from 'react'
import ReactDatePicker from 'react-datepicker';
import moment from 'moment';
import {Input, Form} from 'semantic-ui-react'

export default class DatePicker extends React.Component {
  constructor(props){
    super(props);
    this.state = {};
  }

  render(){
    let type = this.props.type;
    let isForm = this.props.isForm;
    let date = this.props.value ? moment(this.props.value) : undefined;
    var isInvalid = false;
    if (date && !date.isValid()){
      isInvalid = true;
    }
    let controlProps = {};
    controlProps.readOnly = this.props.readOnly;
    
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
        controlProps.dateFormat = "DD MMM YYYY HH:mm";
        controlProps.timeFormat="HH:mm"
      }
    }

    if(this.props.dateFormat != undefined && this.props.dateFormat != "")
      controlProps.dateFormat;


    this.state.dateFormat = controlProps.dateFormat;

    let control;
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
      let divClass = "field";
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
      let divClass = "ui fluid labeled input";
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
    this.onChange(date);
  }

  onChange(date){ 
    if(this.props.readOnly)
      return;
    if(this.props.onChange != undefined){
      let value = null;
      if(date != null && date != undefined){
          date.toJSON = function () { return moment(this).format(); };
          let type = this.props.type;
          let format = "";
          try {
              if (type === "date") {
                  value = date.format("YYYY-MM-DD");
              }
              else if (type === "time") {
                  value = date.format("YYYY-MM-DD HH:mm:ss");
              }
              else if (type === "datetime") {
                  value = date.format("YYYY-MM-DD HH:mm:ss");
              }
          } catch (e) { };
      }
      this.props.onChange(null, {name: this.props.name, value });
    }
  }
}