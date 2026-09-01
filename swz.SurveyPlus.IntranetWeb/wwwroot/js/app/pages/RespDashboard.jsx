import React from 'react'
import { render } from 'react-dom'
import { CloverForm } from "./../../../scripts/swz-form.js"

export default class RespDashboard extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            errors: {}
        }
    }

    render(){
        let sectorprops = {
            eventFunc: this.eventHandler.bind(this)
        };

        return <CloverForm {...sectorprops}  
              formName="documents"
              modelurl="/ui/form/documents" 
              data={this.state.data} 
              errors={this.state.errors}
              className="clover-application-login" />;
    }

    eventHandler(args){
        var me = this;
        if (Array.isArray(args.actions)){
            args.actions.forEach(function (a) {
                if (a === "login"){
                    me.onLogin();
                }
            });
        }
        return false;
    }

    validate(){
        var res = true;
        var editrow = this.state.data;
        var msgRequiredField = "This field is required";
        this.state.errors = {
            login: (editrow.login == undefined || editrow.login == "") ? msgRequiredField : undefined,
            password: (editrow.password == undefined || editrow.password == "") ? msgRequiredField : undefined
        };

        res &= this.state.errors.login == undefined && this.state.errors.password == undefined;
        return res;
    }
    
    onLogin(){
        if (this.validate() == false) {
            alertify.error("Check errors on this form!");
        }
        else {
            var me = this;
            var data = new Array();
            data.push({name: 'login', value: this.state.data.login});
            data.push({name: 'password', value: this.state.data.password});
            data.push({name: 'remember', value: this.state.data.remember});
            $.ajax({
                url: "/resp/login",
                data: data,
                async: true,
                type: "post",
                success: function (response) {
                    if (response.success) {
                        me.redirectToDashboard();
                    }
                    else {
                        alertify.error(response.message);
                        me.setState({errors:{
                            login:true,  
                            password: true}
                        });
                    }
                },
                error: function (jqXHR, exception) {
                    var msg = "Error on the server! Please, check server's configuration and the connection to DB. More information in the application log or Event Viewer.";
                    alert(msg);
                }
            });
        }
        this.forceUpdate();
    }

    redirectToDashboard(){
        let returnUrl = this.getParameterByName("ReturnUrl");
        if (returnUrl != undefined){
            window.location = returnUrl;
        }
        else {
            window.location = '/respdashboard/index';
        }
    }

     getParameterByName(name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }
}


