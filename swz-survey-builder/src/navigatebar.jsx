import React from 'react';
import BuilderActions from './actions'
import CloverFormControls from './controls'
import {CustomBlockEditControl} from './editform-controls'
import CloverStore from './store';

export default class NavigateBar extends React.Component {

  constructor(props) {
    super(props);
    
    CloverStore.listen(this.dataChanged.bind(this));
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

    this.state = {
      items: items,
      pages: this.getData(),
    };
  }

  dataChanged(pages){
    this.setState({
      pages,
      editElement: null
    });
  }
  
  getData(){
    return CloverStore.getData()
  }

  resetProps = () =>{
    CloverStore.swzOffScrollAll();
  }

  multiplePageFunction = (onCollapseAll) =>{
    
    if(onCollapseAll){
      CloverStore.swzHideAll();
      this.resetProps();
    }
    else{
      CloverStore.swzShowAll();
      this.resetProps();
    }
  }

  singlePageFunction = (onCollapseAll, page) => {
    
    var item = {
      key: page
    }

    if (onCollapseAll){
      CloverStore.swzHideAllByKeys();
      CloverStore.swzShow(item);
    }
  }
  
  noPageFunction = () => {
    return(
      <div className="clover-formbuilder-swznavigate">
        <ul>
          <li className="clover-formbuilder-swznavigate-mainheader">
          Add Page Block
          </li>
        </ul>
      </div>
    )
  }

  render() {

    const {pages} = this.state
  
    var me = this;
    var expandedbock = false;
    if(pages != undefined || pages != null){
      if(pages.length > 0){
        return (
          <div className="clover-formbuilder-swznavigate">
            <ul>
              <li className="clover-formbuilder-swznavigate-mainheader">
              Total Pages <span>{pages.length}</span>
              </li>
                <li onClick={me.multiplePageFunction.bind(me, true)} className="clover-formbuilder-swznavigate-functionheader">
                <img src="./images/collapse.svg" height="18px"/> Collapse
                </li>
                <li onClick={me.multiplePageFunction.bind(me, false)} className="clover-formbuilder-swznavigate-functionheader">
                <img src="./images/expand.svg" height="18px"/> Expand
                </li>
                <div className="clover-formbuilder-swznavigate-divider"></div>
              {
                pages.map(pages => {
                    let label = pages.key;                              
                      var icon;
                      var onclick;
                      var onCollapseAll;
                      var page;

                        onCollapseAll = true;
                        page = pages.key;
                        onclick = me.singlePageFunction.bind(me, onCollapseAll, page); //Collapse all then show page
                      
                      return <li onClick={onclick} className="clover-formbuilder-swznavigate-subheader" key={pages.key}>
                          <u>{label}</u>
                          {icon}</li>;                 
                })
              }
            </ul>
          </div>
        )
      }
      else{
        return this.noPageFunction();
      }
    }
    else{
      return this.noPageFunction();
    }
  }
}
