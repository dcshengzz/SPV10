import React from 'react'
import { render } from 'react-dom'
import { CloverForm } from "./../../scripts/swz-form.js"

class RespLogin extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            data: {
                wogaaEnabled: (props.wogaaUrl ? true : false),
                wogaaUrl: (props.wogaaUrl ? props.wogaaUrl : ""),
                spcpLogin: (props.spcpLogin ? true : false),
                singpassSupported: (props.singpassSupported ? true : false),
                corppassSupported: (props.corppassSupported ? true : false),
                goForgotPwd: false,
                goForgotPwdSuccess: false,
                remember: true,
                respLoginHtmlView: undefined,
                brandingImage: '',
                brandingImagePath: props.brandingImagePath || 'misp',
            },
        }
    }

    componentDidMount = () => {
        this.getContent();
        this.observeLogos();
    }

    componentDidUpdate = () => {
        this.updateLogoPaths();
    }

    componentWillUnmount = () => {
        if (this._logoObserver) {
            this._logoObserver.disconnect();
            this._logoObserver = null;
        }
    }

    observeLogos = () => {
        if (this.updateLogoPaths()) return;
        const container = document.getElementById('content');
        if (!container) return;
        this._logoObserver = new MutationObserver(() => {
            if (this.updateLogoPaths() && this._logoObserver) {
                this._logoObserver.disconnect();
                this._logoObserver = null;
            }
        });
        this._logoObserver.observe(container, { childList: true, subtree: true });
    }

    classifyLogo = (img) => {
        img.classList.remove('resp-login-logo-full', 'resp-login-logo-compact', 'resp-login-logo-banner');
        var container = img.closest('.clover-resp-login-container');
        if (container) {
            container.classList.remove('logo-full-mode', 'logo-compact-mode', 'logo-banner-mode');
        }
        var w = img.naturalWidth;
        var h = img.naturalHeight;
        var isFull = h >= w && w >= 200 && h >= 200;
        var isBanner = w > h && w >= 200;
        if (isFull) {
            img.classList.add('resp-login-logo-full');
            if (container) container.classList.add('logo-full-mode');
        } else if (isBanner) {
            img.classList.add('resp-login-logo-banner');
            if (container) container.classList.add('logo-banner-mode');
        } else {
            img.classList.add('resp-login-logo-compact');
            if (container) container.classList.add('logo-compact-mode');
        }
    }

    updateLogoPaths = () => {
        const { brandingImagePath } = this.state.data;
        if (!brandingImagePath) return false;
        const container = document.getElementById('content');
        if (!container) return false;
        const desktopLogo = container.querySelector('.resp-login-logo-desktop');
        const mobileLogo = container.querySelector('.resp-login-logo-mobile');
        if (!desktopLogo && !mobileLogo) return false;
        const classify = this.classifyLogo;
        if (desktopLogo) {
            desktopLogo.onload = function() { classify(this); };
            desktopLogo.src = '/' + brandingImagePath + '/resplogin_logo.png';
        }
        if (mobileLogo) {
            mobileLogo.onload = function() { classify(this); };
            mobileLogo.src = '/' + brandingImagePath + '/resplogin_logo_mobile.png';
            mobileLogo.onerror = function() {
                this.src = '/' + brandingImagePath + '/resplogin_logo.png';
                this.onerror = null;
            };
        }
        return true;
    }

    getContent(){
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
    }

    render(){
        const { spcpLogin, singpassSupported, corppassSupported, wogaaEnabled, wogaaUrl, brandingImagePath } = this.state.data;
        const { goForgotPwd, goForgotPwdSuccess } = this.state;

        let sectorprops = {
            eventFunc: this.eventHandler.bind(this)
        };

        if (wogaaEnabled && wogaaUrl != null && wogaaUrl != '')
        {
            var wogaaScript = document.createElement('script');
            wogaaScript.setAttribute('src', wogaaUrl);
            const wogaaHeadTag = $('#wogaa');
            wogaaHeadTag.replaceWith(wogaaScript);
        }

        var form;
        var modelurl;
        if (spcpLogin) {
            if (singpassSupported && corppassSupported) {
                form = "respLoginIAm";
                modelurl = "/ui/form/respLoginIAm";
            } else if (singpassSupported) {
                form = "respLoginIAmIndividual";
                modelurl = "/ui/form/respLoginIAmIndividual";
            } else if (corppassSupported) {
                form = "respLoginIAmEntity";
                modelurl = "/ui/form/respLoginIAmEntity";
            } else {
                console.error("spcp login is enabled but neither singpass or corppass are supported");
                form = null;
                modelurl = null;
            }
        }
        else
        {
            if (!goForgotPwd)
            {
                form = "resplogin";
                modelurl =  "/ui/form/resplogin";
            }
            else
            {
                if(!goForgotPwdSuccess){
                    form = "respresetpassword";
                    modelurl =  "/ui/form/respresetpassword";
                }
                else{
                    form = "respresetpasswordsuccess";
                    modelurl =  "/ui/form/respresetpasswordsuccess";
                }
            }
        }

       return(
        <CloverForm
            {...sectorprops}
            formName={form}
            modelurl={modelurl}
            data={this.state.data}
            errors={this.state.errors}
            className="clover-resp-login-page" />
        )
    }

    eventHandler(args) {
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
                    window.location.reload();
                }
                if (a === "setSPCPFlow") {
                    let spcpTarget = null;
                    if (args.sourceControlValue === "Corppass") {
                        spcpTarget = "/resp/StartIAmEntityLogin";
                    } else if (args.sourceControlValue === "Singpass") {
                        spcpTarget = "/resp/StartIAmIndividualLogin";
                    } else {
                        console.error("Unknown spcp flow", args.sourceControlValue, args);
                    }
                    const anchor = document.getElementById("spcpLogin");
                    const prompt = document.getElementById("spcpLoginPrompt");
                    if (spcpTarget != null) {
                        prompt.style.visibility = "hidden";
                        anchor.href = spcpTarget;
                    } else {
                        prompt.style.visibility = "visible";
                        anchor.href = "";
                    }
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
                        alertify.success(response.message);
                        me.setState({goForgotPwdSuccess:true});
                    }
                    else {
                        alertify.error(response.message);
                        me.setState({errors:{
                            UID:true}
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
                        me.redirectToDashboard(response.forcePwdChange);
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

    redirectToDashboard(forcePwdChange){
        if (forcePwdChange) {
            window.location = '/form/RespAccountChangePassword';
        } else {
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

window.renderRespLogin = function (spcpLogin = false, singpassSupported = false, corppassSupported = false, wogaaUrl=null, brandingImagePath='misp') {
    render(<RespLogin
            spcpLogin={spcpLogin}
            singpassSupported={singpassSupported}
            corppassSupported={corppassSupported}
            wogaaUrl={wogaaUrl}
            brandingImagePath={brandingImagePath} />,
        document.getElementById('content'));
}
