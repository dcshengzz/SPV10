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
          //onHide={hide}
          vertical
          visible={visible}
        >

        <Menu.Item>
          <Menu.Header>{CloverAdminLang.sidemenu.form}</Menu.Header>
          <Menu.Menu>
            <Menu.Item name='forms' active={activeItem === 'forms'} href="?apanel=forms" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.forms}</Menu.Item>
            <Menu.Item name='actionhandlers' active={activeItem === 'actionhandlers'} href="?apanel=actionhandlers" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.actionhandlers}</Menu.Item>
            {/*<Menu.Item name='localization' active={activeItem === 'localization'} href="?apanel=localization" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.localization}</Menu.Item>*/}
          </Menu.Menu>
        </Menu.Item>
      
      </Sidebar>
      

   
   );
  }
}