import React, { Component } from 'react'
import { connect } from 'react-redux'
import actions from '../actions.jsx'
import { withRouter } from "react-router-dom";

class ApplicationRouter extends Component {
    render() {
        if (this.props.children)
            return React.Children.only(this.props.children);
        else
            return null;
    }
    componentDidMount() {
      this.props.onRouteChanged();
    }
    componentDidUpdate(prevProps, prevState) {
        let needRefresh = false;    
        if (this.props.push) {
            let location = { pathname: this.props.push };
            this.props.history.push(location);
        }
        if (this.props.redirect) {
            let location = { pathname: this.props.redirect };
            this.props.history.replace(location);
        }
        if (this.props.refresh) {
            if (this.props.onRefresh !== undefined)
                needRefresh = true;
            else{
                console.log("ApplicationRouter: Need to define handler for onRefresh");
            }
        }

        if (needRefresh)
            this.props.onRefresh();
        this.props.onRouteChanged();
    }
}

// noinspection JSUnusedLocalSymbols
const mapStateToProps = (state, ownProps) => {
    return {
        push: state.router.push,
        redirect: state.router.redirect,
        refresh: state.router.refresh,
        filter: state.router.filter
    }
};

const mapDispatchToProps = (dispatch, ownProps) => {
    return {
        onRouteChanged: () => {
            dispatch(actions.router.routechanged(ownProps.history, ownProps.history && ownProps.history.location ? ownProps.history.location : ownProps.location));
        }
    }
};

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(ApplicationRouter))