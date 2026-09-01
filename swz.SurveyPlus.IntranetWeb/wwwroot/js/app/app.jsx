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
import { Button, Modal } from 'semantic-ui-react'


class App extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            pagekey: 0,
            onSurvey: "Not exist",
	        onlySurveyForm: false,
            username: "",
            lastLoginDate: "",
            licenseexpiry: "",
            requireExpiryPrompt: false 
        };

        let datetimeformat = (window.CloverLang !== undefined && CloverLang.common !== undefined && window.CloverLang.common.dateFormat != undefined)
            ? window.CloverLang.common.dateFormat + " " +
            (window.CloverLang.common.timeFormat !== undefined ? window.CloverLang.common.timeFormat : "HH:mm")
            : "DD MMM YYYY HH:mm";
        
        let me = this;
        Store.dispatch(Thunks.userinfo.fetch(function (user) {
            if (user) {
                me.setState({ username: user.name });
                var lastLoginDateData = moment(user.lastLoginDate);
                if (lastLoginDateData.isValid()) {
                    me.setState({ lastLoginDate: "Last Login: " + lastLoginDateData.format(datetimeformat) });
                }
            }
            me.forceUpdate();
        }));

        Store.dispatch(Thunks.licenseexpiry.fetch(function (licenseexpiry) {
            if (licenseexpiry) {
                const { expiryDate, expiryDays } = licenseexpiry;
                const endDate = moment(expiryDate);
                const currentDate = moment();
                if (endDate.isValid()) {
                    const diffDays = endDate.diff(currentDate, 'days');
                    // Check if the difference is 30 days or less (configurable in appsettings)
                    if (diffDays <= expiryDays) {
                        me.setState({ licenseexpiry: endDate.format("DD MMM YYYY")});
                        if(sessionStorage.getItem('requireExpiryPrompt') === 'true' || sessionStorage.getItem('requireExpiryPrompt') === null) {
                            sessionStorage.setItem('requireExpiryPrompt', 'false');
                            me.setState ({
                                requireExpiryPrompt: true,
                            })
                        } 
                        else 
                        {
                            me.setState ({
                                requireExpiryPrompt: false,
                            })
                        }
                    }
                }
            }
            me.forceUpdate();
        }));
        Store.dispatch(Thunks.autosave.fetchIntra(function (autosave) {
            me.forceUpdate();
        }));

        window.CloverApp = this;
        window.CloverApp.API = API;
        this.onFetchStarted();
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

        var hideExpiryPrompt = () => {this.setState({requireExpiryPrompt: false})};

        return <div className="clover-application" key={this.state.pagekey}>
            <BrowserCompatibilityCheck />
            {this.state.licenseexpiry && this.state.licenseexpiry !== "" && (
            <div className="ui banner">
                <div className="banner">
                Surveyplus license is due to expire on {this.state.licenseexpiry}. To ensure uninterrupted access and continued support, we kindly request that you take action to renew your license at your earliest convenience.
                </div>
            </div>
            )}
            {this.state.licenseexpiry && this.state.licenseexpiry !== "" && this.state.requireExpiryPrompt === true && (
                        <Modal 
                        open={this.state.requireExpiryPrompt}
                        dimmer={'blurring'}
                        closeOnDimmerClick={false} >
                        <Modal.Header content="License Expiry Notification" /> 
                        <Modal.Content>
                            <p>Surveyplus license is due to expire on {this.state.licenseexpiry}. To ensure uninterrupted access and continued support, we kindly request that you take action to renew your license at your earliest convenience.</p>
                        </Modal.Content>      
                        <Modal.Actions>  
                            <Button 
                                className="buttontype1" 
                                onClick={hideExpiryPrompt} 
                                content="Ok" />                
                        </Modal.Actions>        
                    </Modal>
            )}
            {!this.state.onlySurveyForm && (<div>
                <CloverForm {...sectorprops} formName="header" data={{ currentUser: this.state.username, lastLogin: this.state.lastLoginDate }} modelurl="/ui/form/header" />
                        </div>)}
           <div className="clover-application-container">
                {!this.state.onlySurveyForm && (<div className="clover-application-menu">
                            <CloverForm { ...sectorprops } formName="sidemenu" stateDataPath="app.sidemenu" modelurl="/ui/form/sidemenu" />
                        </div>)}
                        <div className="clover-application-maincontent">
                        <div className="clover-application-top"></div>
                <div className="clover-application-basecontent">
                    <div id="clover-application-content" className="clover-application-content">
                        <Provider store={Store}>
                            <BrowserRouter>
                                <div className="clover-application-content-form">
                                    <ApplicationRouter onRefresh={this.onRefresh.bind(this)} />
                                    <NotificationComponent
                                        onFetchStarted={this.onFetchStarted.bind(this)}
                                        onFetchFinished={this.onFetchFinished.bind(this)} />
                                    <Switch>
                                        <Route key={1} exact path='/form/:formName/preview' render={() => { return <SurveyFormContent onPreview={true} onSurveyRoute={this.onSurveyRoute.bind(this)} />; }} />
                                        <Route key={2} exact path='/form/:formName/dlsi/:id([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})' render={()=> {return <SurveyFormContent onSurveyRoute={this.onSurveyRoute.bind(this)} />;}} />
                                        <Route key={3} exact path='/form/:formName/:id([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})?' render={() => { return <FormContent onCloverRoute={this.onCloverRoute.bind(this)} />; }} />
                                        <Route key={4} exact path='/form/:formName//:parentFieldName/:parentId([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})' render={() => { return <FormContent onCloverRoute={this.onCloverRoute.bind(this)} />; }} />
                                        <Route key={5} exact path='/form/:formName/:id([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/:parentFieldName/:parentId([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})' render={() => { return <FormContent onCloverRoute={this.onCloverRoute.bind(this)} />; }} />
                                        <Route key={6} exact path='/form/:formName/respid/:respid([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/dlsi/:id([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})' render={() => { return <SurveyFormContent onSurveyRoute={this.onSurveyRoute.bind(this)} />; }} />
                                        <Route key={7} exact path='/form/:formName/print/dlsi/:id([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})' render={()=> {return <SurveyFormContent onSurveyRoute={this.onSurveyRoute.bind(this)} />;}} />
                                        <Route key={8} exact path='/form/:formName/print/respid/:respid([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/dlsi/:id([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})' render={() => { return <SurveyFormContent onSurveyRoute={this.onSurveyRoute.bind(this)} />; }} />
                                        <Route key={9} exact path='/form/:formName/view/dlsi/:id([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})' render={()=> {return <SurveyFormContent onSurveyRoute={this.onSurveyRoute.bind(this)} />;}} />
                                        <Route key={10} exact path='/form/:formName/view/respid/:respid([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/dlsi/:id([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})' render={() => { return <SurveyFormContent onSurveyRoute={this.onSurveyRoute.bind(this)} />; }} />
                                        <Route path='/flow' component={FlowContent} />
                                        <Route exact path='/' render={()=> {return <FormContent formName="Home" onCloverRoute={this.onCloverRoute.bind(this)} />;}} />
                                        <Route nomatch render={() => {
                                            //Hack for back button
                                            let url = window.location.href;
                                            window.location.href = url;
                                            return null;
                                        }} />
                                    </Switch>
                                </div>
                            </BrowserRouter>
                        </Provider>
                    </div>
                </div>
                </div>
            </div>
            {!this.state.onlySurveyForm && (<div>
                            <CloverForm {...sectorprops} formName="footer" modelurl="/ui/form/footer" />
                     </div>)}
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

