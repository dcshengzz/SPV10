import React, { Component } from 'react'
import JSON5 from 'json5'
import { Menu } from 'semantic-ui-react'
import ReactDatePicker from 'react-datepicker';

export default class SwzSideMenu extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
          validatedpages: this.props.validatedpages
        }; 
    }

    componentWillReceiveProps = (nextProps) => {
      if(nextProps.validatedpages != this.state.validatedpages){
        var validatedpages = nextProps.validatedpages;
        this.setState({validatedpages});
      }
    }

    render() {
    var items = this.props["data-items"];
    const { validatedpages } = this.state
    
    if (items == undefined || items == "") {
        items = [];
    }
    var children = this.renderItems(items, validatedpages);
    var controlProps = {};
    for(var p in this.props){
        if(p == "data-items" || p == 'activeitem' || p == 'handleEvent' || p == 'link')
            continue;
        controlProps[p] = this.props[p];
    }

        return (<Menu {...controlProps}>
            {children}
        </Menu>);
    }

  existValidatedPages = (item, validatedpages) => {
  
    if(validatedpages !== undefined && validatedpages.length > 0){
      for(let i = 0; i < validatedpages.length; i++){
        if(validatedpages[i] == item.target){
          return true
        }
      }
      return false;
    }
  }

  getItemHeader = (count) => {
    let content = <p><span>Total Pages</span><span style={{float: "right"}}>{count}</span></p>;
    return (
      <Menu.Item
      style={{'border-bottom-style':'none', cursor: "none"}}>
        {content}
        </Menu.Item>);
  }

  getItemContent = (item, validatedpages, key) => {
      var titleSpan;
      var content; 
      var itemContent;
      
      var activeSpan = this.props.activeitem === item.target ? <span style={{float: "right"}}>{'<'}</span> : <React.Fragment></React.Fragment> ;

    if(this.existValidatedPages(item, validatedpages)){  
      titleSpan = <span style={{cursor: "pointer"}} dangerouslySetInnerHTML={{__html: item.title}}/>;
      content = <p style={{color:"inherit", cursor: "pointer"}} onClick={this.props.onClickItem.bind(this, {name: item.target})}>{titleSpan}{activeSpan}</p>;
      itemContent = (<Menu.Item
        key={key}
        name={item.target}
        active={this.props.activeitem === item.target}
        onClick={this.props.onClickItem.bind(this)}>{content}</Menu.Item>)

    }else{
      titleSpan = <span style={{cursor: "not-allowed"}} dangerouslySetInnerHTML={{__html: item.title}}/>;
      content = <p style={{color:"inherit", cursor: "not-allowed"}}>{titleSpan}</p> 
      itemContent = (<Menu.Item
        key={key}
        name={item.target}
        active={this.props.activeitem === item.target}
      >{content}</Menu.Item>)
    
    }
      return itemContent
  }


  renderItems(items, validatedpages, keyPrefix){
    let children = [];
    if(keyPrefix === undefined)
      keyPrefix = "";

    for(let i=0; i < items.length; i++){
      let item = items[i];
      let key = String(keyPrefix) + String(i);
      let itemContent = this.getItemContent(item, validatedpages, key); 
      
      children.push(itemContent)
    }
    children.unshift(this.getItemHeader(items.length));
    return children;
  }
}