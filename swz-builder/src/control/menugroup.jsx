import React, { Component } from 'react'
import JSON5 from 'json5'
import { Menu, Dropdown, Icon } from 'semantic-ui-react'

export default class MenuGroup extends React.Component {
    constructor(props) {
        super(props);
        this.state = {};

        if (props.value != undefined) {
            this.state.activeitem = props.value;
        }
        else if (props.activeitem != null) {
            this.state.activeitem = props.activeitem;
        }
    }

    static getDerivedStateFromProps(nextProps, prevState) {
        if (prevState.activeitem !== nextProps.value)
        {
            return {activeitem: nextProps.value};
        }

        return null;
    }

    handleItemClick(e, {name}) {
        if (this.props.handleEvent != undefined) {
            var res = this.props.handleEvent({
                e,
                key: this.props.name,
                eventName: "onItemClick",
                parameters: {target: name}
            });
            if (res != false) {
                this.setState({activeitem: name});
                this.setState({open: false});
            }
        }
    }

    handleItemClick2(p, e) {
        this.handleItemClick(e, p);
        e.preventDefault();
    }
    
    render() {
        var items = this.props["data-items"];

        if (items == undefined || items == "") {
            items = [];
        }
        else if (!Array.isArray(items)) {
            items = JSON5.parse(items);
        }

    var children = this.renderItems(items, null);

    var controlProps = {};
    for(var p in this.props){
        if(p == "data-items" || p == 'activeitem' || p == 'handleEvent' || p == 'link')
            continue;
        controlProps[p] = this.props[p];
    }
    if(this.props.icon)
        controlProps.icon = 'labeled';
    
    return (<Menu {...controlProps}>
            {children}
        </Menu>);
    }

  renderItems(items, keyPrefix, parentDisplayType){
    let children = [];
    if(keyPrefix === undefined)
      keyPrefix = "";

    for(let i=0; i < items.length; i++){
      let item = items[i];

      if(item.visibleCondition !== undefined && item.visibleCondition !== null && item.visibleCondition !== ""){
        let args = '';
        let body = 'return ' + item.visibleCondition;
        try{
            if(!new Function(args, body)()){
                continue;
            }
        }
        catch(e){};
      }
      let key = String(keyPrefix) + String(i);
      let titleSpan = <span dangerouslySetInnerHTML={{__html: item.title}}/>;

      /*SWZ addition 171019*/
      let icon = item.icon !== undefined && item.icon !== '' ? item.icon : null;
      let displaytype = item.distype !== undefined && item.distype !== null ? item.distype : null;
     
      const trigger = (
        <span>
          {icon !== null && <Icon name={icon} style={{display: "inherit"}} /> 
        }
          {item.title}
        </span>
      )

      
     //If you are a direct parent
      if(Array.isArray(item.children) && item.children.length > 0){
        if(displaytype == 'dropdown'){
            children.push(
                
        <Dropdown open={this.state.open} onClick={this.handleItemClick2.bind(this, {name: item.target})} trigger={trigger} simple item>
          <Dropdown.Menu>
              {this.renderItems(item.children, key + "_", displaytype)}
          </Dropdown.Menu>
        </Dropdown>);

        }else{

        children.push(
        <Menu.Item>{icon !== null &&
            <Icon name={icon}/>
        }
          <Menu.Header>{titleSpan}</Menu.Header>
          <Menu.Menu>
            {this.renderItems(item.children, key + "_", displaytype)}
          </Menu.Menu>
        </Menu.Item>
        )
        };
      }
      else{
        let content = this.props.link ?
            <a style={{color:"inherit"}} href={item.target} onClick={this.handleItemClick2.bind(this, {name: item.target})}>{titleSpan}</a>:
            titleSpan;
            
            let obj = {};
            if(icon !== null){
                obj = {
                    icon: icon
                }
            }
        //Link has no effect for dropdown
        if(parentDisplayType == 'dropdown'){
          if(displaytype !== 'dropdownheader'){
            children.push(<Dropdown.Item
                   {...obj}
                    label={titleSpan}
                    active={this.state.activeitem === item.target}
                    onClick={this.handleItemClick2.bind(this, {name: item.target})}/>)
            }else{
              children.push(<Dropdown.Header
              icon={icon}
              content={titleSpan}/>)
            }
        }else{
        //You are either a child or norma menu item
        children.push(<Menu.Item
          key={key}
          name={item.target}
          active={this.state.activeitem === item.target}
          onClick={this.handleItemClick.bind(this)}>
              {icon !== null &&
        <Icon name={icon}/>}
        {content}</Menu.Item>)
        };
      }
    }
    return children;
  }
}