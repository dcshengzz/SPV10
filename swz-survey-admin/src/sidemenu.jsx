import React from "react";
import ReactDOM from "react-dom";
import { Menu, Icon, Dropdown } from 'semantic-ui-react'

export default class SideMenu extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  handleItemClick(e, { name }){
    this.setState({open: false});
    this.props.parent.handleMenuItemClick(e, { name });
    e.preventDefault();
  }

  
  
  render() {
    var activeItem = this.props.activeItem;
    var me = this;

    const returnapp = (
      <span>
        <Icon name={'reply'} style={{display: "inherit"}}/> 
      </span>
      )
    const trigger = (
      <span>
        <Icon name={'file alternate outline'} style={{display: "inherit"}}/> 
      </span>
    )
    const triggerb = (
      <span>
        <Icon name={'bars'} style={{display: "inherit"}}/> 
      </span>
      )


    return (
    
    <Menu vertical size="huge">
    <Dropdown onClick={this.props.onApp} trigger={returnapp} item>
      <Dropdown.Menu>
        <Dropdown.Item    
           onClick={this.props.onApp}>
        Return to app
        </Dropdown.Item>
      </Dropdown.Menu>
    </Dropdown>

    <Dropdown /* name='forms' onClick={this.handleItemClick.bind(this)} */ open={this.state.open} trigger={trigger} simple item>
      <Dropdown.Menu>
        <Dropdown.Item     
          name='forms'      
          /* href="?apanel=forms" */
          onClick={this.handleItemClick.bind(this)}>
          Forms
        </Dropdown.Item>
        <Dropdown.Item     
          name='formlogic'             
          /* href="?apanel=formlogic" */
          onClick={this.handleItemClick.bind(this)}>
          Form logic
        </Dropdown.Item>
        <Dropdown.Item     
          name='formstyle'             
          onClick={this.handleItemClick.bind(this)}>
          Form Style
        </Dropdown.Item>
      </Dropdown.Menu>
    </Dropdown>      
    <Dropdown open={this.state.open} trigger={triggerb} simple item>
      <Dropdown.Menu>
        <Dropdown.Item     
          name='filestorage'      
          /* href="?apanel=filestorage" */
          onClick={this.handleItemClick.bind(this)}>
          File storage
        </Dropdown.Item>
      </Dropdown.Menu>
    </Dropdown>      
</Menu>
    

    
    
    
    /* <Menu vertical size="huge">
        <Menu.Item name='backtoapp' active={activeItem === 'backtoapp'}  onClick={this.props.onApp}>Return to app </Menu.Item>
        <Menu.Item>
          <Menu.Header>{CloverAdminLang.sidemenu.form}</Menu.Header>
          <Menu.Menu>
            <Menu.Item name='forms' active={activeItem === 'forms'} href="?apanel=forms" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.forms}</Menu.Item>
            <Menu.Item name='formlogic' active={activeItem === 'formlogic'} href="?apanel=formlogic" onClick={this.handleItemClick.bind(this)}> Manage form logic</Menu.Item>
            <Menu.Item name='formdata' active={activeItem === 'formdata'} href="?apanel=formdata" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.formdata}</Menu.Item>
            <Menu.Item name='actionhandlers' active={activeItem === 'actionhandlers'} href="?apanel=actionhandlers" onClick={this.handleItemClick.bind(this)}>Manage validation</Menu.Item>
          <Menu.Item name='localization' active={activeItem === 'localization'} href="?apanel=localization" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.localization}</Menu.Item>
          </Menu.Menu>
        </Menu.Item>
      </Menu> */);
  }
}