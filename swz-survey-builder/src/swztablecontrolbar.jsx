import React from 'react';
import BuilderActions from './actions'
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm, Label, Header } from 'semantic-ui-react'

export default class SwzTableControlBar extends React.Component {
    state = { openMerge: false,
              columns: null,        
              rows: null,
              openFunction: false
              }

    /*   SWZ Addition 110419*/
    onPageElement = (item, element) => {
      if(element != null || element != undefined){
        var onPageElement = element.outerHTML.includes('elementtoinsert');
      }
      if(!onPageElement && item['data-buildertype'] == "swzPage"){
        return true
      }
      if(onPageElement && item['data-buildertype'] != "swzPage"){
        return true
      }
      alert("You can only place control elements under a page block");
      return false
    }

    showMergeModal = () => {
      if(this.state.openMerge == false){
        this.setState({ openMerge: true});
      }
    }

    closeModal = () => {
      this.setState({openMerge: false});
      this.setState({rows: null, columns: null})
      this.setState({openFunction: false});
    }

    showFunctionModal = () => {
      if(this.state.openFunction == false){
        this.setState({ openFunction: true});
      }
    }

    onMerge = (me) => {
      if(this.state.rows == null || this.state.columns == null){
       return alert("Fill in missing values");
      }else{
        this.props.swzMerge(me, this.state.rows, this.state.columns);
        this.setState({rows: null, columns: null})
      }
      this.closeModal();
    }


    handleChange = (e) => {
      var value = e.target.value;
      if(e.target.name == "columns"){
        this.setState({columns: value});
      }
      if(e.target.name == "rows"){
        this.setState({rows: value});
      }
    }

    render() {
      var me = this;
      const { openMerge, dimmer, openFunction } = this.state;
      var className = "clover-formbuilder-item-toolbar-header";
      if(this.props.controlOnRight){
        className += " " + "clover-formbuilder-item-toolbar-right";
      }
      else{
        className += " " + "clover-formbuilder-item-toolbar-left";
      }
     
      var standardIconCss = {
        fontSize: '16px',
        cursor:'pointer',
       // margin: '10px',
        color: '#2E2E2E',
        'margin-bottom': '15px'
      }

      var tableIndex = this.props.additionalParams.model.tableIndex;

      return (
        <div className={className} 
          onMouseOver={this.onMouseOver.bind(this)}
          onMouseLeave={this.onMouseLeave.bind(this)}>
          <div onClick={() => this.showFunctionModal()} title="Table Functions" style={standardIconCss}><img src="./images/tablefunction.svg" /></div> 
          <Modal  dimmer={dimmer} open={openFunction} onClose={() => this.closeModal()} size={"small"} >
              <Header content='Table Functions' />
              <Modal.Content>
                <div style={{ width: '30%'}} >
                    <Form>
                      <Form.Group widths="equal">
                      <div className="clover-formbuilder-item-toolbar-header-buttons-table" >
                        <div className="clover-formbuilder-item-toolbar-header-title">
                          {this.props.text}
                        </div>
                        <div onClick={() => this.showMergeModal()} title="Merge" style={standardIconCss}><img src="./images/merge.svg" height="16px" />Merge</div>
                        <div onClick={() => {this.props.swzSplit(this), this.closeModal()}} title="Split" style={standardIconCss}><img src="./images/split.svg" height="16px" />Split</div>
                        <div onClick={() => {this.props.swzRowAddBefore(this), this.closeModal()}} title="Add Row Before" style={standardIconCss}><img src="./images/AddColumnAfter.svg" height="16px" />Add Row Before</div>
                        <div onClick={() => {this.props.swzRowAddAfter(this), this.closeModal()}} title="Add Row After" style={standardIconCss}><img src="./images/AddColumnAfter.svg" height="16px" />Add Row After</div>
                        <div onClick={() => {this.props.swzColumnAddBefore(this), this.closeModal()}} title="Add Column Before" style={standardIconCss}><img src="./images/AddColumnAfter.svg" height="16px" />Add Column Before</div>
                        <div onClick={() => {this.props.swzColumnAddAfter(this), this.closeModal()}} title="Add Column After" style={standardIconCss}><img src="./images/AddColumnAfter.svg" height="16px" />Add Column After</div>
                        <div onClick={() => {this.props.swzRowDelete(this), this.closeModal()}} title="Delete Row" style={standardIconCss}><img src="./images/DeleteRow.svg" height="16px" />Delete Row</div>
                        <div onClick={() => {this.props.swzColumnDelete(this), this.closeModal()}} title="Delete Column" style={standardIconCss}><img src="./images/DeleteRow.svg" height="16px" />Delete Column</div>
                        <Modal  dimmer={dimmer} open={openMerge} onClose={() => this.closeModal()} size={"small"} >
                        <Header content='Merge Cells' />
                        <Modal.Content>
                          <div style={{ width: '30%'}} >
                              <Form>
                                <Form.Group widths="equal">
                                  <Form.Input name="columns" type="number" label="Columns" value={this.state.columns} onChange={(e) => this.handleChange(e)} />
                                </Form.Group>
                                <Form.Group widths="equal">
                                  <Form.Input name="rows" type="number" label="Rows"  value={this.state.rows} onChange={(e) => this.handleChange(e)} />
                                </Form.Group>
                              </Form>
                          </div>
                        </Modal.Content>
                        <Modal.Actions>
                          <Button className="buttontype1" onClick={() => this.onMerge(this)}>Save</Button>
                          <Button className="buttontype2" onClick={() => this.closeModal()}>Cancel</Button>   
                        </Modal.Actions>
                      </Modal>
                    </div>
                      </Form.Group>
                    </Form>
                </div>
              </Modal.Content>
              <Modal.Actions>
                <Button className="buttontype2" onClick={() => this.closeModal()}>Cancel</Button>   
              </Modal.Actions>
            </Modal>
          
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

  }