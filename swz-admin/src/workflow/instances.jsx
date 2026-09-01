import React from "react";
import ReactDOM from "react-dom";
import PanelPager from "./../panelpager"
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm, Image } from 'semantic-ui-react'
import JSON5 from 'json5'
import EditForm from "./instanceedit"

export default class Instances extends PanelPager {
  constructor(props) {
    super(props);

    this.title = CloverAdminLang.workflowinstance.title;
    this.panelindex = "workflowinstances";
    this.idfield = "id";
    this.editform = EditForm;
    this.state = {
      popup: {},
      filter: {}
    };
  }

  gridColumns(){
    return [{
        key: 'id',
        name: 'Process Id',
        resizable: true
      },{
        key: 'schemeCode',
        name: CloverAdminLang.workflowinstance.schemecolumn,
        resizable: true
      },{
        key: 'instanceStatus',
        name: CloverAdminLang.workflowinstance.statuscolumn,
        resizable: true,
        formatter: instanceStatusFormatter
      },{
        key: 'activityName',
        name: CloverAdminLang.workflowinstance.activitycolumn,
        resizable: true
      },{
        key: 'stateName',
        name: CloverAdminLang.workflowinstance.statecolumn,
        resizable: true
      }
    ];
  }

  renderToolbar(){
    var me = this;
    var buttons = [];
    if(this.state.popup == undefined)
      this.state.popup = {};
    if(this.state.filter == undefined)
      this.state.filter = {};
    
    var showconfirmdelete = () => {me.setState({confirmdeleteshow: true})};
    var showconfirmcreate = () => {
        me.setState({
        popup: {
            show: true,
            id: me.NewGUID()
        }
        });
    };
    var hideconfirmcreate = () => {me.setState({popup: {show: false}})};
    buttons.push(<Button key="btnCreate" className="buttontype1" onClick={showconfirmcreate}>{CloverAdminLang.button.create}</Button>);
    buttons.push(<Button key="btnDelete" className="buttontype2" onClick={showconfirmdelete}>{CloverAdminLang.button.delete}</Button>);
    
    var popuperror;
    if(this.state.popup.errors != undefined){
      popuperror =(<Message negative>
            <p>{this.state.popup.errors}</p>
        </Message>);
    }

    var statusOptions = [];
    statusOptions.push({text: "...", value: undefined});
    for(let i=0; i <=5; i++){
      statusOptions.push({key: i, text: getInstanceStates(i), value: i});
    }
    statusOptions.push({key: 254, text: getInstanceStates(254), value: 254});
    statusOptions.push({key: 255, text: getInstanceStates(255), value: 255});

    return <div className="cloveradmin-toolbar">
            <div className="cloveradmin-toolbarfilter">
              <Form>
                <Form.Group widths="equal">
                  <Form.Input name="id" label="ProcessId" value={this.state.filter.id} onChange={this.handleFilterChange.bind(this)}/>
                  <Form.Input name="scheme" label="Scheme" value={this.state.filter.scheme} onChange={this.handleFilterChange.bind(this)}/>
                  <Form.Dropdown key="status" name="status" options={statusOptions} label="Status" value={this.state.filter.status} onChange={this.handleFilterChange.bind(this)} selection fluid/>
                  <Form.Input name="activity" label="Activity" value={this.state.filter.activity} onChange={this.handleFilterChange.bind(this)}/>
                  <Form.Input name="state" label="State" value={this.state.filter.state} onChange={this.handleFilterChange.bind(this)}/>
                  <Button className="buttontype2" content={CloverAdminLang.button.search} onClick={this.onSearch.bind(this)} />
                </Form.Group>
              </Form>
            </div>
            {buttons}
            <span>{CloverAdminLang.msg.totalcount} {me.state.rowsCount}</span>
            <Modal dimmer={'blurring'} 
                open={this.state.popup.show} >
                <Modal.Header>Create a process</Modal.Header>
                <Modal.Content>
                    <Form>
                        {popuperror}
                        <Form.Input key="id" name="id" label="ProcessId" required
                            value={this.state.popup.id} 
                            onChange={this.handlePopupChange.bind(this)}
                            error={this.state.popup.iderrors != undefined} />
                        <Form.Input key="scheme" name="scheme" label="Scheme" required
                            value={this.state.popup.scheme} 
                            onChange={this.handlePopupChange.bind(this)}
                            error={this.state.popup.schemeerrors != undefined} />
                    </Form>
                </Modal.Content>
                <Modal.Actions>
                    <Button className="buttontype1" content={CloverAdminLang.button.create} onClick={this.onCreate.bind(this)} />
                    <Button className="buttontype2" content={CloverAdminLang.button.cancel} onClick={hideconfirmcreate} />
                </Modal.Actions>
            </Modal>
        </div>;
  }

