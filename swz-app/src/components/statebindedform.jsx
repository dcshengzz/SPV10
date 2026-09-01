import React, { Component } from 'react';
import { connect } from 'react-redux';
import { CloverForm } from "../../../swz-builder/build/swz-form";

class StateBindedForm  extends Component {
    render() {
        return (<CloverForm {...this.props}  data={this.props.combinedData}/>)
    }
}

const mapDispatchToProps = (dispatch, ownProps) => {

};

const mapStateToProps = (state, ownProps) => {
    let newProps = {};

    let getDataFromState = function (stateDataPath, data) {
        const statePathSplitted = stateDataPath.split('.');
        let current = statePathSplitted.length > 0 ? state[statePathSplitted[0]] : null;
        let lastPropertyName = null;
        for (let i = 1; i < statePathSplitted.length; i++) {
            if (current !== undefined && current !== null) {
                lastPropertyName = statePathSplitted[i]
                current = current[lastPropertyName];
            }
            else {
                break;
            }
        }

        if (current === null || current === undefined)
            return {...data};

        if (typeof current === "object" ) {
            return {
                ...data,
                ...current
            }
        }
        else {
            let res = {...data};
            if (lastPropertyName !== null) {
                res[lastPropertyName] = current;
            }
            return res;
        }
    };

    let newData = {};
    if (ownProps.stateDataPath !== null && ownProps.stateDataPath !== undefined) {
        if (typeof ownProps.stateDataPath === "string") {
            newData = getDataFromState(ownProps.stateDataPath, newData);
        }
        else if (Array.isArray(ownProps.stateDataPath))
        {
            for (let i = 0; i < ownProps.stateDataPath.length; i++)
            {
                if (typeof ownProps.stateDataPath[i] === "string")
                {
                    newData = getDataFromState(ownProps.stateDataPath[i], newData);
                }
            }
        }
    }

    if (ownProps.data !== undefined && ownProps.data !== null && typeof ownProps.data === "object")
    {
        const additionalData = ownProps.data;
        newData = {
            ...newData,
            ...additionalData
        };
    }

    newProps.combinedData = newData;
    return newProps;

};

export default connect(mapStateToProps, mapDispatchToProps)(StateBindedForm)