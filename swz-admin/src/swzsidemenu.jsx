import React from "react";
import ReactDOM from "react-dom";
import { Menu, Sidebar, Segment, Header, Button } from 'semantic-ui-react'

export default class SideMenu extends React.Component {
  constructor(props) {
    super(props);
    this.state = { 
  
    }

   

  }


  handleItemClick(e, { name }){
    this.props.parent.handleMenuItemClick(e, { name });
    e.preventDefault();
  }

  render() {
    var activeItem = this.props.activeItem;
    var visible  = this.props.visible;
    var hide  = this.props.hide;
    return (
    

        <Sidebar
              as={Menu}
              animation='overlay'
              inverted
             // onHide={hide}
              vertical
              visible={visible}
            >
            <Menu.Item name='dashboard' active={activeItem === 'dashboard'} href="?apanel=dashboard" onClick={this.handleItemClick.bind(this).bind(this)} >{CloverAdminLang.sidemenu.dashboard}</Menu.Item>
            {/* <Menu.Item name='modules' active={activeItem === 'modules'} href="?apanel=modules" onClick={this.handleItemClick.bind(this).bind(this)} >{CloverAdminLang.sidemenu.modules}</Menu.Item>*/}
            <Menu.Item>
              <Menu.Header>{CloverAdminLang.sidemenu.data}</Menu.Header>
              <Menu.Menu>
                <Menu.Item name='datamodel' active={activeItem === 'datamodel'} href="?apanel=datamodel" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.datamodel}</Menu.Item>
                <Menu.Item name='datasync' active={activeItem === 'datasync'} href="?apanel=datasync" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.datasync}</Menu.Item>
              </Menu.Menu>
            </Menu.Item>

            <Menu.Item name='codeactions' active={activeItem === 'codeactions'} href="?apanel=codeactions" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.codeactions}</Menu.Item>
        <Menu.Item>
          <Menu.Header>{CloverAdminLang.sidemenu.form}</Menu.Header>
          <Menu.Menu>
            <Menu.Item name='forms' active={activeItem === 'forms'} href="?apanel=forms" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.forms}</Menu.Item>
            <Menu.Item name='formdata' active={activeItem === 'formdata'} href="?apanel=formdata" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.formdata}</Menu.Item>
            <Menu.Item name='actionhandlers' active={activeItem === 'actionhandlers'} href="?apanel=actionhandlers" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.actionhandlers}</Menu.Item>
            <Menu.Item name='localization' active={activeItem === 'localization'} href="?apanel=localization" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.localization}</Menu.Item>
          </Menu.Menu>
        </Menu.Item>

        <Menu.Item>
          <Menu.Header>{CloverAdminLang.sidemenu.workflow}</Menu.Header>
          <Menu.Menu>
            <Menu.Item name='workflow' active={activeItem === 'workflow'} href="?apanel=workflow" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.schemes}</Menu.Item>
            <Menu.Item name='workflowinstances' active={activeItem === 'workflowinstances'} href="?apanel=workflowinstances" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.workflowinstances}</Menu.Item>
            <Menu.Item name='businessflow' active={activeItem === 'businessflow'} href="?apanel=businessflow" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.businessflow}</Menu.Item>
            </Menu.Menu>
        </Menu.Item>

        <Menu.Item>
          <Menu.Header>{CloverAdminLang.sidemenu.security}</Menu.Header>
          <Menu.Menu>
            <Menu.Item name='users' active={activeItem === 'users'} href="?apanel=users" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.users}</Menu.Item>
            <Menu.Item name='groups' active={activeItem === 'groups'} href="?apanel=groups" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.groups}</Menu.Item>
            <Menu.Item name='roles' active={activeItem === 'roles'} href="?apanel=roles" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.roles}</Menu.Item>
            <Menu.Item name='permissions' active={activeItem === 'permissions'} href="?apanel=permissions" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.permissions}</Menu.Item>
          </Menu.Menu>
        </Menu.Item>

        <Menu.Item href='https://softworkz.net' target='_blank'>
          {CloverAdminLang.sidemenu.support}
        </Menu.Item>
        
          
      </Sidebar>

   
   );
  }
}