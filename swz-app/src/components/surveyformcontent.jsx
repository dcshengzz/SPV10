import React, { Component } from 'react'
import { connect } from 'react-redux'
import { CloverForm } from "../../../swz-survey-builder/build/swz-form"
import { jsonEqual, cloneDataObject } from '../utils.jsx'
import actions from '../actions.jsx'
import thunks from '../thunks/index.jsx'
import { Modal } from 'semantic-ui-react'
import store from '../store.jsx';

export class Content extends Component {
    render() {
        let drawChildren = (i = 0) => {
            if (i >= this.props.modals.length)
                return null;
            let formName = this.props.modals[i];
            return (
                <Modal open={true}>
                    <Modal.Content>
                        <CloverForm
                            key={"chidForm_" + formName}
                            formName={formName}
                            data={this.props.childData[formName + "_" + i]}
                            extendedData={{filters: this.props.controlFiltersa[formName + "_" + i]}}
                            model={this.props.childModels[formName]}
                            errors={this.props.childErrors ? (this.props.childErrors[formName + "_" + i] ? this.props.childErrors[formName + "_" + i] : undefined ) : undefined}
                            dataChanged={(form, {key, value}) => {
                                this.props.dataChanged(key, value, formName, i, true)
                            }}
                            eventFunc={(args) => {
                                this.props.executeActions({
                                    ...args,
                                    index: i,
                                    isChild: true
                                });
                            }}
                            getAdditionalDataForControl={this.props.additionalFetch.bind(this, () => {
                                return formName;
                            })}
                            //TODO Hide and readonly for chilren
                            // hideControls={this.props.hideControls}
                            // readOnlyControls={this.props.readOnlyControls}
                            // readOnly={this.props.readOnly}
                            uploadUrl={store.getState().settings.dataupload}
                            downloadUrl={store.getState().settings.datadownload}
                        />
                        {drawChildren(i + 1)}
                    </Modal.Content>
                </Modal>
            );
        };
        let drawMainForm = () => {
            if (this.props.preventDrawMainform)
                return null;
            return (
                <CloverForm
                    key={this.props.getMainFormKey()}
                    formName={this.props.formName}
                    data={this.props.data}
                    extendedData={{filters: this.props.mainControlFilters}}
                    model={this.props.model}
                    errors={this.props.errors}
                    dataChanged={(form, {key, value}) => {
                        this.props.dataChanged(key, value, this.props.formName)
                    }}
                    eventFunc={(args) => {
                        this.props.executeActions({
                            ...args,
                            index: -1,
                            isChild: false
                        });
                    }}
                    getAdditionalDataForControl={this.props.additionalFetch.bind(this, () => {
                        return this.props.formName
                    })}
                    hideControls={this.props.hideControls}
                    readOnlyControls={this.props.readOnlyControls}
                    readOnly={this.props.readOnly}
                    uploadUrl={store.getState().settings.dataupload}
                    downloadUrl={store.getState().settings.datadownload}
                    customCss={this.props.customCss}
                />
            );
        };
        //console.log("render formName:" + this.props.formName, "loadedFormName: " + this.state.loadedFormName, this.props.model, this.props.data);
        return (<div>{drawMainForm()}{drawChildren()}</div>);
    }
}

class FormContent extends Component {
    constructor(props){
        super(props);
        this.state = {};
    }

    render(){
        const newProps = {...this.props};
        newProps.getMainFormKey = this.getMainFormKey.bind(this);
        newProps.preventDrawMainform = !this.state.formName || this.state.needFetchForm;
        return <Content key={this.getMainFormKey() + "_formcontent"} {...newProps}></Content>
    }

    componentDidMount = () => {
	this.props.onSurveyRoute();
    }

    getMainFormKey ()
    {
        return "mainform_" + this.state.formName + "_" + this.props.filter;
    }

