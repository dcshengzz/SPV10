import React from 'react';
import {Modal, Breadcrumb, Button, Form, Icon, Dimmer, Loader} from 'semantic-ui-react'
import GridView from './gridview'

class CssStyleModal extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            open: false, //is modal showing
            displayCssSelector: "",
            displayCssProperties: "",
            data: []
        };
        this.styleApi = this.props.styleApi;
        this.applyActionHandler = null;

        //Bind 'this' for our methods (we could have used foo = () => syntax instead)
        this.open = this.open.bind(this);
        this.close = this.close.bind(this);
        this.onGridEvent = this.onGridEvent.bind(this);
        this.copyCssToClipboard = this.copyCssToClipboard.bind(this);
        this.applyCssStyle = this.applyCssStyle.bind(this);
    }

    getStyleData(){
        var me = this;
      return $.ajax({
          url: me.props.styleApi,
          async: false,
          success: function (response) {
            if(response.success){
              return response.result;
            }
            else{
              let msg = response.message;
              if(msg == undefined){
                msg = CloverAdminLang.requesterror.configapi + ": " + me.props.styleApi + "!";
                if(typeof response == "string"){
                  console.error(CloverAdminLang.requesterror.configapi + ":", response);
                  msg += " " + CloverAdminLang.msg.lookdevconsole;
                }
              }
              me.setState({
                progresserror: true,
                progressmsg: msg
              });
            }
          },
          error: function (jqXHR, exception){
            me.processLoadError(jqXHR, exception);
          }
      });
    }

    open () {
        const data = this.getStyleData();
        this.setState( {
            open: true, data: data.responseJSON.result
        });    
    }

    close() {
        this.setState( {
            open: false,
        });
    }

    gridColumns(){
        return [{
            key: 'name',
            name: this.props.localization.namecolumn,
            resizable: true
        } , {
            key: 'description',
            name: this.props.localization.descriptioncolumn,
            resizable: true
        } ];
    }

    onGridEvent(gridEvent) {
        const eventName = gridEvent.eventName;
        if(eventName == "onRowClick"){
            const selector = gridEvent.parameters.row.cssSelector;
            const properties = gridEvent.parameters.row.cssProperties;
            this.setState({
                displayCssSelector: selector, displayCssProperties: properties === null ? '' : properties
            });
        }
    }

    copyCssToClipboard() {
        navigator.clipboard.writeText(this.state.displayCssProperties);
    }

    applyCssStyle(){
        this.props.applyActionHandler(this.state.displayCssProperties);
        this.close();
    }

    render() {
        const triggerLink = 
            <Breadcrumb.Section 
            className="edit-form-go-to-logic-builder-breadcrumb" 
            style={{marginRight:'20px',float:"right"}}
                type="Validation" 
                onClick={this.open}>
                    {this.props.localization.applyrule}
            </Breadcrumb.Section>;

        return (
            <Modal 
                open={this.state.open}
                dimmer="inverted"
                trigger={triggerLink}
                closeOnDimmerClick={false}
                onClose={this.close} >
                <Modal.Header content={this.props.localization.title} /> 
                <Modal.Content>
                    <Form>
                        <GridView 
                            key="StylesGrid"
                            rowKey="Id" 
                            columns={this.gridColumns()}
                            value={this.state.data}
                            handleEvent={this.onGridEvent} 
                            style={{marginBottom:'14px'}}/>
                        <Form.TextArea 
                            key="displayCssProperties"
                            readOnly={true} 
                            label={this.props.localization.cssProperties} 
                            value={this.state.displayCssProperties} />
                    </Form>
                </Modal.Content>      
                <Modal.Actions>
                    {this.state.displayCssSelector === '' ? 
                    <Button 
                        className="buttontype2" 
                        content={this.props.localization.applybutton}
                        disabled/>     
                    :
                    <Button 
                        className="buttontype2" 
                        onClick={this.applyCssStyle} 
                        content={this.props.localization.applybutton}/>     
                    }
                    
                    <Button 
                        className="buttontype2" 
                        icon 
                        onClick={this.copyCssToClipboard} >
                            <Icon name='clipboard' />
                    </Button>
                    <Button 
                        className="buttontype2" 
                        onClick={this.close} 
                        content={this.props.localization.closebutton} />                
                </Modal.Actions>        
            </Modal>
        );    
    } //end render

}

module.exports = {
    CssStyleModal
}









