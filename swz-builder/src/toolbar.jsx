import React from 'react';
import BuilderActions from './actions'
import CloverFormControls from './controls'
import {CustomBlockEditControl} from './editform-controls'

export default class Toolbar extends React.Component {

  constructor(props) {
    super(props);

    let items = [...CloverFormControls.Items];
    if(Array.isArray(this.props.templates) && this.props.templates.length > 0){
      items.push({ key: "sepTemplates", title: 'Templates', isseparate: true, defaultopen: false});
      
      this.props.templates.forEach(function(template){
        items.push({ 
          key: template, 
          builderType: "customblock",
          title: template, 
          control: undefined, 
          editControl: CustomBlockEditControl,
          defaultValues: {formname: template, sourceType: "form"} });
      });
    }

    this.makeLocalization(items);
    
    this.state = {
      items: items
    };
  }

  makeLocalization(items){
    if(this.props.localization == undefined)
      return;

    var local = this.props.localization;
    for(var i=0; i < items.length; i++){
      if(local[items[i].key] != undefined){
        items[i].title = local[items[i].key];
      }
    }
  }

  onDragStart(item, e) {
    var selector = '.clover-formbuilder-zone';
    e.dataTransfer.setData('text', ''); 

    if(item.forContainerType != undefined){
      let cTypes = item.forContainerType.split(',');
      let subSelector = "";
      cTypes.forEach(function(c){
        if(subSelector.length > 0) 
          subSelector += ",";
        subSelector += "[data-buildertype='" + c + "'] > " + selector;
      });
      selector = subSelector;
    }

    $(selector)
        .addClass('clover-formbuilder-zone-active')
        .on('dragenter', this.onTargetDragEnter.bind(this, item, 'clover-formbuilder-zone-select'))
        .on('dragleave', this.onTargetDragLeave.bind(this, item, 'clover-formbuilder-zone-select'))
        .on('dragover', function(e) {e.preventDefault();})
        .on('drop', this.onDrop.bind(this, item));
  }

  onTargetDragEnter(item, css, e) {
    $(e.target).addClass(css);
  }

  onTargetDragLeave(item, css, e) {
    $(e.target).removeClass(css);
  }

  onDragEnd(item) {
    this.stop = false;
    var zones = $('.clover-formbuilder-zone');

    zones.removeClass('clover-formbuilder-zone-active');
    zones.removeClass('clover-formbuilder-zone-select')
    zones.off();
  }

  onDrop(item, e){
    var el = $(e.target);
    if(el.length > 0){
      BuilderActions.add(item, el[0]);
    }

    this.onDragEnd(item);
    return false;
  }

  onDoubleClick(item){
    BuilderActions.add(item);
  }

  onExpand(item, value){
    item.isexpanded = value;
    this.setCookie("toolbar_" + item.key, value);
    this.forceUpdate();
  }

  render() {
    var me = this;
    var expandedbock = false;
    return (
      <div className="clover-formbuilder-toolbox">
        <ul>
          {
            this.state.items.map(item => {
                let title = item.title;                
                if(me.props.localization != undefined && me.props.localization[item.key] != undefined){
                  title = me.props.localization[item.key];
                }

                if(item.isseparate)
                {
                  var icon;
                  var onclick;

                  if(item.isexpanded == undefined){
                    var cookievalue = me.getCookie("toolbar_" + item.key);
                    item.isexpanded = cookievalue != undefined ? (cookievalue == "true") : item.defaultopen;
                  }

                  if(item.isexpanded){
                    expandedbock = true;
                    onclick = me.onExpand.bind(me, item, false);
                    icon = <span>&ndash;</span>;//<img  key="btnexpand" className="collapse" src="/images/collapse.svg"/>;
                  }
                  else{
                    expandedbock = false;
                    onclick = me.onExpand.bind(me, item, true);
                    icon = <span>+</span>;//<img key="btnexpand" className="expand" src="/images/expand.svg"/>;
                  }
                  
                  return <li draggable="false" onClick={onclick} className="clover-formbuilder-toolbox-subheader" key={item.key}>
                      {title}
                      {icon}</li>;
                }
                
                if(expandedbock){
                  var w = item.imagewidth != undefined ? item.imagewidth : 32;
                  var h = item.imageheight != undefined ? item.imageheight : 32;

                  return (<li draggable="true" className="clover-formbuilder-toolbox-control"
                      key={item.key}
                      onDragStart={this.onDragStart.bind(this, item)}
                      onDragEnd={this.onDragEnd.bind(this, item)} 
                      onDoubleClick={this.onDoubleClick.bind(this, item)}
                      onDrag={this.onDrag.bind(this)}>
                      <img className="clover-formbuilder-toolbox-control-icon" src="/images/cloverbuilder-toolbar-move.png"/>
                      <div className="clover-formbuilder-toolbox-control-text">{title}</div>
                  </li>);
                }
            })
          }
        </ul>
      </div>
    )
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

  getCookie(name) {
    var matches = document.cookie.match(new RegExp(
      "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
    ));
    return matches ? decodeURIComponent(matches[1]) : undefined;
  }

  setCookie(name, value, options) {
    options = options || {};
  
    var expires = options.expires;
  
    if (typeof expires == "number" && expires) {
      var d = new Date();
      d.setTime(d.getTime() + expires * 1000);
      expires = options.expires = d;
    }
    if (expires && expires.toUTCString) {
      options.expires = expires.toUTCString();
    }
  
    value = encodeURIComponent(value);
  
    var updatedCookie = name + "=" + value;
  
    for (var propName in options) {
      updatedCookie += "; " + propName;
      var propValue = options[propName];
      if (propValue !== true) {
        updatedCookie += "=" + propValue;
      }
    }
  
    document.cookie = updatedCookie;
  }
}
