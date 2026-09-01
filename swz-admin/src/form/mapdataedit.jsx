import React from "react";
import ReactDOM from "react-dom";
import BaseComponent from "./../basecomponent"
import { Form, Input, Checkbox, Button, Message, Dropdown, Breadcrumb } from 'semantic-ui-react'
import JSON5 from 'json5'
import Controls from './mapdatacontrols'
import CloverAdminFormMappingBlock from './mappingblock'
import CloverAdminFormMappingColl from './mappingcoll'
import Triggers from '../data/trigger'

export default class CloverAdminFormMappingData extends BaseComponent {
  constructor(props) {
    super(props);

    this.state = {};
  }
  
  render(){
    var me = this;
    if(this.state.id != this.props.data.name)
    {  
      this.setForm(this.props.data.name);
      return null;
    }

    var entityList = [{text: "...", value: '' }];
    var datamodel = this.props.metadata.dataModel;
    for(var i=0; i < datamodel.length; i++){
      var entity = datamodel[i];
      entityList.push({text: entity.name, value: entity.id });
    }

    var codeactions = this.props.metadata.codeActions;
    var codeactionsarray = [{text: "...", value: '' }];
    var condeactonsAll = [];
    for(var i=0; i < codeactions.length; i++){
      var ca = codeactions[i];
      if(ca.type == 0){
        codeactionsarray.push({text: ca.name, value: ca.name });
      }

      condeactonsAll.push({text: ca.name, value: ca.name });
    }

    if(this.state.form.triggers == undefined)
      this.state.form.triggers = [];

    this.validate();
    return (<div className="cloveradmin-formmapping">
      <Breadcrumb>
            <Breadcrumb.Section onClick={this.props.parent.back.bind(this.props.parent)} link>{CloverAdminLang.datamap.title}</Breadcrumb.Section>
            <Breadcrumb.Divider />
            <Breadcrumb.Section active>{this.props.data.name}</Breadcrumb.Section>
            <Breadcrumb.Divider icon='right angle' />
            <Breadcrumb.Section href={"?apanel=forms&aid=" + this.state.id} onClick={this.openBuilder.bind(this)}>{CloverAdminLang.datamap.builder}</Breadcrumb.Section>
            <Breadcrumb.Divider />
            <Breadcrumb.Section href={"?apanel=actionhandlers&aid=" + this.state.id} onClick={this.openActionHandlers.bind(this)}>{CloverAdminLang.datamap.actionhandler}</Breadcrumb.Section>
        </Breadcrumb>
        <div className="clover-admin-form-buttons">
          <Button className="buttontype1" onClick={this.onSave.bind(this)}>{CloverAdminLang.button.save}</Button>
          <Button className="buttontype1" onClick={this.onAutoMapping.bind(this)}>{CloverAdminLang.datamap.automappingbutton}</Button>
          <Button className="buttontype2" onClick={this.onResetMapping.bind(this)}>{CloverAdminLang.datamap.resetmappingbutton}</Button>
        </div>
        <div className="cloveradmin-formmapping-left">
          <div className="cloveradmin-formmapping-block">
            <CloverAdminFormMappingBlock 
              form={this.state.form} 
              entities={entityList}
              parent={this} />
          </div>
        </div>
        <div className="cloveradmin-formmapping-right">
            <label>Controls</label>
            <Controls formsource={this.state.source} form={this.state.form} parent={this} />
        </div>
        <div style={{clear: "both"}}>
            <CloverAdminFormMappingColl
              form={this.state.form}
              entities={entityList}
              codeactions={codeactionsarray}
              parent={this}
              formsource={this.state.source} />
        </div>
        <div className="cloveradmin-formmapping-triggers">
          <h1>Triggers</h1>
          <div className="field" widths="16">
              <Form>
                <Triggers data={this.state.form.triggers} types={
                  ["Validate",
                  "AfterSelect",
                  "BeforeInsert",
                  "AfterInsert",
                  "BeforeUpdate",
                  "AfterUpdate",
                  // "BeforeDelete",
                  // "AfterDelete",
                  "AfterNew"]}
                    codeactions={condeactonsAll}  />
              </Form>
          </div>
        </div>
    </div>);
    
  }

  openBuilder(e){
    this.props.parent.props.parent.openpage("forms", this.state.id);
    e.preventDefault();
  }

  openActionHandlers(e){
      this.props.parent.props.parent.openpage("actionhandlers", this.state.id);
      e.preventDefault();
  }

  onDragStart(controlkey, e) {
    var selector = '.clover-formmapping-zone';

    e.dataTransfer.setData('controlkey', controlkey); 
    $(selector)
        .addClass('clover-formmapping-zone-active')
        .on('dragenter', this.onTargetDragEnter.bind(this, controlkey, 'clover-formmapping-zone-select'))
        .on('dragleave', this.onTargetDragLeave.bind(this, controlkey, 'clover-formmapping-zone-select'))
        .on('dragover', function(evt) {evt.preventDefault();})
        .on('drop', this.onDrop.bind(this, controlkey));
  }