    static getDerivedStateFromProps(nextProps, prevState) {
        const stateDelta = {};
        const nextFormName = nextProps.formName === null ? null : nextProps.formName === undefined ? null : nextProps.formName.toLowerCase();
        const prevFormName = prevState !== null ? (prevState.formName === undefined ? null : prevState.formName) : null;
        const nextFilter = nextProps.filter !== undefined ? nextProps.filter : null;
        const prevFilter =  prevState !== null ? prevState.filter : null;
        stateDelta.formName = nextFormName;
        if (nextFormName !== prevFormName) {
            if (nextFormName !== null) {
                stateDelta.needFetchForm = true;
                stateDelta.needFetchData = true;
            }
        }
        else if (nextFilter !== prevFilter) {
            //stateDelta.model = nextProps.model;
            stateDelta.filter = nextProps.filter;
            stateDelta.needFetchData = true;
        }

        return {...stateDelta, ...FormContent.getDerivedStateForChildForms(nextProps, prevState)};
    }


    static getDerivedStateForChildForms (nextProps, prevState)
    {
        const stateDelta = {};
        let prevChildFilters = prevState != null ? prevState.childFilters : null;
        if (nextProps.childFilters && !jsonEqual(nextProps.childFilters, prevChildFilters)) {
            stateDelta.childFilters = nextProps.childFilters;
            let childDataRequest = null;
            for (let propertyName in nextProps.childFilters) {
                if (nextProps.childFilters.hasOwnProperty(propertyName)) {
                    let nextFilter = nextProps.childFilters[propertyName];
                    let currentFilter = prevChildFilters ? prevChildFilters[propertyName] : null;
                    if (nextFilter && (!currentFilter || !jsonEqual(currentFilter !== nextFilter))) {
                        let formName = propertyName.substr(0, propertyName.lastIndexOf('_'));
                        let index = parseInt(propertyName.substr(propertyName.lastIndexOf('_') + 1));
                        childDataRequest = {formName: formName, index: index, filter: nextFilter};
                        break;
                    }
                }
            }
           // if (childDataRequest !== null)
                stateDelta.childDataRequest = childDataRequest;
        }
        else
        {
            stateDelta.childDataRequest = null;
        }


        return stateDelta;
    }

    componentDidMount() {
        this.RequestModelAndData();
    }

    componentDidUpdate(prevProps, prevState) {
        this.RequestModelAndData();
    }

    RequestModelAndData () {
        if (this.state.needFetchForm)
        {

            this.setState({needFetchForm: false});
            if(this.props.onPreview){
                return this.props.fetchFormPreview(this.state.formName);
            }
            this.props.fetchForm(this.state.formName);
        }
        else if (this.state.needFetchData && this.state.formName !== null)
        {
            this.setState ({needFetchData: false});
            this.props.fetchData(null,this.state.filter, this.state.formName);
        }
        else if (this.state.childDataRequest !== null)
        {
            const request = this.state.childDataRequest;
            this.setState({childDataRequest : null});
            this.props.fetchData(null, request.filter, request.formName, request.index, true);
        }
    }
};

