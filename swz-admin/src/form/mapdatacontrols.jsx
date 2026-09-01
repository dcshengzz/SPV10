import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm, Icon} from 'semantic-ui-react'
import JSON5 from 'json5'
import BaseComponent from './../basecomponent'

export default class CloverAdminFormMappingDataControls extends BaseComponent {
  constructor(props) {
    super(props);
  }

  render(){
    var me = this;
    var controls = this.props.parent.getControlsByFormForDataMapping(this.props.formsource, undefined);
    var res = [];
    
    var parent = me.props.parent;

    controls.forEach(function(c){
      if(!me.isAttached(c, me.props.form.dataMap) && !me.isAttached(c, me.props.form.dataColl)){
        var title = c.key + " : " + c.type;
        if(c.parent != undefined){
          title = c.parent + " -> " + title;
        }
        
        res.push(<div draggable="true" className="mapdatacontrol" key={c.key}
            onDragStart={parent.onDragStart.bind(parent, c.key)}
            onDragEnd={parent.onDragEnd.bind(parent, c.key)} 
            onDoubleClick={parent.onDoubleClick.bind(parent, c.key)}
            onDrag={me.onDrag.bind(me)} >
          <span key="el">{title}</span>
        </div>);
      }
    });

    if(res.length > 0)
      res.unshift(<Message key="MappingDataControlsMessage1">{CloverAdminLang.datamap.moveitemsmsg}</Message>);
    else{
      res.unshift(<Message key="MappingDataControlsMessage2">
        <Icon name='info' />{CloverAdminLang.datamap.nocontrolsonformmsg}</Message>);
    }

    res.push(<div key="controlsdropzone" className="clover-formmapping-zone">{CloverAdminLang.datamap.dropzonemsg}</div>);
    return <div>{res}</div>;
  }

  isAttached(c, dataMap){
    for(var i=0; i < dataMap.length; i++){
      if(c.key == dataMap[i].control){
        return true;
      }
    }
    return false;
  }

  onDrag(e){
    var step = 10;
    if (e.clientY < 150) {
      this.scroll(-step);
    }

    if (e.clientY > ($(window).height() - 150)) {
      this.scroll(step);
    }
  }

  scroll(step) {
    var scrollY = $(window).scrollTop();
    $(window).scrollTop(scrollY + step);
    if (!stop) {
        setTimeout(function () { scroll(step) }, 20);
    }
  }
}