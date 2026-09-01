import React from 'react';
import CloverStore from './store';
import BuilderActions from './actions';
import CloverFormControls from './controls';


export default class Preview extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      data: [],
      editElement: null,
      dirty: false
    }

    CloverStore.listen(this.dataChanged.bind(this));
  }

  dataChanged(data){
    this.setState({
      data,
      editElement: null
    });
  }

  checkDirty = () => {
    if(!this.props.isDirty)
      this.props.isDirtyToggle();
  }

  _onEdit(item) {
    BuilderActions.showEditForm(item.key);
  }

  _onCopy(item) {
    this.checkDirty();
    CloverStore.copy(item);
  }

  _onDestroy(item) {
    this.checkDirty();
    CloverStore.remove(item);
  }

  _handleEvent(p){
    // if(console != undefined){
    //   console.log("CloverFormBuilder: handleEvent", p);
    // }
  }
  
  _swzOnHide(item){
    CloverStore.swzHide(item);
  }

  _swzOnShow(item){
    CloverStore.swzShow(item);
  }
  
  swzOnItemsEmpty = (bool) => {
      this.props.handleEmpty(bool);
  }

  _swzColumnAddBefore = (item) => {
    CloverStore.swzAddColumnBefore(item);
  }

  _swzAddColumnAfter = (item) => {
    CloverStore.swzAddColumnAfter(item);
  }

  _swzAddRowBefore = (item) => {
    CloverStore.swzAddRowBefore(item);
  }

  _swzAddRowAfter = (item) => {
    CloverStore.swzAddRowAfter(item);
  }

  _swzRowDelete = (item) => {
    CloverStore.swzDeleteRow(item);
  }

  _swzColumnDelete = (item) => {
    CloverStore.swzDeleteColumn(item);
  }

  _swzMerge = (item, rows, columns) => {
    CloverStore.swzMerge(item, rows, columns);
  }
 
  _swzSplit = (item) => {
    CloverStore.swzSplit(item);
  }

  _swzGetData = () => {
    let formData = CloverStore.getData();
    return formData

  }

  render() {

    var items = CloverFormControls.createControls(this,
        {
            swzEventOnHide: this._swzOnHide,
            swzEventOnShow: this._swzOnShow, 
            swzPageInPage: undefined,

            swzEventOnColumnAddBefore: this._swzColumnAddBefore,
            swzEventOnColumnAddAfter: this._swzAddColumnAfter,
            swzEventOnRowAddBefore: this._swzAddRowBefore,
            swzEventOnRowAddAfter: this._swzAddRowAfter,
            swzEventOnRowDelete: this._swzRowDelete,
            swzEventOnColumnDelete: this._swzColumnDelete,
            swzEventOnMerge: this._swzMerge,
            swzEventOnSplit: this._swzSplit,
            
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
            loadTemplate: this.props.loadTemplate,
            loadTemplateBlock: this.props.loadTemplateBlock,
            getAdditionalDataForControl: this.props.getAdditionalDataForControl,
            disableRefs: true,
            downloadUrl: this.props.downloadUrl,
            uploadUrl: this.props.uploadUrl,
            controlsToReplace: [],
            needCheckReplace: false
        }
    );

    if(items.length <= 0){
      this.swzOnItemsEmpty(true);
    }else{
      this.swzOnItemsEmpty(false);
    }

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