export const mapStateToPropsBase = (state, ownProps) => {
    let childData = state.app.form.data.children;
    let childControlFilters = state.app.form.filters.children;
    let mainControlFilters = state.app.form.filters.main;
    let childModels =  state.app.form.models.children;
    let childErrors = state.app.form.errors.children;
    let childDisplayedData = {};
    let childFilters = {};
    let childActions = {};
    let childModelsOnly = {};
    let childControlFiltersOnly = {};
    let mainControlFiltersOnly = {};
    if (childData) {
        for (let propertyName in childData) {
            if (childData.hasOwnProperty(propertyName)) {
                let data = childData[propertyName].modified;
                childDisplayedData[propertyName]  = Array.isArray(data) ? [...data] : {...data};
                childFilters[propertyName] = childData[propertyName].filter;
                childActions[propertyName] = childData[propertyName].action;
            }
        }
    }
    if (childControlFilters)
    {
        for (let propertyName in childControlFilters) {
            if (childControlFilters.hasOwnProperty(propertyName)) {
                const filters = childControlFilters[propertyName];
                let ch = childControlFiltersOnly[propertyName] = {};
                for (let propertyName in filters) {
                    if (filters.hasOwnProperty(propertyName)) {
                        ch[propertyName] = filters[propertyName].filter((f) => f.value !== null).map((f) => {
                            return {column: f.column, term: f.term, value: f.value}
                        });
                    }
                }
            }
        }
    }

    if (mainControlFilters)
    {
        for (let propertyName in mainControlFilters) {
            if (mainControlFilters.hasOwnProperty(propertyName)) {
                const filter = mainControlFilters[propertyName];
                const filteredFilters = filter.filter((f) => f.value !== null).map((f) => {
                    return {column: f.column, term: f.term, value: f.value}
                });
                if (filteredFilters.length > 0)
                    mainControlFiltersOnly[propertyName] = filteredFilters;
            }
        }
    }
    if (childModels)
    {
        for (let propertyName in childModels) {
            if (childModels.hasOwnProperty(propertyName)) {
                let model = childModels[propertyName].model;
                childModelsOnly[propertyName] = model;
            }
        }
    }
    let filterFromLocation = null;

    if ( state.router.location)
    {
        let locations = state.router.location.pathname.split("/");
        if (locations.length > 3)
            filterFromLocation = locations[3];
    }

    let data = state.app.form.data.modified;
    return {
       // formName : ownProps.formName ? ownProps.formName :  formNameFormLocation,
        filter: filterFromLocation,
        model: state.app.form.models.model,
        data: data === null || data === undefined ? undefined : (Array.isArray(data) ? [...data] : cloneDataObject(data)),
        mainControlFilters: mainControlFiltersOnly,
        errors: state.app.form.errors.main ? state.app.form.errors.main : undefined,
        modals: state.app.form.modals,
        childModels: childModelsOnly,
        childData: childDisplayedData,
        childControlFilters: childControlFiltersOnly,
        childFilters: childFilters,
        childActions: childActions,
        childErrors: childErrors ? childErrors :  undefined,
        hideControls: state.app.form.models.hideControls,
        readOnlyControls: state.app.form.models.readOnlyControls,
        readOnly: state.app.form.models.readOnly,
        customCss: state.app.form.customCss
    }
};

export const mapDispatchToPropsBase = (dispatch, ownProps) => {
    return {
        fetchFlow: (flowName, urlFilter) => {
            dispatch(thunks.form.clear());
            dispatch(thunks.form.fetchflow(flowName, urlFilter))
        },
        fetchForm: (formName) => {
            dispatch(thunks.form.clear());
            dispatch(thunks.form.fetchform(formName))
        },
        fetchFormPreview: (formName) => {
            dispatch(thunks.form.clear());
            dispatch(thunks.form.fetchformpreview(formName))
        },
        fetchData: (filter, urlFilter, formName, index, ischild) => {
            dispatch(thunks.form.fetchdata(filter,urlFilter, formName, index, ischild))
        },
        dataChanged: (key, value, formName, index, ischild, updateDisplayed) => {
            dispatch(actions.app.form.data.update(key, value, formName, index, ischild, updateDisplayed))
        },
        executeActions: (args) => {
            dispatch(thunks.form.executeActions(args))
        },
        additionalFetch: (formNameFunc, controlRef, {startIndex, pageSize, filters, sort, model}, callback) => {
            dispatch(thunks.additional.fetch({
                    type: controlRef.props["data-buildertype"],
                    formName: formNameFunc(),
                    controlRef,
                    startIndex,
                    pageSize,
                    filters,
                    sort,
                    callback
                }
            ));
        }
    }
};

const mapStateToProps = (state, ownProps) => {
    const props = mapStateToPropsBase(state,ownProps);
    let formNameFormLocation = null;
    if ( state.router.location)
    {
        let locations = state.router.location.pathname.split("/");
        if (locations.length > 2 && locations[1].toLowerCase() === store.getState().settings.form)
            formNameFormLocation = locations[2];
    }
    return {
        ...props,
        formName : ownProps.formName ? ownProps.formName :  formNameFormLocation
    }
};

export default connect(mapStateToProps, mapDispatchToPropsBase)(FormContent)
