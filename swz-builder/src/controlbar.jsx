import React from 'react';
import BuilderActions from './actions'

export default class ControlBar extends React.Component {
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
      var zones = $('.clover-formbuilder-zone');
  
      zones.removeClass('clover-formbuilder-zone-active');
      zones.removeClass('clover-formbuilder-zone-select')
      zones.off();
    }
  
    onDrop(item, e){
      var el = $(e.target);
      if(el.length > 0){
          BuilderActions.move(item.key, el[0]);
      }

      this.onDragEnd(item);
      return false;
    }
  
    render() {
      var className = "clover-formbuilder-item-toolbar-header";
      if(this.props.isGroup)
        className += " " + "clover-formbuilder-item-toolbar-controlbargroup";
      
      if(this.props.controlOnRight){
        className += " " + "clover-formbuilder-item-toolbar-right";
      }
      else{
        className += " " + "clover-formbuilder-item-toolbar-left";
      }
        
      return (
        <div className={className} 
          onMouseOver={this.onMouseOver.bind(this)}
          onMouseLeave={this.onMouseLeave.bind(this)}>
          <div className="clover-formbuilder-item-toolbar-header-buttons" >
              <div className="clover-formbuilder-item-toolbar-header-title">
                {this.props.text}
              </div>
              <img src="/images/cloverbuilder-move.svg" className="move" height="16px" draggable={true}  
                onDragStart={this.onDragStart.bind(this, this.props.model)}
                onDragEnd={this.onDragEnd.bind(this, this.props.model)}
                onDrag={this.onDrag.bind(this)} />
              <img src="/images/cloverbuilder-edit.svg" height="16px" onClick={this.props.onEdit.bind(this.props.parent, this.props.model)} />
              <img src="/images/cloverbuilder-copy.svg" height="16px" onClick={this.props.onCopy.bind(this.props.parent, this.props.model)} />
              <img src="/images/cloverbuilder-delete.svg" height="16px" onClick={this.props.onDelete.bind(this.props.parent, this.props.model)} />
          </div>
        </div>
      );
    }

    onMouseOver(e){
      var el = $(e.target).parents(".clover-formbuilder-item-toolbar-header");
      if(this.props.controlOnRight){
        el.prev().addClass("clover-formbuilder-item-selected");
      }
      else{
        el.next().addClass("clover-formbuilder-item-selected");
      }
    }

    onMouseLeave(e){
      var el = $(e.target);
      var parents = $(e.target).parents(".clover-formbuilder-item-toolbar-header");
      if(this.props.controlOnRight){
        el.prev().removeClass("clover-formbuilder-item-selected");
        parents.prev().removeClass("clover-formbuilder-item-selected");
      }
      else{
        el.next().removeClass("clover-formbuilder-item-selected");
        parents.next().removeClass("clover-formbuilder-item-selected");
      }
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