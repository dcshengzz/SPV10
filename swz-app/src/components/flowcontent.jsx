import React, { Component } from 'react'
import { connect } from 'react-redux'
import FormContent from './formcontent.jsx'
import {Content,mapDispatchToPropsBase,mapStateToPropsBase} from "./formcontent";
import store from '../store.jsx'

class FlowContent extends Component {
    render(){
        const newProps = {...this.props};
        newProps.getMainFormKey = this.getMainFormKey.bind(this);
        newProps.preventDrawMainform = !this.state.flowName || this.state.needFetchFlow;
        return <Content key={this.getMainFormKey() + "_flowcontent"} {...newProps}></Content>
    }
    getMainFormKey ()
    {
        return "mainform_" + this.state.flowName + "_" + this.props.filter;
    }

    static getDerivedStateFromProps(nextProps, prevState) {
        const stateDelta = {};
        const nextFlowName = nextProps.flowName === null ? null : nextProps.flowName === undefined ? null : nextProps.flowName.toLowerCase();
        const prevFlowName = prevState !== null ? (prevState.flowName === undefined ? null : prevState.flowName) : null;
        const nextFilter = nextProps.filter !== undefined ? nextProps.filter : null;
        const prevFilter =  prevState !== null ? prevState.filter : null;
        stateDelta.flowName = nextFlowName;
        if (nextFlowName !== prevFlowName) {
            if (nextFlowName !== null) {
                stateDelta.needFetchFlow = true;
                stateDelta.needFetchData = true;
                stateDelta.filter = nextProps.filter;
            }
        }
        else if (nextFilter !== prevFilter) {
            stateDelta.filter = nextProps.filter;
            stateDelta.needFetchData = true;
        }

        return {...stateDelta, ...FormContent.getDerivedStateForChildForms(nextProps, prevState)};
    }

    RequestModelAndData () {

        if (this.state.needFetchFlow)
        {
            this.setState ({needFetchFlow: false});
            this.props.fetchFlow(this.state.flowName, this.state.filter);
        }
        else if (this.state.needFetchData && this.props.formName !== null)
        {
            this.setState ({needFetchData: false});
            this.props.fetchData(null,this.state.filter, this.props.formName);
        }
        else if (this.state.childDataRequest !== null)
        {
            const request = this.state.childDataRequest;
            this.setState({childDataRequest : null});
            this.props.fetchData(null, request.filter, request.formName, request.index, true);
        }
    }

    componentDidMount() {
        this.RequestModelAndData();
    }

    componentDidUpdate(prevProps, prevState) {
        this.RequestModelAndData();
    }
}

const mapStateToProps = (state, ownProps) => {
    const props = mapStateToPropsBase(state,ownProps);
    let flowNameFormLocation = null;
    if ( state.router.location)
    {
        let locations = state.router.location.pathname.split("/");
        if (locations.length > 2 && locations[1].toLowerCase() === store.getState().settings.flow)
            flowNameFormLocation = locations[2];
    }

    return {
        ...props,
        flowName: ownProps.flowName ? ownProps.flowName : flowNameFormLocation,
        formName: state.app.form.formParams.name
    }
};

export default connect(mapStateToProps, mapDispatchToPropsBase)(FlowContent)