  onTargetDragEnter(controlkey, css, e) {
    $(e.target).addClass(css);
  }

  onTargetDragLeave(controlkey, css, e) {
    $(e.target).removeClass(css);
  }

  onDragEnd(controlkey) {
    var zones = $('.clover-formmapping-zone');
    zones.removeClass('clover-formmapping-zone-active');
    zones.removeClass('clover-formmapping-zone-select')
    zones.off();
  }

  onDoubleClick(controlkey) {
    var isFind = false;
    this.state.form.dataMap.forEach(function(e){
      if(e.control == controlkey){
        e.control = undefined;
        isFind = true;
        return false;
      }
    });

    this.state.form.dataColl.forEach(function(e){
      if(e.control == controlkey){
        e.control = undefined;
        isFind = true;
        return false;
      }
    });

    if(isFind){
      //Auto mapping
    }

    this.forceUpdate();
  }

  onDrop(controlkey, e){
    var el = $(e.target);
    if(el.length > 0){
      if(el[0].attributes["data-id"] == undefined){
        this.state.form.dataMap.forEach(function(e){
          if(e.control == controlkey){
            e.control = undefined;
            return false;
          }
        });

        this.state.form.dataColl.forEach(function(e){
          if(e.control == controlkey){
            e.control = undefined;
            return false;
          }
        });
      }
      else{
        var dataid = el[0].attributes["data-id"].value;
        this.state.form.dataMap.forEach(function(e){
          if(e.control == controlkey){
            e.control = undefined;
          }

          if(e.id == dataid){
            e.control = controlkey;
            e.isLoadable = true;
          }
        });

        this.state.form.dataColl.forEach(function(e){
          if(e.control == controlkey){
            e.control = undefined;
          }

          if(e.id == dataid){
            e.control = controlkey;
          }
        });
      }
      this.forceUpdate();
    }

    this.onDragEnd(controlkey);
    return false;
  }


  redirectToFormEdit(){
    this.props.parent.openpage("forms");
  }

  validate(){
    var me = this;
    var res = true;
    var editrow = this.state.form;

    if(editrow == undefined)
      return false;

    
    var msgRequiredField = CloverAdminLang.msg.fieldrequired;
    editrow.__error = {};

    res &= editrow.__error.entityId == undefined;

    if(editrow.dataColl != undefined){
      editrow.dataColl.forEach(function(c){
            c.__error = {
              entityId: (c.entityId == undefined || c.entityId == ""  || c.entityId == me.GuidEmpty()) ? msgRequiredField : undefined
            };

            res &= c.__error.entityId == undefined;
        });
      }
    
    if(editrow.triggers != undefined){
      editrow.triggers.forEach(function(c){
          c.__error = {
            triggers: (Array.isArray(c.triggers) && c.triggers.length > 0) ? undefined : msgRequiredField,
            codeAction: (c.codeAction == undefined || c.codeAction == "") ? msgRequiredField : undefined
          };
          res &= c.__error.triggers == undefined && c.__error.codeAction == undefined;
      });
    }

    return res;
  }

  getControlsByFormForDataMapping(source, parent){
    if(source == undefined || source.constructor != Array)
      return [];

    var me = this;
    var res = [];
    source.forEach(function(c){
      let type = c["data-buildertype"];

      if(type !== "button" && 
        type !== "form" &&
        type !== "formgroup" && 
        type !== "customblock"){
        res.push({key: c.key, type: c["data-buildertype"], parent: parent});
      }

      let formname = c["formname"];
      if(type === "customblock" && formname !== undefined){
        let form = me.loadform(formname, undefined, true);
        if(form !== undefined){
          let formSource = undefined;
          try{
            formSource = JSON5.parse(form.source);
          }catch(ex){
            alertify.error(ex);
          }
          let cntls = me.getControlsByFormForDataMapping(formSource, c.key);
          res = res.concat(cntls);
        }
      }

      if(c.children != undefined && c.children.length > 0){
        res = res.concat(me.getControlsByFormForDataMapping(c.children, c.key));
      }

      if(c.placeholders != undefined){
        for(let ph in c.placeholders){
          if(Array.isArray(c.placeholders[ph]) && c.placeholders[ph].length > 0)
            res = res.concat(me.getControlsByFormForDataMapping(c.placeholders[ph], c.key));
        }
      }
    });
    return res;
  }

