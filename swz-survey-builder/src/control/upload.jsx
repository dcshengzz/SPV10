import React, { Component } from 'react'

export default class Upload extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      onLoading: false
    }
  }

  render(){
    let type = this.props.type;
    let controls = [];
    let isForm = this.props.isForm;
    let token = this.props.value;
    const { onLoading } = this.state; 
 
    let authorisedfiletypes = (this.props.authorisedfiletypes == null || this.props.authorisedfiletypes == undefined) ? null : this.props.authorisedfiletypes;
      authorisedfiletypes = this.props.type == "imagefile" ? 'image/*' : null;


    if(token != undefined && token != null && token != ""){
      let downloadtext = "Download";
      let cleartext = "Clear";
      if(window.CloverAdminLang != undefined && window.CloverAdminLang.button != undefined){
        downloadtext = window.CloverAdminLang.button.download;
        cleartext = window.CloverAdminLang.button.clear;
      }

      let isHideClear = this.props.disabled || this.props.readOnly || this.props.hideClearButton;
      controls.push(<a key="download" className="ui button" target="blank" href={this.props.downloadUrl + token}>{downloadtext}</a>);
     
      if(!isHideClear){
        controls.push(<span key="sparator">&nbsp;&nbsp;</span>);
        controls.push(<button key="clear" className="ui button" onClick={this.onClear.bind(this)}>{cleartext}</button>);
      }
    }
    else{
      if(this.props.disabled || this.props.readOnly)
        controls.push(<span></span>);
      else{
        controls.push(
        <input 
          key="uploadcontrol" 
          type="file" 
          name={this.props.name} 
          onChange={this.onChange.bind(this)}
          accept={this.props.authorisedfiletypes}
          className={onLoading == true ? "clover loading" : ""}
        />);
      }
    }

    let res = undefined;
    if(isForm){
      res = <div className="field">
        {this.props.label != undefined && <label>{this.props.label}</label>}
        <div data-buildertype={type}>
          {controls}
        </div>
      </div>;
    }
    else{
      res = <div data-buildertype={type}>
        {this.props.label != undefined && <div className="ui label label">{this.props.label}</div>}
        {controls}
      </div>;
    }

    return res;
  }

  resizeImage = function (settings) {
    var file = settings.file;
    var maxSize = settings.maxSize;
    var reader = new FileReader();
    var image = new Image();
    var canvas = document.createElement('canvas');
    var maxQuality = settings.maxQuality * 0.01;
   /*  var dataURItoBlob = function (dataURI) {
        var bytes = dataURI.split(',')[0].indexOf('base64') >= 0 ?
            atob(dataURI.split(',')[1]) :
            unescape(dataURI.split(',')[1]);
        var mime = dataURI.split(',')[0].split(':')[1].split(';')[0];
        var max = bytes.length;
        var ia = new Uint8Array(max);
        for (var i = 0; i < max; i++)
            ia[i] = bytes.charCodeAt(i);
        return new Blob([ia], { type: mime });
    }; */

    var dataURLtoFile = function (dataurl, filename) {
      var arr = dataurl.split(','), mime = arr[0].match(/:(.*?);/)[1],
          bstr = atob(arr[1]), n = bstr.length, u8arr = new Uint8Array(n);
      while(n--){
          u8arr[n] = bstr.charCodeAt(n);
      }
      return new File([u8arr], filename, {type:mime});
  }
  
    var resize = function () {
        var width = image.width;
        var height = image.height;
        if (width > height) {
            if (width > maxSize) {
                height *= maxSize / width;
                width = maxSize;
            }
        } else {
            if (height > maxSize) {
                height *= maxSize / height;
                width = maxSize;
            }
        }
        canvas.width = width;
        canvas.height = height;
        canvas.getContext('2d').drawImage(image, 0, 0, width, height);
        var dataUrl = canvas.toDataURL('image/jpeg', maxQuality);
        var resizedImage = dataURLtoFile(dataUrl, file.name);
        return resizedImage
    };
    return new Promise(function (ok, no) {
        if (!file.type.match(/image.*/)) {
            no(new Error("Not an image"));
            return;
        }
        reader.onload = function (readerEvent) {
            image.onload = function () { return ok(resize()); };
            image.src = readerEvent.target.result;
        };
        reader.readAsDataURL(file);
    });
  }
  
  hasExtension(fileName, exts) {
    return (new RegExp('(' + exts.join('|').replace(/\./g, '\\.') + ')$')).test(fileName);
  }

  onChange(e){

    var me = this;
    var formdata = new FormData();
    //formdata.append(me.props.name, e.target.files[0]);

    //   if(!this.hasExtension(e.target.files[0].name, ['.jpg', '.gif', '.png'])) {
      me.setState({onLoading: true});

    var authorisedfiletypes = this.props.authorisedfiletypes; 
    if(authorisedfiletypes !== null && authorisedfiletypes !== undefined){
      if(!this.hasExtension(e.target.files[0].name, this.props.authorisedfiletypes.split(','))) {
        alert("Unauthorised file type! " + "File type must be " + this.props.authorisedfiletypes);  
        e.target.value = '';
        me.setState({onLoading: false});
        return
      }
    }
    if(this.props.type == "file"){
      if((this.props.filemaxsize !== undefined || this.props.filemaxsize !== null) && (Number(this.props.filemaxsize) * 1000 < Number(e.target.files[0].size))){
        alert('File size must not be larger than ' + this.props.filemaxsize + 'kb');
        e.target.value = '';
        me.setState({onLoading: false});
        return
      }
    }
  
    var isLocalStorage = this.props.islocalstorage ? 'True':'False';
    var updateFileId = this.props.updatefileid !== undefined && this.props.updatefileid !== null ? this.props.updatefileid : '';

      var submitFile = function(me) {
      $.ajax({
      url: me.props.uploadUrl,
      type: 'POST',
      processData: false,
      contentType: false,
      dataType : 'json',
      data: formdata,
      //Turn this off during debug
      
      beforeSend: function(request) {
        request.setRequestHeader("isLocalStorage", isLocalStorage);
        request.setRequestHeader("updateFileId", updateFileId);
      }, 

      success: function(jsonData){
        if(jsonData.success == true){
          me.setState({onLoading: false});
          if(me.props.onChange != undefined){
            if(jsonData.item == undefined){
              me.props.onChange(e, {name: me.props.name, value: jsonData.message});
            } 
            else {
              me.props.onChange(e, {name: me.props.name, value: jsonData});
            }
          }

          if(me.props.refreshOnSuccess)
            location.reload();
        }else if(jsonData.success == false){
          alert("Failed to upload file");
          console.log("err", jsonData.message);
          me.setState({onLoading: false});
        }
      },
      error: function(request, status, error){
        if(request.status == 413){
          //server responded with a status of 413 (Request Entity Too Large)
          alert('File size must not be larger than 10mb');
          me.setState({onLoading: false});
        }
      }
    });
   }

    if(this.props.type == "imagefile"){

      this.resizeImage({
        file: e.target.files[0], //$image.files[0],
        maxSize: this.props.imagemaxwidth !== undefined && this.props.imagemaxwidth !== null ? this.props.imagemaxwidth : 1024,
        maxQuality: (this.props.imagemaxquality !== undefined && this.props.imagemaxquality !== null) && this.props.imagemaxquality <= 100 ? this.props.imagemaxquality : 75
      }).then(function (resizedImage) {
        formdata.append(me.props.name, resizedImage);
        submitFile(me);
      }).catch(function (err) {
          console.error(err);
          me.onClear();
          alert("Image not valid");
          e.target.value = '';
        me.setState({onLoading: false});
      });
    }else if(this.props.type == "file"){
      formdata.append(me.props.name, e.target.files[0]);
      submitFile(me);
      
    }
  
  }

  onClear(){
    if(this.props.onChange != undefined)
      this.props.onChange(undefined, {name: this.props.name, value: null});
  }
}