import React from 'react';
import CloverStore from './store';
import BuilderActions from './actions';
import CloverFormControls from './controls';
import {Button, Checkbox} from 'semantic-ui-react'


export default class Preview extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      data: [],
      editElement: null
    }

    CloverStore.listen(this.dataChanged.bind(this));
  }
  
  dataChanged(data){
    this.setState({
      data,
      editElement: null
    });
  }

  _onEdit(item) {
    BuilderActions.showEditForm(item.key);
  }

  _onCopy(item) {
    CloverStore.copy(item);
  }

  _onDestroy(item) {
    CloverStore.remove(item);
  }

  _handleEvent(p){
    // if(console != undefined){
    //   console.log("CloverFormBuilder: handleEvent", p);
    // }
  }
  
  render() {
    var items = CloverFormControls.createControls(this,
        {
            model: this.state.data,
            data: undefined,
            buildermode: true,
            eventOnEdit: this._onEdit,
            eventOnDelete: this._onDestroy,
            eventOnCopy: this._onCopy,
            parentItem: undefined,
            handleEvent: this._handleEvent,
            getFormFunc: this.props.getFormFunc,
            getFormFist: this.props.getFormFist,
            getAdditionalDataForControl: this.props.getAdditionalDataForControl,
            disableRefs: true,
            downloadUrl: this.props.downloadUrl,
            uploadUrl: this.props.uploadUrl,
            controlsToReplace: [],
            needCheckReplace: false
        }
    );
      
    var dropzonetext = undefined;
    if(this.props.localization != undefined && this.props.localization.preview != undefined){
      dropzonetext = this.props.localization.preview.dropzonetext;
    }
    var dropzone = CloverFormControls.createBuilderDropzone("dropzone_header", undefined, undefined, dropzonetext);
    var dropzone_footer = items.length > 0 ? 
      CloverFormControls.createBuilderDropzone("dropzone_footer", undefined, undefined, dropzonetext) 
      : '';

    return (
      <div  className="clover-formbuilder-preview">
        {dropzone}
        {items}
        {dropzone_footer}
      </div>
    )
  }
}