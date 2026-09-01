import React, { Component } from 'react'
import { Form, Radio } from 'semantic-ui-react'

export default class RadioGroup extends React.Component {
  constructor(props){
    super(props);
    this.state = {
        value: this.props.value,
        isShuffled: false
    }
  }

    componentDidMount() {
        var isSlider = this.props.sliderForm;
        if(isSlider){
            this.redrawSlider();
        }
    } 

    componentDidUpdate(prevProps){ 
        var isSlider = this.props.sliderForm;
        if(isSlider && (prevProps.value != this.props.value || this.props.builderMode)){
            this.redrawSlider();
        }

    }

    redrawSlider(){
            var radiotoslider = $("#"+this.props.name).radioslider();
            radiotoslider.radioslider('destroy');
            var newslider = $("#"+this.props.name).radioslider();
            if(this.props.readOnly){
                newslider.radioslider('setDisabled');
            }else{
                newslider.radioslider('setEnabled');
            }
    }

    onChange(e, {name, value}){
        if(this.props.onChange != undefined){
            this.props.onChange(e, {name: this.props.name, value});
        }
        else{
            console.error("Set onChange property for RadioGroup!");
        }
        
    }

    onSliderChange(e, value){
        if(this.props.onChange != undefined){
            this.props.onChange(e, {name: this.props.name, value});
        }
        else{
            console.error("Set onChange property for Slider!");
        }
        
    }

    static getDerivedStateFromProps(nextProps, prevState) {

        if (nextProps.value != prevState.value){
           return ({value: nextProps.value});
        }
    }
    
    onClick(inValue, e){
            
        if(this.props.readOnly)
            return;

        var newValue;
        const { value } = this.state;

        if(value == inValue){
            newValue = "";
        }else{
            newValue = inValue
        }
        this.setState({value: newValue})

        if(this.props.onClick != undefined){
            this.props.onClick(e, newValue);
        }
        else{
            console.error("Set onClick property for RadioGroup!");
        }

        if(this.props.autoSave)
            this.props.autoSave(e);
        
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

    resetValue(){
        CloverApp.API.setDataField(this.props.name, '');
    }

  render() {
    let builderMode = this.props.builderMode ? this.props.builderMode : false;
    if(builderMode){
        var radiotoslider = $("#"+this.props.name).radioslider();
        radiotoslider.radioslider('destroy');
    }

    var isSlider = this.props.sliderForm;
    var isPrePopulated = this.props.isPrePopulated;
    var applyErrorClass = this.props.additionalParams.errors !== undefined && this.props.additionalParams.errors[this.props.name] ? 'swz-error-highlight-border' : '';
    var me = this;
    //var initialItems = this.props.items;
    var data = this.props.additionalParams.data;
    var newItems = this.props.randomise !== undefined && this.props.randomise && data !== undefined && !this.state.isShuffled ? this.shuffle(this.props.items): this.props.items;
    var fields = undefined;
    if(isSlider){
        fields = newItems.map(function(item) {
            let isChecked = me.props.value === item.value;
            let className = (isChecked && isPrePopulated) ? 'prepopulated-field' : '';
            var checkValue = false;
            if(me.props.value === item.value){
                checkValue = true;
            }
            if(!builderMode){
                let visibleCondition = item['visible-condition'] ? item['visible-condition'] : '';
                if(visibleCondition != '' && data != undefined){
                    let args = 'data';
                    let body = 'return ' + visibleCondition;
                    let isDisplay = true;
                    try { 
                        isDisplay = new Function(args, body)(data); 
                    }
                    catch(err) {
                        console.log('Logic error - condition ', item.value, err);
                    }
                    if(!isDisplay) {
                        if(isChecked)
                            this.resetValue();
                        className = className + ' RadioGroupHide ';
                    }
                }
            }
            return ([
                <input 
                    id={me.props.name+"_"+item.value}                     
                    name={me.props.name}
                    value={item.value}
                    type="radio"
                    checked={checkValue}
                    readOnly={me.props.readOnly}
                    onChange={me.onChange.bind(this)}
                    className={className}
                    onClick={me.onClick.bind(this, item.value)}> 
                </input>,
            <label for={me.props.name+"_"+item.value}>{item.text}</label>]);

        }, this);
        //this.redrawSlider();
        return (<div className="swz-radio-group">
                    <div className="ui form">
                        <div className="field">
                            <label>{this.props.label}</label>
                            <div className={this.props.className} style={this.props.style} >
                                <div class="radiotoslider" id={this.props.name}>{fields}</div>
                            </div>
                        </div>
                    </div>
                </div>);
    }
    else{
        var radiotoslider = $("#"+this.props.name).radioslider();
        radiotoslider.radioslider('destroy');
        fields = newItems.map(function(item) {
            let isChecked = me.props.value === item.value;
            let className = (isChecked && isPrePopulated) ? 'prepopulated-field' : '';
            if(!builderMode){
                let visibleCondition = item['visible-condition'] ? item['visible-condition'] : '';
                if(visibleCondition != '' && data != undefined){
                    let args = 'data';
                    let body = 'return ' + visibleCondition;
                    let isDisplay = true;
                    try { 
                        isDisplay = new Function(args, body)(data); 
                    }
                    catch(err) {
                        console.log('Logic error - condition ', item.value, err);
                    }
                    if(!isDisplay) {
                        if(isChecked)
                            this.resetValue();
                        className = className + ' RadioGroupHide ';
                    }
                }
            }

            return <Form.Field key={item.key + "_formfield"} onClick={me.onClick.bind(this, item.value)}>
                <Radio
                    key={item.key}
                    label={item.text}
                    name={me.props.name /* + '_radioGroup' */}
                    value={item.value}
                    readOnly={me.props.readOnly}
                    checked={isChecked}
                    onChange={me.onChange.bind(this)}
                    className={className}
                />
            </Form.Field>
        }, this)

        if(this.props.direction == 'v'){
            return (<div className={applyErrorClass}>
                <div className="swz-radio-group">
                    <div className="ui form"> {/*added positon unset 161019 to remove clicking on toolbar bug*/}
                        <div className="field">
                            <label>{this.props.label}</label>
                            <Form className={this.props.className} style={this.props.style} >
                                {fields}    
                            </Form>
                        </div>
                    </div>
                </div>
          </div>);
        }
    
        return (<div className={applyErrorClass}>
        <div className="swz-radio-group">
            <div className="ui form"> {/*added positon unset 161019 to remove clicking on toolbar bug*/}
            <div className="field">
                <label>{this.props.label}</label>
                <div className={this.props.className} style={this.props.style} >
                    <Form.Group key="group">
                        {fields} 
                    </Form.Group>
                </div>
            </div>
            </div>
          </div>
          </div>);
    }
 }
}