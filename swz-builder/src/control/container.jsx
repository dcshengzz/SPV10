import React, { Component } from 'react'
import { Form, Radio } from 'semantic-ui-react'

export default class Container extends React.Component {
  constructor(props){
    super(props);
    this.state = {}
  }

  
  render() {
    return (<div {...this.props}></div>);
    
  }
}