  onSave(){
    var me = this;

    if(!this.validate()){
      alertify.error(CloverAdminLang.msg.checkerrorsonform);
      this.forceUpdate();
      return;
    }

    this.state.form.__type = "formmapping";
    this.state.form.__state = "updated";
    this.ChangeData([this.state.form], function(response){
      me.ResetSystemProps(me.state.form);
      me.forceUpdate();
    });
  }

  onAutoMapping(){
    this.onResetMapping(true);

    var me = this;
    var form = this.state.form;
    var controls = this.getControlsByFormForDataMapping(this.state.source);

    form.dataMap.forEach(function(item){
      let attributeName = item.attributeName.toLowerCase();
      for(let i=0; i < controls.length; i++){
        if(attributeName == controls[i].key.toLowerCase()){
          item.control = controls[i].key;
          controls.splice(i, 1);
          break;
        }
      }
    });

    alertify.success(CloverAdminLang.datamap.automappingcompleatemsg);
    this.forceUpdate();
  }

  onResetMapping(ignoreForceUpdate){
    var me = this;
    var form = this.state.form;

    form.dataMap = me.createDataMap(form.entityId, undefined, "", []);
    if(form.dataColl == undefined) 
      form.dataColl = [];
    form.dataColl.forEach(function(coll){
      coll.control = undefined;
      coll.dataMap = me.createDataMap(coll.entityId, undefined, "", []);
    });

    if(ignoreForceUpdate != true){
      this.forceUpdate();
    }
  }

  setForm(formId){
    var me = this;
    this.loadform(formId, function(form){
      form.dataMap = me.createDataMap(form.entityId, undefined, "", form.dataMap);
      if(form.dataColl == undefined) 
        form.dataColl = [];

      form.dataColl.forEach(function(coll){
        coll.dataMap = me.createDataMap(coll.entityId, undefined, "", coll.dataMap);
      });

      me.setState({
        form: form,
        id: form.name,
        source: JSON.parse(form.source)
      });
    });
  }

  loadform(name, callfunc, isSync){
    var me = this;
    var data = new Array();
    data.push({ name: 'operation', value: 'loadform' });
    data.push({ name: 'name', value: name });

    if(isSync === true){
      let response = $.ajax({
        url: me.props.apiUrl,
        data: data,
        async: false,
        type: "post",
      }).responseJSON;
      
      if(response.success){
        return response.item;
      }
      else{
        alertify.error(response.message);
      }
      return undefined;
    }
    else{
      $.ajax({
          url: me.props.apiUrl,
          data: data,
          async: true,
          type: "post",
          success: function (response) {
            if(response.success){
              callfunc(response.item);
            }
            else{
              alertify.error(response.message);
            }
          }
      });
    }
  }

  setEntity(entityId){
    if(entityId == this.state.form.entityId)
      return;

    this.state.form.entityId = entityId;
    this.state.form.dataMap = this.createDataMap(entityId, undefined, "", this.state.form.dataMap);
    this.forceUpdate();
  }

  createDataMap(entityId, parentId, nameprefix, existingDataMap, childrenCall) {

      if (childrenCall && !existingDataMap.some(dm => dm.parentId === parentId)) return [];

      var dataMap = [];
      if (entityId == undefined)
          return dataMap;

      var entity = this.getEntityById(entityId);
      if (entity == undefined)
          return dataMap;

      for (var i = 0; i < entity.attributes.length; i++) {
          var att = entity.attributes[i];
          var attdm = undefined;

          for (var j = 0; j < existingDataMap.length; j++) {
              var dm = existingDataMap[j];
              if (dm.attributeId == att.id && dm.parentId == parentId) {
                  attdm = dm;
                  break;
              }
          }

          let item = null;

          if (attdm == undefined) {
              item = {
                  id: this.NewGUID(),
                  parentId: parentId,
                  isLoadable: parentId == undefined ? true : false,
                  isEditable: parentId == undefined ? true : false,
                  attributeId: att.id,
                  attributeName: nameprefix + att.name,
                  referenceEntityId: att.typeId === 1 ? att.referenceEntityId : undefined
              };

          }
          else {
              item = {
                  ...attdm,
                  attributeName: nameprefix + att.name,
                  referenceEntityId: att.typeId === 1 ? att.referenceEntityId : undefined
              };
          }

          dataMap.push(item);

          if (att.referenceEntityId != undefined && att.typeId === 1) {
              var refdataMap = this.createDataMap(item.referenceEntityId, item.id, item.attributeName + "_", existingDataMap, true);
              dataMap = dataMap.concat(refdataMap);
          }
      }
      return dataMap;
  }

  getEntityById(entityId){
    var datamodels = this.props.metadata.dataModel;
    for(var i=0; i < datamodels.length; i++){
      var model = datamodels[i];
      if(model.id == entityId){
        return model;
      }
    }
  }

  updateStateAndForce(){
    this.forceUpdate();
  }
}