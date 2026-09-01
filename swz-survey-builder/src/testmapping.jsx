import React from 'react';
import ReactDOM from 'react-dom';
import CloverForm from './form';
import CloverFormControls from './controls';
import {TextArea} from 'semantic-ui-react'
import JSON5 from 'json5'

export default class CloverFormTestMapping extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      model : [],
      data : "{}",
      eventslog : ""
    };

    var me = this;
    if(props.modelurl != undefined){
      this.sendrequest(props.modelurl, function(data){
        me.setState({model: data});
      })
    }

    if(props.dataurl != undefined){
      this.sendrequest(props.dataurl, function(data){
        me.setState({data: JSON5.stringify(data, null, 4)});
      })
    }
  }


  render() {
    var data = [];
    var errors = undefined;
    try{
      data = JSON5.parse(this.state.data);
      if(this.state.errors != undefined || this.state.errors == "")
        errors = JSON5.parse(this.state.errors);
    } 
    catch(e){
    }

    return (<div className="clover-form-mappging">
      <div className="clover-form-mappging-left">
        <h1>Form</h1>
        <CloverForm
            model={this.state.model} 
            data={data} 
            errors={errors}
            eventFunc={this.eventFunc.bind(this)} 
            eventErrFunc={this.props.eventErrProcess}
            getFormFunc={this.props.getform}
            dataChanged={this.formDataChaged.bind(this)}
            getAdditionalDataForControl={this.getAdditionalDataForControl.bind(this)}
             />
      </div>
      <div className="clover-form-mappging-right">
        <h1>Data</h1>
        <TextArea rows={4} autoHeight={false} onChange={this.handleChange.bind(this)} value={this.state.data} />
        <h1>Model</h1>
        <TextArea rows={4} autoHeight={false} /*onChange={this.handleChangeModel.bind(this)} */
          value={ JSON5.stringify(this.state.model, null, 4)} />
        <h1>Errors</h1>
        <TextArea rows={4} autoHeight={false} onChange={this.handleChangeErrors.bind(this)} 
          value={ this.state.errors} />
        <h1>Events</h1>
        <TextArea rows={4} autoHeight={false} readOnly={true} value={this.state.eventslog} />
      </div>
    </div>);
  }

  getAdditionalDataForControl(control,
    {startIndex, pageSize, filters, sort, model},
    callback)
  {
    var me = this;
    if(control.props["data-buildertype"] == "dictionary"){
      setTimeout(function(){
        var items = [];
        for(var i = 0 ; i < 500; i++){
          var obj = {};
          obj.key = "Test_" + i;
          obj.text = "Test_" + i;
          obj.value = i;
          items.push(obj);
        }

        let res = [];
        let rowsCount = items.length;
        if(Array.isArray(filters) && filters.length > 0){
          let filter = filters[0];
          if(filter.term == "="){
              for(let i = 0; i < items.length; i++){
                if(items[i].value == filter.value){
                  res.push(items[i]);
                }
              }
          }
          else if(filter.term == "in"){
            for(let i = 0; i < items.length; i++){
              for(let j = 0; j < filter.value.length; j++){
                if(items[i].value == filter.value[j]){
                  res.push(items[i]);
                  break;
                }
              }
            }
          }
          else if(filter.term == "like"){
            let value = filter.value;
            let findIndex = 0;
            for(let i = 0; i < items.length; i++){
              if(items[i].text.includes(filter.value)){
                findIndex ++;
                if(findIndex < startIndex)
                  continue;

                if(res.length <= pageSize)
                  res.push(items[i]);
              }
            }

            callback({items: res, rowsCount: findIndex});
            return;
          }
          

          callback({items: res, rowsCount: res.length});
          return;
        }
        else if(startIndex == undefined || pageSize == undefined){
          callback({items, rowsCount});
          return;
        }
        else{
          for(let i=0; i < pageSize; i++){
            res.push(items[startIndex + i]);
          }
        }
        
        callback({items: res, rowsCount});
      }, 100);
    }
    else if(control.props["data-buildertype"] == "dictionarytree"){
      setTimeout(function(){
        var items = [];
        for(var i = 0 ; i < 10; i++){
          var obj = {};
          obj.key = "Test_" + i;
          obj.text = "Test_" + i;
          obj.value = i;
          obj.children = [];

          for(var j = 0 ; j < 10; j++){
            var child = {};
            child.key = obj.key + "_" + j;
            child.text = obj.key + "_" + j;
            child.value = j;
            obj.children.push(child);
          }
          
          items.push(obj);
        }

        callback({items: items, rowsCount: items.length});
      });
    }
    else if(control.props["data-buildertype"] == "workflowbar"){
      callback({
        commands: [{value:"approve", type:"1", text:"Approve"}, 
                  {value:"back", type:"2", text:"Back"}], 
        states: [
          {value:"draft", text: "Draft"},
          {value:"state1", text: "State 1"},
          {value:"state2", text: "State 2"},
          {value:"final", text: "Final"}
        ]});
    }
    else{
      setTimeout(function(){
        var rowsCount = 100;
        var items = [];
        for(var i = 0 ; i < pageSize; i++){
          var obj = {};
          control.props.columns.forEach(function(c){
            obj[c.key] = c.key + "_" + (Number(startIndex) + Number(i));
          });
          items.push(obj);
        }
        callback({startIndex, pageSize, rowsCount, items});
      }, 100);
    }
  }

  eventFunc(p){
    p.syntheticEvent = undefined;
    p.component = undefined;
    p.controlRef = undefined;
    p.sourceEvent = undefined;
    var eventslog = this.state.eventslog;
    var sep = "";
    if(eventslog.length > 0)
      sep = "\n";
    
    eventslog = JSON5.stringify({...p, e: undefined, sourceControlRef: undefined }) + sep + eventslog;

    this.setState({
      eventslog: eventslog
    });
  }

  formDataChaged(form, {key, value}){
    this.setState({
      data: JSON5.stringify(form.state.data, null, 4)
    });
  }

  handleChange(e, {value}){
    this.setState({
      data: value
    });
  }

  handleChangeErrors(e, {value}){
    this.setState({
      errors: value
    });
  }

  handleChangeModel(e, {value}){
    this.setState({
      model: value
    });
  }

  sendrequest(url, successFunc){
    var me = this;
    $.getJSON(url)
    .done(function( data ) {
        successFunc(data);
    })
    .fail(function( jqxhr, textStatus, error ) {
        var err = textStatus + ", " + error;
        console.error(err);
    });
  }
}