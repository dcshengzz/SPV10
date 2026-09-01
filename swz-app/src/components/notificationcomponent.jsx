import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import actions from '../actions.jsx'
import thunks from '../thunks/index.jsx'
import { encodeHtml  } from '../utils.jsx';

class NotificationComponent extends Component {
    constructor (props)
    {
        super(props);

        this.state = {
            fetchCount:0
        }

    }

    render() {
        return null;
    }

    static getDerivedStateFromProps(nextProps, prevState) {
        const stateDelta = {};
        if (prevState.fetchCount === 0 && nextProps.fetchCount > 0)
        {
            stateDelta.fetchCount = nextProps.fetchCount;
            stateDelta.start = true;
            stateDelta.stop = false;
        }
        else if (prevState.fetchCount > 0 && nextProps.fetchCount === 0)
        {
            stateDelta.fetchCount = 0;
            stateDelta.start = false;
            stateDelta.stop = true;
        }

        if (!stateDelta.showError && nextProps.error !== undefined)
        {
            stateDelta.showError = true;
            stateDelta.error = nextProps.error;
            stateDelta.errorLevel = nextProps.errorLevel;
            stateDelta.errorDetails = nextProps.errorDetails;
        }
        return stateDelta;

    }

    componentDidMount() {
        this.StartStopOnFetch();
        this.ShowError();
    }

    componentDidUpdate(prevProps, prevState) {
        this.StartStopOnFetch();
        this.ShowError();
    }

    StartStopOnFetch() {
        if (this.state.start) {
            this.setState({start: false});
            this.onFetchStarted();
        }
        else if (this.state.stop) {
            this.setState({stop: false});
            this.onFetchFinished();
        }
    }

    ShowError ()
    {
        if (this.state.showError)
        {
            var error = this.state.error;

            this.setState({showError: false});
            if (this.state.errorLevel === 1){
                this.ShowPopupError(error);
            }
            else {
                let msg = error;
                if (this.state.errorDetails !== undefined){
                    let moreinformation = ""; //"More information in the developer console!";
                    if(window.CloverAdminLang !== undefined){
                        moreinformation = window.CloverAdminLang.msg.moreinformation;
                    }
                    msg += " " + moreinformation;
                }
                this.ShowPopupError(msg);
                console.error(error, this.state.errorDetails);
            }

            this.props.clearErrors();
        }
    }

    ShowPopupError(msg){
        var seconds = undefined;

        if(this.state.prevError != undefined && this.state.prevErrorDate != undefined){
            var t1 = new Date();
            var t2 = this.state.prevErrorDate;
            var dif = t1.getTime() - t2.getTime();
            seconds = dif / 1000;
        }
        
        if(seconds == undefined || !(this.state.prevError == msg && seconds < 1)){
            if(Array.isArray(msg)){	
                alertify.alert(encodeHtml(msg.join('\n')));
            }
            else{
                alertify.alert(encodeHtml(msg)); 
            }
        }

        this.state.prevError = msg;
        this.state.prevErrorDate = new Date();
    }

    onFetchStarted(){
        if (this.props.onFetchStarted !== undefined)
            this.props.onFetchStarted();
    }

    onFetchFinished(){
        if (this.props.onFetchFinished !== undefined)
            this.props.onFetchFinished();
    }
};

const mapStateToProps = (state, ownProps) => {
    return {
        fetchCount: state.app.fetchCount,
        error: state.app.error,
        errorLevel: state.app.errorLevel,
        errorDetails: state.app.errorDetails
    }
};

const mapDispatchToProps = (dispatch, ownProps) => {
    return {
        clearErrors: () => {
            dispatch(actions.app.clearerrors());
        }
    }
};

export default connect(mapStateToProps, mapDispatchToProps)(NotificationComponent);