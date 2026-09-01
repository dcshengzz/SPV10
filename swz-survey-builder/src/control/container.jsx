import React, { Component } from 'react'
import { Form, Radio } from 'semantic-ui-react'

export default class Container extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      isShuffled: false
    }
  }

  shuffle = (array, isModel) => {
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
    if(isModel)
      this.storePosition(array); 
  
    //Important statement to ensure render does not exceed
    this.setState({isShuffled: true});
    return array;
  }

  storePosition = (children) => {
    var childrenPosition = {};
    for(let i = 0; i < children.length; i++){
      childrenPosition[children[i].key] = i;
    }
    this.setState({childrenPosition});
    this.setState({childrenLength: children.length});
  }

  loadPosition = (array) => {
    const { childrenPosition, childrenLength } = this.state;
    var newArr = [];
    var genArray = function (length){
      var arr = [];
      for(let i = 0; i < length; i++){
        arr.push(null);
      }
      return arr;
    }
    
    if(array !== undefined && array.length > 0){
      newArr = genArray(childrenLength);
      for(let i = 0; i < array.length; i++){
        if(childrenPosition[array[i].key] !== undefined){
            newArr.splice(childrenPosition[array[i].key], 0, array[i]);
        }
      }

      var filtered = newArr.filter(function (el) {
        return el != null;
      });

      return filtered
    }
      return array  
  }

  render() {

    const { isShuffled } = this.state;
    var propsControl = {};
    var data = this.props.data;
    var model = this.props.additionalParams.model;
    var myProps = this.props;
    var newChildren;
    
    if(isShuffled){
      newChildren = this.loadPosition(myProps.children);
    }else if(this.props.randomise !== undefined && this.props.randomise && data !== undefined && !isShuffled){
      this.shuffle(model.children, true);
      newChildren = this.shuffle(myProps.children, false);
    }else{
      newChildren = myProps.children;
    }

    for(var p in myProps){
      if(p !== 'children'){
        propsControl[p] = myProps[p];
      }else{
        propsControl[p] = newChildren;
      }
    }
    
    return (<div {...propsControl}></div>);    
  }
}