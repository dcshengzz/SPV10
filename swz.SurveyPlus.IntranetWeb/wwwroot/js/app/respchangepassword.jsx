import React from 'react'
import { render } from 'react-dom'
import { CloverForm } from "./../../scripts/swz-form.js"

class RespChangePassword extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            data: {
                urlId: null,
                goSuccessForm: false,
            }
        }
    }
    
    eventHandler(args){
        var me = this;
        if (Array.isArray(args.actions)){
            args.actions.forEach(function (a) {
                if (a === "changePassword"){
                    me.onChangePassword();
                }
                if (a === "gohome"){
                    me.redirectToLogin();
                }
                if (a === "cancel"){
                    me.redirectToLogin();
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
            newPassword: (editrow.newPassword == undefined || editrow.newPassword == "") ? msgRequiredField : undefined,
            confirmPassword: (editrow.confirmPassword == undefined || editrow.confirmPassword == "") ? msgRequiredField : undefined
        };

        res &= this.state.errors.newPassword == undefined && this.state.errors.confirmPassword == undefined;
        return res;
    }

    checkConfirmPassword(){
        var res = true;
        var editrow = this.state.data;
        var msgRequiredField = "Confirm password do not match";

        this.state.errors = {
            confirmPassword: (editrow.newPassword != editrow.confirmPassword) ? msgRequiredField : undefined
        };

        res &= this.state.errors.confirmPassword == undefined;
        return res;
    }

    validatePassword(){
        var res = true;
        var pwd = this.state.data.newPassword;
        
        var req = new RegExp(/(?=[A-Za-z\!\@\#\$\%\^\&amp;\*\(\)_\+])(?=.*\d)|([a-z\d\!\@\#\$\%\^\&amp;\*\(\)_\+])(?=.*[A-Z])|([A-Z\d\!\@\#\$\%\^\&amp;\*\(\)_\+])(?=.*[a-z])|([A-Z\d\a-z])(?=.*[\!\@\#\$\%\^\&amp;\*\(\)_\+])/);
        var reqlength = 12;    
        
        if(!req.test(pwd || pwd.length < reqlength)){
                res = false;
        }
          
        return res
    }

    render(){

        const {goSuccessForm} = this.state;
        let sectorprops = {
            eventFunc: this.eventHandler.bind(this)
        };

        var form;
        var modelurl;
        if (!goSuccessForm){
            form = "respchangepassword";
            modelurl =  "/ui/form/respchangepassword";
        }
        else{
            form = "respchangepasswordsuccess";
            modelurl = "/ui/form/respchangepasswordsuccess";
        }
        return(
        <div>
             <CloverForm   
               {...sectorprops}  
               formName={form}
               modelurl={modelurl}
               data={this.state.data} 
               errors={this.state.errors}
               className="clover-application-login" />
         </div>
         )
    }
    
    getUrlId = () => { 
        var url = new URL(window.location.href);
      
        var query_string = url.search;
        var search_params = new URLSearchParams(query_string); 
        var id = search_params.get('nkt');

        return id;
    }

    onChangePassword = () => {
        if (this.validate() == false || this.checkConfirmPassword() == false) {
            alertify.error("Check errors on this form!");
        }
        else {
            if (this.validatePassword() == false) {
              return alertify.error("Password does not fit requirement!");
            }
            var me = this;    
            var data = new Array();
            data.push({name: 'token', value: me.getUrlId()});
            data.push({name: 'newPassword', value: this.state.data.confirmPassword});
            $.ajax({
                url: "/resp/RespChangePassword",
                data: data,
                async: true,
                type: "post",
                success: function (response) {
                    if (response.success) {
                        alertify.success(response.message);
                        me.setState({goSuccessForm: true});
                    }
                    else {
                        alertify.error(response.message);
                       
                        me.setState({errors:{
                            newPassword:true,  
                            confirmPassword: true}
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

    redirectToLogin = () => {
            window.location = '/resp/login';
    }
}

render(<RespChangePassword/>,document.getElementById('content'));
