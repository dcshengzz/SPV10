import React from 'react';
import ReactDOM from 'react-dom';
import CloverStore from './store';
import CloverFormControls from './controls';
import Timeout from './timeout';
import JSON5 from 'json5';

export default class CloverForm extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            data: props.data,
            model: props.model,
            extendedData: props.extendedData,
            controlsToReplace: null
        };
       // this.controlsToReplace = null;

        this.checkLoadedState(this.state.data, this.state.model);
    }

    static getDerivedStateFromProps(nextProps, prevState) {
        const stateDelta = {};
        if (nextProps.modelurl !== undefined && nextProps.modelurl !== "" && nextProps.modelurl !== prevState.modelurl) {
            stateDelta.modelurl = nextProps.modelurl;
            stateDelta.needFetchModel = true;
        }
        //TODO add json equal?
        if (nextProps.model !== undefined && nextProps.model !== prevState.model) {
            stateDelta.controlsToReplace = null;
            stateDelta.model = nextProps.model;
        }

        if (nextProps.dataurl !== undefined && nextProps.dataurl !== "" && nextProps.dataurl !== prevState.dataurl) {
            stateDelta.dataurl = nextProps.dataurl;
            stateDelta.needFetchData = true;
        }
        if (nextProps.data !== undefined) {
            stateDelta.data = nextProps.data;
        }

        return stateDelta;
    }

    _asyncGetData = null;
    _asyncGetModel = null;

    componentDidMount() {
        this.PrepareState();
    }

    componentDidUpdate(prevProps, prevState) {
        this.PrepareState();
    }

    componentWillUnmount() {
        if (this._asyncGetData) {
            this._asyncGetData.abort();
        }
        if (this._asyncGetModel) {
            this._asyncGetModel.abort();
        }
    }

    PrepareState() {
        let me = this;
        if (this.state.needFetchModel) {
            me.setState({needFetchModel: false});
            this._asyncGetModel = $.getJSON(this.state.modelurl)
                .done(function (data) {
                    me._asyncGetModel = null;
                    me.modelChanged(data);
                })
                .fail(function (jqxhr, textStatus, error) {
                    me._asyncGetModel = null;
                    const err = textStatus + ", " + error;
                    me.handleErrEvent(err);
                });
        }

        if (this.state.needFetchData) {
            me.setState({needFetchData: false});
            this._asyncGetData = $.getJSON(this.state.dataurl)
                .done(function (data) {
                    me._asyncGetData = null;
                    me.dataChanged(data);
                })
                .fail(function (jqxhr, textStatus, error) {
                    me._asyncGetData = null;
                    const err = textStatus + ", " + error;
                    me.handleErrEvent(err);
                });
        }


        this.checkConditions(this.state.model);
        this.checkLoadedState(this.state.data, this.state.model);
    }

    modelChanged(model) {
        this.setState({
            model: model,
            controlsToReplace: null
        });

        this.checkConditions(model)
    }

    dataChanged(data) {
        this.setState({
            data: data
        });

        this.checkLoadedState(data, this.state.model);
    }

    checkLoadedState(data, model) {
        if (!this.state.isLoaded && data !== undefined && data !== null && model !== undefined && model !== null) {
            this.setState({isLoaded: true});
            this.props.eventFunc({
                key: undefined,
                controlRef: this,
                formName: this.props.formName,
                component: this,
                eventName: "init",
                actions: ["initSystem", "init"],
                parameters: undefined
            });


        }
    }

    handleEvent({e, key, eventName, parameters, name, value}) {
        const me = this;
        const isOnchange = eventName === "onChange";
        if (isOnchange) {
            if (!Boolean(this.props.onlyExternalDataChanged)) {
                if (this.state.data === undefined) {
                    this.state.data = {};
                }
                var data = this.state.data;
                data[key] = value;
                this.setState({data: data});
            }

            if (this.props.dataChanged !== undefined)
                this.props.dataChanged(this, {key, value});

            this.onConditions(key, eventName, parameters, name, value);
        }

        if (this.props.eventFunc === undefined)
            return;

        var item = this.findModelItembyKey(key);
        if (item === undefined)
            return;

        if (item.events !== undefined &&
            item.events[eventName] !== undefined &&
            item.events[eventName].active) {
            var event = item.events[eventName];

            var eventParameters = {...parameters};
            if (Array.isArray(event.parameters) && event.parameters.length > 0) {
                event.parameters.forEach(function (p) {
                    eventParameters[p.name] = p.value;
                });
            }
            const sourceControl = me.refs[key];
            const sourceControlValue = value;
            let fireEvent;
            if (Array.isArray(event.targets) && event.targets.length > 0) {

                fireEvent = () => event.targets.forEach(function (t) {
                    me.props.eventFunc({
                        key: t,
                        sourceControlRef: sourceControl,
                        sourceControlValue: sourceControlValue,
                        controlRef: me.refs[t],
                        formName: me.props.formName,
                        component: me,
                        eventName: eventName,
                        actions: event.actions,
                        parameters: eventParameters
                    });
                });

            }
            else {
                fireEvent = () => me.props.eventFunc({
                    key: key,
                    sourceControlRef: sourceControl,
                    sourceControlValue: sourceControlValue,
                    controlRef: sourceControl,
                    formName: me.props.formName,
                    component: me,
                    eventName: eventName,
                    actions: event.actions,
                    parameters: eventParameters
                });
            }
            if (!isOnchange
                || item.onChangeTimeout === undefined || item.onChangeTimeout === ""
                || Number(item.onChangeTimeout) < 1) {
                fireEvent();
            }
            else {
                Timeout.Set(key, fireEvent, Number(item.onChangeTimeout));
            }
        }
    }

    checkConditions(model, child) {
        var enableCheckConditions = false;
       
        if (Array.isArray(model)) {
            for (var i = 0; i < model.length; i++) {
                if ((model[i]["other-visibleConition"] !== undefined && model[i]["other-visibleConition"] !== "") ||
                    (model[i]["other-readOnlyConition"] !== undefined && model[i]["other-readOnlyConition"] !== "")) {
                    enableCheckConditions = true;
                }

                else if (Array.isArray(model[i].children)) {
                    enableCheckConditions = this.checkConditions(model[i].children, true);
                }

                if (enableCheckConditions)
                    break;
            }
        }

        if (child) {
            return enableCheckConditions;
        }

        this.state.enableCheckConditions = enableCheckConditions;
    }

    onConditions(key, eventName, parameters, name, value) {
  
        if (this.state.enableCheckConditions) {
            this.props.eventFunc({
                key: key,
                controlRef: this.refs[key],
                formName: this.props.formName,
                component: this,
                eventName: eventName,
                actions: ["checkConditions"],
                parameters: parameters
            });
        }
    }

    handleErrEvent(message) {
        if (this.props.eventErrFunc) {
            this.props.eventErrFunc(this, message);
        }
    }

    findModelItembyKey(key, array, deepSearch) {
        if (array === undefined) {
            array = this.state.model;
        }

        for (var i = 0; i < array.length; i++) {
            if (array[i].key === key)
                return array[i];

            if (array[i].children !== undefined) {
                var item = this.findModelItembyKey(key, array[i].children);
                if (item !== undefined)
                    return item;
            }

            if (array[i].placeholders !== undefined) {
                for(let ph in array[i].placeholders){
                    var item = this.findModelItembyKey(key, array[i].placeholders[ph]);
                    if (item !== undefined)
                        return item;
                }
            }
            if(array[i]["data-buildertype"] == "customblock" && array[i].sourceType == "source" && array[i].source != undefined){
                var children = JSON5.parse(array[i].source);
                var item = this.findModelItembyKey(key, children);
                if (item !== undefined)
                    return item;
            }
        }
        return undefined;
    }

    render() {
        let controlsToReplace = [];
        let needCheckReplace = false;
        
        if (this.state.model !== null && this.state.model !== undefined) {
            controlsToReplace = this.state.controlsToReplace === null ? [] : this.state.controlsToReplace;
            needCheckReplace = this.state.controlsToReplace === null;
        }

        let items = CloverFormControls.createControls(this,
            {
                model: this.state.model,
                data: this.state.data,
                errors: this.props.errors,
                handleEvent: this.handleEvent.bind(this),
                getFormFunc: this.props.getFormFunc,
                getAdditionalDataForControl: this.props.getAdditionalDataForControl,
                hideControls: this.props.hideControls,
                readOnlyControls: this.props.readOnlyControls,
                readOnly: this.props.readOnly,
                uploadUrl: this.props.uploadUrl,
                downloadUrl: this.props.downloadUrl,
                extendedData: this.props.extendedData,
                controlsToReplace: controlsToReplace,
                needCheckReplace: needCheckReplace
            }
        );

        if (needCheckReplace) {
           this.setState({controlsToReplace:controlsToReplace});
        }

        const className = "clover-form" + (this.props.className === undefined ?
            "" :
            (" " + this.props.className));
        return (
            <div className={className}>
                {this.props.customCss && (<style>{this.props.customCss}</style>)}
                {items}
            </div>
        )
    }
}