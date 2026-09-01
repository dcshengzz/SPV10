import React from 'react';
import BuilderActions from './actions'

export default class ControlBar extends React.Component {
  constructor(){
    super();
    this.state = {
      isShuffled: false,
      autoSumVal: null
    }
  }
  
    onDragStart(item, e) {
      
      var selector = '.clover-formbuilder-zone';
      if(e !== undefined && e.dataTransfer !== undefined)
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
          .on('onmousedown', this.onClear())
          .on('dragenter', this.onTargetDragEnter.bind(this, item, 'clover-formbuilder-zone-select'))
          .on('dragleave', this.onTargetDragLeave.bind(this, item, 'clover-formbuilder-zone-select'))
          .on('dragover', function(e) {e.preventDefault();})
          .on('click', this.onDrop.bind(this, item))
          .on('drop', this.onDrop.bind(this, item));
    }
    
    onClear(item) {
      this.stop = false;
      var zones = $('.clover-formbuilder-zone');
      zones.off(); 
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
  
    /*SWZ Addition 110419*/
    onPageElement = (item, element) => {
      if(element != null || element != undefined){
        var onPageElement = element.outerHTML.includes('elementtoinsert');
      }
      if(!onPageElement && item['data-buildertype'] == "swzPage"){
        return true
      }
      if(onPageElement && item['data-buildertype'] !== "swzPage"){
        return true
      }
      alert("You can only place control elements under a page block");
      return false
    }

    isInput = (type) => {
      if(type == "input" || type == "textarea"|| type == "checkbox" || type == "dropdown" || type == "radiogroup" || type == "swztable"){
        return true
      }else{
          return false
      }
    }

    /*SWZ Addition for ToolBar 151019*/
    onInputElement = (item, element, parentType) => {

      if(element != null || element != undefined){
        var onBlockElement = element.outerHTML.includes('elementtoinsert');
        var onTableElement = element.outerHTML.includes('tableindex');
      }
      //If we are not putting into a div/page
      if(!onBlockElement && item['data-buildertype'] == "swzPage"){
        return true
      }

      //Not input
      if(onBlockElement && !this.isInput(item['data-buildertype'])){
        return true
      }

      if(onBlockElement && this.isInput(item['data-buildertype']) && (parentType == "block"  || parentType == "formgroup") && !(item.key == "swztable" && parentType == "formgroup")){
        return true
      }

      if(onTableElement){
        return true
      }

      /* alert("Inputs or table must be placed under block"); */
      alert("Control must be placed under the block");
      return false
    }

    onDrop(item, e){
      var el = $(e.target);
    if(el.length > 0){
      if(this.onPageElement(item, el[0]) && this.onInputElement(item, el[0], el[0].parentNode.dataset['buildertype'])){
        BuilderActions.move(item.key, el[0]);
  
      }
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
     
      var onHeaderTitleGroup = (this.props.model['other-required'] !== undefined && this.props.model['other-required'] !== "" && this.props.model['other-required']) 
      || (this.props.model['other-customValidation'] !== undefined && this.props.model['other-customValidation'] !== "") 
      || (this.props.model['other-visibleConition'] !== undefined && this.props.model['other-visibleConition'] !== "")
      || (this.props.model['other-skipConition'] !== undefined && this.props.model['other-skipConition'] !== "")
      || (this.props.model['other-readOnlyConition'] !== undefined && this.props.model['other-readOnlyConition'] !== "");

      return (
        <div className={className} 
          onMouseOver={this.onMouseOver.bind(this)}
          onMouseLeave={this.onMouseLeave.bind(this)}>
          <div className="clover-formbuilder-item-toolbar-header-buttons" >
              {/*Contain name and type*/}             
              <div className="clover-formbuilder-item-toolbar-header-title">
               {this.props.model.key}
               {this.props.model.reference && 
                ` (` + this.props.model.reference + `) ` }{` - `}
              </div>        
              <div className="clover-formbuilder-item-toolbar-header-title">
              {/* Add to change formgroup name to blockgroup - hard code 251019 Ben */}
                {this.props.text == 'formgroup' ? 'blockgroup' : this.props.text}{` `}
              </div>
              {(this.props.text == "swzPage" || this.props.text == "block" ) &&
                <div className="clover-formbuilder-item-toolbar-header-addtemplate">
                  <div className="clover-formbuilder-item-toolbar-header-title">
                    {this.props.text == "swzPage" && 
                      <span style={{'cursor': 'pointer'}} onClick={(e) => this.props.loadTemplate(this.props.model.key)}>
                        {'Add template'}
                      </span>
                    }
                    {this.props.text == "block" && 
                      <span style={{'cursor': 'pointer'}} onClick={(e) => this.props.loadTemplateBlock(this.props.model.key)}>
                        {'Add template'}
                      </span>
                    }
                  </div>
                </div>
              }
              {onHeaderTitleGroup &&
              <div className="clover-formbuilder-item-toolbar-header-title-group">
                {/* Contain validation*/}
                {(this.props.model['other-required'] !== undefined && this.props.model['other-required'] !== "" && this.props.model['other-required']) && 
                  <div className="clover-formbuilder-item-toolbar-header-title">
                    <span name={'onHighlightR'}>
                      {'R'}
                    </span>
                  </div>
                }
                {/* Contain validation*/}
                {(this.props.model['other-customValidation'] !== undefined && this.props.model['other-customValidation'] !== "") &&
                  <div className="clover-formbuilder-item-toolbar-header-title">
                    <span name={'onHighlightV'}>  
                      {'V'}
                    </span>
                  </div>
                }
                {/* Contain condition*/}
                {(this.props.model['other-visibleConition'] !== undefined && this.props.model['other-visibleConition'] !== "") &&
                  <div className="clover-formbuilder-item-toolbar-header-title">
                    <span name={'onHighlightC'}>
                      {'C'}
                    </span>
                  </div>
                }
                {/* Contain ReadOnly*/}
                {(this.props.model['other-readOnlyConition'] !== undefined && this.props.model['other-readOnlyConition'] !== "") &&
                  <div className="clover-formbuilder-item-toolbar-header-title">
                    <span name={'onHighlightRd'}>
                      {'RD'}
                    </span>
                  </div>
                }
                {/* Contain skip*/}
                {(this.props.model['other-skipConition'] !== undefined && this.props.model['other-skipConition'] !== "") &&
                  <div className="clover-formbuilder-item-toolbar-header-title">
                    <span name={'onHighlightS'}>
                      {'S'}
                    </span>
                  </div>
                }
              </div>
              }
              <img src="./images/cloverbuilder-move.svg" className="move" height="16px" draggable={true}  
                onDragStart={this.onDragStart.bind(this, this.props.model)}
                onDragEnd={this.onDragEnd.bind(this, this.props.model)}
                onDrag={this.onDrag.bind(this)}
                onClick={this.onDragStart.bind(this, this.props.model)} />

                {this.props.text == "swzPage" && this.props.model.onpagedisplay ? (
                  <img src="./images/collapse.svg" height="16px" onClick={this.props.swzOnHide.bind(this.props.parent, this.props.model)} />
                 ): null
              }

              {this.props.text == "swzPage" && !this.props.model.onpagedisplay ? (
                  <img src="./images/expand.svg" height="16px" onClick={this.props.swzOnShow.bind(this.props.parent, this.props.model)} />  
                  ): null
              }

              <img src="./images/cloverbuilder-edit.svg" height="16px" onClick={this.props.onEdit.bind(this.props.parent, this.props.model)} />
              <img src="./images/cloverbuilder-copy.svg" height="16px" onClick={this.props.onCopy.bind(this.props.parent, this.props.model)} />
              <img src="./images/cloverbuilder-delete.svg" height="16px" onClick={this.props.onDelete.bind(this.props.parent, this.props.model)} />
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