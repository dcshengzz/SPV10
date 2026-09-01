import React from 'react'
import { render } from 'react-dom'
import { CloverForm } from "./../../scripts/swz-form.js"

//const htmlExample =[{"blocks":[{"key":"44m4a","text":"","type":"unstyled","depth":0,"inlineStyleRanges":[{"offset":0,"length":3,"style":"BOLD"},{"offset":0,"length":3,"style":"ITALIC"}],"entityRanges":[],"data":{}}],"entityMap":{}}];

class RespLogin extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            data: {
                goForgotPwd: false,
                goForgotPwdSuccess: false,
                remember: true,
                respLoginHtmlView: undefined//JSON.stringify(htmlExample),
            }
        }
    }
    componentDidMount = () => {
        const { body } = this.state;
        var data = new Array();

        $.ajax({
            url: "/swzdata/getmultiple?type=RespLogin",
            async: true,
            type: "get",
            success: (response) => {
                if (response.success) {
                    var htmldata = [];
                    for (var i=0; i<response.data.length; i++){
                        htmldata.push(response.data[i].editorState);
                    }
                    this.setState(prevState => ({
                        ...prevState,
                        data:{
                            ...prevState.data,
                            respLoginHtmlView: htmldata
                            }
                        })
                    ) 
                }
                else {
                    alertify.error(response.message);
                }
            },
            error: function (jqXHR, exception) {
                var msg = "Error on the server! Please, check server's configuration and the connection to DB. More information in the application log or Event Viewer.";
                alert(msg);
            }
        });
        this.forceUpdate();
    }
    render(){
        const {goForgotPwd} = this.state;
        const {goForgotPwdSuccess} = this.state;
        let sectorprops = {
            eventFunc: this.eventHandler.bind(this)
        };

        var form;
        var modelurl;
        if (!goForgotPwd){
            form = "resplogin";
            modelurl =  "/ui/form/resplogin";
        }
        else{
            if(!goForgotPwdSuccess){
                form = "respresetpassword";
                modelurl =  "/ui/form/respresetpassword";
            }
            else{
                form = "respresetpasswordsuccess";
                modelurl =  "/ui/form/respresetpasswordsuccess";
            }
        }
       
       return( 
        <div>
            <CloverForm {...sectorprops}  
                    formName={form}
                    modelurl={modelurl} 
                    data={this.state.data} 
                    errors={this.state.errors}
                    className="clover-application-login" />
        </div>
        )
    }
    handleClick = () => {

        this.setState(prevState => ({
            ...prevState,
            data:{
                ...prevState.data,
                respLoginHtmlView: JSON.stringify(htmlExample)
                }
            })
        )      
    }
    eventHandler(args){
        var me = this;
        if (Array.isArray(args.actions)){
            args.actions.forEach(function (a) {
                if (a === "login"){
                    me.onLogin();
                }
                if (a === "forgotPassword"){
                    me.setState({goForgotPwd: true});
                }
                if (a === "sendResetLink"){
                    me.onReset();
                }
                if (a === "cancel"){
                    //me.setState({goForgotPwd: false});
                    //me.setState({goForgotPwdSuccess: false});
                    window.location.reload();
                }
            });
        }
        return false;
    }
    
    onReset(){
        if (this.onResetValidate() == false) {
            alertify.error("Check errors on this form!");
        }
        else{
                alertify.success("Loading...");
                var me = this;
               
                var data = new Array();
                data.push({name: 'uid', value: this.state.data.UID});
                $.ajax({
                    url: "/resp/resetresppassword",
                    data: data,
                    async: true,
                    type: "post",
                    success: function (response) {
                        if (response.success) {
                            alertify.success("Success");
                         me.setState({goForgotPwdSuccess:true});
                        }
                        else {
                            alertify.error(response.message);
                            me.setState({errors:{
                                login:true,  
                                password: true}
                            });
                        }
                    }
                });
            }     
            this.forceUpdate();
    }

    onLoginValidate(){
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

    onResetValidate(){
        var res = true;
        var editrow = this.state.data;
        var msgRequiredField = "This field is required";
        this.state.errors = {
            UID: (editrow.UID == undefined || editrow.UID == "") ? msgRequiredField : undefined
        };

        res &= this.state.errors.UID == undefined;
        return res;
    }

    onLogin(){
        if (this.onLoginValidate() == false) {
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
            window.location = '/form/respdashboard';
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

render(<RespLogin/>,document.getElementById('content'));
