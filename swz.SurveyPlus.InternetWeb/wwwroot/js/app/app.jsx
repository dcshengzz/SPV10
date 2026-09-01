import React from 'react'
import { render } from 'react-dom'
import { Provider } from 'react-redux'
import { BrowserRouter, Switch, Route } from 'react-router-dom'
import { CloverForm } from "./../../scripts/swz-form.js"
import {
    ApplicationRouter, NotificationComponent, FormContent, SurveyFormContent,
    FlowContent, Thunks, Store, Actions, SignalRConnector, StateBindedForm, API
} from './../../scripts/swz-app.js'
import moment from 'moment';
import BrowserCompatibilityCheck from "./BrowserCompatibilityCheck.jsx";

class App extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            pagekey: 0,
            onSurvey: "Not exist",
	        onlySurveyForm: true,
	        username: "",
	        uid: "",
            lastLoginDate: "",
            autosave:"",
            data: {
                wogaaEnabled: false,
                wogaaUrl: ""
            }
        };
        
        this.checkWogaaEnabled();
        let me = this;
        Store.dispatch(Thunks.autosave.fetch(function (autosave) {
            me.forceUpdate();
        }));

    $.ajax({
        url: "/resp/getResp",
        async: true,
        type: "get",
        success: function (response) {
            if (response.success) {
                me.setState({ uid: response.item });
            }
            else {
                alertify.error(response.message);
            }
        },
        error: function (jqXHR, exception) {
                alertify.error("Cannot get respondent UID");
        }
    });

        $.ajax({
            url: "/resp/getRespLastLoginDate",
            async: true,
            type: "get",
            success: function (response) {
                if (response.success) {

                    let datetimeformat = (window.CloverLang !== undefined && CloverLang.common !== undefined && window.CloverLang.common.dateFormat != undefined)
                        ? window.CloverLang.common.dateFormat + " " +
                        (window.CloverLang.common.timeFormat !== undefined ? window.CloverLang.common.timeFormat : "HH:mm")
                        : "DD MMM YYYY HH:mm";

                    var lastLoginDateData = moment(response.item);
                    if (lastLoginDateData.isValid()) {
                        me.setState({ lastLoginDate: "Last Login: " + lastLoginDateData.format(datetimeformat) });
                    }

                }
                else {
                    alertify.error(response.message);
                }
            },
            error: function (jqXHR, exception) {
                alertify.error("Cannot get respondent last login");
            }
        });

        window.CloverApp = this;
        window.CloverApp.API = API;
        this.onFetchStarted();
    }

    checkWogaaEnabled() {
        $.ajax({
            url: "/resp/IsWogaaEnabled",
            async: true,
            type: "get",
            success: (response) => {
                this.setState(prevState => ({
                    ...prevState,
                    data: {
                        ...prevState.data,
                        wogaaEnabled: response.wogaaEnabled,
                        wogaaUrl: response.wogaaUrl
                    }
                })
                )
                if (response.message) {
                    alertify.error(response.message);
                }

            },
            error: function (jqXHR, exception) {
                alertify.error("Not able to connect to the server.");
            }
        });
    }


    getPath = () =>{
        var path = window.location.pathname;
        if (path.includes('/form/')){
            path = path.replace('/form/',''); 
        }
        return path
    }

    render() {
        let sectorprops = {
            eventFunc: this.actionsFetch.bind(this),
            getAdditionalDataForControl: this.additionalFetch.bind(this, undefined)
        };

        const { wogaaEnabled } = this.state.data;
        const { wogaaUrl } = this.state.data;

        if (wogaaEnabled && wogaaUrl != null && wogaaUrl != '') {
            var wogaaScript = document.createElement('script');
            wogaaScript.setAttribute('src', wogaaUrl);
            const wogaaHeadTag = $('#wogaa');
            wogaaHeadTag.replaceWith(wogaaScript);
        }

        let state = Store.getState();
        let user = state.app.user;

        let headerModelUrl = "/ui/form/header";
        let headerFormName = "header";
        let footerModelUrl = "/ui/form/footer";
        let footerFormName = "footer";
        let homeFormName = "SwzQnnList";
        let noMatchUrl = window.location.href;
        let id = "userapp";
        let headerData = { currentUser: "" };
        let onSideMenu = false;
        let onHeader = true;
        let onFooter = true;
	    let sideMenu = null;

        if (!user) {
            //user = {};
            id = "spapp";
            headerFormName = "spheader";
            footerFormName = "spfooter";
            footerModelUrl = "/ui/form/spfooter";
            headerModelUrl = "/ui/form/spheader";
            homeFormName = "respdashboard";
            noMatchUrl = '/form/respdashboard';
            if (this.state.uid) headerData = { currentUser: this.state.uid, lastLogin: this.state.lastLoginDate };
        } else {
            headerData = { currentUser: user.name }
            sideMenu = <div className="clover-application-menu">
                            <CloverForm { ...sectorprops } formName="sidemenu" stateDataPath="app.sidemenu" modelurl="/ui/form/sidemenu" />
                        </div>;
        }

        if (this.state.onlySurveyForm){
            onSideMenu = false;
            onHeader = false;
            onFooter = false;
        }
     

        return <div id={id} className="clover-application" key={this.state.pagekey}>
            <BrowserCompatibilityCheck />
            {onHeader && <CloverForm {...sectorprops} formName={headerFormName} data={headerData} modelurl={headerModelUrl} />}
            <div className="clover-application-container">
                {onSideMenu && sidemenu}
                <div className="clover-application-basecontent">
                    <div className="clover-application-top"></div>
                    <div id="clover-application-content" className="clover-application-content">
                        <Provider store={Store}>
                            <BrowserRouter>
                                <div id={id} className="clover-application-content-form">
                                    <ApplicationRouter onRefresh={this.onRefresh.bind(this)} />
                                    <NotificationComponent
                                        onFetchStarted={this.onFetchStarted.bind(this)}
                                        onFetchFinished={this.onFetchFinished.bind(this)} />
                                    <Switch>
                                        <Route key={1} exact path='/form/:formName/dlsi/:id([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})' render={()=> {return <SurveyFormContent onSurveyRoute={this.onSurveyRoute.bind(this)} />;}} />
                                        <Route key={5} exact path='/form/:formName/respid/:respid([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/dlsi/:id([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})' render={()=> {return <SurveyFormContent onSurveyRoute={this.onSurveyRoute.bind(this)} />;}} />
                                        <Route key={2} exact path='/form/:formName/:id([0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12})?' render={()=> {return <FormContent  onCloverRoute={this.onCloverRoute.bind(this)} />;}} />

                                        <Route path='/flow' component={FlowContent} />
                                        <Route exact path='/' render={()=> {return <FormContent formName="respdashboard" onCloverRoute={this.onCloverRoute.bind(this)} />;}} />
                                        <Route exact path='/resp/logoff' render={() => {
                                            window.location.href = '/resp/logoff';
                                            return null;
                                        }} />
                                        <Route nomatch render={() => {
                                            window.location.href = '/error/404';
                                            return null;
                                        }} />
                                    </Switch>
                                </div>
                            </BrowserRouter>
                        </Provider>
                    </div>
                </div>
            </div>
         {/*    {onFooter && <CloverForm {...sectorprops} formName={footerFormName} modelurl={footerModelUrl} />} */}
        </div>;

    }

    onFetchStarted() {
        $('body').loadingModal({
            text: 'Loading...',
            animation: 'foldingCube',
            backgroundColor: '#1262E2',
        });
        $('#clover-application-content').css("visibility","hidden");
    }

    onFetchFinished() {
         setTimeout(function(){
            $('body').loadingModal('destroy');
            $('#clover-application-content').css("visibility","visible");
          }, 400); 
    }

    onRefresh() {
        this.onFetchStarted();
        Store.resetForm();
        this.setState({
            pagekey: this.state.pagekey + 1
        });
        //SignalRConnector.Connect(Store);
    }

    onSurveyRoute() {
	this.setState({onlySurveyForm: true});
    }
    onCloverRoute() {
	this.setState({onlySurveyForm: false});
    }
    actionsFetch(args) {
        Store.dispatch(Thunks.form.executeActions(args));
    }

    additionalFetch(formName, controlRef, { startIndex, pageSize, filters, sort, model }, callback) {
        Store.dispatch(Thunks.additional.fetch({
            type: controlRef.props["data-buildertype"],
            formName, controlRef, startIndex, pageSize, filters, sort, callback
        }
        ));
    }

    encodeQueryData = (data) => {
        const ret = [];
        for (let d in data)
          ret.push(encodeURIComponent(d) + '=' + encodeURIComponent(data[d]));
        return ret.join('&');
    }
}

//SignalRConnector.Connect(Store);

render(<App />, document.getElementById('content'));

