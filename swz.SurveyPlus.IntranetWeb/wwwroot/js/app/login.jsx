import React from 'react'
import { render } from 'react-dom'
import { CloverForm } from "./../../scripts/swz-form.js"

class Login extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            data: {
                remember: true, 
            },
            flowState: "login",
            ipAddress: null
        }
    }

    eventHandler(args) {
        var me = this;
        if (Array.isArray(args.actions)){
            args.actions.forEach(function (action) {
                if ("login" === action) {
                    me.onLogin();
                } else if ("verifyTotp" === action) {
                    me.onLoginTotp();
                } else if ("cancel" === action) {
                    //TODO - just change state back and inform server to clear stuff
                    window.location = "/account/login";
                }
            });
        }
        return false;
    }

    validateLogin(){
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
        
        if (this.validateLogin() == false) {
            alertify.error("Check errors on this form!");
        }
        else {
            const me = this;
            const data = new Array();
            data.push({name: 'login', value: this.state.data.login});
            data.push({name: 'password', value: this.state.data.password});
            $.ajax({
                url: "/account/login",
                data: data,
                async: true,
                type: "post",
                success: function (response) {
                    if (response.success) {
                        const result = response.item;
                        if ("redirectToApp" === result) {
                            me.redirectToApp();
                        } else if ("totpRequired" === result) {
                            me.setState({ flowState: "loginTotp", data: {}, errors: {} });
                        } else {
                            console.error(response);
                            alertify.error("Unknown Response Item");
                        }
                    }
                    else {
                        console.error(response.message);
                        alertify.error(response.message, 30000);
                        me.setState({errors:{
                            login:true,  
                            password: true}
                        });
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    if (403 === jqXHR.status) {
                        const msg = "403 Forbidden - " + jqXHR.responseText;
                        console.error(msg);
                        alertify.error(msg, 30000);
                    } else {
                        const msg = "Error on the server! Please, check server's configuration and the connection to DB. More information in the application log or Event Viewer.";
                        console.error(msg, textStatus);
                        alert(msg);
                    }                    
                }
            });
        }
        this.forceUpdate();
    }

    validateTotp() {
        let res = true;
        const editrow = this.state.data;
        const msgRequiredField = "This field is required";
        this.state.errors = {
            code: (editrow.code == undefined || editrow.code == "") ? msgRequiredField : undefined,
        };

        res &= this.state.errors.code == undefined;
        return res;
    }

    onLoginTotp() {

        if (this.validateTotp() == false) {
            alertify.error("Check errors on this form!");
        }
        else {
            const me = this;
            const data = new Array();
            data.push({ name: 'code', value: this.state.data.code });
            $.ajax({
                url: "/account/loginTotp",
                data: data,
                async: true,
                type: "post",
                success: function (response) {
                    if (response.success) {
                        const result = response.item;
                        if ("redirectToApp" === result) {
                            me.redirectToApp();
                        } else {
                            console.error(response);
                            alertify.error("Unknown Response Item");
                        }
                    }
                    else {
                        console.error(response.message);
                        alertify.error(response.message, 30000);
                        me.setState({
                            errors: {
                                code: true,
                            }
                        });
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    if (403 === jqXHR.status) {
                        const msg = "403 Forbidden - " + jqXHR.responseText;
                        console.error(msg);
                        alertify.error(msg, 30000);
                    } else {
                        const msg = "Error on the server! Please, check server's configuration and the connection to DB. More information in the application log or Event Viewer.";
                        console.error(msg, textStatus);
                        alert(msg);
                    }
                }
            });
        }
        this.forceUpdate();
    }

    redirectToApp(){
        let returnUrl = this.getParameterByName("ReturnUrl");
        if (returnUrl != undefined){
            window.location = returnUrl;
        }
        else {
            window.location = '/';
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

    render(){
        let sectorprops = {
            eventFunc: this.eventHandler.bind(this)
        };

        const flowState = this.state.flowState;
        if (flowState === "login") {
            return <CloverForm {...sectorprops}
                formName="login"
                modelurl="/ui/login"
                data={this.state.data}
                errors={this.state.errors}
                className="clover-application-login" />;
        } else if (flowState === "loginTotp") {
            return <CloverForm {...sectorprops}
                formName="loginTotp"
                modelurl="/ui/loginTotp"
                data={this.state.data}
                errors={this.state.errors}
                className="clover-application-login" />;
        } else {
            console.error("bad flowState", this.state.flowState);
        }            
    }

}

render(<Login/>,document.getElementById('content'));
