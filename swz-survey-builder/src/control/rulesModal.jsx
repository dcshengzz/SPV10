import React from 'react';
import {Modal, Breadcrumb, Button, Form, Icon, Dimmer, Loader} from 'semantic-ui-react'
import GridView from './gridview';

//RulesModal is a modal that is triggered by a "Rules" button and lists the QNN_RULE to allow copying
//a selected Validation snippet to the clipboard. Used in BaseEditControl.
class RulesModal extends React.Component {
    constructor(props) {
        super(props);
        console.log("props to RulesModal", props);

        this.state = {
            open: false, //is modal showing
            displayValidationRule: "", //to display selected validation rule
            displayComments: "",
            rules: []
        };
        this.ruleApi = this.props.ruleApi;
        this.applyActionHandler = null;

        //Bind 'this' for our methods (we could have used foo = () => syntax instead)
        this.open = this.open.bind(this);
        this.close = this.close.bind(this);
        this.onGridEvent = this.onGridEvent.bind(this);
        this.copyRuleToClipboard = this.copyRuleToClipboard.bind(this);
        this.applyValidationRule = this.applyValidationRule.bind(this);
    }

    getRuleData(){
        var me = this;
      return $.ajax({
          url: me.props.ruleApi,
          async: false,
          success: function (response) {
            console.log(me.props.ruleApi,response);
            if(response.success){
              return response.result;
            }
            else{
              let msg = response.message;
              if(msg == undefined){
                msg = CloverAdminLang.requesterror.configapi + ": " + me.props.ruleApi + "!";
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
        const rules = this.getRuleData();
        this.setState( {
            open: true, rules: rules.responseJSON.result
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
            //Show the validation rule for the selected row below in the textarea
            //const validation = gridEvent.parameters.row.Validation;
            const validation = gridEvent.parameters.row.validation;
            const comments = gridEvent.parameters.row.comments;
            this.setState({
                displayValidationRule: validation, displayComments: comments === null ? '' : comments
            });
        }
    }

    copyRuleToClipboard() {
        navigator.clipboard.writeText(this.state.displayValidationRule);
    }

    applyValidationRule(){
        this.props.applyActionHandler(this.state.displayValidationRule);
        this.close();
    }

    render() {
       const trigger = 
            <Button 
                className="buttontype2" 
                compact 
                onClick={this.open} 
                content={this.props.localization.triggerbutton} />;

        const triggerLink = 
            <Breadcrumb.Section 
            className="edit-form-go-to-logic-builder-breadcrumb" 
            style={{marginRight:'20px'}}
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
                            key="RulesGrid"
                            rowKey="Id" 
                            columns={this.gridColumns()}
                            value={this.state.rules}
                            handleEvent={this.onGridEvent} 
                            style={{marginBottom:'14px'}}/>
                        <Form.TextArea 
                            key="DisplayValidationRule"
                            readOnly={true} 
                            label={this.props.localization.validationRule} 
                            value={this.state.displayValidationRule} />
                        <Form.TextArea 
                            key="DisplayRuleComments"
                            readOnly={true} 
                            label={this.props.localization.comments} 
                            value={this.state.displayComments} />
                    </Form>
                </Modal.Content>      
                <Modal.Actions>
                    {this.state.displayValidationRule === '' ? 
                    <Button 
                        className="buttontype2" 
                        content={this.props.localization.applybutton}
                        disabled/>     
                    :
                    <Button 
                        className="buttontype2" 
                        onClick={this.applyValidationRule} 
                        content={this.props.localization.applybutton}/>     
                    }
                    
                    <Button 
                        className="buttontype2" 
                        icon 
                        onClick={this.copyRuleToClipboard} >
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
  RulesModal,  
}









