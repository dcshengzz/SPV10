
import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./basecomponent"
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm } from 'semantic-ui-react'
import JSON5 from 'json5'
import PanelBase from './panelbase'
import GridView from './../../swz-builder/src/control/gridview'

export default class PanelPager extends PanelBase {
  constructor(props) {
    super(props);

  }

  renderMainForm(){
    var me = this;
    var rowCount = this.props.data[this.dataindex] == undefined ? 0 : this.props.data[this.dataindex].length;
    var hideconfirmdelete = () => {me.setState({confirmdeleteshow: false})};
    
    var columns = this.gridColumns();
    var defaultSort = "";
    if(columns.length > 0)
        defaultSort = columns[0].key + " ASC";

    var res = (<div>
        <h1>{this.title}</h1>
        {this.renderToolbar()}
        <GridView key="Formgrid"
            rowKey={this.idfield} rowHeight={40} columns={this.gridColumns()}
            defaultSort={defaultSort}
            minHeight={this.state.gridHeight} multiselect={true}
            pagerType="server"
            getAdditionalDataForControl={this.getAdditionalDataForControl.bind(this)}
            handleEvent={this.gridHandleEvent.bind(this)}
            ref={(grid)=> { this.grid = grid; }} />
        <Confirm open={this.state.confirmdeleteshow}
        dimmer={'blurring'}
        content={CloverAdminLang.msg.confirmdelete}
        onCancel={hideconfirmdelete}
        onConfirm={this.onDelete.bind(this)} /> 
      </div>);
        
        return res;
  }

  handlePopupChange(e, {name, value, checked}){
    this.state.popup[name] = value;
    this.forceUpdate();
  }

  onDelete(){
    var me = this;
    var deleterows = [];
    var selectedKeys = this.grid.getSeletedRowKeys();
    for(var i=0; i < selectedKeys.length; i++){
      let deleterow = {};
      deleterow[this.idfield] = selectedKeys[i];
      deleterow["__type"] = this.datatype;
      deleterow["__state"] = "deleted"
      deleterows.push(deleterow);
    }

    me.setState({ confirmdeleteshow: false });
    this.ChangeData(deleterows, function(){
      me.grid.refresh();
    });
  }
}