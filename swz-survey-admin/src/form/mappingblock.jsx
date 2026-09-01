import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm, Icon } from 'semantic-ui-react'
import JSON5 from 'json5'
import MappingAppribute from './mappingattribute'
import BaseComponent from './../basecomponent'

export default class CloverAdminFormMappingBlock extends BaseComponent {
  constructor(props) {
    super(props);

    this.state= {
      isexpanded: true
    };
  }

  onExpand(value){
    this.setState({
        isexpanded: value
      });
  }

  render(){
    var me = this;
    var dataMap = this.props.form.dataMap;
    var setEntityHandle = (e, {value}) => { this.props.parent.setEntity(value); };

    var icon;
    if(this.state.isexpanded){
      icon = <img key="btnexpand" onClick={this.onExpand.bind(this, false)} className="clover-formadmin-imgbutton" src="/images/collapse.svg"/>;
    }
    else{
      icon = <img key="btnexpand" onClick={this.onExpand.bind(this, true)} className="clover-formadmin-imgbutton" src="/images/expand.svg"/>;
    }
    
    var renderedAtt = this.renderFields(dataMap);
    var attBlock = [];
    if(renderedAtt.length > 0){
      attBlock.push(<h3 key="titleAtt">Attributes</h3>);
      attBlock.push(renderedAtt);
    }

    let handleChange = function(e, {name, value}){
      me.props.parent.state.form[name] = value;
      me.props.parent.forceUpdate();
    };
    
    let sourceControl = [];
    let dataSourceTypeEntity = false;
    if(this.props.form.dataSourceType === null || this.props.form.dataSourceType === ""){
      dataSourceTypeEntity = true;
      sourceControl.push(<Form.Group key="datatypeentity" widths="equal">
        <div className="clover-formadmin-imgbuttondiv">
          {icon}
        </div>
        <Form.Dropdown label={CloverAdminLang.datamap.mainentityfield} name="entityId" options={this.props.entities} 
            placeholder={CloverAdminLang.datamap.mainentityps} error={Boolean(this.props.form.__error.entityId)}
            value={this.props.form.entityId} onChange={setEntityHandle.bind(this)} selection fluid search />
      </Form.Group>);
      if(this.state.isexpanded){
        sourceControl.push(<div key="mapattributes" className="field clover-formadmin-mapattributes">
          {attBlock}
        </div>);
      }
    }
    else{
      sourceControl.push(<Form.Group key="datatypeurl" widths="equal">
        <Form.Input label={CloverAdminLang.datamap.dataurlfield} name="dataUrl" value={this.props.form.dataUrl} 
          onChange={handleChange} />
      </Form.Group>);
    }

    return <div className="field">
       <Form>
        <div className="field">
            <label key="c1label">{CloverAdminLang.datamap.dataSourceType}</label>
            <Form.Group widths="equal">
                <Form.Radio name="dataSourceType" value="" label={CloverAdminLang.datamap.entityfield} checked={dataSourceTypeEntity} onChange={handleChange} />
                <Form.Radio name="dataSourceType" value="url" label={CloverAdminLang.datamap.dataurlfield} checked={this.props.form.dataSourceType === "url" } onChange={handleChange} />
            </Form.Group>
        </div>
        {sourceControl}
      </Form>
    </div>;
  }
  
  renderFields(dataMap){
    var res = [];
    var me = this;
    dataMap.forEach(function(dm){
      var key = dm.id;
      if(dm.parentId == undefined){
        res.push(<MappingAppribute key={key} item={dm} parent={me} dataMap={dataMap} />);
      }
    });

    return res;
  }
}