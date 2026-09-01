import React, { Component } from 'react'
import { Form, Radio } from 'semantic-ui-react'

export default class RadioGroup extends React.Component {
  constructor(props){
    super(props);
    this.state = {}
  }

  onChange(e, {name, value}){
      if(this.props.onChange != undefined){
        this.props.onChange(e, {name: this.props.name, value});
      }
      else{
          console.error("Set onChange property for RadioGroup!");
      }
  }

  render() {
    var me = this;
    var fields = this.props.items.map(function(item) {
                return <Form.Field key={item.key + "_formfield"}>
                    <Form.Radio
                        key={item.key}
                        label={item.text}
                        name={me.props.name + '_radioGroup'}
                        value={item.value}
                        readOnly={me.props.readOnly}
                        checked={me.props.value === item.value}
                        onChange={me.onChange.bind(this)}
                    />
                </Form.Field>
            }, this);

            
    if(this.props.direction == 'v'){
        return <div className="ui form">
                <label>{this.props.label}</label>
                <Form className={this.props.className} style={this.props.style} >
                    {fields}
                </Form>
      </div>;
    }

    return (<div className="ui form">
        <div className="field">
            <label>{this.props.label}</label>
            <div className={this.props.className} style={this.props.style} >
                <Form.Group key="group">
                    {fields}
                </Form.Group>
            </div>
        </div>
      </div>);
    
  }
}