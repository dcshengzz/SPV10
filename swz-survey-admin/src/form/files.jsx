import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal} from 'semantic-ui-react';
import Upload from './../../../swz-survey-builder/src/control/upload'
import PanelExternal from '../panelexternal';
import CloverAdminFormEdit from './formedit';
import { encodeHtml } from './../utils.jsx'

export default class CloverAdminFiles extends PanelExternal {
  constructor(props) {
    super(props);

    this.dataindex = "fileUploads";
    this.idfield= "id";
    this.panelindex = "filestorage";
    this.datatype = "fileuploads";
    this.title = "File Storage";
    this.editrow = false;
    this.onfilestorage = true;
    this.rowHeight = 80;
    this.data = {
      filetokenindividual: '123'
    };

  }

  handleClose = () => { 
    this.setState({modalOpen: false});
    
  }

  handleOpen = (val) => {
    this.setState({modalOpen: true, fileId: val}); 
  }
  
  gridColumns(){
    
    var me = this;
    const { dimmer } = me.state;
    
    var handleChange = function(e, {name, value}){
      //let data = {};
      //data[name] = value;
      //me.setState({data});
      if(value.item != undefined && value.message == "Successful"){
        alertify.hide;
        window.location.reload(false);
      } else if (value.item != null && value.message != "Successful"){
        alertify.error(encodeHtml(value.message));
      }
      
    }

    return [{
        key: 'name',
        name: CloverAdminLang.column.name,
        resizable: true
    },
    {
      key: 'contentType',
      name: 'Type',
      resizable: true,
    },{
      key: 'attachmentLength',
      name: 'Size (Kb)',
      resizable: true,
      type: "custom",
      customFormatter: function({value}){
        let amt = value / 1000;
        return Math.floor(amt);
      }
    },
    {
      key: 'name',
      name: 'Download source',
      resizable: true,
      type: "custom",
      customFormatter: function({value}){
        let res =(<div>
            <div><a target="_blank" href={me.props.parent.props.downloadFileUrl + value}>{me.props.parent.props.downloadFileUrl + value}</a></div>
                  </div>);
        return res;
      },
    },
    {
      key: 'name',
      name: 'View source',
      resizable: true,
      type: "custom",
      customFormatter: function({value}){
        let res =(<div>
             <div><a target="_blank" href={me.props.parent.props.viewFileUrl + value}>{me.props.parent.props.viewFileUrl + value}</a></div>
            </div>);
        return res;
      },
    },
    {
      key: 'id',
      name: 'Action',
      resizable: true,
      type: "custom",
      customFormatter: function({value}){
        var val = value;
        let res =(<div>
     
     <Modal closeOnDimmerclick={false} key={value} open={me.state.modalOpen} dimmer={dimmer} onClose={me.handleClose} trigger={<Button className="buttontype2" compact onClick={() => me.handleOpen(val)} >Update</Button>}>
              <Modal.Header content='Import File' />
              <Modal.Content>
                <div style={{width: '100%', 'margin-left': '1em'}} >
                    <Upload 
                      name="filetokenindividual" 
                      value={me.state.data.filetokenindividual}
                      type="file"
                      downloadUrl="/data/download/"
                      uploadUrl="/data/file/upload/"
                      onChange={handleChange}
                      islocalstorage={true}
                      refreshOnSuccess={false}
                      updatefileid = {me.state.fileId}
                    />
                </div>
              </Modal.Content>
              <Modal.Actions>
                <Button className="buttontype2" onClick={me.handleClose}>Cancel</Button>
              </Modal.Actions>
            </Modal></div>
        );
        return res;
      }
    }
    ];
  }
}