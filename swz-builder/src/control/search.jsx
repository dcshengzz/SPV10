import React, { Component } from 'react'
import { Search } from 'semantic-ui-react'

export default class SearchControl extends React.Component {
  constructor(props){
    super(props);

    this.state = {value : ''};
  }

  render() {
    var me = this;
    
    var controlProps = {};
    for(var p in this.props){
        if( p == "value" ||
            p == "handleEvent")
            continue;
        controlProps[p] = this.props[p];
    }
    
    return (<Search
      {...controlProps}
      fluid={true}
      loading={this.state.isLoading}
      onResultSelect={this.handleResultSelect.bind(this)}
      onSearchChange={this.handleSearchChange.bind(this)}
      results={this.state.results}
      value={this.state.value}
      />);
  }

  resetSearch(){
    this.setState({ isLoading: false, results: []});
  }
  
  handleResultSelect(e, {result}){
    if (this.props.handleEvent !== undefined) {
      this.props.handleEvent({key: this.props.name, eventName: "onSelect", parameters: result});
    }
  }

  handleSearchChange(e, {value}){
    var me = this;
    me.setState({ isLoading: true, value });
    
    setTimeout(function(){
      if (me.state.value === null || me.state.value === undefined || me.state.value.length < 2){ 
        return me.resetSearch();
      }
      me.search(me.state.value);
    }, 200);
  }

  search(searchStr){
    let me = this;
    let url = this.props.url;
    url += this.props.url.includes('?') ? "&" : "?";
    url += "term=" + searchStr;
    fetch(url, {
      credentials: 'same-origin'
    }).then(function (response) {
      return response.json();
    })
    .then(function (results) {
        me.setState({
          isLoading: false,
          results: results
        });
    }).catch(function (error) {
      if(console == undefined)
        alert(error);
      else
        console.error(error);
    });
  }
}