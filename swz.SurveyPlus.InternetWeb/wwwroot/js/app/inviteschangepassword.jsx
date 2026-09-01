import React from 'react'
import { render } from 'react-dom'
import { CloverForm } from "./../../scripts/swz-form.js"

class InvitesChangePassword extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            data: {
                goSuccessForm: false
            }
        }
    }

    eventHandler(args) {
        var me = this;

        if (Array.isArray(args.actions)) {
            args.actions.forEach(function (a) {
                if (a === "changePassword") {
                    me.onChangePassword();
                }
                if (a === "gohome"){
                    me.redirectToDashboard();
                }
                if (a === "cancel") {
                    me.redirectToDashboard();
                }
            });
        }
        return false;
    }

    validate() {
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

    checkConfirmPassword() {
        var res = true;
        var editrow = this.state.data;
        var msgRequiredField = "Confirm password do not match";

        this.state.errors = {
            confirmPassword: (editrow.newPassword != editrow.confirmPassword) ? msgRequiredField : undefined
        };

        res &= this.state.errors.confirmPassword == undefined;
        return res;
    }

    countChars(str, type) {
        var count = 0, len = str.length;
        for (var i = 0; i < len; i++) {
            if (type == 0) {
                if (/[A-Z]/.test(str.charAt(i))) count++;
            }
            else if (type == 1) {
                if (/[a-z]/.test(str.charAt(i))) count++;
            }
            else if (type == 2) {
                if (/[0-9]/.test(str.charAt(i))) count++;
            }
        }
        return count;
    }

    validatePassword() {

        var res = true;
        var pwd = this.state.data.newPassword;
        var req = new RegExp(/^[a-zA-Z0-9]{12,100}$/);

        if (!req.test(pwd)) {
            res = false;
        }

        if (this.countChars(pwd, 0) < 3 || this.countChars(pwd, 1) < 3 || this.countChars(pwd, 2) < 3) {
            res = false;
        }

        return res
    }

    onChangePassword = () => {
        if (this.validate() == false || this.checkConfirmPassword() == false) {
            alertify.error("New Password must not be empty<br />Confirm Password and New Password must match", 10000);
        }
        else {
            if (this.validatePassword() == false) {
                return alertify.error("Password must contain alphanumeric characters only<br />Password must not be less than 12 characters<br />Password must contain at least 3 characters from each category (lowercase letter, uppercase letter, numeric digit)", 10000);
            }

            var me = this;
            let formData = new FormData();
            formData.append('newPassword', this.state.data.confirmPassword);
            const url = '/Resp/InvitesChangePassword/';
            return Utils.postFormRequest(url, formData).then(
                response => {
                    if (response.success) {
                        alertify.success(response.message);
                        me.setState({ goSuccessForm: true });
                    } else {
                        alertify.error(response.message);

                        me.setState({
                            errors: {
                                newPassword: true,
                                confirmPassword: true
                            }
                        });
                    }
                }, reason => {
                    alertify.error(reason);
                }
            ).finally(Utils.loadingStop);
        }
        this.forceUpdate();
    }

    redirectToDashboard = () => {
        window.location = '/form/respdashboard';
    }

    render(){

        const { goSuccessForm } = this.state;
        let sectorprops = {
            eventFunc: this.eventHandler.bind(this)
        };

        var form;
        var modelurl;
        if (!goSuccessForm) {
            form = "inviteschangepassword";
            modelurl = "/ui/form/inviteschangepassword";
        }
        else {
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
}

render(<InvitesChangePassword/>,document.getElementById('content'));