  handleFilterChange(e, {name, value}){
    this.state.filter[name] = value;
    this.forceUpdate();
  }

  getAdditionalDataForControl(control, 
    {startIndex, pageSize, filters, sort}, 
    callback){
    var me = this;
    var data = new Array();
    data.push({ name: 'operation', value: 'workflow' });
    data.push({ name: 'suboperation', value: 'loadlist' });
    data.push({ name: 'skip', value: startIndex });
    data.push({ name: 'take', value: pageSize });
    data.push({ name: 'sort', value: sort });

    if(me.state.filter.id != undefined && me.state.filter.id != "")
      data.push({ name: 'id', value: me.state.filter.id });
    if(me.state.filter.scheme != undefined && me.state.filter.scheme != "")
      data.push({ name: 'scheme', value: me.state.filter.scheme });
    if(me.state.filter.status != undefined && me.state.filter.status !== "")
      data.push({ name: 'status', value: me.state.filter.status });
    if(me.state.filter.activity != undefined && me.state.filter.activity != "")
      data.push({ name: 'activity', value: me.state.filter.activity });
    if(me.state.filter.state != undefined && me.state.filter.state != "")
      data.push({ name: 'state', value: me.state.filter.state });
    $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: true,
        type: "post",
        success: function (response) {
          if(response.success){
            callback({
                sIndex: startIndex,
                pSize: pageSize,
                rowsCount: response.item.count,
                items: response.item.instances
            });

            me.setState({
              rowsCount: response.item.count
            });
          }
          else{
            alertify.error(response.message);
          }
        }
    }); 
  }

  getEditRow(){
    var id = this.props.id;
    var me = this;
    var data = new Array();
    data.push({ name: 'operation', value: 'workflow' });
    data.push({ name: 'suboperation', value: 'load' });
    data.push({ name: 'instanceId', value: id });
    
    var response = $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: false,
        type: "post"
    }).responseJSON; 

    if(response.success){
      if(response.item == undefined){
        alertify.error(CloverAdminLang.msg.objectnotfound);
        me.back();
        return {};
      }
      else{
        return response.item;
      }
    }
    else{
      alertify.error(response.message);
    }
    
    return undefined;
  }

  onSearch(){
    this.grid.refresh();
  }

  onCreate(){

    var me = this;
    var processId = me.state.popup.id;
    var scheme = me.state.popup.scheme;
 
    if(processId == undefined || processId == ""){
        me.state.popup.iderrors = "error";
    }
    else{
      me.state.popup.iderrors = undefined;
    }

    if(scheme == undefined || scheme == ""){
      me.state.popup.schemeerrors = "error";
    }
    else{
      me.state.popup.iderrors = undefined;
    }

    if(me.state.popup.iderrors || me.state.popup.schemeerrors){
      this.forceUpdate();
      return;
    }

    var data = new Array();
    data.push({ name: 'operation', value: 'workflow' });
    data.push({ name: 'suboperation', value: 'create' });
    data.push({ name: 'processId', value: processId });
    data.push({ name: 'scheme', value: scheme });
    $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: true,
        type: "post",
        success: function (response) {
          me.setState({popup: {}})
          if(response.success){
            me.props.parent.openpage("workflowinstances", processId);
          }
          else{
            alertify.error(response.message);
          }
        }
    });
  }

  onDelete(){
    var me = this;
    var data = new Array();
    me.setState({ confirmdeleteshow: false });
    
    var processIds = this.grid.getSeletedRowKeys();
    data.push({ name: 'operation', value: 'workflow' });
    data.push({ name: 'suboperation', value: 'delete' });
    data.push({ name: 'processIds', value: JSON.stringify(processIds) });
    $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: true,
        type: "post",
        success: function (response) {
          if(response.success){
            me.grid.refresh();
            alertify.success("Rows have been deleted!");
          }
          else{
            alertify.error(response.message);
          }
        }
    });
  }

  recalcSizeParams(){
    if(!this._isMounted)
        return;
    var h = $(window).height();
  
    this.setState({
        gridHeight: h - 280 - this.props.deltaHeight
    });
  }
}

class instanceStatusFormatter extends React.Component {
  render() {
    var value = getInstanceStates(this.props.value);
    return (<span>{value}</span>);
  }
}

let getInstanceStates = function(status){
  if(status === undefined)
    return "";

  if(status == 255) return "NotFound";
  if(status == 254) return "Unknown";
  if(status == 0) return "Initialized";
  if(status == 1) return "Running";
  if(status == 2) return "Idled";
  if(status == 3) return "Finalized";
  if(status == 4) return "Terminated";
  if(status == 5) return "Error";
  return status;
};