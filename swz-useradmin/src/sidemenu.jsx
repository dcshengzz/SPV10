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
  
    const returnapp = (
      <span>
        <Icon name={'reply'} style={{display: "inherit"}}/> 
      </span>
      )
    const trigger = (
      <span>
        <Icon name={'users'} style={{display: "inherit"}}/> 
      </span>
      )

    var item = {
      target: '/surveydesigner'
    };

    return (
      <Menu vertical size="huge">
            <Dropdown onClick={this.props.onApp} trigger={returnapp} simple item>
              <Dropdown.Menu>
                <Dropdown.Item    
                    onClick={this.props.onApp}>
                Return to app
                </Dropdown.Item>
              </Dropdown.Menu>
            </Dropdown>

            <Dropdown open={this.state.open} name='users' onClick={this.handleItemClick.bind(this)} trigger={trigger} simple item>
              <Dropdown.Menu>
                <Dropdown.Item     
                  name='users'             
                  onClick={this.handleItemClick.bind(this)}>
                  Users
                </Dropdown.Item>
              </Dropdown.Menu>
            </Dropdown>      
      </Menu>
      

      
      /* <Menu vertical size="huge">
  <Menu.Header  name='users' active={activeItem === 'users'} href="?apanel=users" onClick={this.handleItemClick.bind(this)}>Back To App</Menu.Header>
  }      <Menu.Item name='backtoapp' active={activeItem === 'backtoapp'}  onClick={this.props.onApp}  >Return to app </Menu.Item>
        <Menu.Item> 
          <Menu.Header>{CloverAdminLang.sidemenu.security}</Menu.Header>
          <Menu.Menu>
	            <Menu.Item name='users' active={activeItem === 'users'} href="?apanel=users" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.users}</Menu.Item>
	            {//<Menu.Item name='groups' active={activeItem === 'groups'} href="?apanel=groups" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.groups}</Menu.Item>
	            }
		    {//<Menu.Item name='roles' active={activeItem === 'roles'} href="?apanel=roles" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.roles}</Menu.Item>
	             }
	           {// <Menu.Item name='permissions' active={activeItem === 'permissions'} href="?apanel=permissions" onClick={this.handleItemClick.bind(this)} >{CloverAdminLang.sidemenu.permissions}</Menu.Item>
	           }
	</Menu.Menu>
        </Menu.Item>

      
      </Menu> */);
  }
}