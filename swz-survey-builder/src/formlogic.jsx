import React from 'react';
import CloverStore from './store';
import Helper from './formlogicfunctions';
import {Menu, Breadcrumb, Form, Grid, Card, Input, Dropdown, Confirm, Checkbox, TextArea, Button, Icon, Message, Image, Label, Header, Item, Segment, Modal} from 'semantic-ui-react'

export default class FormLogic extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      data: {},
      condGroups: [],
      onNewForm: true,            
      editElement: null,
      condOperators: {
        textTypeOperator: [{key: Helper.newGuid(), value:{value: "=="}, text: "Equal To"}, {key: Helper.newGuid(), value:{value: "!=="}, text: "Not Equal To"},{key: Helper.newGuid(), value:{value: "Contain"}, text: "Contain"},{key: Helper.newGuid(), value:{value: "DoesNotContain"}, text: "Does Not Contain"}, {key: Helper.newGuid(), value:{value: ".length =="}, text: "Specific Length"}, {key: Helper.newGuid(),value:{value: "Regex"}, text: "Apply Regex"}, {key: Helper.newGuid(), value:{value: "Blank"}, text: "Equal To Blank"}, {key: Helper.newGuid(), value:{value: "NotBlank"}, text: "Not Equal to Blank"}],
        numberTypeOperator: [{key: Helper.newGuid(), value:{value: "=="}, text: "Equal To"},{key: Helper.newGuid(), value:{value: "!=="}, text: "Not Equal To"}, {key: Helper.newGuid(), value:{value: "<"}, text: "Less than"}, {key: Helper.newGuid(), value:{value: ">"}, text: "More than"}, {key: Helper.newGuid(), value:{value: "<="}, text: "Less than Or Equal To"},{key: Helper.newGuid(), value:{value: ">="}, text: "More than Or Equal To"},{key: Helper.newGuid(),value:{value: ".length =="}, text: "Specific Length"},{key: Helper.newGuid(),value:{value: "Regex"}, text: "Apply Regex"}, {key: Helper.newGuid(), value:{value: "Blank"}, text: "Equal to Blank"}, {key: Helper.newGuid(), value:{value: "NotBlank"}, text: "Not Blank"}],   
        radioTypeOperator: [{key: Helper.newGuid(), value:{value: "=="}, text: "Equal To"}, {key: Helper.newGuid(), value:{value: "!=="}, text: "Not Equal To"}],  
        checkboxTypeOperator: [{key: Helper.newGuid(), value:{value: "=="}, text: "Equal To"}, {key: Helper.newGuid(), value:{value: "!=="}, text: "Not Equal To"}],  
      },
      selectAnsType: [{key: Helper.newGuid(),value:{value:"Control"}, text: "Select Control"}, {key: Helper.newGuid(), value:{value: "Answer"}, text: "Answer"}],
      selectAnsTypeAns: [{key: Helper.newGuid(), value:{value: "Answer"}, text: "Answer"}],
      selectAnsCb: [{key: Helper.newGuid(),value:{value:1}, text: "True"}, {key: Helper.newGuid(), value:{value: 0}, text: "False"}],
      selectCondType: [{key: Helper.newGuid(),value:{value:""}, text: ""}, {key: Helper.newGuid(), value:{value: ""}, text: "Answer"}],
      selectApplyType: [{key: Helper.newGuid(),value:'other-customValidation', text: "Validation"}, {key: Helper.newGuid(),value:'other-visibleConition', text: "Visible"}, {key: Helper.newGuid(),value:'other-readOnlyConition', text: "ReadOnly"}, {key: Helper.newGuid(),value:'other-skipConition', text: "Skip To"}],
      selectNotApplicable: [{key: Helper.newGuid(), value:{value: "Not Applicable"}, text: "Not Applicable"}],
      applyControls: [], 
      applyType: null , //Skip,ReadOnly,Visible,Validation,
      applySkipControl: null,
      applyValidMessage: null,
      applyItem: '',
      applyCond: [],
      open: false,
      onFilterDiv: false,
      onLoadNewForm: true,
      onFilterInput: true
    }
    
    CloverStore.listen(this.dataChanged.bind(this));
  //Types of filter: input, all, text, number, radio, checkbox
  }

  dataChanged(data){
    this.setState({
      data,
      editElement: null
    });
  }

  handleChange(e, {groupid, groupindex, condindex, condid, name, value, type, checked}){

    if(checked !== undefined){
      this.setState((prevState) => {
        let tempObj = {
          value: checked,
          ['type']: value.type !== undefined ? value.type : undefined
        }
        let temp = {
          ...prevState,
          condGroups:[...prevState.condGroups]
         }
         temp.condGroups[groupindex][groupid][condindex][condid][name] = tempObj;
         
        return temp
     })
    }
    else{
      this.setState((prevState) => {
        let temp = {
          ...prevState,
          condGroups:[...prevState.condGroups]
         }
         temp.condGroups[groupindex][groupid][condindex][condid][name] = value;
         
        return temp
     })
    } 
  }

  //Model to options
  onConvertOptions = (data, filter) => {  
    
    if(!(data !== null && data !== undefined) && data.length > 0)
      return
    
    var convert = function(data, filter){
      let controls = [];
      
      for(let control of data){
       
        let type = Helper.getModelType(control);
        let controlObj = {
          key: Helper.newGuid(),
          text: control['key'],
        }

        if(filter['applyControls'] !== undefined && filter['applyControls']){
          controlObj['value'] = control['key']; 
        }else{
          controlObj['value'] = {
            value: control['key'],
            type
          }
        }
        if(!Helper.isEmpty(filter)){
          if(filter['type'] !== undefined){
            //Not inputs
            if(filter['type'] == "inputControls" && Helper.isInputControl(control['data-buildertype'])){
              controls.push(controlObj);

            //Data-buildertype does not consist of type property
            }else if(filter['type'] == control['type']){
              controls.push(controlObj);
            
            }else if(filter['type'] == control['data-buildertype']){
                controls.push(controlObj);

            }
          }else if(filter['onFilterDiv'] !== undefined || filter['onFilterInput'] !== undefined || filter['applyControls'] !== undefined){
          
            if(filter['onFilterDiv'] || filter['onFilterInput']){
                if(filter['onFilterDiv'] && control['data-buildertype'] == 'block')
                  controls.push(controlObj);
                if(filter['onFilterInput'] && Helper.isInputControl(control['data-buildertype']))
                  controls.push(controlObj);
            }else{
              controls.push(controlObj);
            }
            
          }
        }
        else{
          controls.push(controlObj);

        }
        if(control.children !== undefined && control.children.length > 0){
          let cs = convert(control.children, filter);
          controls = controls.concat(cs);

        }
      
      }
      return controls
    }
    var options = convert(data, filter);
    
    return options
  }

  genDropDownAttributes = (groupProps, condProps, name, filter) => {

    const { data, condGroups, condOperators } = this.state;
    let getOptions = [];
    let attributes = {};
    let formData = Helper._swzGetData();
    let type = filter.type;
    let cond;
    let me = this;

    cond = condGroups[groupProps.groupindex][groupProps.groupid][condProps.condindex][condProps.condid];
    
    if(name == "applyControls")
      getOptions = (formData !== undefined && formData.length > 0) ? this.onConvertOptions(formData, filter) : getOptions;

    if(name == "selectControl" || name == "selectAnsControl"){
      getOptions = (formData !== undefined && formData.length > 0) ? this.onConvertOptions(formData, filter) : getOptions;

     if(this.state.applyType == "other-customValidation"){
        let inputType = 'value';
        if(me.state.applyItem['data-buildertype'] == "input"){
          inputType = me.state.applyItem.type;

        }else{
          inputType = me.state.applyItem['data-buildertype'];
        }

        let obj = {
          key: Helper.newGuid(),
          text: "value",
          value: {
            type: Helper.getModelType(me.state.applyItem),
            value: "value",
            valueType: "value"
          }
        };

        getOptions.push(obj); 
      }      
    }

    if(name == "selectOperator"){
      if(type == "text"){
        getOptions = condOperators['textTypeOperator'];
      }else if(type == "number"){
        getOptions = condOperators['numberTypeOperator'];
      }else if(type == "radiogroup" || type == "dropdown"){
        getOptions = condOperators['radioTypeOperator'];
      }else if(type == "checkbox"){
        getOptions = condOperators['checkboxTypeOperator'];
      }
    }

    if(name == "selectAnsType"){
     getOptions = this.state.selectAnsType;
     let operator = cond['selectOperator'] !== undefined ? cond['selectOperator']['value'] : null;
      if(operator == "Regex" || operator == ".length ==")
        getOptions = this.state.selectAnsTypeAns;

      if(operator == "Blank" || operator == "NotBlank")
        getOptions = this.state.selectNotApplicable;
    }

    //Both radio and dropdown
    if(name == "selectAnsRad"){
      let target = cond['selectControl']['value'] !== undefined ? cond['selectControl']['value'] : alert('No control selected');
      getOptions = Helper.getModelOptions(data, target);
    }
    
    if(name == "selectAnsCb")
      getOptions = this.state.selectAnsCb;

    attributes = {
      groupindex: groupProps.groupindex,
      groupid: groupProps.groupid,
      condindex: condProps.condindex,
      condid: condProps.condid,
      name,
      options: getOptions,
      search: true,
      value: data[name],
      onChange: this.handleChange.bind(this),
      selection: true,
    }
   
    return attributes

  }

  genInputAttributes = (groupProps, condProps, name, type) => {
    const { data } = this.state;
    var attributes = {};
    var type = type == 'number' ? 'number' : 'text'

    attributes = {
      groupindex: groupProps.groupindex,
      groupid: groupProps.groupid,
      condindex: condProps.condindex,
      condid: condProps.condid,
      name,
      value: data[name],
      type,
      onChange: this.handleChange.bind(this)
    }
    return attributes

  }

  clearControlLogic = (arr) => {
    let emptyArr = [];
    let emptyCond = [];

    if(arr !== undefined && arr.length > 0){
      for(let i = 0; i < arr.length; i++){
        emptyCond.push(null);
      }
    }

    this.setState({condGroups: emptyArr, applyCond: emptyCond/* , applyItem: '' */});
    this.forceUpdate();
  }

  genConditionGroups = () => {
    const { condGroups, applyCond, applyControls, applyType, applySkipControl, applyValidMessage } = this.state;
    var me = this;
    
    if(condGroups == undefined || !(condGroups.length > 0))
      return
    
    var rows = [];
    var join = ' || ';
    var getConcatCond = '';
    var newConds = '';
    var getGroupCond = '';
    var res = {};
    var getGroupsCond = '';
    var header = (<React.Fragment></React.Fragment>);
    var reset = applyCond !== undefined && applyCond.length > 0 /* || (this.getApplyCond() !== undefined && this.getApplyCond() !== '')  */? ( <div style={{width: '100%', paddingBottom: '10px'}} className="clover-admin-formheader-breadcrumb">
    <Breadcrumb><Breadcrumb.Section onClick={() => this.clearControlLogic(applyCond)}>Reset</Breadcrumb.Section></Breadcrumb>
    </div>) : null;

    var skipControl = (applyType && applyType == 'other-skipConition') && applySkipControl !== null ? applySkipControl : null;
    var validMessage = (applyType && applyType == 'other-customValidation') && applyValidMessage !== null ? applyValidMessage : null;

    var genControlsCond = function (applyConds,  getGroupCond) {
      var condStr = [];
      let item;
      var groupCond = getGroupCond;
      
      var obj = {};

      if(!(applyConds !== undefined && applyConds.length > 0)){
        res['condStr'] = condStr;
        return obj
      }
   
      for(let i = 0; i < applyConds.length; i++){
        let str = '';
        let applyCond = applyConds[i] == null || applyConds[i] == undefined ? '' : applyConds[i]
        
       if(applyCond !== '' && applyCond !== null){
         if(groupCond !== ''){
            str = applyCond + join + groupCond;
         }else{
           str = applyCond;
         }
        }else{
          str = applyCond + groupCond;
        }
        item = <div style={{width: '100%', paddingTop: '10px', paddingBottom: '10px'}}><h4>{applyControls[i] + ':'} </h4>{str}</div>
        condStr.push(item);
      }

      obj['condStr'] = condStr;
      return obj
      
    }
    rows.push(header);
    for(let j = 0; j < condGroups.length; j++){
     
        let groupindex = j;
        let groupid = Object.keys(condGroups[j])[0];
        let condGroup = condGroups[j][groupid];  
        let groupProps = {
          groupindex,
          groupid
        }  
        
          getGroupCond = me.concatConditions(condGroup, skipControl, validMessage, applyType) == '' ? '' : me.concatConditions(condGroup, skipControl, validMessage, applyType);
          if(getGroupsCond == ''){
            getGroupsCond = getGroupCond;
          }else{
            if(getGroupCond !== ''){
              getGroupsCond = getGroupsCond + join + getGroupCond ;
            }else{
              getGroupsCond = getGroupsCond;
            }
          }
          res = genControlsCond(applyCond, getGroupsCond, getConcatCond);
        
        header = (<React.Fragment>{reset}
          {res['condStr']}
        {condGroup !== undefined && condGroup.length > 0 && <div className="swz-form-logic-cond-group-swzdivider"/>}
        </React.Fragment>);
        rows.splice(0, 1, header);

      if(condGroup == undefined || !(condGroup.length > 0))
        me.addCondition(groupindex, groupid);
    
        var groupCompo = function() {
          return (condGroup.map((item, condindex) => {
                let condid = Object.keys(item)[0];
                var itemObj = item[condid];
                
                let type = itemObj['selectControl'] !== undefined && itemObj['selectControl'].type !== undefined ? itemObj['selectControl'].type : undefined;
                    //on Specific length or regex;    
                let specialOperatorType = '';
                if(itemObj['selectOperator'] !== undefined){
                  if(itemObj['selectOperator'].value == '.length =='){
                    specialOperatorType = 'number';
                  }else if(itemObj['selectOperator'].value == 'Regex')
                    specialOperatorType = 'text';
                }
                
                let condProps = {
                  condindex,
                  condid
                }

              return(
                <div key={condid} className="swz-form-logic-cond-group-child">
                    <h4>Select control:</h4>
                      <Form.Dropdown {...me.genDropDownAttributes(groupProps, condProps, 'selectControl', {type: 'inputControls'})}/>
                    <h4>Select operator:</h4>
                      <Form.Dropdown {...me.genDropDownAttributes(groupProps, condProps,'selectOperator', {type: type})}/>
                    <h4>Answer type:</h4>
                      <Form.Dropdown {...me.genDropDownAttributes(groupProps, condProps,'selectAnsType', {undefined})}/>
                      <p></p>
                      
                    {(itemObj['selectAnsType']  !== undefined && itemObj['selectAnsType']['value'] == "Answer" && (type == 'text' || type == 'number')) && 
                      <Form.Input {...me.genInputAttributes(groupProps, condProps, 'selectAnsAns', specialOperatorType != '' ? specialOperatorType : type )}/>
                    }

                    {(itemObj['selectAnsType']  !== undefined && itemObj['selectAnsType']['value'] == "Answer" && type == 'checkbox') && 
                      <Form.Dropdown {...me.genDropDownAttributes(groupProps, condProps,'selectAnsCb', {undefined})}/>
                    }

                    {(itemObj['selectAnsType']  !== undefined && itemObj['selectAnsType']['value'] == "Answer" && (type == 'radiogroup' || type == 'dropdown')) && 
                      <Form.Dropdown {...me.genDropDownAttributes(groupProps, condProps,'selectAnsRad', {undefined})}/>
                    }

                    {(itemObj['selectAnsType']  !== undefined && itemObj['selectAnsType']['value'] == "Control") &&
                      <Form.Dropdown {...me.genDropDownAttributes(groupProps, condProps, 'selectAnsControl', {type: type})}/>
                    }
                    <div className="swz-form-logic-delete" onClick={() => {me.deleteCondition(groupProps, condindex)}}><img src="./images/DeleteRow.svg" height="24px" /></div>
                  <div className="swz-form-logic-swzdivider"/>
                    {(condGroup.length > 1 && condProps.condindex !== condGroup.length - 1) &&
                    <h4><i>AND</i></h4>}
                      <p></p>
                </div>  
              )
            })
          )
        }
        
      rows.push(
        <div key={groupid} className="swz-form-logic-cond-group">
           <h2 style={{color: 'black', fontWeight: '700'}}>Logic Group {groupindex+1}</h2>
           <div className="swz-form-logic-cond-group-str">
            {/*<Input>{me.concatConditions(condGroup)}</Input>*/}
          </div>
        {groupCompo(condGroup)}
        <div>
          <div className="swz-form-logic-and-button">
            <Button onClick={() => me.addCondition(groupindex, groupid)}> AND </Button>
          </div>
          <div className="swz-form-logic-cond-group-delete" onClick={() => {me.deleteConditionGroup(groupindex)}}>
            <img src="./images/DeleteRow.svg" height="24px" />
          </div>
          <div className="swz-form-logic-cond-group-swzdivider"/>
        </div>
        </div> 
        )       
      }

      return rows
  }

  deleteCondition = (groupProps, condindex) =>{
    let groupindex = groupProps.groupindex;
    let groupid = groupProps.groupid;
    this.setState(prevState => {
      let condGroups = [ ...prevState.condGroups ];
      condGroups[groupindex][groupid] = [...condGroups[groupindex][groupid].slice(0,condindex), ...condGroups[groupindex][groupid].slice(condindex +1)]
      return { condGroups };               
    }) 

  }
  
  deleteConditionGroup = (groupindex) => {
    const condGroups = this.state.condGroups;
    this.setState({ 
      condGroups: [...condGroups.slice(0,groupindex), ...condGroups.slice(groupindex+1)]
    });

  }

  addCondition = (groupindex, groupid) => {
    var condId = Helper.newGuid();//Date.now().valueOf();
    var newArr =  {
        [condId]: {}
    };

    this.setState(prevState => {
      let condGroups = [ ...prevState.condGroups ];
      condGroups[groupindex][groupid] = [...prevState.condGroups[groupindex][groupid], newArr]; 
      return { condGroups };               
    })
    
  }

  addConditionGroup = () => {
    var condGroupId = Helper.newGuid();
    var condId = Helper.newGuid();
    var newArr = {
      [condGroupId]:[{
        [condId]: {}
      }]
    }
   
    var arr = this.state.condGroups == undefined ? [] : this.state.condGroups;
    arr.push(newArr);
   
    this.setState((prevState) => {
      let temp = {
        ...prevState,
        condGroups: arr
       };
      return temp
   })
  }

  concatConditions = (cond, applySkipControl, applyValidMessage, applyType) => {

    let str = '';
    let itemStr;

    var isSpecialOperator = function (value){
      if(value == 'Contain' || value == 'DoesNotContain' || value == 'Regex' || value == '.length ==' || value == 'Blank' || value == "NotBlank")
        return true

      return false
    }

    for(let id in cond){
      let key = Object.keys(cond[id])[0];
      let answer = '';
      let selectControl =  '';
   
      let selectControlType = cond[id][key].selectControl ? cond[id][key].selectControl.type: '';
      
      if(cond[id][key].selectControl){
        let selControlStr = 'data.' + cond[id][key].selectControl.value; 
          selectControl = selControlStr;
 
        if(cond[id][key].selectControl.valueType && cond[id][key].selectControl.valueType == "value"){
           selControlStr = "value";
           selectControl = "value";
        }
       
        if(selectControlType == "number")
           selectControl = 'Number(' + selControlStr + '?' + selControlStr + ':0)';
                 
       }

      let selectOperator = cond[id][key].selectOperator ? cond[id][key].selectOperator.value: '';
      let selectAnsType = cond[id][key].selectAnsType ? cond[id][key].selectAnsType.value : ''; 
      
      let selectAnsAns = cond[id][key].selectAnsAns ? cond[id][key].selectAnsAns : '';
      let selectAnsCb = cond[id][key].selectAnsCb ? cond[id][key].selectAnsCb.value: '';
      let selectAnsRad = cond[id][key].selectAnsRad ? cond[id][key].selectAnsRad: '';
      let selectAnsControl = '';
    

      if(cond[id][key].selectAnsControl){
        let ansControlStr = 'data.' + cond[id][key].selectAnsControl.value;
        selectAnsControl = ansControlStr;
        
        if(selectControlType == "number")
          selectAnsControl = 'Number(' + ansControlStr + '?' + ansControlStr + ':0)';
        
      }

      let openBracket = ' ( ';
      let closeStatement;

      if(applySkipControl){
        closeStatement = ' ? ' + "'" + applySkipControl + "'" +' : false )';
      }else if(applyValidMessage){
        closeStatement = ' ? ' +' true : ' +"'" + applyValidMessage + "'"  + ' )';
      }else{
        if(applyType == 'other-skipConition'){
          closeStatement = ' ? false : false )';
        }else if(applyType == 'other-customValidation'){
          closeStatement = ' ? ' +' true : ' +  "'" + 'is not valid' + "'"  + ' )';
        }else{
          closeStatement = ' ? true : false )';
        }
      }

      let andStatement = ' && ';
      if(selectAnsType == "Answer"){     
        if(selectControlType == "text" || selectControlType == "radiobutton" || selectControlType == "dropdown"){
          answer = "'" + selectAnsAns + "'";
        }else if(selectControlType == "checkbox"){
          answer = selectAnsCb; 
        }else if(selectControlType == "radiogroup" || selectControlType == "dropdown"){
          answer = "'" + selectAnsRad + "'";
        }else{
          answer = selectAnsAns; //nothing
        }
      }else if(selectAnsType == "Control"){
        answer = selectAnsControl;
      }

      if(isSpecialOperator(selectOperator)){
        if(selectOperator == 'Contain'){
          itemStr = selectControl + '.includes(' + answer + ')';
        }else if(selectOperator == 'DoesNotContain'){
          itemStr = '!' + selectControl + '.includes(' + answer + ')';
        }else if(selectOperator == 'Regex'){
          itemStr = '!' + selectControl + ' || (' + selectAnsAns + '.test(' + selectControl + ')' + ')';
        }else if(selectOperator == '.length =='){
          itemStr = selectControl + selectOperator + ' ' + selectAnsAns;
        }else if(selectOperator == 'Blank'){
          itemStr = '!' + selectControl;
        }else if(selectOperator == 'NotBlank'){
          itemStr = selectControl; 
        } 
      }else{
        itemStr = selectControl + ' ' + selectOperator + ' ' + answer;
      }
      var isSelected = selectControl !== '' && selectOperator !== '';
      var isAns = (selectAnsAns !== '' || selectAnsControl !== '' || selectAnsCb !== '' || selectAnsRad !== '');
      var isAnsOthers = (selectOperator == 'Blank' || selectOperator == 'NotBlank');
      var isAllAnswered = isSelected && (isAnsOthers || isAns);

      if(selectControl == '' && (selectAnsAns == '' && selectAnsControl == '')){
        itemStr = '';
      }else{
        if(id < cond.length - 1){
          itemStr += andStatement;
          str += itemStr
  
        }else if(isAllAnswered && id == cond.length - 1){
          //Only if all are not null and last condition
            str = openBracket + str;
            str += itemStr 
            str += closeStatement
        }else{
          str += itemStr
        }
      }
    }
    return str
  }

  handleFormChange = (e, {value, name, checked}) =>{

    const { applyCond, applyType, applyControls } = this.state;
    var type = applyType;
    var controls = applyControls;

    if(checked !== undefined){
      this.setState({ [name]: checked });

    }else{
      this.setState({ [name]: value });

    }
 
    if(name == 'applyControls' || name == 'applyType'){
      if(name == 'applyType')
        type = value !== null && value !== applyType && value;
        
      if(name == 'applyControls')
        controls = value !== null && value !== undefined && value;

      if(controls !== undefined && controls.length > 0 && type !== undefined && type !== ''){
        this.setState({applyCond: []});
        for(let i = 0; i < controls.length; i++){
          this.loadExistingLogic(controls[i], type, false);
        }        
      }else{
        this.setState({applyCond: []});
      }
    }
 
  }  

  loadExistingLogic = (control, type, onApplyControls) => {
    
    const { data } = this.state;
    var filterItem;
    var model;
    var filter;
    var applyControls = [];
    var value = {};

    if(control !== null && type !== null){
      model = Helper.getModelProperty(data, control);
      //other-customValidation, other-visibleConition, other-readOnlyConition, other-skipConition
      //Skip,ReadOnly,Visible,Validation,
      if(type == 'Validation' || type == 'other-customValidation'){
        filter = 'other-customValidation';
      }else if(type == 'Visible' || type == 'other-visibleConition'){
        filter = 'other-visibleConition';
      }else if(type == 'ReadOnly' || type == 'other-readOnlyConition'){
        filter = 'other-readOnlyConition';
      
      }else if(type == 'Skip'){
        filter = 'other-skipConition';
      }

      filterItem = model[filter] !== undefined && model[filter] !== ""? model[filter] : null;
      
      if(onApplyControls){
        applyControls = [model['key']];
        this.setState({applyControls, applyType: filter});
      }

        this.setState(prevState => {
          let applyCond = [ ...prevState.applyCond, filterItem ];
          return { applyCond };               
        })
      
      this.setState({applyItem: model, onFilterDiv: false, onFilterInput:false});
    }
  }

  loadNewForm = () => {
    let emptyArr = [];
    var onLoadNewForm = true;
    this.setState({condGroups: emptyArr, applyCond: [], applyItem: '', applyType: null, onLoadNewForm, applyControls: [], loadNewForm: true});
    let condProps = {
      control: undefined,
      type: undefined
    }
    this.props.openFormLogicControl(condProps);
  }

  getPageInformation = () => {
    console.log("this is", this.state);
    console.log("get data", Helper._swzGetData());
  }
  
  onSaveCond = (bypass) =>{
    const { data, applyControls, applyType, applyItem, applyCond, onLoadNewForm, onNewForm } = this.state;
    var onControlType = (applyControls !== undefined && applyControls.length > 0) || (applyType !== undefined && applyType !== null);
    var onApplyCond = this.getApplyCond();//(applyCond !== undefined && applyCond !== null && applyCond !== ""); 
    let formData = this.state.data !== undefined ? this.state.data : Helper._swzGetData();
    var item;

    var validate = function () {
      
    if(applyControls == undefined || applyControls.length < 0)
      return false
    
    if(applyType == undefined || applyType == null)
      return false

     return true;
    }

    if(!validate()){
      alert("Form is incomplete")
      return
    }

   /*  if((!onApplyCond && onLoadNewForm || bypass))
      return this.setState({open: true}); */

    if(!onControlType)
      return alert('Control or logic type not selected')
    
    if(!onNewForm){
      if(applyItem !== undefined && applyItem !== ''){
        item = applyItem;
      }else{
        item = Helper.getModelProperty(formData, applyControls[0]);
      }
      Helper.onConfirmedSave(applyControls[0], applyType, this.getApplyCond(), item);
    }
    
    if((onNewForm && (applyControls !== undefined && applyControls.length > 0))){        
        for(let i = 0; i < applyControls.length; i++){
          item = Helper.getModelProperty(formData, applyControls[i]);
          Helper.onConfirmedSave(applyControls[i], applyType, this.getApplyCond(), item);
        }
    }
    this.props.onSave();
  }
  
  getApplyCond = () => {
    const { condGroups, applyCond, applySkipControl, applyValidMessage, applyType } = this.state;
    var me = this;
    var str = '';
    var skipControl = (applyType !== undefined && applyType !== null && applyType == 'other-skipConition') && applySkipControl !== null ? applySkipControl : null;
    var validMessage = (applyType !== undefined && applyType !== null && applyType == 'other-customValidation') && applyValidMessage !== null ? applyValidMessage : null;

    var cond;
    if(condGroups == undefined || !(condGroups.length > 0))
      return
    
    for(let j = 0; j < condGroups.length; j++){ 
        let groupid = Object.keys(condGroups[j])[0];
        let condGroup = condGroups[j][groupid];  
        let join = str !== '' ? ' && ' : '';
        cond = me.concatConditions(condGroup, skipControl, validMessage, applyType) == '' ? /* applyCond */ applyCond[0] : me.concatConditions(condGroup, skipControl, validMessage, applyType); 
        str = str + join + cond;
    }
    
    if(str == null || str == 'null'){
      return
    }
    
    return str
  }

  onDetectExistLogic = () => {
    const { onNewForm, currentQuery, data } = this.state;
    var queryObj = Helper.parse_query_string(location.search);
    var control = null;
    var type = null;
    
    if(queryObj !== undefined && queryObj.control !== undefined && queryObj.type !== undefined){
      control = queryObj.control;
      type = queryObj.type;
    }

    if(!(data !== undefined && data.length > 0 ))
      return

    //By default it is true
    if(onNewForm){
      if(control !== null && type !== null){
        this.setState({onNewForm: false, onLoadNewForm: false, currentQuery: control + type});
        return this.loadExistingLogic(control, type, true);

      }
    }else if(currentQuery !== control + type) {
      //Load new form if detected url has changed
      return this.loadExistingLogic(control, type, true);
    }
  }
 
  show = () => this.setState({ open: true });

  handleConfirm = () =>{
    this.onSaveCond(true);
    this.props.onSave();
    this.setState({ open: false });
  }

  handleCancel = () => this.setState({ open: false });
  
  render() {

    const { condGroups, applyControls, applyType, applyValidMessage, applySkipControl, onLoadNewForm, onFilterDiv, onFilterInput, selectApplyType } = this.state;
    const { open } = this.state

    if(condGroups == undefined || !(condGroups.length > 0))
        this.addConditionGroup();    

        this.onDetectExistLogic();

    let filter = {};   
      filter['onFilterDiv'] = onFilterDiv;
      filter['onFilterInput'] = onFilterInput;
      filter['applyControls'] = true;

    let formData = this.state.data !== undefined ? this.state.data : Helper._swzGetData();
    let getOptions = formData !== undefined && formData.length > 0 ? this.onConvertOptions(formData, filter): null;

    return (
      
      <div className="clover-formbuilder-logic-preview">
      <Confirm
          open={open}
          onCancel={this.handleCancel}
          onConfirm={this.handleConfirm}
          header='Confirm'
          content='Logic statement is empty, please confirm the action'
        />
        <div onClick={() => this.getPageInformation()}>
            <h2>Form Logic Builder</h2> 
        </div> 
        <div className="swz-form-logic-cond-group-type">
          <div className="swz-form-logic-cond-group-swzdivider"/>
          <h4 style={{color: 'black', fontWeight: '700'}}>Apply control:</h4> 
          <div style={{'width': '100%', float: 'left'}}>
            <Form.Dropdown disabled={!onLoadNewForm} style={{float: 'left', marginRight: '10px', marginBottom: '10px'}} value={applyControls} name="applyControls" options={getOptions} multiple search selection onChange={this.handleFormChange.bind(this)}/>
            <Form.Group widths="equal">
              <label>Filter by: </label>
              <Checkbox disabled={!onLoadNewForm || (applyControls !== undefined && applyControls.length > 0)} name="onFilterDiv" checked={onFilterDiv} label="Block" onChange={this.handleFormChange.bind(this)}/>
              <Checkbox disabled={!onLoadNewForm || (applyControls !== undefined && applyControls.length > 0)} name="onFilterInput" checked={onFilterInput} label="Input Controls" onChange={this.handleFormChange.bind(this)}/>
            </Form.Group>
          </div>
          <Form.Dropdown disabled={!onLoadNewForm} name="applyType" value={applyType} options={selectApplyType} search selection onChange={this.handleFormChange.bind(this)}/>
          { (applyType && applyType == 'other-skipConition') && 
            <Form.Dropdown style={{marginTop: '10px'}}name="applySkipControl" value={applySkipControl} options={getOptions} search selection onChange={this.handleFormChange.bind(this)}/>
          } 
          { (applyType && applyType == 'other-customValidation') && 
          <React.Fragment>
            <h4>Apply message:</h4>
            <Form.TextArea name="applyValidMessage" value={applyValidMessage} rows={4} style={{width: '500px'}} onChange={this.handleFormChange.bind(this)}/>
          </React.Fragment>
          }  
        </div>
         
        <div className="swz-form-logic-cond-groups">
          {this.genConditionGroups()}
        </div>
        
        <div className="swz-form-logic-spacing"></div>
      </div>
    )
  }
}