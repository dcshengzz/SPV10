(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory(require("react"), require("semantic-ui-react"), require("json5"), require("react-dom"), require("reflux"), require("moment"), require("react-datepicker"), require("react-data-grid"), require("react-dropzone-component"));
	else if(typeof define === 'function' && define.amd)
		define(["react", "semantic-ui-react", "json5", "react-dom", "reflux", "moment", "react-datepicker", "react-data-grid", "react-dropzone-component"], factory);
	else if(typeof exports === 'object')
		exports["swz-builder"] = factory(require("react"), require("semantic-ui-react"), require("json5"), require("react-dom"), require("reflux"), require("moment"), require("react-datepicker"), require("react-data-grid"), require("react-dropzone-component"));
	else
		root["swz-builder"] = factory(root["react"], root["semantic-ui-react"], root["json5"], root["react-dom"], root["reflux"], root["moment"], root["react-datepicker"], root["react-data-grid"], root["react-dropzone-component"]);
})(typeof self !== 'undefined' ? self : this, function(__WEBPACK_EXTERNAL_MODULE_0__, __WEBPACK_EXTERNAL_MODULE_1__, __WEBPACK_EXTERNAL_MODULE_2__, __WEBPACK_EXTERNAL_MODULE_6__, __WEBPACK_EXTERNAL_MODULE_8__, __WEBPACK_EXTERNAL_MODULE_12__, __WEBPACK_EXTERNAL_MODULE_18__, __WEBPACK_EXTERNAL_MODULE_22__, __WEBPACK_EXTERNAL_MODULE_32__) {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 15);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports) {

module.exports = __WEBPACK_EXTERNAL_MODULE_0__;

/***/ }),
/* 1 */
/***/ (function(module, exports) {

module.exports = __WEBPACK_EXTERNAL_MODULE_1__;

/***/ }),
/* 2 */
/***/ (function(module, exports) {

module.exports = __WEBPACK_EXTERNAL_MODULE_2__;

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var Reflux = __webpack_require__(8);

var BuilderActions = Reflux.createActions(['add', 'showEditForm', 'remove', 'saveData', 'save', 'move']);

module.exports = BuilderActions;

/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _editformControls = __webpack_require__(9);

var _radiogroup = __webpack_require__(13);

var _radiogroup2 = _interopRequireDefault(_radiogroup);

var _menugroup = __webpack_require__(20);

var _menugroup2 = _interopRequireDefault(_menugroup);

var _json = __webpack_require__(2);

var _json2 = _interopRequireDefault(_json);

var _gridview = __webpack_require__(21);

var _gridview2 = _interopRequireDefault(_gridview);

var _chartview = __webpack_require__(23);

var _chartview2 = _interopRequireDefault(_chartview);

var _workflowbar = __webpack_require__(24);

var _workflowbar2 = _interopRequireDefault(_workflowbar);

var _dictionary = __webpack_require__(25);

var _dictionary2 = _interopRequireDefault(_dictionary);

var _container = __webpack_require__(26);

var _container2 = _interopRequireDefault(_container);

var _staticcontent = __webpack_require__(27);

var _staticcontent2 = _interopRequireDefault(_staticcontent);

var _collectioneditor = __webpack_require__(7);

var _collectioneditor2 = _interopRequireDefault(_collectioneditor);

var _controlbar = __webpack_require__(28);

var _controlbar2 = _interopRequireDefault(_controlbar);

var _dropdowntrigger = __webpack_require__(29);

var _dropdowntrigger2 = _interopRequireDefault(_dropdowntrigger);

var _semanticcontrol = __webpack_require__(30);

var _semanticcontrol2 = _interopRequireDefault(_semanticcontrol);

var _dropzone = __webpack_require__(31);

var _dropzone2 = _interopRequireDefault(_dropzone);

var _functionalfilter = __webpack_require__(14);

var _search = __webpack_require__(33);

var _search2 = _interopRequireDefault(_search);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

//------CloverFormControls-----------
var CloverFormControls = {
    Items: [{ key: "sepContainers", title: 'Containers', isseparate: true, defaultopen: true }, { key: "container", title: 'DIV', control: _container2.default, editControl: _editformControls.ContainerEditControl }, { key: "form", title: 'Form', control: _semanticcontrol2.default, editControl: _editformControls.FormEditControl }, {
        key: "formgroup",
        title: 'Form Group',
        control: _semanticcontrol2.default,
        editControl: _editformControls.FormGroupEditControl,
        defaultValues: { widths: "equal" }
    }, {
        key: "menu", title: 'Menu', control: _menugroup2.default, editControl: _editformControls.MenuEditControl,
        defaultValues: {
            items: [{ target: 'menu1', title: 'Menu 1' }, { target: 'menu2', title: 'Menu 2' }, { target: 'menu3', title: 'Menu 3' }]
        }
    }, {
        key: "workflowbar",
        title: 'Workflow bar',
        control: _workflowbar2.default,
        editControl: _editformControls.WorkflowBarEditControl,
        defaultValues: {
            events: {
                onCommandClick: { active: true, actions: ["workflowExecuteCommand"] },
                onSetStateClick: { active: true, actions: ["workflowSetState"] }
            }
        }
    }, {
        key: "customblock",
        title: 'Custom block',
        control: undefined,
        editControl: _editformControls.CustomBlockEditControl,
        defaultValues: { sourceType: 'form' }
    }, { key: "sepCollection", title: 'Collections', isseparate: true }, {
        key: "gridview", title: 'GridView', control: _gridview2.default, editControl: _editformControls.GridEditControl, defaultValues: {
            columns: [{ key: 'id', name: 'ID' }, { key: 'title', name: 'Title' }, { key: 'count', name: 'Count' }]
        }
    }, {
        key: "collectioneditor",
        title: 'Collection Editor',
        control: _collectioneditor2.default,
        editControl: _editformControls.CollectionEditorEditControl,
        defaultValues: {
            idField: "Id",
            parentIdField: "ParentId",
            columns: [{ key: 'Id', name: 'ID' }, { key: 'Title', name: 'Title' }, { key: 'Count', name: 'Count' }]
        }
    }, { key: "sepControls", title: 'Controls', isseparate: true }, {
        key: "header",
        title: 'Header',
        control: _semanticcontrol2.default,
        editControl: _editformControls.HeaderEditControl,
        defaultValues: { content: "Header", size: "medium" }
    }, {
        key: "input",
        title: 'Input',
        control: _semanticcontrol2.default,
        editControl: _editformControls.InputEditControl,
        defaultValues: { label: "Input", fluid: true, onChangeTimeout: 200 }
    }, {
        key: "textarea",
        title: 'TextArea',
        control: _semanticcontrol2.default,
        editControl: _editformControls.TextAreaEditControl,
        defaultValues: { label: "TextArea", fluid: true }
    }, {
        key: "dictionary",
        title: 'Dictionary',
        control: _dictionary2.default,
        editControl: _editformControls.DictionaryEditControl,
        defaultValues: { label: "Dictionary", fluid: true, selection: true }
    }, {
        key: "dropdown",
        title: 'Dropdown',
        control: _semanticcontrol2.default,
        editControl: _editformControls.DropdownEditControl,
        defaultValues: {
            label: "Dropdown", fluid: true, selection: true,
            "data-elements": [{ key: 1, value: 1, text: 'Item 1' }, { key: 2, value: 2, text: 'Item 2' }, { key: 3, value: 3, text: 'Item 3' }]
        }
    }, {
        key: "checkbox",
        title: 'CheckBox',
        control: _semanticcontrol2.default,
        editControl: _editformControls.CheckboxEditControl,
        defaultValues: { label: "Checkbox" }
    }, {
        key: "radiogroup",
        title: 'Radio group',
        control: _radiogroup2.default,
        editControl: _editformControls.RadioGroupEditControl,
        defaultValues: {
            label: "Radio",
            "data-elements": [{ key: 1, value: 1, text: 'Item 1' }, { key: 2, value: 2, text: 'Item 2' }, { key: 3, value: 3, text: 'Item 3' }]
        }
    }, {
        key: "button",
        title: 'Button',
        control: _semanticcontrol2.default,
        editControl: _editformControls.ButtonEditControl,
        defaultValues: { content: "Button" }
    }, {
        key: "label",
        title: 'Label',
        control: _semanticcontrol2.default,
        editControl: _editformControls.LabelEditControl,
        defaultValues: { content: "Label" }
    }, {
        key: "message",
        title: 'Message',
        control: _semanticcontrol2.default,
        editControl: _editformControls.MessageEditControl,
        defaultValues: { header: "Message", content: "Description..." }
    }, {
        key: "image",
        title: 'Image',
        control: _semanticcontrol2.default,
        editControl: _editformControls.ImageEditControl,
        defaultValues: { src: '/images/unknown.png' }
    }, {
        key: "statistic", title: 'Statistic', control: _semanticcontrol2.default, editControl: _editformControls.StatisticEditControl,
        defaultValues: {
            "data-elements": [{ label: 'Score', value: '22,1%' }, { label: 'Views', value: '30,000' }, { label: 'Points', value: '500' }]
        }
    }, {
        key: "customcontrol",
        title: 'Custom control',
        control: undefined,
        editControl: _editformControls.CustomEditControl,
        defaultValues: { props: "{  }" }
    }, {
        key: "staticcontent",
        title: 'Static Content',
        control: _staticcontent2.default,
        editControl: _editformControls.StaticContentEditControl,
        defaultValues: { content: "Text..." }
    }, {
        key: "dropdowntrigger",
        title: 'Dropdown trigger',
        control: _dropdowntrigger2.default,
        editControl: _editformControls.DropdownTriggerEditControl,
        defaultValues: {
            defaultValue: "User",
            items: [{ target: '#1', title: 'Item 1' }, { target: '#2', title: 'Item 2' }, { target: '#3', title: 'Item 3' }]
        }
    }, {
        key: "dropzonecontrol",
        title: 'Dropzone',
        control: _dropzone2.default,
        editControl: _editformControls.DropzoneEditControl,
        defaultValues: {
            showFiletypeIcon: false,
            autoProcessQueue: true,
            addRemoveLinks: true,
            multile: true
        }
    }, {
        key: "breadcrumb",
        title: 'Breadcrumbs',
        control: _semanticcontrol2.default,
        editControl: _editformControls.BreadcrumbEditControl,
        defaultValues: {
            items: [{ "text": "Home", "url": "/" }, { "divider": "right angle", "text": "Page1", "url": "/page1" }, { "text": "Page2", "active": true }],
            events: {
                onItemClick: { active: true, actions: ["redirect"] }
            }
        }
    }, {
        key: "search",
        title: 'Search',
        control: _search2.default,
        editControl: _editformControls.SearchEditControl,
        defaultValues: {}
    }, { key: "sepCharts", title: 'Charts', isseparate: true }, {
        key: "barchart",
        title: 'Bar',
        control: _chartview2.default,
        editControl: _editformControls.ChartEditControl,
        defaultValues: { chartType: "bar", datasetLabel: "" }
    }, {
        key: "linechart",
        title: 'Line',
        control: _chartview2.default,
        editControl: _editformControls.ChartEditControl,
        defaultValues: { chartType: "line", datasetLabel: "" }
    }, {
        key: "scatterchart",
        title: 'Scatter',
        control: _chartview2.default,
        editControl: _editformControls.ChartEditControl,
        defaultValues: { chartType: "scatter", datasetLabel: "" }
    }, {
        key: "doughnutchart",
        title: 'Doughnut',
        control: _chartview2.default,
        editControl: _editformControls.ChartEditControl,
        defaultValues: { chartType: "doughnut", datasetLabel: "" }
    }, {
        key: "piechart",
        title: 'Pie',
        control: _chartview2.default,
        editControl: _editformControls.ChartEditControl,
        defaultValues: { chartType: "pie", datasetLabel: "" }
    }, {
        key: "radarchart",
        title: 'Radar',
        control: _chartview2.default,
        editControl: _editformControls.ChartEditControl,
        defaultValues: { chartType: "radar", datasetLabel: "" }
    }],

    createControls: function createControls(parentComponent, _ref) {
        var model = _ref.model,
            data = _ref.data,
            errors = _ref.errors,
            eventOnEdit = _ref.eventOnEdit,
            eventOnDelete = _ref.eventOnDelete,
            eventOnCopy = _ref.eventOnCopy,
            handleEvent = _ref.handleEvent,
            parentItem = _ref.parentItem,
            getFormFunc = _ref.getFormFunc,
            getAdditionalDataForControl = _ref.getAdditionalDataForControl,
            buildermode = _ref.buildermode,
            hideControls = _ref.hideControls,
            readOnlyControls = _ref.readOnlyControls,
            readOnly = _ref.readOnly,
            disableRefs = _ref.disableRefs,
            uploadUrl = _ref.uploadUrl,
            downloadUrl = _ref.downloadUrl,
            extendedData = _ref.extendedData,
            controlsToReplace = _ref.controlsToReplace,
            needCheckReplace = _ref.needCheckReplace,
            parentPlaceholder = _ref.parentPlaceholder,
            formItem = _ref.formItem,
            controlBarRight = _ref.controlBarRight;


        var res = [];
        if (model === null || model === undefined) return res;

        for (var i = 0; i < model.length; i++) {
            if (Array.isArray(hideControls) && hideControls.includes(model[i].key)) {
                continue;
            }

            var item = void 0;
            var dbtype = model[i]["data-buildertype"];
            if (dbtype === "customcontrol") {
                if (model[i].type === undefined || model[i].type === "") {
                    item = _react2.default.createElement(
                        'div',
                        { className: 'clover-formbuilder-empty', key: model[i].key },
                        'Fill Type property for rendering the control.'
                    );
                } else {
                    var controlPropsInit = model[i].props === undefined ? {} : _json2.default.parse(model[i].props);
                    var controlProps = _extends({}, controlPropsInit, {
                        key: model[i].key,
                        name: model[i].key,
                        className: model[i]["style-customcss"],
                        style: this.getStyle(model[i], buildermode),
                        "data-buildertype": model[i]["data-buildertype"],
                        getAdditionalDataForControl: getAdditionalDataForControl,
                        uploadUrl: uploadUrl, downloadUrl: downloadUrl
                    });

                    if (readOnly || Array.isArray(readOnlyControls) && readOnlyControls.includes(controlProps.key)) controlProps.readOnly = true;

                    var children = model[i].children;
                    if (model[i].children !== undefined) {
                        try {
                            children = _json2.default.parse(model[i].children);
                        } catch (e) {}
                    }

                    if (children === undefined || Array.isArray(children) && children.length === 0) {
                        item = _react2.default.createElement(model[i].type, controlProps);
                    } else {
                        item = _react2.default.createElement(model[i].type, controlProps, children);
                    }
                }
            } else if (dbtype === "customblock") {
                var children_source = [];
                var renderempty = false;
                var cbbuildermode = false;
                var addDropZones = false;
                var newParentItem = model[i];
                var newParentPlaceholder = parentPlaceholder;
                var newFormItem = formItem;

                if (model[i].sourceType === 'form' || model[i].sourceType === undefined) {
                    if (model[i].children !== undefined && model[i].children !== "") {
                        children_source = model[i].children;
                    } else {
                        if (getFormFunc === undefined) {
                            console.error('Error: "getFormFunc" parameter is undefined!. Please, set "getFormFunc" parameter for CloverBuilder or CloverForm!');
                            continue;
                        }

                        if (model[i].formname !== undefined && model[i].formname !== "") {
                            children_source = getFormFunc(model[i].formname);
                        } else {
                            renderempty = true;
                        }
                    }
                } else if (model[i].sourceType === 'placeholder') {
                    cbbuildermode = eventOnEdit !== undefined;
                    addDropZones = eventOnEdit !== undefined;
                    newParentItem = parentItem;

                    if (newParentPlaceholder === undefined) newParentPlaceholder = model[i];

                    if (newFormItem === undefined) {
                        newFormItem = parentItem;
                    }

                    if (newFormItem !== undefined && newFormItem.placeholders !== undefined && newFormItem.placeholders[model[i].key] !== undefined) {

                        children_source = newFormItem.placeholders[model[i].key];
                    }
                } else {
                    if (model[i].source !== undefined && model[i].source !== "") children_source = _json2.default.parse(model[i].source);else renderempty = true;
                }

                if (renderempty) {
                    item = _react2.default.createElement(
                        'div',
                        { className: 'clover-formbuilder-empty', key: model[i].key },
                        'Set a form name or source in propepries.'
                    );
                } else {
                    var _children = this.createControls(parentComponent, {
                        model: children_source,
                        data: data,
                        errors: errors,
                        buildermode: cbbuildermode,
                        eventOnEdit: eventOnEdit,
                        eventOnDelete: eventOnDelete,
                        eventOnCopy: eventOnCopy,
                        parentItem: newParentItem,
                        handleEvent: handleEvent,
                        getFormFunc: getFormFunc,
                        getAdditionalDataForControl: getAdditionalDataForControl,
                        hideControls: hideControls,
                        readOnlyControls: readOnlyControls,
                        readOnly: readOnly,
                        disableRefs: disableRefs,
                        uploadUrl: uploadUrl, downloadUrl: downloadUrl, controlsToReplace: controlsToReplace, needCheckReplace: needCheckReplace,
                        parentPlaceholder: newParentPlaceholder,
                        formItem: newFormItem
                    });

                    var className = model[i]["style-customcss"];
                    if (buildermode) {
                        className = (className == undefined ? "" : className + " ") + "clover-formbuilder-item-container";
                    }

                    var formProps = {
                        key: model[i].key,
                        name: model[i].key,
                        className: className,
                        style: this.getStyle(model[i], buildermode),
                        "data-buildertype": model[i]["data-buildertype"]
                    };

                    if (addDropZones) {
                        if (_children === undefined) _children = [];

                        if (_children.length > 0) {
                            var dz_footer = CloverFormControls.createBuilderDropzone(model[i].key + "_dropzone_footer", newFormItem === undefined ? undefined : newFormItem.key, //parentItem === undefined ? undefined : parentItem.key,
                            _children[_children.length - 1].key, model[i].key, model[i].key);
                            _children.push(dz_footer);
                        }

                        var dz = CloverFormControls.createBuilderDropzone(model[i].key + "_dropzone_header", newFormItem === undefined ? undefined : newFormItem.key, //parentItem === undefined ? undefined : parentItem.key,
                        undefined, model[i].key, model[i].key);
                        _children.unshift(dz);
                    }

                    item = _react2.default.createElement('div', formProps, _children);
                }
            } else {
                var control = this.getControlByType(dbtype);
                if (control === null) {
                    item = _react2.default.createElement(
                        'div',
                        { key: model[i].key },
                        dbtype,
                        ' is unsupported'
                    );
                } else {
                    if (this.isContainer(dbtype)) {

                        var _newFormItem = formItem;
                        if (_newFormItem == undefined && parentItem != undefined && parentItem.sourceType == "form") {
                            _newFormItem = parentItem;
                        }

                        var isGorizontalGroup = buildermode && model[i]["data-buildertype"] === "formgroup" && model[i].orientation !== "grouped";
                        var _children2 = this.createControls(parentComponent, {
                            model: model[i].children,
                            data: data,
                            errors: errors,
                            buildermode: buildermode,
                            eventOnEdit: eventOnEdit,
                            eventOnDelete: eventOnDelete,
                            eventOnCopy: eventOnCopy,
                            parentItem: model[i],
                            handleEvent: handleEvent,
                            getFormFunc: getFormFunc,
                            getAdditionalDataForControl: getAdditionalDataForControl,
                            hideControls: hideControls,
                            readOnlyControls: readOnlyControls,
                            readOnly: readOnly,
                            disableRefs: disableRefs,
                            uploadUrl: uploadUrl, downloadUrl: downloadUrl, controlsToReplace: controlsToReplace, needCheckReplace: needCheckReplace,
                            parentPlaceholder: undefined,
                            formItem: _newFormItem,
                            controlBarRight: isGorizontalGroup
                        });
                        if (buildermode) {
                            if (_children2.length > 0) {
                                var _textDZ = isGorizontalGroup ? "..." : "... " + model[i].key + " down ...";
                                var dropzone_footer = this.createBuilderDropzone(model[i].key + "-dropzone_footer", model[i].key, undefined, _textDZ);
                                _children2.push(dropzone_footer);
                            }

                            var textDZ = isGorizontalGroup ? "..." : "... " + model[i].key + " up ...";
                            var dropzone_header = this.createBuilderDropzone(model[i].key + "-dropzone_header", model[i].key, undefined, textDZ);
                            _children2.unshift(dropzone_header);
                        }
                        item = this.createControl(parentComponent, control, {
                            model: model[i],
                            data: data,
                            errors: errors,
                            parentItem: parentItem,
                            buildermode: buildermode,
                            children: _children2,
                            handleEvent: handleEvent,
                            getAdditionalDataForControl: getAdditionalDataForControl,
                            readOnlyControls: readOnlyControls,
                            readOnly: readOnly,
                            disableRefs: disableRefs,
                            parentPlaceholder: parentPlaceholder,
                            controlsToReplace: controlsToReplace,
                            needCheckReplace: needCheckReplace,
                            eventOnEdit: eventOnEdit, eventOnDelete: eventOnDelete, eventOnCopy: eventOnCopy
                        });
                    } else {
                        item = this.createControl(parentComponent, control, {
                            model: model[i],
                            data: data,
                            errors: errors,
                            parentItem: parentItem,
                            buildermode: buildermode,
                            handleEvent: handleEvent,
                            getAdditionalDataForControl: getAdditionalDataForControl,
                            readOnlyControls: readOnlyControls,
                            readOnly: readOnly,
                            disableRefs: disableRefs,
                            uploadUrl: uploadUrl,
                            downloadUrl: downloadUrl,
                            extendedData: extendedData,
                            parentPlaceholder: parentPlaceholder,
                            controlsToReplace: controlsToReplace,
                            needCheckReplace: needCheckReplace,
                            eventOnEdit: eventOnEdit, eventOnDelete: eventOnDelete, eventOnCopy: eventOnCopy
                        });
                    }
                }
            }

            if (buildermode) {
                if (i > 0 && i < model.length) {
                    var dropzone_bw = this.createBuilderDropzone(model[i].key + "-dropzone_bw", parentItem === undefined ? undefined : parentItem.key, model[i].key, "...", parentPlaceholder === undefined ? undefined : parentPlaceholder.key);
                    res.push(dropzone_bw);
                }

                var buildercontrol = _react2.default.createElement(_controlbar2.default, { key: model[i].key + "_controlbar",
                    text: model[i]["data-buildertype"],
                    model: model[i], parent: parentComponent,
                    onDelete: eventOnDelete, onEdit: eventOnEdit, onCopy: eventOnCopy,
                    isGroup: model[i]["data-buildertype"] === "formgroup",
                    controlOnRight: controlBarRight });

                if (controlBarRight) {
                    res.push(item);
                    res.push(buildercontrol);
                } else {
                    res.push(buildercontrol);
                    res.push(item);
                }
            } else {
                res.push(item);
            }
        }

        return res;
    },

    getControlByType: function getControlByType(buildertype) {
        var control = undefined;
        for (var i = 0; i < this.Items.length; i++) {
            if (this.Items[i].key === buildertype) {
                control = this.Items[i].control;
                break;
            }
        }
        return control;
    },
    getEditControlByType: function getEditControlByType(buildertype) {
        var control = undefined;
        for (var i = 0; i < this.Items.length; i++) {
            if (this.Items[i].key === buildertype) {
                control = this.Items[i].editControl;
                break;
            }
        }
        return control;
    },

    getStyle: function getStyle(model, buildermode) {
        var style = {
            marginTop: model["style-marginTop"],
            marginBottom: model["style-marginBottom"],
            marginLeft: model["style-marginLeft"],
            marginRight: model["style-marginRight"],
            width: model["style-width"],
            height: model["style-height"]
        };

        if (model["style-float"] !== undefined) {
            style.float = model["style-float"];
        }

        if (model["style-hidden"]) {
            if (buildermode) style.opacity = 0.2;else style.display = "none";
        }

        if (model["style-source"] !== undefined) {
            var properties = model["style-source"].split(';');
            properties.forEach(function (property) {
                var tup = property.split(':');
                if (tup.length === 2) {
                    var p = tup[0].replace(/^\s+|\s+$/g, '');
                    style[p] = tup[1].replace(/^\s+|\s+$/g, '');
                }
            });
        }

        if (model["style-font-size"] !== undefined) {
            style["font-size"] = model["style-font-size"];
        }

        return style;
    },


    regexForReplace: /{\S+}/gm,

    createControl: function createControl(parentComponent, control, _ref2) {
        var model = _ref2.model,
            data = _ref2.data,
            errors = _ref2.errors,
            parentItem = _ref2.parentItem,
            buildermode = _ref2.buildermode,
            children = _ref2.children,
            handleEvent = _ref2.handleEvent,
            getAdditionalDataForControl = _ref2.getAdditionalDataForControl,
            readOnlyControls = _ref2.readOnlyControls,
            readOnly = _ref2.readOnly,
            disableRefs = _ref2.disableRefs,
            uploadUrl = _ref2.uploadUrl,
            downloadUrl = _ref2.downloadUrl,
            extendedData = _ref2.extendedData,
            controlsToReplace = _ref2.controlsToReplace,
            needCheckReplace = _ref2.needCheckReplace,
            eventOnEdit = _ref2.eventOnEdit,
            eventOnDelete = _ref2.eventOnDelete,
            eventOnCopy = _ref2.eventOnCopy;


        var obj = void 0;
        var i = void 0;
        var res = undefined;
        var props = {
            key: model.key,
            name: model.key,
            className: model["style-customcss"],
            style: this.getStyle(model, buildermode),
            "data-buildertype": model["data-buildertype"]
        };
        var dataBuilderType = props["data-buildertype"];
        var needReplace = needCheckReplace || controlsToReplace.includes(model.key);

        if (buildermode && this.isContainer(props["data-buildertype"])) {
            props.className = (props.className == undefined ? "" : props.className + " ") + "clover-formbuilder-item-container";
        }

        if (!disableRefs) {
            props.ref = model.key;
        }

        if (model.readOnly !== undefined) {
            props.readOnly = model.readOnly;
        }

        if (readOnly || Array.isArray(readOnlyControls) && readOnlyControls.includes(model.key)) {
            props.readOnly = true;
        }
        var regexForReplace = this.regexForReplace;
        var replaceControlValue = function replaceControlValue(originalValue) {
            if (!needReplace || originalValue === undefined || originalValue === null) return originalValue;
            var replaceFromData = function replaceFromData(m) {
                if (data === undefined || data === null) return "";
                var value = data[m.slice(1, m.length - 1)];
                if (value === null || value === undefined) return "";
                return value;
            };
            if (Array.isArray(originalValue)) {
                var newValue = [];
                var needPushKey = false;
                originalValue.forEach(function (v) {
                    var newV = {};
                    for (var p in v) {
                        if (v.hasOwnProperty(p)) {
                            if (v[p] !== undefined && v[p] !== null && typeof v[p] === "string") {
                                newV[p] = v[p].replace(regexForReplace, function (m) {
                                    return replaceFromData(m);
                                });
                                if (!needPushKey && needCheckReplace && newV[p] !== v[p]) needPushKey = true;
                            } else if (Array.isArray(v[p])) {
                                newV[p] = replaceControlValue(v[p]);
                            } else {
                                newV[p] = v[p];
                            }
                        }
                    }
                    newValue.push(newV);
                });
                if (needPushKey) controlsToReplace.push(model.key);
                return newValue;
            } else {
                if (typeof originalValue !== "string") return originalValue;
                var _newValue = originalValue.replace(regexForReplace, function (m) {
                    return replaceFromData(m);
                });
                if (needCheckReplace && originalValue !== _newValue) {
                    controlsToReplace.push(model.key);
                }
                return _newValue;
            }
        };

        if (control === _semanticcontrol2.default) {
            if (dataBuilderType === "header") {
                props.content = replaceControlValue(model.content);
                props.subheader = replaceControlValue(model.subheader);
            } else if (dataBuilderType === "label") {
                props.content = replaceControlValue(model.content);
            } else if (dataBuilderType === "message") {
                props.content = replaceControlValue(model.content);
                props.header = replaceControlValue(model.header);
            } else if (dataBuilderType === "image") {
                props.src = replaceControlValue(model.src);
                props.href = replaceControlValue(model.href);
            } else if (dataBuilderType === "breadcrumb") {
                props.items = replaceControlValue(model.items);
            }

            res = _react2.default.createElement(_semanticcontrol2.default, _extends({}, props, { additionalParams: {
                    model: model, data: data, errors: errors, children: children, handleEvent: handleEvent, parentItem: parentItem, uploadUrl: uploadUrl, downloadUrl: downloadUrl
                } }));
        } else if (control === _dictionary2.default) {
            props.label = model.label;
            props.defaultValue = model.defaultvalue;
            props.placeholder = model.placeholder;
            props.loading = model.loading;
            props.error = model.error;
            props.disabled = model.disabled;
            props.fluid = model.fluid;
            props.selection = model.selection;
            props.multiple = model.multiple;
            props.search = model.search;
            props.dataModel = model.dataModel;
            props.clearable = model.clearable;
            props.columns = model.columns;
            props.paging = model.paging;
            props.pageSize = model.pageSize;
            props.getAdditionalDataForControl = getAdditionalDataForControl;

            if ((typeof errors === 'undefined' ? 'undefined' : _typeof(errors)) === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }

            if (handleEvent !== null) {
                props.onChange = function (e, _ref3) {
                    var name = _ref3.name,
                        value = _ref3.value;

                    handleEvent({ syntheticEvent: e, key: props.key, eventName: "onChange", name: name, value: value });
                };
            }
            props.parentIsForm = this.isForm(parentItem);

            if (data !== undefined) props.value = data[props.key];

            res = _react2.default.createElement(_dictionary2.default, props);
        } else if (control === _dropdowntrigger2.default) {
            props.defaultValue = model.defaultValue;
            props.items = model.items;
            props.imageUrl = model.imageUrl;
            props.handleEvent = handleEvent;

            if (data !== undefined) props.value = data[props.key];

            res = _react2.default.createElement(_dropdowntrigger2.default, props);
        } else if (control === _search2.default) {
            props.url = model.url;
            props.category = model.category;
            props.handleEvent = handleEvent;

            if (data !== undefined) props.value = data[props.key];

            res = _react2.default.createElement(_search2.default, props);
        } else if (control === _radiogroup2.default) {
            var items = [];
            if (model["data-elements"] !== undefined) {
                if (Array.isArray(model["data-elements"])) {
                    items = model["data-elements"];
                } else {
                    items = _json2.default.parse(model["data-elements"]);
                }
            }

            if (handleEvent !== null) {
                props.onChange = function (e, _ref4) {
                    var name = _ref4.name,
                        value = _ref4.value;

                    handleEvent({ syntheticEvent: e, key: props.key, eventName: "onChange", name: name, value: value });
                };
            }

            if ((typeof errors === 'undefined' ? 'undefined' : _typeof(errors)) === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }

            if (data !== undefined) props.value = data[props.key];

            res = _react2.default.createElement(_radiogroup2.default, _extends({}, props, {
                label: model.label,
                direction: model.direction,
                placeholder: model.placeholder,
                items: items }));
        } else if (control === _collectioneditor2.default) {
            props.columns = model.columns;
            props.draggable = model.draggable;
            props.hierarchical = model.hierarchical;
            props.parentIdField = model.parentIdField;
            props.idField = model.idField;
            props.childrenField = model.childrenField;
            props.collapseAll = model.collapseAll;
            props.disableAdd = model.disableAdd;
            props.placeholders = model.placeholders;
            if (props.placeholders != undefined) {
                props.getAdditionalDataForControl = getAdditionalDataForControl;
                props.createControl = function (parentControl, databuildertype, parameters) {
                    var control = CloverFormControls.getControlByType(databuildertype);
                    if (control == undefined) {
                        console.error("Control is unsupported!", databuildertype, parentControl, parameters);
                        return;
                    }

                    var item = CloverFormControls.createControl(parentControl, control, parameters);
                    var res = [];
                    if (parameters.buildermode) {
                        var buildercontrol = _react2.default.createElement(_controlbar2.default, { key: parameters.model.key + "_controlbar",
                            model: parameters.model, parent: parentComponent,
                            onDelete: eventOnDelete, onEdit: eventOnEdit, onCopy: eventOnCopy });
                        res.push(buildercontrol);
                        res.push(item);
                        return res;
                    }
                    return item;
                };
            }
            props.handleEvent = handleEvent;
            props.downloadUrl = downloadUrl;
            props.uploadUrl = uploadUrl;
            if (handleEvent !== null) {
                props.onChange = function (e, _ref5) {
                    var name = _ref5.name,
                        value = _ref5.value;

                    handleEvent({ syntheticEvent: e, key: props.key, eventName: "onChange", name: name, value: value });
                };
            } else if (buildermode) {
                props.onChange = function (e, _ref6) {
                    var name = _ref6.name,
                        value = _ref6.value;

                    props.value = value;
                };
            }

            if (data !== undefined) props.value = data[props.key];

            if (errors !== undefined) props.error = errors[props.key];

            if (buildermode && props.value === undefined && props.columns !== undefined) {
                props.buildermode = buildermode;
                props.createBuilderDropzone = function (columnName, value) {
                    return CloverFormControls.createBuilderDropzone(props.key, props.key, undefined, columnName, columnName);
                };
                props.value = [];
                for (i = 0; i < 5; i++) {
                    props.value.push({});
                }

                if (Boolean(model.hierarchical) && model.parentIdField !== undefined && model.parentIdField !== "" && model.idField !== undefined && model.idField !== "") {
                    for (i = 1; i < 5; i++) {
                        var parent = props.value[i];
                        if (parent[model.idField] === undefined) {
                            parent[model.idField] = i;
                        }

                        for (var j = 0; j < 2; j++) {
                            var child = {};
                            child[model.parentIdField] = parent[model.idField];
                            props.value.push(child);
                        }
                    }
                }
            }

            res = _react2.default.createElement(_collectioneditor2.default, props);
        } else if (control === _gridview2.default) {
            props.columns = model.columns;
            props.multiselect = model.multiselect;
            props.rowKey = model.rowKey;
            props.editForm = model.editForm;
            props.editFlow = model.editFlow;
            props.editType = model.editType;
            props.pagerType = model.pagerType;
            props.pageSize = model.pageSize;
            props.rowHeight = model.rowHeight;
            props.minHeight = model.minHeight;
            props.autoHeight = model.autoHeight;
            props.offSet = model.offSet;
            props.disableSort = model.disableSort;
            props.resizeColumns = model.resizeColumns;
            props.editFormShowType = model.editFormShowType;
            props.getAdditionalDataForControl = getAdditionalDataForControl;
            props.handleEvent = handleEvent;
            props.defaultSort = model.defaultSort;

            if ((typeof errors === 'undefined' ? 'undefined' : _typeof(errors)) === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }

            if (data !== undefined) props.value = data[props.key];

            if (buildermode && props.value === undefined) {
                props.value = [];

                var _loop = function _loop() {
                    var obj = {};
                    props.columns.forEach(function (c) {
                        obj[c.key] = c.key + "_" + i;
                    });
                    props.value.push(obj);
                };

                for (i = 0; i < 30; i++) {
                    _loop();
                }
            }
            if (extendedData !== undefined && extendedData.filters !== undefined && extendedData.filters[props.key] !== undefined) {
                props.filter = new _functionalfilter.FunctionalFilter(extendedData.filters[props.key], props.columns.map(function (c) {
                    return c.key;
                }));
            }
            res = _react2.default.createElement(_gridview2.default, props);
        } else if (control === _menugroup2.default) {
            props["data-items"] = replaceControlValue(model.items);
            props.pointing = model.pointing;
            props.secondary = model.secondary;
            props.tabular = model.tabular;
            props.fluid = model.fluid;
            props.vertical = model.vertical;
            props.activeitem = model.activeitem;
            props.link = model.link;
            props.handleEvent = handleEvent;

            if (data !== undefined) props.value = data[props.key];

            res = _react2.default.createElement(_menugroup2.default, props);
        } else if (control === _chartview2.default) {
            props.chartType = model.chartType;
            props.responsive = model.responsive;
            props.legendPosition = model.legendPosition;
            props.title = model.title;
            props.titleSize = model.titleSize;
            props.datasetCustom = model.datasetCustom;
            props.dataLabels = model.dataLabels;
            props.datasetLabel = model.datasetLabel;
            props.datasetSteppedLine = model.datasetSteppedLine;
            props.datasetBorderColor = model.datasetBorderColor;
            props.datasetFill = model.datasetFill;
            props.datasetBorderWidth = model.datasetBorderWidth;
            props.datasetBackgroundColor = model.datasetBackgroundColor;

            if (buildermode) {
                if (props.datasetCustom) {
                    props.value = [1, 2, 3, 4, 3, 2, 1];
                } else {

                    var testData = props.chartType !== "scatter" ? [6, 23, 15, 3] : [{ x: 6, y: -12 }, { x: 11, y: 1 }, { x: 24, y: 5 }, { x: 40, y: 32 }];

                    props.value = {
                        labels: ["Q1", "Q2", "Q3", "Q4"],
                        datasets: [{
                            data: testData
                        }]
                    };
                }
            } else {
                if (data !== undefined) props.value = data[props.key];
            }

            res = _react2.default.createElement(_chartview2.default, props);
        } else if (control === _workflowbar2.default) {
            props.blockSetState = model.blockSetState;
            props.setStateButton = model.setStateButton;
            props.handleEvent = handleEvent;
            props.getAdditionalDataForControl = getAdditionalDataForControl;

            if ((typeof errors === 'undefined' ? 'undefined' : _typeof(errors)) === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }

            if (buildermode) {
                props.commands = [{ value: "approve", text: "Approve", type: 1 }, { value: "back", text: "Back", type: 2 }];

                props.states = [{ value: "draft", text: "Draft" }, { value: "state1", text: "State 1" }, { value: "state2", text: "State 2" }, { value: "state3", text: "State 3" }, { value: "finish", text: "Finish" }];
            }

            res = _react2.default.createElement(_workflowbar2.default, props);
        } else if (control === _container2.default) {
            res = _react2.default.createElement(_container2.default, _extends({}, props, { children: children }));
        } else if (control === _staticcontent2.default) {
            props.content = replaceControlValue(model.content);
            props.isHtml = model.isHtml;
            res = _react2.default.createElement(_staticcontent2.default, props);
        } else if (control === _dropzone2.default) {
            props.iconFiletypes = model.iconFiletypes;
            props.postUrl = uploadUrl;
            props.showFiletypeIcon = model.showFiletypeIcon;
            props.autoProcessQueue = model.autoProcessQueue;
            props.addRemoveLinks = model.addRemoveLinks;
            res = _react2.default.createElement(_dropzone2.default, _extends({}, props, {
                additionalParams: { model: model, data: data, errors: errors, children: children, handleEvent: handleEvent, parentItem: parentItem } }));
        } else {
            console.error("Control is unsupported!", control, model);
        }

        return res;
    },

    isContainer: function isContainer(key) {
        return key === 'form' || key === 'formgroup' || key === 'grid' || key === 'gridrow' || key === 'gridcolumn' || key === 'card' || key === 'cardcontent' || key === 'container' || key === 'div';
    },
    isForm: function isForm(model) {
        return model !== null && model !== undefined && (model["data-buildertype"] === "form" || model["data-buildertype"] === "formgroup");
    },
    createBuilderDropzone: function createBuilderDropzone(key, elementToInsert, elementafter, text, placeholderKey) {
        // if(text === undefined)
        text = "DROP ZONE";
        return _react2.default.createElement(
            'div',
            { name: key, key: key, elementafter: elementafter, elementtoinsert: elementToInsert, placeholderkey: placeholderKey, className: 'clover-formbuilder-zone' },
            text
        );
    },

    fillDefaultValues: function fillDefaultValues(model, defaultValues) {
        var control = undefined;
        for (var k in defaultValues) {
            if (model[k] === undefined) model[k] = defaultValues[k];
        }
        return model;
    }
};

module.exports = CloverFormControls;

/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var Reflux = __webpack_require__(8);
var BuilderActions = __webpack_require__(3);
var CloverFormControls = __webpack_require__(4);

var _data;

var CloverStore = Reflux.createStore({
  init: function init() {
    this.listenTo(BuilderActions.add, this.add);
    this.listenTo(BuilderActions.move, this.move);
    this.listenTo(BuilderActions.remove, this.remove);
    this.listenTo(BuilderActions.save, this.save);
    this.listenTo(BuilderActions.saveData, this._updateOrder);

    _data = [];
  },

  move: function move(key, el) {
    if (el == undefined) return;

    var item = this.findItemByKey(key, _data);
    var sortedArray = this._excludeItemByKey(key, _data);

    if (el.attributes['name'] != undefined && el.attributes['name'].value == 'dropzone_footer') {
      sortedArray.push(item);
    } else if (el.attributes['name'] != undefined && el.attributes['name'].value == 'dropzone_header') {
      sortedArray.unshift(item);
    } else if (el.attributes['elementtoinsert'] != undefined) {
      var parentControl;
      var insertIndex = 0;
      var parentKey = el.attributes['elementtoinsert'];

      if (parentKey != undefined) {
        parentControl = this.findItemByKey(parentKey.value, sortedArray);
      }

      if (parentControl != undefined) {
        var placeholderKey = el.attributes['placeholderkey'];
        var container = undefined;

        if (placeholderKey === undefined) {
          if (parentControl.children == undefined) parentControl.children = [];
          container = parentControl.children;
        } else {
          if (parentControl.placeholders === undefined) parentControl.placeholders = {};
          if (parentControl.placeholders[placeholderKey.value] == undefined) {
            parentControl.placeholders[placeholderKey.value] = [];
          }
          container = parentControl.placeholders[placeholderKey.value];
        }

        if (el.attributes['name'] != undefined && el.attributes['name'].value.includes('dropzone_footer')) {
          container.push(item);
        } else if (el.attributes['name'] != undefined && el.attributes['name'].value.includes('dropzone_header')) {
          container.unshift(item);
        } else {
          var afterKey = el.attributes['elementafter'];
          var afterControl;
          if (afterKey != undefined) {
            afterControl = this.findItemByKey(afterKey.value, container);
          }
          container.splice(container.indexOf(afterControl), 0, item);
        }
      } else {
        console.error("ERROR: element is not found", parentKey, item, el);
      }
    } else if (el.attributes['elementafter'] != undefined) {
      var control;
      var afterKey = el.attributes['elementafter'];
      if (afterKey != undefined) {
        control = this.findItemByKey(afterKey.value, sortedArray);
      }

      if (control != undefined) {
        sortedArray.splice(sortedArray.indexOf(control), 0, item);
      } else {
        console.error("ERROR: element is not found", afterKey, item, el);
      }
    }

    this.setData(sortedArray);
  },
  _excludeItemByKey: function _excludeItemByKey(key, data) {
    var sortedArray = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i].key == key) continue;

      sortedArray.push(data[i]);

      if (data[i].children) {
        sortedArray[sortedArray.length - 1].children = this._excludeItemByKey(key, data[i].children);
      }

      if (data[i].placeholders != undefined) {
        for (var ph in data[i].placeholders) {
          if (Array.isArray(data[i].placeholders[ph])) {
            sortedArray[sortedArray.length - 1].placeholders[ph] = this._excludeItemByKey(key, data[i].placeholders[ph]);
          }
        }
      }
    }
    return sortedArray;
  },
  add: function add(item, el) {
    var res = CloverFormControls.fillDefaultValues({
      key: this.getDefaultKey(item.key),
      "data-buildertype": item.builderType !== undefined ? item.builderType : item.key
    }, item.defaultValues);

    if (el == undefined) {
      if (_data.length > 0 && _data[_data.length - 1]["data-buildertype"] == 'form') {
        var p = _data[_data.length - 1];
        if (p.children == undefined) p.children = [];
        p.children.push(res);
      } else {
        _data.push(res);
      }
    } else if (el.attributes['name'] != undefined && el.attributes['name'].value == 'dropzone_footer') {
      _data.push(res);
    } else if (el.attributes['name'] != undefined && el.attributes['name'].value == 'dropzone_header') {
      _data.unshift(res);
    } else if (el.attributes['elementtoinsert'] != undefined) {
      var parentControl;
      var insertIndex = 0;
      var parentKey = el.attributes['elementtoinsert'];

      if (parentKey != undefined) {
        parentControl = this.findItemByKey(parentKey.value, _data);
      }

      if (parentControl != undefined) {
        var placeholderKey = el.attributes['placeholderkey'];
        var container = undefined;

        if (placeholderKey === undefined) {
          if (parentControl.children == undefined) parentControl.children = [];
          container = parentControl.children;
        } else {
          if (parentControl.placeholders === undefined) {
            parentControl.placeholders = {};
          }
          if (parentControl.placeholders[placeholderKey.value] == undefined) {
            parentControl.placeholders[placeholderKey.value] = [];
          }
          container = parentControl.placeholders[placeholderKey.value];
        }

        if (el.attributes['name'] != undefined && el.attributes['name'].value.includes('dropzone_footer')) {
          container.push(res);
        } else if (el.attributes['name'] != undefined && el.attributes['name'].value.includes('dropzone_header')) {
          container.unshift(res);
        } else {
          var afterKey = el.attributes['elementafter'];
          var afterControl;
          if (afterKey != undefined) {
            afterControl = this.findItemByKey(afterKey.value, container);
          }
          container.splice(container.indexOf(afterControl), 0, res);
        }
      } else {
        console.error("ERROR: element is not found", parentKey, item, el);
      }
    } else if (el.attributes['elementafter'] != undefined) {
      var control;
      var afterKey = el.attributes['elementafter'];
      if (afterKey != undefined) {
        control = this.findItemByKey(afterKey.value, _data);
      }

      if (control != undefined) {
        _data.splice(_data.indexOf(control), 0, res);
      } else {
        console.error("ERROR: element is not found", afterKey, buildertype, title, el);
      }
    }

    this.trigger(_data);
  },

  remove: function remove(item) {
    this.removeItemByKey(item.key, _data);
    this.trigger(_data);
  },

  copy: function copy(item) {
    var newItem = this.copyObj(item);
    this.insertAfterKey(newItem, item.key, _data);
    this.makeUniqueKeys(newItem);
    this.trigger(_data);
  },

  getData: function getData() {
    return _data;
  },

  setData: function setData(data) {
    _data = data;
    this.trigger(_data);
  },

  _updateOrder: function _updateOrder(elements) {
    _data = elements;
    this.trigger(_data);
  },

  getDefaultKey: function getDefaultKey(name) {
    var index = 1;
    var tmp = name + '_' + index;

    var allKeys = this.getAllKeys(_data);
    for (var i = 0; i < allKeys.length; i++) {
      var item = allKeys[i];
      var tmp = name + '_' + index;
      if (item == tmp) {
        index++;
        i = -1;
      }
    }

    return tmp;
  },
  getAllKeys: function getAllKeys(items) {
    var res = [];
    if (items != undefined) {
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        res.push(item.key);
        if (item.children != undefined) {
          var childkeys = this.getAllKeys(item.children);
          res = res.concat(childkeys);
        } else if (item.placeholders != undefined) {
          for (var ph in item.placeholders) {
            if (Array.isArray(item.placeholders[ph])) {
              var phkeys = this.getAllKeys(item.placeholders[ph]);
              res = res.concat(phkeys);
            }
          }
        }
      }
    }

    return res;
  },
  getByKey: function getByKey(key) {
    return this.findItemByKey(key, _data);
  },
  findItemByKey: function findItemByKey(key, items) {
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      if (item.key == key) return item;else if (item.children != undefined) {
        var res = this.findItemByKey(key, item.children);
        if (res != undefined) return res;
      } else if (item.placeholders != undefined) {
        for (var ph in item.placeholders) {
          if (Array.isArray(item.placeholders[ph])) {
            var res = this.findItemByKey(key, item.placeholders[ph]);
            if (res != undefined) return res;
          }
        }
      }
    }
    return undefined;
  },
  insertAfterKey: function insertAfterKey(insertItem, key, items) {
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      if (item.key == key) {
        items.splice(i + 1, 0, insertItem);
        return true;
      }

      if (item.children !== undefined) {
        if (this.insertAfterKey(insertItem, key, item.children)) {
          return true;
        }
      }

      if (item.placeholders !== undefined) {
        for (var ph in item.placeholders) {
          if (Array.isArray(item.placeholders[ph])) {
            if (this.insertAfterKey(insertItem, key, item.placeholders[ph])) {
              return true;
            }
          }
        }
      }
    }
    return undefined;
  },
  updateItemByKey: function updateItemByKey(key, item) {
    var data = this.getByKey(key);
    for (var i in item) {
      data[i] = item[i];
    }

    if (key != item.key) {
      this.replaceDepensKeys(key, item.key);
    }

    this.trigger(_data);
  },

  replaceDepensKeys: function replaceDepensKeys(oldKey, newKey, items) {
    if (items == undefined) items = _data;

    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      if (Array.isArray(item["events-onclick-targets"])) {
        var targets = item["events-onclick-targets"];
        for (var j = 0; j < targets.length; j++) {
          if (targets[j] == oldKey) targets[j] = newKey;
        }
      }

      if (item.children != undefined) {
        this.replaceDepensKeys(oldKey, newKey, item.children);
      }

      if (item.placeholders !== undefined) {
        for (var ph in item.placeholders) {
          if (Array.isArray(item.placeholders[ph])) {
            this.replaceDepensKeys(oldKey, newKey, item.placeholders[ph]);
          }
        }
      }
    }
  },
  removeItemByKey: function removeItemByKey(key, items) {
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      if (item.key == key) {
        items.splice(i, 1);
        break;
      }

      if (item.children != undefined) {
        this.removeItemByKey(key, item.children);
      }

      if (item.placeholders !== undefined) {
        for (var ph in item.placeholders) {
          if (Array.isArray(item.placeholders[ph])) {
            this.removeItemByKey(key, item.placeholders[ph]);
          }
        }
      }
    }
  },
  copyObj: function copyObj(obj) {
    if (null == obj || "object" != (typeof obj === 'undefined' ? 'undefined' : _typeof(obj))) return obj;
    var copy = obj.constructor();

    for (var attr in obj) {
      if (obj.hasOwnProperty(attr)) copy[attr] = this.copyObj(obj[attr]);
    }
    return copy;
  },
  makeUniqueKeys: function makeUniqueKeys(obj) {
    var me = this;
    var buildertype = obj["data-buildertype"];
    if (buildertype != undefined) {
      obj.key = this.getDefaultKey(buildertype);
    }

    if (Array.isArray(obj.children)) {
      obj.children.forEach(function (c) {
        me.makeUniqueKeys(c);
      });
    }

    if (obj.placeholders !== undefined) {
      for (var ph in obj.placeholders) {
        if (Array.isArray(obj.placeholders[ph])) {
          obj.placeholders[ph].forEach(function (c) {
            me.makeUniqueKeys(c);
          });
        }
      }
    }
  }
});

module.exports = CloverStore;

/***/ }),
/* 6 */
/***/ (function(module, exports) {

module.exports = __WEBPACK_EXTERNAL_MODULE_6__;

/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _json = __webpack_require__(2);

var _json2 = _interopRequireDefault(_json);

var _semanticUiReact = __webpack_require__(1);

var _upload = __webpack_require__(10);

var _upload2 = _interopRequireDefault(_upload);

var _datepicker = __webpack_require__(11);

var _datepicker2 = _interopRequireDefault(_datepicker);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var CollectionEditor = function (_React$Component) {
    _inherits(CollectionEditor, _React$Component);

    function CollectionEditor(props) {
        _classCallCheck(this, CollectionEditor);

        var _this = _possibleConstructorReturn(this, (CollectionEditor.__proto__ || Object.getPrototypeOf(CollectionEditor)).call(this, props));

        _this.state = {
            expanded: {}
        };
        return _this;
    }

    _createClass(CollectionEditor, [{
        key: 'applyCollapseAll',
        value: function applyCollapseAll(data) {
            for (var p in data) {
                if (this.state.expanded[p] == undefined) this.state.expanded[p] = false;
            }
        }
    }, {
        key: 'render',
        value: function render() {
            var columns = this.props.columns;
            var data = this.props.value;
            var error = this.props.error;

            if (Boolean(this.props.collapseAll) && Array.isArray(data)) {
                this.applyCollapseAll(data);
            }

            if (columns == undefined || columns.length == 0) {
                return _react2.default.createElement(
                    'div',
                    null,
                    'Fill columns property!'
                );
            }

            this.state.data = this.getCopyRowsFromProps();
            return _react2.default.createElement(
                'div',
                { style: this.props.style, className: 'field' },
                _react2.default.createElement(
                    'label',
                    null,
                    this.props.label
                ),
                _react2.default.createElement(
                    'table',
                    { className: 'clover-collectioneditor' },
                    _react2.default.createElement(
                        'tbody',
                        null,
                        this.renderHeaderRow(columns),
                        this.renderRows(columns, this.state.data, error)
                    )
                )
            );
        }
    }, {
        key: 'renderHeaderRow',
        value: function renderHeaderRow(columns) {
            var res = [];
            var index = 0;
            columns.forEach(function (c) {
                var key;
                var title;
                var width;
                var dataListOptions = undefined;
                if ((typeof c === 'undefined' ? 'undefined' : _typeof(c)) === 'object') {
                    key = c.key;
                    title = c.name;
                    width = c.width;
                    if (Array.isArray(c.dataList)) dataListOptions = c.dataList;
                } else {
                    key = c;
                    title = c;
                }

                if (title != undefined && title.length >= 2) {
                    title = title.charAt(0).toUpperCase() + title.slice(1);
                }

                var dataListControl;
                var dataListId = undefined;
                if (dataListOptions != undefined) {
                    dataListId = key + "_datalist";
                    var optValue = [];
                    dataListOptions.forEach(function (o) {
                        optValue.push(_react2.default.createElement('option', { key: o, value: o }));
                    });
                    dataListControl = _react2.default.createElement(
                        'datalist',
                        { key: dataListId, id: dataListId },
                        optValue
                    );
                }

                res.push(_react2.default.createElement(
                    'td',
                    { key: index, style: { width: width } },
                    title,
                    dataListControl
                ));
                index++;
            });

            if (!Boolean(this.props.readOnly) && this.props.disableAdd !== true) {
                var addcontent = "Add";
                if (window.CloverAdminLang != undefined && window.CloverAdminLang.collectioneditor != undefined) {
                    addcontent = window.CloverAdminLang.collectioneditor.add;
                }
                res.push(_react2.default.createElement(
                    'td',
                    { key: 'btntd', className: 'clover-collectioneditor-buttoncol' },
                    _react2.default.createElement(
                        'a',
                        { key: 'btnadd', className: 'clover-btn', onClick: this.btnAdd.bind(this) },
                        addcontent
                    )
                ));
            }

            return _react2.default.createElement(
                'tr',
                { key: 'headertr', className: 'clover-collectioneditor-header' },
                res
            );
        }
    }, {
        key: 'getDragColumn',
        value: function getDragColumn(rows, i) {
            var draggable = !Boolean(this.props.readOnly) && Boolean(this.props.draggable);
            if (draggable) {
                return _react2.default.createElement(
                    'div',
                    {
                        draggable: draggable,
                        onDragStart: this.onDragStart.bind(this, i, rows),
                        onDragEnd: this.onDragEnd.bind(this, i, rows),
                        onDragOver: this.onDragOver.bind(this),
                        onDrop: this.onDrop.bind(this, i, rows),
                        key: 'celldrag', className: 'clover-collectioneditor-action' },
                    _react2.default.createElement(_semanticUiReact.Icon, { onClick: this.onExpand.bind(this, i, false), name: 'ellipsis vertical' })
                );
            }
            return undefined;
        }
    }, {
        key: 'renderRows',
        value: function renderRows(columns, data, errors, parentIdValue, level, prefix) {
            var _this2 = this;

            var me = this;
            var res = [];
            var rows = data;
            if (level == undefined) level = 0;

            if (prefix === undefined) prefix = "";

            for (var i = 0; i < rows.length; i++) {
                if (this.props.childrenField === undefined && this.props.hierarchical) {
                    if (rows[i][this.props.parentIdField] != parentIdValue) {
                        continue;
                    }
                }

                var dragcol = this.getDragColumn(rows, i);
                var expand = undefined;
                var children = undefined;
                if (this.props.hierarchical) {
                    var icon = void 0;
                    var parentPrefix = prefix + String(i + "_");
                    if (this.props.parentIdField !== undefined && this.props.parentIdField !== "") {
                        var parentId = rows[i][this.props.idField];
                        if (parentId != undefined && parentId != "") {
                            children = this.renderRows(columns, data, errors, parentId, level + 1, parentPrefix);
                            if (children.length > 0) {
                                var isexpanded = this.state.expanded[prefix + i];
                                if (isexpanded == undefined || isexpanded == true) {
                                    icon = _react2.default.createElement('img', { onClick: this.onExpand.bind(this, prefix + i, false), className: 'clover-collectioneditor-imgbutton', src: '/images/collapse.svg' });
                                } else {
                                    icon = _react2.default.createElement('img', { onClick: this.onExpand.bind(this, prefix + i, true), className: 'clover-collectioneditor-imgbutton', src: '/images/expand.svg' });
                                    children = undefined;
                                }
                            }
                        }
                    } else if (Array.isArray(rows[i][this.props.childrenField]) && rows[i][this.props.childrenField].length > 0) {
                        children = this.renderRows(columns, rows[i][this.props.childrenField], errors, undefined, level + 1, parentPrefix);
                        if (children.length > 0) {
                            var isexpanded = this.state.expanded[prefix + i];
                            if (isexpanded == undefined || isexpanded == true) {
                                icon = _react2.default.createElement('img', { onClick: this.onExpand.bind(this, prefix + i, false), className: 'clover-collectioneditor-imgbutton', src: '/images/collapse.svg' });
                            } else {
                                icon = _react2.default.createElement('img', { onClick: this.onExpand.bind(this, prefix + i, true), className: 'clover-collectioneditor-imgbutton', src: '/images/expand.svg' });
                                children = undefined;
                            }
                        }
                    } else {
                        icon = _react2.default.createElement('img', { style: { opacity: 0 }, className: 'clover-collectioneditor-imgbutton', src: '/images/collapse.svg' });
                    }

                    expand = _react2.default.createElement(
                        'div',
                        { className: 'clover-collectioneditor-action' },
                        icon
                    );
                }

                var row = [];
                var errorOnRow = Array.isArray(errors) ? errors[i] : undefined;
                for (var j = 0; j < columns.length; j++) {
                    var colName = void 0;
                    var control = this.props.readOnly ? "" : "input";
                    var dataListId = undefined;
                    var options = undefined;
                    if (_typeof(columns[j]) === 'object') {
                        colName = columns[j].key;
                        control = columns[j].control;
                        if (Array.isArray(columns[j].dataList)) {
                            dataListId = colName + "_datalist";
                        }

                        if (Array.isArray(columns[j].options)) {
                            options = columns[j].options;
                        }
                    } else {
                        colName = columns[j];
                    }

                    var errorFlag = undefined;
                    if (errorOnRow != undefined) {
                        errorFlag = Boolean(errorOnRow[colName]);
                    }

                    var element = undefined;
                    if (control == "checkbox") {
                        element = _react2.default.createElement(_semanticUiReact.Form.Checkbox, {
                            key: i + "_" + j,
                            name: colName,
                            checked: Boolean(rows[i][colName]),
                            readOnly: Boolean(this.props.readOnly),
                            error: errorFlag,
                            onChange: this.handleChange.bind(this, rows[i]) });
                    } else if (control == "span") {
                        element = _react2.default.createElement(
                            'span',
                            {
                                key: i + "_" + j,
                                name: colName },
                            rows[i][colName]
                        );
                    } else if (control == "number") {
                        var value = rows[i][colName] == null ? "" : rows[i][colName];
                        element = _react2.default.createElement(_semanticUiReact.Form.Input, {
                            key: i + "_" + j,
                            name: colName,
                            type: 'number',
                            error: errorFlag,
                            value: value,
                            readOnly: Boolean(this.props.readOnly),
                            onChange: this.handleChange.bind(this, rows[i]) });
                    } else if (control == "date") {
                        var _value = rows[i][colName] == null ? "" : rows[i][colName];
                        element = _react2.default.createElement(_datepicker2.default, {
                            key: i + "_" + j,
                            name: colName,
                            type: 'date',
                            error: errorFlag,
                            value: _value,
                            isForm: true,
                            readOnly: Boolean(this.props.readOnly),
                            onChange: this.handleChange.bind(this, rows[i]) });
                    } else if (control == "datetime") {
                        var _value2 = rows[i][colName] == null ? "" : rows[i][colName];
                        element = _react2.default.createElement(_datepicker2.default, {
                            key: i + "_" + j,
                            name: colName,
                            type: 'datetime',
                            error: errorFlag,
                            value: _value2,
                            isForm: true,
                            readOnly: Boolean(this.props.readOnly),
                            onChange: this.handleChange.bind(this, rows[i]) });
                    } else if (control == "dropdown") {
                        var _value3 = rows[i][colName] == null ? Boolean(columns[j].multiple) ? [] : "" : rows[i][colName];
                        element = _react2.default.createElement(_semanticUiReact.Form.Dropdown, {
                            key: i + "_" + j,
                            name: colName,
                            multiple: Boolean(columns[j].multiple),
                            error: errorFlag,
                            value: _value3,
                            options: options,
                            readOnly: Boolean(this.props.readOnly),
                            onChange: this.handleChange.bind(this, rows[i]),
                            selection: true, fluid: true, search: true });
                    } else if (control == "file" || control == "file2") {
                        var _value4 = rows[i][colName] == null ? "" : rows[i][colName];
                        element = _react2.default.createElement(_upload2.default, {
                            key: i + "_" + j,
                            name: colName,
                            error: errorFlag,
                            value: _value4,
                            readOnly: Boolean(this.props.readOnly),
                            onChange: this.handleChange.bind(this, rows[i]),
                            downloadUrl: this.props.downloadUrl,
                            uploadUrl: this.props.uploadUrl,
                            isForm: true,
                            hideClearButton: control == "file2" });
                    } else if (control == "custom") {
                        var _value5 = rows[i][colName] == null ? "" : rows[i][colName];
                        if (this.props.placeholders != undefined && Array.isArray(this.props.placeholders[colName]) && this.props.placeholders[colName].length > 0) {
                            var model = this.props.placeholders[colName][0];
                            if (model != undefined) {
                                (function () {
                                    model.key = colName;
                                    var row = rows[i];
                                    element = _this2.props.createControl(_this2, model["data-buildertype"], {
                                        model: model, data: row, errors: errorOnRow,
                                        parentItem: _this2.props.name,
                                        buildermode: _this2.props.buildermode,
                                        handleEvent: function handleEvent(args) {
                                            if (args.eventName == "onChange") {
                                                me.handleChange(row, args.syntheticEvent, { name: args.name, value: args.value, checked: args.checked });
                                            } else {
                                                this.props.handleChange(args);
                                            }
                                        },
                                        getAdditionalDataForControl: _this2.props.getAdditionalDataForControl,
                                        readOnly: _this2.props.readOnly,
                                        uploadUrl: _this2.props.uploadUrl,
                                        downloadUrl: _this2.props.downloadUrl,
                                        controlsToReplace: []
                                    });
                                })();
                            }
                        } else if (this.props.buildermode && this.props.createBuilderDropzone != undefined) {
                            element = this.props.createBuilderDropzone(colName, _value5);
                        }
                    } else {
                        var _value6 = rows[i][colName] == null ? "" : rows[i][colName];
                        element = _react2.default.createElement(_semanticUiReact.Form.Input, {
                            key: i + "_" + j,
                            name: colName,
                            list: dataListId,
                            error: errorFlag,
                            value: _value6,
                            readOnly: Boolean(this.props.readOnly),
                            onChange: this.handleChange.bind(this, rows[i]) });
                    }

                    if (j == 0) {
                        var paddingLeft = void 0;
                        if (level != 0) {
                            paddingLeft = String(level * 15) + "px";
                        }

                        row.push(_react2.default.createElement(
                            'td',
                            { key: i + "_" + j + "td", style: { paddingLeft: paddingLeft } },
                            expand,
                            dragcol,
                            element
                        ));
                    } else row.push(_react2.default.createElement(
                        'td',
                        { key: i + "_" + j + "td" },
                        element
                    ));
                }

                if (!Boolean(this.props.readOnly)) {
                    if (this.props.hierarchical) {
                        row.push(_react2.default.createElement(
                            'td',
                            { key: 'celldelete', className: 'clover-collectioneditor-cellbtn' },
                            _react2.default.createElement(
                                'div',
                                { className: 'field' },
                                _react2.default.createElement(_semanticUiReact.Icon, { key: 'addchild', onClick: this.btnAddChild.bind(this, i, rows), link: true, name: 'add' }),
                                _react2.default.createElement(_semanticUiReact.Icon, { key: 'delete', onClick: this.btnDelete.bind(this, i, rows), link: true, name: 'delete' })
                            )
                        ));
                    } else {
                        row.push(_react2.default.createElement(
                            'td',
                            { key: 'celldelete', className: 'clover-collectioneditor-cellbtn' },
                            _react2.default.createElement(
                                'div',
                                { className: 'field' },
                                _react2.default.createElement(_semanticUiReact.Icon, { key: 'delete', onClick: this.btnDelete.bind(this, i, undefined), link: true, name: 'delete' })
                            )
                        ));
                    }
                }

                res.push(_react2.default.createElement(
                    'tr',
                    { key: prefix + i, className: 'clover-collectioneditor-row', 'data-rowindex': i },
                    row
                ));
                res = res.concat(children);
            }

            return res;
        }
    }, {
        key: 'btnDelete',
        value: function btnDelete(index, rows) {
            if (this.props.onChange == undefined) return;

            if (rows === undefined) rows = this.state.data;

            var obj = rows[index];
            rows.splice(index, 1);

            this.sendChangesToParent();
        }
    }, {
        key: 'btnAddChild',
        value: function btnAddChild(index, rows) {
            if (rows === undefined) rows = this.state.data == undefined ? [] : this.state.datae;

            var objParent = rows[index];
            var obj = this.props.defaultrow == undefined ? {} : _extends({}, this.props.defaultrow);

            if (this.props.parentIdField !== undefined && this.props.parentIdField !== "") {
                obj[this.props.parentIdField] = objParent[this.props.idField];
                rows.push(obj);
            } else {
                if (!Array.isArray(rows[index][this.props.childrenField])) rows[index][this.props.childrenField] = [];

                rows[index][this.props.childrenField].push(obj);
            }

            if (this.props.handleEvent != undefined) {
                this.props.handleEvent({ key: this.props.name, eventName: "onAddChild", parameters: { rowIdx: rows.length - 1, row: obj } });
            }
            this.sendChangesToParent();
        }
    }, {
        key: 'btnAdd',
        value: function btnAdd() {
            var obj = this.props.defaultrow == undefined ? {} : this.props.defaultrow;
            this.state.data.push(obj);

            if (this.props.handleEvent != undefined) {
                this.props.handleEvent({ key: this.props.name, eventName: "onAdd", parameters: { rowIdx: this.state.data.length - 1, row: obj } });
            }

            this.sendChangesToParent();
        }
    }, {
        key: 'onExpand',
        value: function onExpand(i, value) {
            this.state.expanded[i] = value;
            this.forceUpdate();
        }
    }, {
        key: 'onDragOver',
        value: function onDragOver(e) {
            e.preventDefault();
        }
    }, {
        key: 'onDragStart',
        value: function onDragStart(index, rows, e) {
            e.dataTransfer.setData('index', index);
            this.state.dragElementIndex = index;
            this.state.dragRows = rows;
        }
    }, {
        key: 'onDragEnd',
        value: function onDragEnd(index, e) {
            this.state.dragElementIndex = undefined;
            this.state.dragRows = undefined;
        }
    }, {
        key: 'onDrop',
        value: function onDrop(index, rows, e) {
            var rowIndexA = this.state.dragElementIndex;
            var rowsA = this.state.dragRows;
            var rowIndexB = index;
            var rowsB = rows;
            if (rowIndexA != undefined) {
                if (rowIndexB != rowIndexA) {
                    if (this.props.parentIdField !== undefined && this.props.parentIdField !== "") {
                        rowsA[rowIndexA][this.props.parentIdField] = rowsB[rowIndexB][this.props.parentIdField];
                    }
                    rowsB.splice(rowIndexB, 0, rowsA.splice(rowIndexA, 1)[0]);
                    this.sendChangesToParent();
                }
                e.preventDefault();
            }
            return false;
        }
    }, {
        key: 'handleChange',
        value: function handleChange(item, e, _ref) {
            var name = _ref.name,
                value = _ref.value,
                checked = _ref.checked;

            if (this.props.onChange == undefined) return;

            if (value == undefined && checked != undefined) {
                item[name] = checked;
            } else {
                item[name] = value;
            }

            this.sendChangesToParent();

            if (e != undefined) e.preventDefault();else this.forceUpdate();
        }
    }, {
        key: 'getCopyRowsFromProps',
        value: function getCopyRowsFromProps() {
            var rows = this.props.value == undefined ? [] : this.props.value;
            this.state.stringmode = false;
            if (!Array.isArray(rows)) {
                rows = _json2.default.parse(rows);
                this.state.stringmode = true;
            } else {
                rows = rows.slice();
            }

            return rows;
        }
    }, {
        key: 'sendChangesToParent',
        value: function sendChangesToParent() {
            var rows = this.state.data;
            var res = this.state.stringmode ? _json2.default.stringify(rows) : rows;
            this.props.onChange(null, { name: this.props.name, value: res });
        }
    }]);

    return CollectionEditor;
}(_react2.default.Component);

exports.default = CollectionEditor;

/***/ }),
/* 8 */
/***/ (function(module, exports) {

module.exports = __WEBPACK_EXTERNAL_MODULE_8__;

/***/ }),
/* 9 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _semanticUiReact = __webpack_require__(1);

var _collectioneditor = __webpack_require__(7);

var _collectioneditor2 = _interopRequireDefault(_collectioneditor);

var _json = __webpack_require__(2);

var _json2 = _interopRequireDefault(_json);

var _eventseditor = __webpack_require__(19);

var _eventseditor2 = _interopRequireDefault(_eventseditor);

var _radiogroup = __webpack_require__(13);

var _radiogroup2 = _interopRequireDefault(_radiogroup);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

//------Edit Form-------------------
var BaseEditControl = function (_React$Component) {
  _inherits(BaseEditControl, _React$Component);

  function BaseEditControl(props) {
    _classCallCheck(this, BaseEditControl);

    var _this = _possibleConstructorReturn(this, (BaseEditControl.__proto__ || Object.getPrototypeOf(BaseEditControl)).call(this, props));

    _this.state = {
      activeItem: 'general'
    };

    _this.menuItems = [{ key: 'general', name: 'general', content: _this.getLocalValue('generaltab', 'General'), active: true, onClick: _this.handleItemClick.bind(_this) }, { key: 'style', name: 'style', content: _this.getLocalValue('styletab', 'Style'), active: false, onClick: _this.handleItemClick.bind(_this) }, { key: 'events', name: 'events', content: _this.getLocalValue('eventstab', 'Events'), active: false, onClick: _this.handleItemClick.bind(_this) }, { key: 'other', name: 'other', content: _this.getLocalValue('othertab', 'Other'), active: false, onClick: _this.handleItemClick.bind(_this) }];
    return _this;
  }

  _createClass(BaseEditControl, [{
    key: 'getLocalValue',
    value: function getLocalValue(key, defaultvalue, formname) {
      var local = this.props.localization;
      var block = formname != undefined ? formname : "base";

      if (local == undefined || local[block] == undefined || local[block][key] == undefined) return defaultvalue;
      return local[block][key];
    }
  }, {
    key: 'handleItemClick',
    value: function handleItemClick(e, _ref) {
      var name = _ref.name;

      this.setState({ activeItem: name });
    }
  }, {
    key: 'getDescription',
    value: function getDescription() {
      var activeItem = this.state.activeItem;

      this.menuItems.forEach(function (item) {
        item.active = item.name === activeItem;
      });

      return _react2.default.createElement(
        _semanticUiReact.Modal.Description,
        null,
        _react2.default.createElement(_semanticUiReact.Menu, { key: 'descriptionMenu', pointing: true, secondary: true, items: this.menuItems }),
        this.getDetailDescription(activeItem)
      );
    }
  }, {
    key: 'getDetailDescription',
    value: function getDetailDescription(activeItem) {
      var segment;

      if (activeItem === 'general') segment = this.getGeneralDescription();else if (activeItem === 'style') segment = this.getStyleDescription();else if (activeItem === 'events') segment = this.getEventsDescription();else if (activeItem === 'other') segment = this.getOtherDescription();

      return segment;
    }
  }, {
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      return _react2.default.createElement(
        _semanticUiReact.Form,
        { key: 'generalDescriptionForm' },
        _react2.default.createElement(_semanticUiReact.Form.Input, { key: 'name', label: 'Name', name: 'key', value: data.key, onChange: handleChange })
      );
    }
  }, {
    key: 'getStyleDescription',
    value: function getStyleDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var stylesource_ps = "/*** Example Code ***/\ncolor:red;\npaddingTop:5px;";
      return _react2.default.createElement(
        _semanticUiReact.Form,
        { key: 'styleDescriptionForm' },
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'style-width', label: this.getLocalValue('widthfield', 'Width'), placeholder: '100px', value: data["style-width"], onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'style-height', label: this.getLocalValue('heightfield', 'Height'), placeholder: '100px', value: data["style-height"], onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'style-marginTop', label: this.getLocalValue('margintopfield', 'Margin Top'), placeholder: '0px', value: data["style-marginTop"], onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'style-marginBottom', label: this.getLocalValue('marginbottomfield', 'Margin Bottom'), placeholder: '0px', value: data["style-marginBottom"], onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'style-marginLeft', label: this.getLocalValue('marginleftfield', 'Margin Left'), placeholder: '0px', value: data["style-marginLeft"], onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'style-marginRight', label: this.getLocalValue('marginrightfield', 'Margin Right'), placeholder: '0px', value: data["style-marginRight"], onChange: handleChange })
        ),
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'style-customcss', label: this.getLocalValue('customcssclassfield', 'Custom CSS class'), placeholder: 'clover-application-css (without \'.\')', value: data["style-customcss"], onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.TextArea, { name: 'style-source', label: this.getLocalValue('stylefield', 'Style'), placeholder: stylesource_ps, value: data["style-source"], onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'style-hidden', label: this.getLocalValue('hiddenfield', 'Hidden'), checked: data["style-hidden"], onChange: handleChange })
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return [];
    }
  }, {
    key: 'getEventsDescription',
    value: function getEventsDescription() {
      var me = this;
      var data = this.props.data;
      if (data.events == undefined) data.events = {};

      var handleChange = this.props.parent.handleChange.bind(this.props.parent);

      var actions = this.props.actions;
      var events = this.getEventsList();
      var content;
      if (!Array.isArray(events) || events.length == 0) {
        content = _react2.default.createElement(
          _semanticUiReact.Message,
          { icon: true },
          _react2.default.createElement(_semanticUiReact.Image, { src: '/images/cloverbuilder-info.png', height: '32px' }),
          _react2.default.createElement(
            _semanticUiReact.Message.Content,
            null,
            this.getLocalValue('controlhasnoeventsmsg', 'This control has no events.')
          )
        );
      } else {
        var controlsOnForm = this.props.parent.getControlsList();
        var listControls = [];
        for (var i = 0; i < controlsOnForm.length; i++) {
          if (data.key == controlsOnForm[i]) continue;
          listControls.push({ text: controlsOnForm[i], value: controlsOnForm[i] });
        }
        content = _react2.default.createElement(_eventseditor2.default, {
          key: 'events', name: 'events',
          data: data.events,
          events: events,
          actions: actions,
          targets: listControls,
          onAdditionActions: this.handleAdditionActions.bind(this),
          onChange: handleChange });
      }
      var timeot = null;
      if (events.includes("onChange")) {
        timeot = _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'onChangeTimeout',
          style: { width: 100 },
          placeholder: "0",
          type: "number",
          label: this.getLocalValue("onchangetimeout", "onChange timeout"),
          value: data.onChangeTimeout, onChange: handleChange });
      }

      return _react2.default.createElement(
        _semanticUiReact.Form,
        { key: 'eventsDescriptionForm' },
        _react2.default.createElement(
          _semanticUiReact.Message,
          { icon: true },
          _react2.default.createElement(_semanticUiReact.Image, { src: '/images/cloverbuilder-info.png', height: '32px' }),
          _react2.default.createElement(
            _semanticUiReact.Message.Content,
            null,
            this.getLocalValue('eventsinfomsg', 'These flags enable processing from this element.')
          )
        ),
        timeot,
        content
      );
    }
  }, {
    key: 'getOtherDescription',
    value: function getOtherDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var customvalidation_ps = "/*** Example Code ***/\nvalue > 10 ? true : 'Must be more 10'";
      var visibleconition_ps = "/*** Example Code ***/\ndata.type == 1 ? true : false";
      var readOnlyconition_ps = "/*** Example Code ***/\ndata.type == 1 ? true : false";

      return _react2.default.createElement(
        _semanticUiReact.Form,
        { key: 'otherDescriptionForm' },
        _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'other-required', label: this.getLocalValue('requiredfield', 'Required'), checked: data["other-required"], onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'defaultValue', label: this.getLocalValue('defaultvaluefield', 'Default value'), value: data["defaultValue"], onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.TextArea, { name: 'other-customValidation', label: this.getLocalValue('customvalidationfield', 'Custom Validation'), placeholder: customvalidation_ps, value: data["other-customValidation"], onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.TextArea, { name: 'other-visibleConition', label: this.getLocalValue('visibleconditionfield', 'Visible condition'), placeholder: visibleconition_ps, value: data["other-visibleConition"], onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.TextArea, { name: 'other-readOnlyConition', label: this.getLocalValue('readonlyconditionfield', 'ReadOnly condition'), placeholder: readOnlyconition_ps, value: data["other-readOnlyConition"], onChange: handleChange })
      );
    }
  }, {
    key: 'render',
    value: function render() {
      return _react2.default.createElement(
        _semanticUiReact.Modal,
        { dimmer: 'inverted', open: this.props.open, onClose: this.props.onClose.bind(this.props.parent) },
        _react2.default.createElement(
          _semanticUiReact.Modal.Content,
          null,
          _react2.default.createElement(
            _semanticUiReact.Modal.Description,
            null,
            this.getDescription()
          )
        ),
        _react2.default.createElement(
          _semanticUiReact.Modal.Actions,
          null,
          _react2.default.createElement(
            _semanticUiReact.Button,
            { className: 'buttontype1', onClick: this.props.onSave.bind(this.props.parent) },
            this.getLocalValue('savebutton', 'Save')
          ),
          _react2.default.createElement(
            _semanticUiReact.Button,
            { className: 'buttontype2', onClick: this.props.onClose.bind(this.props.parent) },
            this.getLocalValue('cancelbutton', 'Cancel')
          )
        )
      );
    }
  }, {
    key: 'checkActionsList',
    value: function checkActionsList(value) {
      var isExists = false;

      for (var i = 0; i < this.props.actions.length; i++) {
        if (this.props.actions[i] == value) {
          isExists = true;
          break;
        }
      }

      if (!isExists) {
        this.props.actions.push({ text: value, value: value });
      }
    }
  }, {
    key: 'handleAdditionActions',
    value: function handleAdditionActions(e, _ref2) {
      var value = _ref2.value;

      this.checkActionsList(value);
      this.forceUpdate();
    }
  }]);

  return BaseEditControl;
}(_react2.default.Component);

var HeaderEditControl = function (_BaseEditControl) {
  _inherits(HeaderEditControl, _BaseEditControl);

  function HeaderEditControl(props) {
    _classCallCheck(this, HeaderEditControl);

    return _possibleConstructorReturn(this, (HeaderEditControl.__proto__ || Object.getPrototypeOf(HeaderEditControl)).call(this, props));
  }

  _createClass(HeaderEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;
      var sizedata = [{ text: this.getLocalValue('sizedefault', 'Default'), value: '' }, { text: this.getLocalValue('sizemini', 'Mini'), value: 'mini' }, { text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny' }, { text: this.getLocalValue('sizesmall', 'Small'), value: 'small' }, { text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium' }, { text: this.getLocalValue('sizelarge', 'Large'), value: 'large' }, { text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge' }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "headerform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'size', selection: true, fluid: true, options: sizedata, placeholder: 'Default', label: this.getLocalValue('sizefield', 'Size', "header"), value: data.size, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.TextArea, { name: 'content', label: this.getLocalValue('contentfield', 'Content', "headerform"), value: data.content, onChange: handleChange }),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('textalignfield', 'Text Align', "headerform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              { widths: 'equal' },
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'textAlign', label: this.getLocalValue('textalignleft', 'Left', "headerform"), value: 'left', checked: data.textAlign === 'left', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'textAlign', label: this.getLocalValue('textaligncenter', 'Center', "headerform"), value: 'center', checked: data.textAlign === 'center', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'textAlign', label: this.getLocalValue('textalignright', 'Right', "headerform"), value: 'right', checked: data.textAlign === 'right', onChange: handleChange })
            )
          )
        ),
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'subheader', label: this.getLocalValue('subheaderfield', 'Subheader', "headerform"), value: data.subheader, onChange: handleChange })
      );
    }
  }]);

  return HeaderEditControl;
}(BaseEditControl);

var ButtonEditControl = function (_BaseEditControl2) {
  _inherits(ButtonEditControl, _BaseEditControl2);

  function ButtonEditControl(props) {
    _classCallCheck(this, ButtonEditControl);

    return _possibleConstructorReturn(this, (ButtonEditControl.__proto__ || Object.getPrototypeOf(ButtonEditControl)).call(this, props));
  }

  _createClass(ButtonEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var sizedata = [{ text: this.getLocalValue('sizedefault', 'Default'), value: '' }, { text: this.getLocalValue('sizemini', 'Mini'), value: 'mini' }, { text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny' }, { text: this.getLocalValue('sizesmall', 'Small'), value: 'small' }, { text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium' }, { text: this.getLocalValue('sizebig', 'Big'), value: 'big' }, { text: this.getLocalValue('sizelarge', 'Large'), value: 'large' }, { text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge' }, { text: this.getLocalValue('sizemassive', 'Massive'), value: 'massive' }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "buttonform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('typefield', 'Type', "buttonform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'buttonType', label: this.getLocalValue('typenonefield', 'None', "buttonform"), value: '', checked: data.buttonType === '' || data.buttonType === undefined, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'buttonType', label: this.getLocalValue('typesubmitfield', 'Submit', "buttonform"), value: 'submit', checked: data.buttonType === 'submit', onChange: handleChange })
            )
          )
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'content', label: this.getLocalValue('contentfield', 'Content', "buttonform"), value: data.content, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'size', selection: true, fluid: true, options: sizedata, placeholder: 'Default', label: this.getLocalValue('sizefield', 'Size', "buttonform"), value: data.size, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('optionsfield', 'Options', "buttonform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'basic', label: this.getLocalValue('basicfield', 'Basic', "buttonform"), checked: data.basic, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'circular', label: this.getLocalValue('circularfield', 'Circular', "buttonform"), checked: data.circular, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'compact', label: this.getLocalValue('compactfield', 'Compact', "buttonform"), checked: data.compact, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'disabled', label: this.getLocalValue('disabledfield', 'Disabled', "buttonform"), checked: data.disabled, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'fluid', label: this.getLocalValue('fluidfield', 'Fluid', "buttonform"), checked: data.fluid, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'inverted', label: this.getLocalValue('invertedfield', 'Inverted', "buttonform"), checked: data.inverted, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'loading', label: this.getLocalValue('loadingfield', 'Loading', "buttonform"), checked: data.loading, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'primary', label: this.getLocalValue('primaryfield', 'Primary', "buttonform"), checked: data.primary, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'secondary', label: this.getLocalValue('secondaryfield', 'Secondary', "buttonform"), checked: data.secondary, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'toggle', label: this.getLocalValue('togglefield', 'Toggle', "buttonform"), checked: data.toggle, onChange: handleChange })
            )
          ),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('floatedfield', 'Floated', "buttonform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'floated', label: this.getLocalValue('floateddefaultfield', 'Default', "buttonform"), value: '', checked: data.floated === undefined || data.floated === '', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'floated', label: this.getLocalValue('floatedleftfield', 'Left', "buttonform"), value: 'left', checked: data.floated === 'left', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'floated', label: this.getLocalValue('floatedrightfield', 'Right', "buttonform"), value: 'right', checked: data.floated === 'right', onChange: handleChange })
            )
          )
        )
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onClick"];
    }
  }]);

  return ButtonEditControl;
}(BaseEditControl);

var LabelEditControl = function (_BaseEditControl3) {
  _inherits(LabelEditControl, _BaseEditControl3);

  function LabelEditControl(props) {
    _classCallCheck(this, LabelEditControl);

    return _possibleConstructorReturn(this, (LabelEditControl.__proto__ || Object.getPrototypeOf(LabelEditControl)).call(this, props));
  }

  _createClass(LabelEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var sizedata = [{ text: this.getLocalValue('sizedefault', 'Default'), value: '' }, { text: this.getLocalValue('sizemini', 'Mini'), value: 'mini' }, { text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny' }, { text: this.getLocalValue('sizesmall', 'Small'), value: 'small' }, { text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium' }, { text: this.getLocalValue('sizelarge', 'Large'), value: 'large' }, { text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge' }];

      var attacheddata = [{ text: this.getLocalValue('attachednone', 'None'), value: '' }, { text: this.getLocalValue('attachedtop', 'Top'), value: 'top' }, { text: this.getLocalValue('attachedbottom', 'Bottom'), value: 'bottom' }, { text: this.getLocalValue('attachedtopright', 'Top right'), value: 'top right' }, { text: this.getLocalValue('attachedtopleft', 'Top left'), value: 'top left' }, { text: this.getLocalValue('attachedbottomleft', 'Bottom left'), value: 'bottom left' }, { text: this.getLocalValue('attachedbottomright', 'Bottom right'), value: 'bottom right' }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "labelform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'attached', selection: true, fluid: true, options: attacheddata, placeholder: attacheddata[0].text, label: this.getLocalValue('attachedfield', 'Attached', "labelform"), value: data.attached, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'content', label: this.getLocalValue('contentfield', 'Content', "labelform"), value: data.content, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'size', selection: true, fluid: true, options: sizedata, placeholder: 'Default', label: this.getLocalValue('sizefield', 'Size', "labelform"), value: data.size, onChange: handleChange })
          ),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('optionsfield', 'Options', "labelform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'basic', label: this.getLocalValue('basicfield', 'Basic', "labelform"), checked: data.basic, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'circular', label: this.getLocalValue('circularfield', 'Circular', "labelform"), checked: data.circular, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'corner', label: this.getLocalValue('cornerfield', 'Corner', "labelform"), checked: data.corner, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'floating', label: this.getLocalValue('floatingfield', 'Floating', "labelform"), checked: data.floating, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'horizontal', label: this.getLocalValue('horizontalfield', 'Horizontal', "labelform"), checked: data.horizontal, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'pointing', label: this.getLocalValue('pointingfield', 'Pointing', "labelform"), checked: data.pointing, onChange: handleChange })
            )
          )
        )
      );
    }
  }]);

  return LabelEditControl;
}(BaseEditControl);

var StaticContentEditControl = function (_BaseEditControl4) {
  _inherits(StaticContentEditControl, _BaseEditControl4);

  function StaticContentEditControl(props) {
    _classCallCheck(this, StaticContentEditControl);

    return _possibleConstructorReturn(this, (StaticContentEditControl.__proto__ || Object.getPrototypeOf(StaticContentEditControl)).call(this, props));
  }

  _createClass(StaticContentEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;
      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "staticcontentform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'style-font-size', placeholder: '20px', label: this.getLocalValue('fontsizefield', 'Font size', "staticcontentform"), value: data["style-font-size"], onChange: handleChange })
        ),
        _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'isHtml', label: this.getLocalValue('allowhtmlfield', 'Allow HTML', "staticcontentform"), checked: data.isHtml, onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.TextArea, { rows: 6, autoHeight: true, name: 'content', label: this.getLocalValue('contentfield', 'Content', "staticcontentform"), value: data.content, onChange: handleChange })
      );
    }
  }]);

  return StaticContentEditControl;
}(BaseEditControl);

var MessageEditControl = function (_BaseEditControl5) {
  _inherits(MessageEditControl, _BaseEditControl5);

  function MessageEditControl(props) {
    _classCallCheck(this, MessageEditControl);

    return _possibleConstructorReturn(this, (MessageEditControl.__proto__ || Object.getPrototypeOf(MessageEditControl)).call(this, props));
  }

  _createClass(MessageEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var sizedata = [{ text: this.getLocalValue('sizedefault', 'Default'), value: '' }, { text: this.getLocalValue('sizemini', 'Mini'), value: 'mini' }, { text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny' }, { text: this.getLocalValue('sizesmall', 'Small'), value: 'small' }, { text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium' }, { text: this.getLocalValue('sizelarge', 'Large'), value: 'large' }, { text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge' }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "messageform"), value: data.key, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'header', label: this.getLocalValue('headerfield', 'Header', "messageform"), value: data.header, onChange: handleChange })
          ),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('optionsfield', 'Options', "messageform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'compact', label: this.getLocalValue('compactfield', 'Compact', "messageform"), checked: data.compact, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'error', label: this.getLocalValue('errorfield', 'Error', "messageform"), checked: data.error, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'floating', label: this.getLocalValue('floatingfield', 'Floating', "messageform"), checked: data.floating, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'info', label: this.getLocalValue('infofield', 'Info', "messageform"), checked: data.info, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'negative', label: this.getLocalValue('negativefield', 'Negative', "messageform"), checked: data.negative, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'positive', label: this.getLocalValue('positivefield', 'Positive', "messageform"), checked: data.positive, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'success', label: this.getLocalValue('successfield', 'Success', "messageform"), checked: data.success, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'warning', label: this.getLocalValue('warningfield', 'Warning', "messageform"), checked: data.warning, onChange: handleChange })
            )
          )
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.TextArea, { name: 'content', label: this.getLocalValue('contentfield', 'Content', "messageform"), value: data.content, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'size', selection: true, fluid: true, options: sizedata, placeholder: sizedata[0].text, label: this.getLocalValue('sizefield', 'Size', "messageform"), value: data.size, onChange: handleChange })
        )
      );
    }
  }]);

  return MessageEditControl;
}(BaseEditControl);

var InputEditControl = function (_BaseEditControl6) {
  _inherits(InputEditControl, _BaseEditControl6);

  function InputEditControl(props) {
    _classCallCheck(this, InputEditControl);

    return _possibleConstructorReturn(this, (InputEditControl.__proto__ || Object.getPrototypeOf(InputEditControl)).call(this, props));
  }

  _createClass(InputEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var sizedata = [{ text: this.getLocalValue('sizedefault', 'Default'), value: '' }, { text: this.getLocalValue('sizemini', 'Mini'), value: 'mini' }, { text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny' }, { text: this.getLocalValue('sizesmall', 'Small'), value: 'small' }, { text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium' }, { text: this.getLocalValue('sizelarge', 'Large'), value: 'large' }, { text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge' }, { text: this.getLocalValue('sizemassive', 'Massive'), value: 'massive' }];

      var labelPositions = [{ text: this.getLocalValue('labeldefault', 'Default'), value: '' }, { text: this.getLocalValue('labelleft', 'Left'), value: 'left' }, { text: this.getLocalValue('labelright', 'Right'), value: 'right' }, { text: this.getLocalValue('labelleftcorner', 'Left corner'), value: 'left corner' }, { text: this.getLocalValue('labelrightcorner', 'Right corner'), value: 'right corner' }];

      var disableDateFormat = data.type !== "date" && data.type !== "datetime" && data.type !== "time";

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "inputform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'label', label: this.getLocalValue('labelfield', 'Label', "inputform"), value: data.label, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('typefield', 'Type', "inputform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              { widths: 'equal' },
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'type', label: this.getLocalValue('typetext', 'Text', "inputform"), value: 'text', checked: data.type == undefined || data.type == 'text', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'type', label: this.getLocalValue('typenumber', 'Number', "inputform"), value: 'number', checked: data.type === 'number', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'type', label: this.getLocalValue('typepasswod', 'Password', "inputform"), value: 'password', checked: data.type === 'password', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'type', label: this.getLocalValue('typefile', 'File', "inputform"), value: 'file', checked: data.type === 'file', onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              { widths: 'equal' },
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'type', label: this.getLocalValue('typedate', 'Date', "inputform"), value: 'date', checked: data.type === 'date', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'type', label: this.getLocalValue('typetime', 'Time', "inputform"), value: 'time', checked: data.type === 'time', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'type', label: this.getLocalValue('typedatetime', 'Date & Time', "inputform"), value: 'datetime', checked: data.type === 'datetime', onChange: handleChange })
            )
          ),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'labelPosition', selection: true, fluid: true, placeholder: labelPositions[0].text, options: labelPositions, label: this.getLocalValue('labelpositionfield', 'Label position', "inputform"), value: data.labelPosition, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'placeholder', label: this.getLocalValue('placeholderfield', 'Placeholder', "inputform"), value: data.placeholder, onChange: handleChange })
          )
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('optionsfield', 'Options', "inputform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              { widths: 'equal' },
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'loading', label: this.getLocalValue('loadingfield', 'Loading', "inputform"), checked: data.loading, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'inverted', label: this.getLocalValue('invertedfield', 'Inverted', "inputform"), checked: data.inverted, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'error', label: this.getLocalValue('errorfield', 'Error', "inputform"), checked: data.error, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              { widths: 'equal' },
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'disabled', label: this.getLocalValue('disabledfield', 'Disabled', "inputform"), checked: data.disabled, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'transparent', label: this.getLocalValue('transparentfield', 'Transparent', "inputform"), checked: data.transparent, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'fluid', label: this.getLocalValue('fluidfield', 'Fluid', "inputform"), checked: data.fluid, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              { widths: 'equal' },
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'readOnly', label: this.getLocalValue('readonlyfield', 'Read only', "inputform"), checked: data.readOnly, onChange: handleChange })
            )
          ),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'size', selection: true, fluid: true, options: sizedata, placeholder: sizedata[0].text, label: this.getLocalValue('sizefield', 'Size', "inputform"), value: data.size, onChange: handleChange })
          )
        )
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onClick", "onChange"];
    }
  }]);

  return InputEditControl;
}(BaseEditControl);

var TextAreaEditControl = function (_BaseEditControl7) {
  _inherits(TextAreaEditControl, _BaseEditControl7);

  function TextAreaEditControl(props) {
    _classCallCheck(this, TextAreaEditControl);

    return _possibleConstructorReturn(this, (TextAreaEditControl.__proto__ || Object.getPrototypeOf(TextAreaEditControl)).call(this, props));
  }

  _createClass(TextAreaEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;
      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "textareaform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'label', label: this.getLocalValue('labelfield', 'Label', "textareaform"), value: data.label, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'rows', placeholder: '3', type: 'number', label: this.getLocalValue('rowsfield', 'Rows', "textareaform"), value: data.rows, onChange: handleChange }),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'placeholder', label: this.getLocalValue('placeholderfield', 'Placeholder', "textareaform"), value: data.placeholder, onChange: handleChange }),
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('placeholderfield', 'Options', "textareaform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              { widths: 'equal' },
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'autoHeight', label: this.getLocalValue('autoheightfield', 'Auto height', "textareaform"), checked: data.autoHeight, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'readOnly', label: this.getLocalValue('readonlyfield', 'Read only', "textareaform"), checked: data.readOnly, onChange: handleChange })
            )
          )
        )
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onClick", "onChange"];
    }
  }]);

  return TextAreaEditControl;
}(BaseEditControl);

var SearchEditControl = function (_BaseEditControl8) {
  _inherits(SearchEditControl, _BaseEditControl8);

  function SearchEditControl(props) {
    _classCallCheck(this, SearchEditControl);

    return _possibleConstructorReturn(this, (SearchEditControl.__proto__ || Object.getPrototypeOf(SearchEditControl)).call(this, props));
  }

  _createClass(SearchEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;
      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "searchform"), value: data.key, onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'url', label: this.getLocalValue('urlfield', 'Url', "searchform"), value: data.url, onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'category', label: this.getLocalValue('categoryfield', 'Enable Categories', "searchform"), checked: Boolean(data.category), onChange: handleChange })
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onSelect"];
    }
  }]);

  return SearchEditControl;
}(BaseEditControl);

var CheckboxEditControl = function (_BaseEditControl9) {
  _inherits(CheckboxEditControl, _BaseEditControl9);

  function CheckboxEditControl(props) {
    _classCallCheck(this, CheckboxEditControl);

    return _possibleConstructorReturn(this, (CheckboxEditControl.__proto__ || Object.getPrototypeOf(CheckboxEditControl)).call(this, props));
  }

  _createClass(CheckboxEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;
      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "checkboxform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'label', label: this.getLocalValue('labelfield', 'Label', "checkboxform"), value: data.label, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: '2' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('optionsfield', 'Options', "checkboxform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'fitted', label: this.getLocalValue('fittedfield', 'Fitted', "checkboxform"), checked: data.fitted, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'indeterminate', label: this.getLocalValue('indeterminatefield', 'Indeterminate', "checkboxform"), checked: data.indeterminate, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'readOnly', label: this.getLocalValue('readonlyfield', 'ReadOnly', "checkboxform"), checked: data.readOnly, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'disabled', label: this.getLocalValue('disabledfield', 'Disabled', "checkboxform"), checked: data.disabled, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'slider', label: this.getLocalValue('sliderfield', 'Slider', "checkboxform"), checked: data.slider, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'toggle', label: this.getLocalValue('togglefield', 'Toggle', "checkboxform"), checked: data.toggle, onChange: handleChange })
            )
          )
        )
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onClick", "onChange"];
    }
  }]);

  return CheckboxEditControl;
}(BaseEditControl);

var DropdownEditControl = function (_BaseEditControl10) {
  _inherits(DropdownEditControl, _BaseEditControl10);

  function DropdownEditControl(props) {
    _classCallCheck(this, DropdownEditControl);

    return _possibleConstructorReturn(this, (DropdownEditControl.__proto__ || Object.getPrototypeOf(DropdownEditControl)).call(this, props));
  }

  _createClass(DropdownEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var labelPositions = [{ text: this.getLocalValue('labeldefault', 'Default'), value: '' }, { text: this.getLocalValue('labelleft', 'Left'), value: 'left' }, { text: this.getLocalValue('labelright', 'Right'), value: 'right' }, { text: this.getLocalValue('labelleftcorner', 'Left corner'), value: 'left corner' }, { text: this.getLocalValue('labelrightcorner', 'Right corner'), value: 'right corner' }];

      var dataColumns = [{ key: 'value', name: this.getLocalValue('datavaluecolumn', 'Value', "dropdownform") }, { key: 'text', name: this.getLocalValue('datatextcolumn', 'Text', "dropdownform") }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "dropdownform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'label', label: this.getLocalValue('labelfield', 'Label', "dropdownform"), value: data.label, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_collectioneditor2.default, { key: 'data-elements',
            draggable: true,
            columns: dataColumns,
            label: this.getLocalValue('datafield', 'Data', "dropdownform"),
            name: 'data-elements',
            value: data["data-elements"],
            onChange: handleChange }),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'placeholder', label: 'Placeholder', value: data.placeholder, onChange: handleChange }),
            _react2.default.createElement(
              'div',
              { className: 'field' },
              _react2.default.createElement(
                'label',
                null,
                this.getLocalValue('optionsfield', 'Options', "dropdownform")
              ),
              _react2.default.createElement(
                _semanticUiReact.Form.Group,
                null,
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'loading', label: this.getLocalValue('loadingfield', 'Loading', "dropdownform"), checked: data.loading, onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'error', label: this.getLocalValue('errorfield', 'Error', "dropdownform"), checked: data.error, onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'disabled', label: this.getLocalValue('disabledfield', 'Disabled', "dropdownform"), checked: data.disabled, onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'fluid', label: this.getLocalValue('fluidfield', 'Fluid', "dropdownform"), checked: data.fluid, onChange: handleChange })
              ),
              _react2.default.createElement(
                _semanticUiReact.Form.Group,
                null,
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'multiple', label: this.getLocalValue('multiplefield', 'Multiple', "dropdownform"), checked: data.multiple, onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'search', label: this.getLocalValue('searchfield', 'Search', "dropdownform"), checked: data.search, onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'selection', label: this.getLocalValue('selectionfield', 'Selection', "dropdownform"), checked: data.selection, onChange: handleChange })
              ),
              _react2.default.createElement(
                _semanticUiReact.Form.Group,
                null,
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'readOnly', label: this.getLocalValue('readonlyfield', 'Read only', "dropdownform"), checked: data.readOnly, onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'allowAddItems', label: this.getLocalValue('allowAddItemsfield', 'Allow add items', "dropdownform"), disabled: !(data.search && data.multiple), checked: data.allowAddItems, onChange: handleChange })
              )
            )
          )
        )
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onClick", "onChange"];
    }
  }]);

  return DropdownEditControl;
}(BaseEditControl);

var DictionaryEditControl = function (_BaseEditControl11) {
  _inherits(DictionaryEditControl, _BaseEditControl11);

  function DictionaryEditControl(props) {
    _classCallCheck(this, DictionaryEditControl);

    return _possibleConstructorReturn(this, (DictionaryEditControl.__proto__ || Object.getPrototypeOf(DictionaryEditControl)).call(this, props));
  }

  _createClass(DictionaryEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "dictionaryform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'label', label: this.getLocalValue('labelfield', 'Label', "dictionaryform"), value: data.label, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'dataModel', label: this.getLocalValue('datamodelfield', 'Data model', "dictionaryform"), value: data.dataModel, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'placeholder', label: this.getLocalValue('placeholderfield', 'Placeholder', "dictionaryform"), value: data.placeholder, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'columns', label: this.getLocalValue('columnsfield', 'Columns (Name ASC, Email)', "dictionaryform"), value: data.columns, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'pageSize', label: this.getLocalValue('pagesizefield', 'Page Size', "dictionaryform"), disabled: !Boolean(data.paging), value: data.pageSize, placeholder: '100', onChange: handleChange })
          ),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('optionsfield', 'Options', "dictionaryform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'paging', label: this.getLocalValue('pagingfield', 'Server pagination', "dictionaryform"), checked: data.paging, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'search', label: this.getLocalValue('searchfield', 'Search', "dictionaryform"), checked: data.search, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'multiple', label: this.getLocalValue('multiplefield', 'Multiple', "dictionaryform"), checked: data.multiple, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'readOnly', label: this.getLocalValue('readonlyfield', 'Read only', "dictionaryform"), checked: data.readOnly, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'disabled', label: this.getLocalValue('disabledfield', 'Disabled', "dictionaryform"), checked: data.disabled, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'clearable', label: this.getLocalValue('clearablefield', 'Clearable', "dictionaryform"), checked: data.clearable, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'selection', label: this.getLocalValue('selectionfield', 'Selection', "dictionaryform"), checked: data.selection, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'fluid', label: this.getLocalValue('fluidfield', 'Fluid', "dictionaryform"), checked: data.fluid, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'error', label: this.getLocalValue('errorfield', 'Error', "dictionaryform"), checked: data.error, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'loading', label: this.getLocalValue('loadingfield', 'Loading', "dictionaryform"), checked: data.loading, onChange: handleChange })
            )
          )
        )
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onChange"];
    }
  }]);

  return DictionaryEditControl;
}(BaseEditControl);

var RadioGroupEditControl = function (_BaseEditControl12) {
  _inherits(RadioGroupEditControl, _BaseEditControl12);

  function RadioGroupEditControl(props) {
    _classCallCheck(this, RadioGroupEditControl);

    return _possibleConstructorReturn(this, (RadioGroupEditControl.__proto__ || Object.getPrototypeOf(RadioGroupEditControl)).call(this, props));
  }

  _createClass(RadioGroupEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var dataColumns = [{ key: 'value', name: this.getLocalValue('datavaluecolumn', 'Value', "radiogroupform") }, { key: 'text', name: this.getLocalValue('datatextcolumn', 'Text', "radiogroupform") }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "radiogroupform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'label', label: this.getLocalValue('labelfield', 'Label', "radiogroupform"), value: data.label, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_collectioneditor2.default, { key: 'data-elements',
            draggable: true,
            columns: dataColumns,
            label: this.getLocalValue('datafield', 'Data', "radiogroupform"),
            name: 'data-elements',
            value: data["data-elements"],
            onChange: handleChange }),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('groupdirectfield', 'Group direct', "radiogroupform")
            ),
            _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'direction', label: this.getLocalValue('directiongorizontalfield', 'Gorizontal', "radiogroupform"), value: 'g', checked: data.direction === undefined || data.direction === 'g', onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'direction', label: this.getLocalValue('directionverticalfield', 'Vertical', "radiogroupform"), value: 'v', checked: data.direction === 'v', onChange: handleChange }),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'readOnly', label: this.getLocalValue('readonlyfield', 'Read only', "radiogroupform"), checked: data.readOnly, onChange: handleChange })
            )
          )
        )
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onClick", "onChange"];
    }
  }]);

  return RadioGroupEditControl;
}(BaseEditControl);

var FormEditControl = function (_BaseEditControl13) {
  _inherits(FormEditControl, _BaseEditControl13);

  function FormEditControl(props) {
    _classCallCheck(this, FormEditControl);

    return _possibleConstructorReturn(this, (FormEditControl.__proto__ || Object.getPrototypeOf(FormEditControl)).call(this, props));
  }

  _createClass(FormEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var sizedata = [{ text: this.getLocalValue('sizedefault', 'Default'), value: '' }, { text: this.getLocalValue('sizemini', 'Mini'), value: 'mini' }, { text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny' }, { text: this.getLocalValue('sizesmall', 'Small'), value: 'small' }, { text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium' }, { text: this.getLocalValue('sizelarge', 'Large'), value: 'large' }, { text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge' }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "form"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'size', selection: true, fluid: true, options: sizedata, placeholder: sizedata[0].text, label: this.getLocalValue('sizefield', 'Size', "form"), value: data.size, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: '2' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('optionsfield', 'Options', "form")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'loading', label: this.getLocalValue('loadingfield', 'Loading', "form"), checked: data.loading, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'error', label: this.getLocalValue('errorfield', 'Error', "form"), checked: data.error, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'inverted', label: this.getLocalValue('invertedfield', 'Inverted', "form"), checked: data.inverted, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'reply', label: this.getLocalValue('replyfield', 'Reply', "form"), checked: data.reply, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'success', label: this.getLocalValue('successfield', 'Success', "form"), checked: data.success, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'warning', label: this.getLocalValue('warningfield', 'Warning', "form"), checked: data.warning, onChange: handleChange })
            )
          )
        )
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onSubmit"];
    }
  }]);

  return FormEditControl;
}(BaseEditControl);

var FormGroupEditControl = function (_BaseEditControl14) {
  _inherits(FormGroupEditControl, _BaseEditControl14);

  function FormGroupEditControl(props) {
    _classCallCheck(this, FormGroupEditControl);

    return _possibleConstructorReturn(this, (FormGroupEditControl.__proto__ || Object.getPrototypeOf(FormGroupEditControl)).call(this, props));
  }

  _createClass(FormGroupEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "formgroupform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('widthsfield', 'Widths', "formgroupform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'widths', label: this.getLocalValue('widthsdefaultfield', 'Default', "formgroupform"), checked: data.widths === undefined, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'widths', label: this.getLocalValue('widthsequalfield', 'Equal', "formgroupform"), value: 'equal', checked: data.widths === 'equal', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'widths', label: this.getLocalValue('widthscustomfield', 'Custom (1 - 16)', "formgroupform"), value: 'custom', checked: data.widths === 'custom', onChange: handleChange })
            )
          )
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: '2' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('typefield', 'Type', "formgroupform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              { inline: true },
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'orientation', label: this.getLocalValue('orientationcolumnsfield', 'Columns', "formgroupform"), value: 'inline', checked: data.orientation === undefined || data.orientation === 'inline', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'orientation', label: this.getLocalValue('orientationrowsfield', 'Rows', "formgroupform"), value: 'grouped', checked: data.orientation === "grouped", onChange: handleChange })
            )
          ),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'widthsCustom', disabled: data.widths !== 'custom', placeholder: '2', value: data.widthsCustom, onChange: handleChange })
        )
      );
    }
  }]);

  return FormGroupEditControl;
}(BaseEditControl);

var ContainerEditControl = function (_BaseEditControl15) {
  _inherits(ContainerEditControl, _BaseEditControl15);

  function ContainerEditControl(props) {
    _classCallCheck(this, ContainerEditControl);

    return _possibleConstructorReturn(this, (ContainerEditControl.__proto__ || Object.getPrototypeOf(ContainerEditControl)).call(this, props));
  }

  _createClass(ContainerEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var floatdata = [{ text: this.getLocalValue('floatnonefield', 'None', "containerform"), value: '' }, { text: this.getLocalValue('floatleftfield', 'Left', "containerform"), value: 'left' }, { text: this.getLocalValue('floatrightfield', 'Right', "containerform"), value: 'right' }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "containerform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'style-float', selection: true, fluid: true, options: floatdata, placeholder: floatdata[0].text, label: this.getLocalValue('floatfield', 'Float', "containerform"), value: data["style-float"], onChange: handleChange })
        )
      );
    }
  }]);

  return ContainerEditControl;
}(BaseEditControl);

var ImageEditControl = function (_BaseEditControl16) {
  _inherits(ImageEditControl, _BaseEditControl16);

  function ImageEditControl(props) {
    _classCallCheck(this, ImageEditControl);

    return _possibleConstructorReturn(this, (ImageEditControl.__proto__ || Object.getPrototypeOf(ImageEditControl)).call(this, props));
  }

  _createClass(ImageEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "imageform"), value: data.key, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'src', label: this.getLocalValue('srcfield', 'Src', "imageform"), value: data.src, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'href', label: this.getLocalValue('hreffield', 'Href', "imageform"), value: data.href, onChange: handleChange })
          ),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'div',
              { className: 'field' },
              _react2.default.createElement(
                'label',
                null,
                this.getLocalValue('optionsfield', 'Options', "imageform")
              ),
              _react2.default.createElement(
                _semanticUiReact.Form.Group,
                null,
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'avatar', label: this.getLocalValue('avatarfield', 'Avatar', "imageform"), checked: data.avatar, onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'bordered', label: this.getLocalValue('borderedfield', 'Bordered', "imageform"), checked: data.bordered, onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'centered', label: this.getLocalValue('centeredfield', 'Centered', "imageform"), checked: data.centered, onChange: handleChange })
              ),
              _react2.default.createElement(
                _semanticUiReact.Form.Group,
                null,
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'disabled', label: this.getLocalValue('disabledfield', 'Disabled', "imageform"), checked: data.disabled, onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'inline', label: this.getLocalValue('inlinefield', 'Inline', "imageform"), checked: data.inline, onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'spaced', label: this.getLocalValue('spacedfield', 'Spaced', "imageform"), checked: data.spaced, onChange: handleChange })
              )
            ),
            _react2.default.createElement(
              'div',
              { className: 'field' },
              _react2.default.createElement(
                'label',
                null,
                this.getLocalValue('floatedfield', 'Floated', "imageform")
              ),
              _react2.default.createElement(
                _semanticUiReact.Form.Group,
                null,
                _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'floated', label: this.getLocalValue('floatedleftfield', 'Left', "imageform"), value: 'left', checked: data.floated === 'left' || data.floated === '', onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'floated', label: this.getLocalValue('floatedrightfield', 'Right', "imageform"), value: 'right', checked: data.floated === 'right', onChange: handleChange })
              ),
              _react2.default.createElement(
                'label',
                null,
                this.getLocalValue('verticalalignfield', 'Vertical align', "imageform")
              ),
              _react2.default.createElement(
                _semanticUiReact.Form.Group,
                null,
                _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'verticalAlign', label: this.getLocalValue('verticalaligntopfield', 'Top', "imageform"), value: 'top', checked: data.verticalAlign === 'top', onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'verticalAlign', label: this.getLocalValue('verticalalignmiddlefield', 'Middle', "imageform"), value: 'middle', checked: data.verticalAlign === 'middle', onChange: handleChange }),
                _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'verticalAlign', label: this.getLocalValue('verticalalignbottomfield', 'Bottom', "imageform"), value: 'bottom', checked: data.verticalAlign === 'bottom', onChange: handleChange })
              )
            )
          )
        )
      );
    }
  }]);

  return ImageEditControl;
}(BaseEditControl);

var StatisticEditControl = function (_BaseEditControl17) {
  _inherits(StatisticEditControl, _BaseEditControl17);

  function StatisticEditControl(props) {
    _classCallCheck(this, StatisticEditControl);

    return _possibleConstructorReturn(this, (StatisticEditControl.__proto__ || Object.getPrototypeOf(StatisticEditControl)).call(this, props));
  }

  _createClass(StatisticEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var sizedata = [{ text: this.getLocalValue('sizedefault', 'Default'), value: '' }, { text: this.getLocalValue('sizemini', 'Mini'), value: 'mini' }, { text: this.getLocalValue('sizetiny', 'Tiny'), value: 'tiny' }, { text: this.getLocalValue('sizesmall', 'Small'), value: 'small' }, { text: this.getLocalValue('sizemedium', 'Medium'), value: 'medium' }, { text: this.getLocalValue('sizelarge', 'Large'), value: 'large' }, { text: this.getLocalValue('sizehuge', 'Huge'), value: 'huge' }];

      var datacolumns = [{ key: 'label', name: this.getLocalValue('datakeycolumn', 'Label', "statisticform") }, { key: 'value', name: this.getLocalValue('datavaluecolumn', 'Value', "statisticform") }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "statisticform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('optionsfield', 'Options', "statisticform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'floated', label: this.getLocalValue('floatedfield', 'Floated', "statisticform"), checked: data.floated, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'horizontal', label: this.getLocalValue('horizontalfield', 'Horizontal', "statisticform"), checked: data.horizontal, onChange: handleChange })
            )
          )
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_collectioneditor2.default, { key: 'data-elements',
            columns: datacolumns,
            label: this.getLocalValue('datafield', 'Data', "statisticform"),
            name: 'data-elements',
            value: data["data-elements"],
            onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'size', selection: true, fluid: true, options: sizedata, placeholder: sizedata[0].text, label: this.getLocalValue('sizefield', 'Size', "statisticform"), value: data.size, onChange: handleChange })
        )
      );
    }
  }]);

  return StatisticEditControl;
}(BaseEditControl);

var GridEditControl = function (_BaseEditControl18) {
  _inherits(GridEditControl, _BaseEditControl18);

  function GridEditControl(props) {
    _classCallCheck(this, GridEditControl);

    return _possibleConstructorReturn(this, (GridEditControl.__proto__ || Object.getPrototypeOf(GridEditControl)).call(this, props));
  }

  _createClass(GridEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var pagertype = [{ value: "", text: this.getLocalValue('pagertypenonefield', 'None', "gridform") }, { value: "server", text: this.getLocalValue('pagertypeserverfield', 'Server', "gridform") }];

      var editformtype = [{ value: "", text: this.getLocalValue('editformtypedefaultfield', 'Default', "gridform") }, { value: "modal", text: this.getLocalValue('editformtypemodalfield', 'Modal', "gridform") }];

      var columns = [{ key: 'key', name: this.getLocalValue('keycolumn', 'Key', "gridform") }, { key: 'name', name: this.getLocalValue('namecolumn', 'Name', "gridform") }, { key: 'type', name: this.getLocalValue('typecolumn', 'Type', "gridform"), dataList: ["", "number", "checkbox", "date", "datetime", "time", "custom"] }, { key: 'width', name: this.getLocalValue('widthcolumn', 'Width', "gridform"), control: 'number' }, { key: 'resizable', name: this.getLocalValue('resizablecolumn', 'Resizable', "gridform"), control: "checkbox" }];

      var editTypeItems = [{ key: "form", text: "Form", value: undefined }, { key: "flow", text: "Flow", value: "flow" }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "gridform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('optionsfield', 'Options', "gridform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'multiselect', label: this.getLocalValue('multiselectfield', 'Multiselect', "gridform"), checked: data.multiselect, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'disableSort', label: this.getLocalValue('disablesortfield', 'Disable sorting', "gridform"), checked: data.disableSort, onChange: handleChange })
            )
          )
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              { widths: 'equal' },
              _react2.default.createElement(_radiogroup2.default, {
                name: 'editType',
                label: this.getLocalValue('edittypefield', 'Edit type', "gridform"),
                items: editTypeItems,
                value: data.editType,
                onChange: handleChange }),
              data.editType != "flow" && _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'editForm', label: this.getLocalValue('editformfield', 'Edit form', "gridform"), disabled: data.inline == true, value: data.editForm, onChange: handleChange }),
              data.editType == "flow" && _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'editFlow', label: this.getLocalValue('editflowfield', 'Edit flow', "gridform"), disabled: data.inline == true, value: data.editFlow, onChange: handleChange })
            ),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'rowKey', label: this.getLocalValue('rowkeyfield', 'Row key', "gridform"), value: data.rowKey, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'pageSize', label: this.getLocalValue('pagesizefield', 'Page size', "gridform"), value: data.pageSize, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'defaultSort', label: this.getLocalValue('defaultsortfield', 'Default sort', "gridform"), placeholder: 'Name ASC', value: data.defaultSort, onChange: handleChange })
          ),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'editFormShowType', selection: true, fluid: true, label: this.getLocalValue('editformshowtypefield', 'Edit form show type', "gridform"), placeholder: editformtype[0].text, options: editformtype, value: data.editFormShowType, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'pagerType', selection: true, fluid: true, label: this.getLocalValue('pagertypefield', 'Pagination type', "gridform"), placeholder: 'None', options: pagertype, value: data.pagerType, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'rowHeight', label: this.getLocalValue('rowheightfield', 'Row height', "gridform"), value: data.rowHeight, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'minHeight', label: this.getLocalValue('minheightfield', 'Min height', "gridform"), value: data.minHeight, onChange: handleChange }),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              { widths: 'equal' },
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'autoHeight', label: this.getLocalValue('autoheightfield', 'Auto Height', "gridform"), checked: Boolean(data.autoHeight), onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'offSet', label: this.getLocalValue('offsetfield', 'OffSet', "gridform"), disabled: !Boolean(data.autoHeight), value: data.offSet, onChange: handleChange })
            )
          )
        ),
        _react2.default.createElement(
          'div',
          { className: 'field' },
          _react2.default.createElement(_collectioneditor2.default, { key: 'columns',
            draggable: true,
            columns: columns,
            label: this.getLocalValue('columnsfield', 'Columns', "gridform"),
            name: 'columns',
            value: data["columns"],
            onChange: handleChange })
        )
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onRowClick", "onRowDblClick", "onSelectionChanged"];
    }
  }]);

  return GridEditControl;
}(BaseEditControl);

var CollectionEditorEditControl = function (_BaseEditControl19) {
  _inherits(CollectionEditorEditControl, _BaseEditControl19);

  function CollectionEditorEditControl(props) {
    _classCallCheck(this, CollectionEditorEditControl);

    return _possibleConstructorReturn(this, (CollectionEditorEditControl.__proto__ || Object.getPrototypeOf(CollectionEditorEditControl)).call(this, props));
  }

  _createClass(CollectionEditorEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var me = this;
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var columns = [{ key: 'key', name: this.getLocalValue('keycolumn', 'Key', "collectioneditorform") }, { key: 'name', name: this.getLocalValue('namecolumn', 'Name', "collectioneditorform") }, { key: 'control', name: this.getLocalValue('controlcolumn', 'Control', "collectioneditorform"), dataList: ["input", "checkbox", "span", "number", "file", "date", "datetime", "custom"] }, { key: 'width', name: this.getLocalValue('widthcolumn', 'Width', "collectioneditorform") }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "collectioneditorform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'idField', label: this.getLocalValue('idfield', 'Id field', "collectioneditorform"), disabled: data.hierarchical != true, value: data.idField, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('optionsfield', 'Options', "collectioneditorform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'readOnly', label: this.getLocalValue('readonlyfield', 'ReadOnly', "collectioneditorform"), checked: data.readOnly, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'draggable', label: this.getLocalValue('draggablefield', 'Draggable', "collectioneditorform"), checked: data.draggable, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'hierarchical', label: this.getLocalValue('hierarchicalfield', 'Hierarchical', "collectioneditorform"), checked: data.hierarchical, onChange: handleChange })
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'disableAdd', label: this.getLocalValue('disableAdd', 'Disable Add', "collectioneditorform"), checked: data.disableAdd, onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'collapseAll', label: this.getLocalValue('collapseallfield', 'Collapse all', "collectioneditorform"), disabled: data.hierarchical != true, checked: data.collapseAll, onChange: handleChange })
            )
          ),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'parentIdField', label: this.getLocalValue('parentidfield', 'ParentId field', "collectioneditorform"), disabled: data.hierarchical != true, value: data.parentIdField, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'childrenField', label: this.getLocalValue('childrenField', 'Children field', "collectioneditorform"), disabled: data.hierarchical != true || data.parentIdField !== undefined && data.parentIdField !== "", value: data.childrenField, onChange: handleChange })
          )
        ),
        _react2.default.createElement(_collectioneditor2.default, { key: 'columns',
          columns: columns,
          label: this.getLocalValue('columnsfield', 'Columns', "collectioneditorform"),
          name: 'columns',
          value: data["columns"],
          height: '200px',
          onChange: handleChange })
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onChange", "onAdd", "onDelete"];
    }
  }]);

  return CollectionEditorEditControl;
}(BaseEditControl);

var CustomEditControl = function (_BaseEditControl20) {
  _inherits(CustomEditControl, _BaseEditControl20);

  function CustomEditControl(props) {
    _classCallCheck(this, CustomEditControl);

    return _possibleConstructorReturn(this, (CustomEditControl.__proto__ || Object.getPrototypeOf(CustomEditControl)).call(this, props));
  }

  _createClass(CustomEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;
      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "customform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'type', label: this.getLocalValue('typefield', 'Type control', "customform"), value: data.type, onChange: handleChange })
        ),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.TextArea, { key: 'props', label: this.getLocalValue('propsfield', 'Props', "customform"), name: 'props',
            value: data["props"],
            onChange: handleChange,
            rows: 5 }),
          _react2.default.createElement(_semanticUiReact.Form.TextArea, { key: 'children', label: this.getLocalValue('childrenfield', 'Children', "customform"), name: 'children',
            value: data["children"],
            onChange: handleChange,
            rows: 5 })
        )
      );
    }
  }]);

  return CustomEditControl;
}(BaseEditControl);

var CustomBlockEditControl = function (_BaseEditControl21) {
  _inherits(CustomBlockEditControl, _BaseEditControl21);

  function CustomBlockEditControl(props) {
    _classCallCheck(this, CustomBlockEditControl);

    return _possibleConstructorReturn(this, (CustomBlockEditControl.__proto__ || Object.getPrototypeOf(CustomBlockEditControl)).call(this, props));
  }

  _createClass(CustomBlockEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "customblockform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(
              'label',
              null,
              this.getLocalValue('sourcetypefield', 'Source type', "customblockform")
            ),
            _react2.default.createElement(
              _semanticUiReact.Form.Group,
              null,
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'sourceType', label: this.getLocalValue('sourcetypeformfield', 'Form name', "customblockform"), value: 'form', checked: data.sourceType === undefined || data.sourceType == 'form', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'sourceType', label: this.getLocalValue('sourcetypejsonfield', 'JSON source', "customblockform"), value: 'source', checked: data.sourceType === 'source', onChange: handleChange }),
              _react2.default.createElement(_semanticUiReact.Form.Radio, { name: 'sourceType', label: this.getLocalValue('placeholderfield', 'Placeholder', "customblockform"), value: 'placeholder', checked: data.sourceType === 'placeholder', onChange: handleChange })
            )
          )
        ),
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'formname', label: this.getLocalValue('formnamefield', 'Form name', "customblockform"), value: data.formname, onChange: handleChange,
          disabled: data.sourceType != undefined && data.sourceType != 'form' }),
        _react2.default.createElement(_semanticUiReact.Form.TextArea, { key: 'source', label: this.getLocalValue('sourcefield', 'JSON source', "customblockform"), name: 'source',
          value: data["source"], onChange: handleChange, rows: 10,
          disabled: data.sourceType != 'source' })
      );
    }
  }]);

  return CustomBlockEditControl;
}(BaseEditControl);

var MenuEditControl = function (_BaseEditControl22) {
  _inherits(MenuEditControl, _BaseEditControl22);

  function MenuEditControl(props) {
    _classCallCheck(this, MenuEditControl);

    return _possibleConstructorReturn(this, (MenuEditControl.__proto__ || Object.getPrototypeOf(MenuEditControl)).call(this, props));
  }

  _createClass(MenuEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var columns = [{ key: 'target', name: this.getLocalValue('itemstargetcolumn', 'Target', "menuform"), width: 150 }, { key: 'title', name: this.getLocalValue('itemstitlecolumn', 'Title', "menuform") }, { key: 'visibleCondition', name: this.getLocalValue('visibleConditioncolumn', 'Visible Condition', "menuform") }];
      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "menuform"), value: data.key, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'activeItem', label: this.getLocalValue('activeitemfield', 'Active Item', "menuform"), value: data.activeItem, onChange: handleChange })
        ),
        _react2.default.createElement(
          'div',
          { className: 'field' },
          _react2.default.createElement(
            'label',
            null,
            this.getLocalValue('optionsfield', 'Options', "menuform")
          ),
          _react2.default.createElement(
            _semanticUiReact.Form.Group,
            null,
            _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'pointing', label: this.getLocalValue('pointingfield', 'Pointing', "menuform"), checked: data.pointing, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'secondary', label: this.getLocalValue('secondaryfield', 'Secondary', "menuform"), checked: data.secondary, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'tabular', label: this.getLocalValue('tabularfield', 'Tabular', "menuform"), checked: data.tabular, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'fluid', label: this.getLocalValue('fluidfield', 'Fluid', "menuform"), checked: data.fluid, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'vertical', label: this.getLocalValue('verticalfield', 'Vertical', "menuform"), checked: data.vertical, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'link', label: this.getLocalValue('linkfield', 'Link', "menuform"), checked: data.link, onChange: handleChange })
          )
        ),
        _react2.default.createElement(_collectioneditor2.default, { key: 'items',
          draggable: true,
          hierarchical: true,
          childrenField: 'children',
          columns: columns,
          label: this.getLocalValue('itemsfield', 'Items', "menuform"),
          name: 'items',
          value: data["items"],
          onChange: handleChange })
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onItemClick"];
    }
  }]);

  return MenuEditControl;
}(BaseEditControl);

var BreadcrumbEditControl = function (_BaseEditControl23) {
  _inherits(BreadcrumbEditControl, _BaseEditControl23);

  function BreadcrumbEditControl(props) {
    _classCallCheck(this, BreadcrumbEditControl);

    return _possibleConstructorReturn(this, (BreadcrumbEditControl.__proto__ || Object.getPrototypeOf(BreadcrumbEditControl)).call(this, props));
  }

  _createClass(BreadcrumbEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var columns = [{ key: 'text', name: this.getLocalValue('itemstextcolumn', 'Text', "breadcrumbform") }, { key: 'url', name: this.getLocalValue('itemsurlcolumn', 'Url', "breadcrumbform") }, { key: 'active', control: 'checkbox', name: this.getLocalValue('itemsactivecolumn', 'Active', "breadcrumbform") }, { key: 'divider', name: this.getLocalValue('itemsiconcolumn', 'Divider Icon', "breadcrumbform"), dataList: ["right angle", "right chevron"] }];
      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "breadcrumbform"), value: data.key, onChange: handleChange })
        ),
        _react2.default.createElement(_collectioneditor2.default, { key: 'items',
          draggable: true,
          columns: columns,
          label: this.getLocalValue('itemsfield', 'Items', "breadcrumbform"),
          name: 'items',
          value: data["items"],
          onChange: handleChange })
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onItemClick"];
    }
  }]);

  return BreadcrumbEditControl;
}(BaseEditControl);

var DropdownTriggerEditControl = function (_BaseEditControl24) {
  _inherits(DropdownTriggerEditControl, _BaseEditControl24);

  function DropdownTriggerEditControl(props) {
    _classCallCheck(this, DropdownTriggerEditControl);

    return _possibleConstructorReturn(this, (DropdownTriggerEditControl.__proto__ || Object.getPrototypeOf(DropdownTriggerEditControl)).call(this, props));
  }

  _createClass(DropdownTriggerEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      var columns = [{ key: 'target', name: this.getLocalValue('itemstargetcolumn', 'Target', "dropdowntriggerform") }, { key: 'title', name: this.getLocalValue('itemstitlecolumn', 'Title', "dropdowntriggerform") }, { key: 'visibleCondition', name: this.getLocalValue('itemsvisibleconditioncolumn', 'Visible Condition', "dropdowntriggerform") }];

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "dropdowntriggerform"), value: data.key, onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'defaultValue', label: this.getLocalValue('defaultvaluefield', 'Default Value', "dropdowntriggerform"), value: data.defaultValue == undefined ? "" : data.defaultValue, onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'imageUrl', label: this.getLocalValue('imageurlfield', 'ImageUrl', "dropdowntriggerform"), value: data.imageUrl == undefined ? "" : data.imageUrl, onChange: handleChange }),
        _react2.default.createElement(_collectioneditor2.default, { key: 'items',
          draggable: true,
          columns: columns,
          label: this.getLocalValue('itemsfield', 'Items', "dropdowntriggerform"),
          name: 'items',
          value: data["items"],
          onChange: handleChange })
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onItemClick"];
    }
  }]);

  return DropdownTriggerEditControl;
}(BaseEditControl);

var DropzoneEditControl = function (_BaseEditControl25) {
  _inherits(DropzoneEditControl, _BaseEditControl25);

  function DropzoneEditControl(props) {
    _classCallCheck(this, DropzoneEditControl);

    return _possibleConstructorReturn(this, (DropzoneEditControl.__proto__ || Object.getPrototypeOf(DropzoneEditControl)).call(this, props));
  }

  _createClass(DropzoneEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);
      var data = this.props.data;

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "uploadform"), value: data.key, onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'iconFiletypes', label: this.getLocalValue('iconFiletypes', 'Icon file types', "uploadform"), placeholder: '*.png, *.jpg, *.gif', value: data.iconFiletypes == undefined ? "" : data.iconFiletypes, onChange: handleChange }),
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          null,
          _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'showFiletypeIcon', label: this.getLocalValue('showFiletypeIcon', 'Show file type icon', "uploadform"), checked: data.showFiletypeIcon, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'autoProcessQueue', label: this.getLocalValue('autoProcessQueue', 'Auto process queue', "uploadform"), checked: data.autoProcessQueue, onChange: handleChange }),
          _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'addRemoveLinks', label: this.getLocalValue('addRemoveLinks', 'Add remove links', "uploadform"), checked: data.addRemoveLinks, onChange: handleChange })
        )
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["success"];
    }
  }]);

  return DropzoneEditControl;
}(BaseEditControl);

//----------
//Chart
//----------


var ChartEditControl = function (_BaseEditControl26) {
  _inherits(ChartEditControl, _BaseEditControl26);

  function ChartEditControl(props) {
    _classCallCheck(this, ChartEditControl);

    return _possibleConstructorReturn(this, (ChartEditControl.__proto__ || Object.getPrototypeOf(ChartEditControl)).call(this, props));
  }

  _createClass(ChartEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);

      var legendPositionOptions = [{ value: "", text: this.getLocalValue('legendpositiondefaultfield', 'Default', "chartform") }, { value: "top", text: this.getLocalValue('legendpositiontopfield', 'Top', "chartform") }, { value: "left", text: this.getLocalValue('legendpositionleftfield', 'Left', "chartform") }, { value: "bottom", text: this.getLocalValue('legendpositionbottomfield', 'Bottom', "chartform") }, { value: "right", text: this.getLocalValue('legendpositionrightfield', 'Right', "chartform") }];

      var disableCustom = data.datasetCustom == "" || data.datasetCustom == undefined;
      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          { widths: 'equal' },
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "chartform"), value: data.key, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'title', label: this.getLocalValue('titlefield', 'Title', "chartform"), value: data.title, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'titleSize', label: this.getLocalValue('titlesizefield', 'Title size', "chartform"), value: data.titleSize, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Dropdown, { name: 'legendPosition', selection: true, fluid: true, label: this.getLocalValue('legendpositionfield', 'Legend position', "chartform"), placeholder: legendPositionOptions[0].text, options: legendPositionOptions, value: data.legendPosition, onChange: handleChange })
          ),
          _react2.default.createElement(
            'div',
            { className: 'field' },
            _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'responsive', label: this.getLocalValue('responsivefield', 'Responsive', "chartform"), checked: data.responsive, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'datasetCustom', label: this.getLocalValue('datasetcustomfield', 'Dataset custom', "chartform"), checked: data.datasetCustom, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'dataLabels', style: { paddingTop: "5px" }, disabled: disableCustom, placeholder: this.getLocalValue('datalabelsplaceholder', 'Q1, Q2, Q3, Q4', "chartform"),
              label: this.getLocalValue('datalabelsfield', 'Data labels', "chartform"), value: data.dataLabels, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'datasetLabel', disabled: disableCustom, label: this.getLocalValue('datasetlabelfield', 'Dataset Label', "chartform"), value: data.datasetLabel, onChange: handleChange }),
            _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'datasetBackgroundColor', disabled: disableCustom, label: this.getLocalValue('datasetbackgroundcolorfield', 'Dataset BackgroundColor', "chartform"), value: data.datasetBackgroundColor, onChange: handleChange })
          )
        )
      );
    }
  }]);

  return ChartEditControl;
}(BaseEditControl);

//----------
//Workflow
//----------


var WorkflowBarEditControl = function (_BaseEditControl27) {
  _inherits(WorkflowBarEditControl, _BaseEditControl27);

  function WorkflowBarEditControl(props) {
    _classCallCheck(this, WorkflowBarEditControl);

    return _possibleConstructorReturn(this, (WorkflowBarEditControl.__proto__ || Object.getPrototypeOf(WorkflowBarEditControl)).call(this, props));
  }

  _createClass(WorkflowBarEditControl, [{
    key: 'getGeneralDescription',
    value: function getGeneralDescription() {
      var data = this.props.data;
      var handleChange = this.props.parent.handleChange.bind(this.props.parent);

      return _react2.default.createElement(
        _semanticUiReact.Form,
        null,
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'key', label: this.getLocalValue('namefield', 'Name', "workflowform"), value: data.key, onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.Input, { name: 'setStateButton', label: this.getLocalValue('setstatebuttonfield', 'Set state button', "workflowform"), value: data.setStateButton, onChange: handleChange }),
        _react2.default.createElement(_semanticUiReact.Form.Checkbox, { name: 'blockSetState', label: this.getLocalValue('blocksetstatefield', 'Block SetState', "workflowform"), checked: Boolean(data.blockSetState), onChange: handleChange })
      );
    }
  }, {
    key: 'getEventsList',
    value: function getEventsList() {
      return ["onCommandClick", "onSetStateClick", "onReceivedCommands"];
    }
  }]);

  return WorkflowBarEditControl;
}(BaseEditControl);

module.exports = {
  BaseEditControl: BaseEditControl,
  HeaderEditControl: HeaderEditControl,
  ButtonEditControl: ButtonEditControl,
  LabelEditControl: LabelEditControl,
  MessageEditControl: MessageEditControl,
  InputEditControl: InputEditControl,
  TextAreaEditControl: TextAreaEditControl,
  DropdownEditControl: DropdownEditControl,
  DictionaryEditControl: DictionaryEditControl,
  RadioGroupEditControl: RadioGroupEditControl,
  CheckboxEditControl: CheckboxEditControl,
  FormEditControl: FormEditControl,
  FormGroupEditControl: FormGroupEditControl,
  ImageEditControl: ImageEditControl,
  StatisticEditControl: StatisticEditControl,
  GridEditControl: GridEditControl,
  CustomEditControl: CustomEditControl,
  MenuEditControl: MenuEditControl,
  ChartEditControl: ChartEditControl,
  WorkflowBarEditControl: WorkflowBarEditControl,
  ContainerEditControl: ContainerEditControl,
  StaticContentEditControl: StaticContentEditControl,
  CollectionEditorEditControl: CollectionEditorEditControl,
  CustomBlockEditControl: CustomBlockEditControl,
  DropdownTriggerEditControl: DropdownTriggerEditControl,
  DropzoneEditControl: DropzoneEditControl,
  BreadcrumbEditControl: BreadcrumbEditControl,
  SearchEditControl: SearchEditControl
};

/***/ }),
/* 10 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var Upload = function (_React$Component) {
  _inherits(Upload, _React$Component);

  function Upload(props) {
    _classCallCheck(this, Upload);

    var _this = _possibleConstructorReturn(this, (Upload.__proto__ || Object.getPrototypeOf(Upload)).call(this, props));

    _this.state = {};
    return _this;
  }

  _createClass(Upload, [{
    key: "render",
    value: function render() {
      var type = this.props.type;
      var controls = [];
      var isForm = this.props.isForm;
      var token = this.props.value;

      if (token != undefined && token != null && token != "") {
        var downloadtext = "Download";
        var cleartext = "Clear";
        if (window.CloverAdminLang != undefined && window.CloverAdminLang.button != undefined) {
          downloadtext = window.CloverAdminLang.button.download;
          cleartext = window.CloverAdminLang.button.clear;
        }

        var isHideClear = this.props.disabled || this.props.readOnly || this.props.hideClearButton;
        controls.push(_react2.default.createElement(
          "a",
          { key: "download", className: "ui button", target: "blank", href: this.props.downloadUrl + token },
          downloadtext
        ));

        if (!isHideClear) {
          controls.push(_react2.default.createElement(
            "span",
            { key: "sparator" },
            "\xA0\xA0"
          ));
          controls.push(_react2.default.createElement(
            "button",
            { key: "clear", className: "ui button", onClick: this.onClear.bind(this) },
            cleartext
          ));
        }
      } else {
        if (this.props.disabled || this.props.readOnly) controls.push(_react2.default.createElement("span", null));else controls.push(_react2.default.createElement("input", { key: "uploadcontrol", type: "file", name: this.props.name, onChange: this.onChange.bind(this) }));
      }

      var res = undefined;
      if (isForm) {
        res = _react2.default.createElement(
          "div",
          { className: "field" },
          this.props.label != undefined && _react2.default.createElement(
            "label",
            null,
            this.props.label
          ),
          _react2.default.createElement(
            "div",
            { "data-buildertype": type },
            controls
          )
        );
      } else {
        res = _react2.default.createElement(
          "div",
          { "data-buildertype": type },
          this.props.label != undefined && _react2.default.createElement(
            "div",
            { className: "ui label label" },
            this.props.label
          ),
          controls
        );
      }

      return res;
    }
  }, {
    key: "onChange",
    value: function onChange(e) {
      var me = this;
      var formdata = new FormData();
      formdata.append(me.props.name, e.target.files[0]);

      $.ajax({
        url: me.props.uploadUrl,
        type: 'POST',
        processData: false,
        contentType: false,
        dataType: 'json',
        data: formdata,
        success: function success(jsonData) {
          if (jsonData.success == true) {
            if (me.props.onChange != undefined) {
              me.props.onChange(e, { name: me.props.name, value: jsonData.message });
            }
          }
        }
      });
    }
  }, {
    key: "onClear",
    value: function onClear() {
      if (this.props.onChange != undefined) this.props.onChange(undefined, { name: this.props.name, value: null });
    }
  }]);

  return Upload;
}(_react2.default.Component);

exports.default = Upload;

/***/ }),
/* 11 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _reactDatepicker = __webpack_require__(18);

var _reactDatepicker2 = _interopRequireDefault(_reactDatepicker);

var _moment = __webpack_require__(12);

var _moment2 = _interopRequireDefault(_moment);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var DatePicker = function (_React$Component) {
  _inherits(DatePicker, _React$Component);

  function DatePicker(props) {
    _classCallCheck(this, DatePicker);

    var _this = _possibleConstructorReturn(this, (DatePicker.__proto__ || Object.getPrototypeOf(DatePicker)).call(this, props));

    _this.state = {};
    return _this;
  }

  _createClass(DatePicker, [{
    key: 'render',
    value: function render() {
      var _this2 = this;

      var type = this.props.type;
      var isForm = this.props.isForm;
      var date = this.props.value ? (0, _moment2.default)(this.props.value) : undefined;

      var controlProps = {};
      controlProps.readOnly = this.props.readOnly;

      if (type === "date") {
        if (window.CloverLang !== undefined && window.CloverLang.common != undefined && window.CloverLang.common.dateFormat != undefined) {
          controlProps.dateFormat = window.CloverLang.common.dateFormat;
        } else {
          controlProps.dateFormat = "DD.MM.YYYY";
        }
      } else if (type === "time") {
        controlProps.showTimeSelect = true;
        controlProps.showTimeSelectOnly = true;
        controlProps.timeIntervals = 10;
        if (window.CloverLang !== undefined && window.CloverLang.common !== undefined && window.CloverLang.common.timeFormat != undefined) {
          controlProps.dateFormat = window.CloverLang.common.timeFormat;
        } else {
          controlProps.dateFormat = "HH:mm";
          controlProps.timeFormat = "HH:mm";
        }
      } else if (type === "datetime") {
        controlProps.showTimeSelect = true;
        if (window.CloverLang !== undefined && window.CloverLang.common !== undefined && window.CloverLang.common.dateFormat != undefined) {
          controlProps.timeFormat = window.CloverLang.common.timeFormat;
          controlProps.dateFormat = window.CloverLang.common.dateFormat + " " + (window.CloverLang.common.timeFormat == undefined ? "HH:ss" : window.CloverLang.common.timeFormat);
        } else {
          controlProps.dateFormat = "DD.MM.YYYY HH:mm";
          controlProps.timeFormat = "HH:mm";
        }
      }

      if (this.props.dateFormat != undefined && this.props.dateFormat != "") controlProps.dateFormat;

      this.state.dateFormat = controlProps.dateFormat;

      var control = void 0;

      control = _react2.default.createElement(_reactDatepicker2.default, _extends({}, controlProps, {
        peekNextMonth: true,
        showMonthDropdown: true,
        showYearDropdown: true,
        dropdownMode: 'select',
        isClearable: !this.props.readOnly,
        placeholderText: this.placeholder,
        selected: date,
        onChange: this.onChange.bind(this),
        onChangeRaw: function onChangeRaw(event) {
          return _this2.handleChangeRaw(event.target.value);
        }
      }));

      var res = undefined;
      if (isForm) {
        var divClass = "field";
        if (this.props.error) divClass += " error";
        res = _react2.default.createElement(
          'div',
          { className: divClass },
          this.props.label != undefined && _react2.default.createElement(
            'label',
            null,
            this.props.label
          ),
          _react2.default.createElement(
            'div',
            { 'data-buildertype': type, className: 'ui fluid input' },
            control
          )
        );
      } else {
        var _divClass = "ui fluid labeled input";
        if (this.props.error) _divClass += " error";
        res = _react2.default.createElement(
          'div',
          { 'data-buildertype': type, className: _divClass },
          this.props.label != undefined && _react2.default.createElement(
            'div',
            { className: 'ui label label' },
            this.props.label
          ),
          control
        );
      }

      return res;
    }
  }, {
    key: 'handleChangeRaw',
    value: function handleChangeRaw(value) {
      var date = undefined;
      var type = this.props.type;
      date = (0, _moment2.default)(value, this.state.dateFormat);
      this.onChange(date);
    }
  }, {
    key: 'onChange',
    value: function onChange(date) {
      if (this.props.readOnly) return;

      if (this.props.onChange != undefined) {
        var value = null;
        if (date != null && date != undefined) {
          var type = this.props.type;
          var format = "";
          if (type === "date") {
            value = date.format("YYYY-MM-DD");
          } else {
            value = date.toJSON();
          }
        }

        this.props.onChange(null, { name: this.props.name, value: value });
      }
    }
  }]);

  return DatePicker;
}(_react2.default.Component);

exports.default = DatePicker;

/***/ }),
/* 12 */
/***/ (function(module, exports) {

module.exports = __WEBPACK_EXTERNAL_MODULE_12__;

/***/ }),
/* 13 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _semanticUiReact = __webpack_require__(1);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var RadioGroup = function (_React$Component) {
    _inherits(RadioGroup, _React$Component);

    function RadioGroup(props) {
        _classCallCheck(this, RadioGroup);

        var _this = _possibleConstructorReturn(this, (RadioGroup.__proto__ || Object.getPrototypeOf(RadioGroup)).call(this, props));

        _this.state = {};
        return _this;
    }

    _createClass(RadioGroup, [{
        key: 'onChange',
        value: function onChange(e, _ref) {
            var name = _ref.name,
                value = _ref.value;

            if (this.props.onChange != undefined) {
                this.props.onChange(e, { name: this.props.name, value: value });
            } else {
                console.error("Set onChange property for RadioGroup!");
            }
        }
    }, {
        key: 'render',
        value: function render() {
            var me = this;
            var fields = this.props.items.map(function (item) {
                return _react2.default.createElement(
                    _semanticUiReact.Form.Field,
                    { key: item.key + "_formfield" },
                    _react2.default.createElement(_semanticUiReact.Form.Radio, {
                        key: item.key,
                        label: item.text,
                        name: me.props.name + '_radioGroup',
                        value: item.value,
                        readOnly: me.props.readOnly,
                        checked: me.props.value === item.value,
                        onChange: me.onChange.bind(this)
                    })
                );
            }, this);

            if (this.props.direction == 'v') {
                return _react2.default.createElement(
                    'div',
                    { className: 'ui form' },
                    _react2.default.createElement(
                        'label',
                        null,
                        this.props.label
                    ),
                    _react2.default.createElement(
                        _semanticUiReact.Form,
                        { className: this.props.className, style: this.props.style },
                        fields
                    )
                );
            }

            return _react2.default.createElement(
                'div',
                { className: 'ui form' },
                _react2.default.createElement(
                    'div',
                    { className: 'field' },
                    _react2.default.createElement(
                        'label',
                        null,
                        this.props.label
                    ),
                    _react2.default.createElement(
                        'div',
                        { className: this.props.className, style: this.props.style },
                        _react2.default.createElement(
                            _semanticUiReact.Form.Group,
                            { key: 'group' },
                            fields
                        )
                    )
                )
            );
        }
    }]);

    return RadioGroup;
}(_react2.default.Component);

exports.default = RadioGroup;

/***/ }),
/* 14 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var FilterTerms = function () {
    function FilterTerms() {
        _classCallCheck(this, FilterTerms);
    }

    _createClass(FilterTerms, null, [{
        key: "IsGreater",
        value: function IsGreater(value) {
            return value === FilterTerms.Greater;
        }
    }, {
        key: "IsLess",
        value: function IsLess(value) {
            return value === FilterTerms.Less;
        }
    }, {
        key: "IsEqual",
        value: function IsEqual(value) {
            return value === FilterTerms.Equal;
        }
    }, {
        key: "IsGreaterOrEqual",
        value: function IsGreaterOrEqual(value) {
            return value === FilterTerms.GreaterOrEqual;
        }
    }, {
        key: "IsLessOrEqual",
        value: function IsLessOrEqual(value) {
            return value === FilterTerms.LessOrEqual;
        }
    }, {
        key: "IsNotEqual",
        value: function IsNotEqual(value) {
            return value === FilterTerms.NotEqual;
        }
    }, {
        key: "IsLike",
        value: function IsLike(value) {
            return value.toLowerCase() === FilterTerms.Like || value.toLowerCase() === "*like*";
        }
    }, {
        key: "IsStartsWith",
        value: function IsStartsWith(value) {
            return value.toLowerCase() === FilterTerms.StartsWith;
        }
    }, {
        key: "IsEndsWith",
        value: function IsEndsWith(value) {
            return value.toLowerCase() === FilterTerms.EndsWith;
        }
    }, {
        key: "Evaluate",
        value: function Evaluate(value, expected, term) {
            if (FilterTerms.IsGreater(term)) {
                return FilterTerms.compareWithTypeCheck(value, expected, function (v, e) {
                    return v > e;
                });
            }
            if (FilterTerms.IsLess(term)) {
                return FilterTerms.compareWithTypeCheck(value, expected, function (v, e) {
                    return v < e;
                });
            }
            if (FilterTerms.IsEqual(term)) {
                return FilterTerms.compareWithTypeCheck(value, expected, function (v, e) {
                    return v === e;
                });
            }
            if (FilterTerms.IsGreaterOrEqual(term)) {
                return FilterTerms.compareWithTypeCheck(value, expected, function (v, e) {
                    return v >= e;
                });
            }
            if (FilterTerms.IsLessOrEqual(term)) {
                return FilterTerms.compareWithTypeCheck(value, expected, function (v, e) {
                    return v <= e;
                });
            }
            if (FilterTerms.IsNotEqual(term)) {
                return FilterTerms.compareWithTypeCheck(value, expected, function (v, e) {
                    return v !== e;
                });
            }
            if (FilterTerms.IsLike(term)) {
                return FilterTerms.likeCompare(value, expected, function (v, e) {
                    return v.indexOf(e) >= 0;
                });
            }
            if (FilterTerms.IsStartsWith(term)) {
                return FilterTerms.likeCompare(value, expected, function (v, e) {
                    return v.startsWith(e);
                });
            }
            if (FilterTerms.IsEndsWith(term)) {
                return FilterTerms.likeCompare(value, expected, function (v, e) {
                    return v.endsWith(e);
                });
            }

            throw "Unknown term " + term;
        }
    }, {
        key: "likeCompare",
        value: function likeCompare(value, expected, comparator) {
            if (value === null && expected === null) return true;

            if (value === undefined && expected === undefined) return true;

            if (value === null || value === undefined) return false;

            if (expected === null || expected === undefined) return false;
            return comparator(value.toString().toLowerCase(), expected.toString().toLowerCase());
        }
    }, {
        key: "compareWithTypeCheck",
        value: function compareWithTypeCheck(value, expected, comparator) {
            if (value === null && expected === null) return true;

            if (value === undefined && expected === undefined) return true;

            if (value === null || value === undefined) return false;

            if (expected === null || expected === undefined) return false;

            if ((typeof value === "undefined" ? "undefined" : _typeof(value)) === (typeof expected === "undefined" ? "undefined" : _typeof(expected))) {
                return comparator(value, expected);
            } else if (typeof value === "number" && typeof expected === "string") {
                return comparator(value, parseFloat(expected));
            } else if (typeof value === "string" && typeof expected === "number") {
                return comparator(value, expected.toString());
            } else {
                return comparator(value, expected);
            }
        }
    }, {
        key: "Greater",
        get: function get() {
            return ">";
        }
    }, {
        key: "Less",
        get: function get() {
            return ">";
        }
    }, {
        key: "Equal",
        get: function get() {
            return "=";
        }
    }, {
        key: "GreaterOrEqual",
        get: function get() {
            return ">=";
        }
    }, {
        key: "LessOrEqual",
        get: function get() {
            return "<=";
        }
    }, {
        key: "NotEqual",
        get: function get() {
            return "!=";
        }
    }, {
        key: "Like",
        get: function get() {
            return "like";
        }
    }, {
        key: "StartsWith",
        get: function get() {
            return "like*";
        }
    }, {
        key: "EndsWith",
        get: function get() {
            return "*like";
        }
    }]);

    return FilterTerms;
}();

var FunctionalFilter = function () {
    function FunctionalFilter(objectFilter, columns) {
        var _this = this;

        _classCallCheck(this, FunctionalFilter);

        this._innerFilter = {};
        if (objectFilter === undefined || !Array.isArray(objectFilter)) return;
        if (columns === undefined || !Array.isArray(columns)) throw "columns must be array";

        objectFilter.forEach(function (el) {
            if (el === undefined) return;
            var applyToColumns = void 0;
            if (el.column === "*") {
                applyToColumns = columns;
            } else {
                applyToColumns = el.column.split(",").map(function (n) {
                    return n.trim();
                });
            }

            _this.AddFilter({ names: applyToColumns, expected: el.value, term: el.term });
        });
    }

    _createClass(FunctionalFilter, [{
        key: "AddFilter",
        value: function AddFilter(_ref) {
            var _this2 = this;

            var names = _ref.names,
                expected = _ref.expected,
                term = _ref.term,
                id = _ref.id;

            if (names.length < 1) return;

            var filterId = names.length === 1 ? names[0] : names.sort().join("_");
            var filter = void 0;
            if (!this._innerFilter.hasOwnProperty(filterId)) {
                filter = this._innerFilter[filterId] = {};
                filter.funcs = [];
                filter.items = [];
                filter.test = function (r) {
                    return _this2._innerFilter[filterId].funcs.every(function (f) {
                        return f(r);
                    });
                };
            } else {
                filter = this._innerFilter[filterId];
            }

            var compFunc = void 0;
            var singleCompFunc = function singleCompFunc(r, name) {
                var propName = Object.keys(r).find(function (k) {
                    return k.toString().toLowerCase() === name.toLowerCase();
                });
                if (propName !== undefined) {
                    var result = FilterTerms.Evaluate(r[propName], expected, term);
                    return result;
                } else return false;
            };

            if (names.length === 1) {
                compFunc = function compFunc(r) {
                    return singleCompFunc(r, names[0]);
                };
            } else {
                compFunc = function compFunc(r) {
                    return names.some(function (name) {
                        return singleCompFunc(r, name);
                    });
                };
            }
            filter.funcs.push(compFunc);
            filter.items.push({ expected: expected, term: term, id: id });
        }
    }, {
        key: "RemoveFilter",
        value: function RemoveFilter(_ref2) {
            var _this3 = this;

            var name = _ref2.name,
                id = _ref2.id;

            var filterId = void 0;
            var names = void 0;
            if (name !== undefined) {
                if (Array.isArray(name)) {
                    filterId = name.length === 1 ? name[0] : name.sort().join("_");
                    names = name;
                } else {
                    filterId = name;
                    names = [name];
                }
            }

            if (name !== undefined && id === undefined) {
                delete this._innerFilter[filterId];
            } else if (name === undefined && id === undefined) {
                this._innerFilter = {};
            } else {
                var recreateProperty = function recreateProperty(filterId, names, id) {
                    if (!_this3._innerFilter.hasOwnProperty(filterId)) return;
                    var newItems = _this3._innerFilter[filterId].items.filter(function (el) {
                        return el.id !== id;
                    });
                    if (newItems.length < _this3._innerFilter[filterId].items.length) {
                        delete _this3._innerFilter[filterId];
                        newItems.forEach(function (ni) {
                            _this3.AddFilter({ names: names, expected: ni.expected, term: ni.term, id: ni.id });
                        });
                    }
                };

                if (name !== undefined && id !== undefined) {
                    recreateProperty(filterId, names, id);
                } else {
                    var allFilterIds = Object.keys(this._innerFilter);
                    allFilterIds.forEach(function (filterId) {
                        recreateProperty(filterId, filterId.split("_"), id);
                    });
                }
            }
        }
    }, {
        key: "IsRowMatched",
        value: function IsRowMatched(row) {
            var allNames = Object.keys(this._innerFilter);
            if (allNames.length <= 0) return true;

            for (var i = 0; i < allNames.length; i++) {
                if (!this._innerFilter[allNames[i]].test(row)) return false;
            }

            return true;
        }
    }, {
        key: "GetFilterAsObjects",
        value: function GetFilterAsObjects() {
            var _this4 = this;

            if (this._innerFilter === undefined) return [];
            var result = [];
            var allNames = Object.keys(this._innerFilter);
            allNames.forEach(function (pn) {
                _this4._innerFilter[pn].items.forEach(function (i) {
                    result.push({ column: pn.replace(/_/g, ","), value: i.expected, term: i.term });
                });
            });
            return result;
        }
    }]);

    return FunctionalFilter;
}();

exports.FilterTerms = FilterTerms;
exports.FunctionalFilter = FunctionalFilter;

/***/ }),
/* 15 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.CloverForm = exports.CloverFormBuider = undefined;

var _builder = __webpack_require__(16);

var _builder2 = _interopRequireDefault(_builder);

var _form = __webpack_require__(37);

var _form2 = _interopRequireDefault(_form);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.CloverFormBuider = _builder2.default;
exports.CloverForm = _form2.default;

/***/ }),
/* 16 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _reactDom = __webpack_require__(6);

var _reactDom2 = _interopRequireDefault(_reactDom);

var _toolbar = __webpack_require__(17);

var _toolbar2 = _interopRequireDefault(_toolbar);

var _preview = __webpack_require__(34);

var _preview2 = _interopRequireDefault(_preview);

var _store = __webpack_require__(5);

var _store2 = _interopRequireDefault(_store);

var _editform = __webpack_require__(35);

var _editform2 = _interopRequireDefault(_editform);

var _json = __webpack_require__(2);

var _json2 = _interopRequireDefault(_json);

var _lang = __webpack_require__(36);

var _lang2 = _interopRequireDefault(_lang);

var _semanticUiReact = __webpack_require__(1);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var CloverFormBuider = function (_React$Component) {
  _inherits(CloverFormBuider, _React$Component);

  function CloverFormBuider(props) {
    _classCallCheck(this, CloverFormBuider);

    var _this = _possibleConstructorReturn(this, (CloverFormBuider.__proto__ || Object.getPrototypeOf(CloverFormBuider)).call(this, props));

    _this.state = {
      defaultForm: props.defaultForm,
      apiurl: props.apiurl,
      imagefolder: props.imagefolder,
      actions: props.actions,
      dropzoneactive: true
    };
    return _this;
  }

  _createClass(CloverFormBuider, [{
    key: "componentDidMount",
    value: function componentDidMount() {
      if (this.state.defaultForm != undefined) this.load(this.state.defaultForm);
    }
  }, {
    key: "exists",
    value: function exists(code) {
      return _store2.default.exists(code);
    }
  }, {
    key: "setBuilderMode",
    value: function setBuilderMode(enabled) {
      if (enabled) {
        $('.clover-formbuilder-zone').show();
        $('.clover-formbuilder-item-toolbar-header').show();
      } else {
        $('.clover-formbuilder-zone').hide();
        $('.clover-formbuilder-item-toolbar-header').hide();
      }

      this.setState({
        dropzoneactive: enabled
      });
    }
  }, {
    key: "create",
    value: function create() {
      _store2.default.setData([]);
      this.setBuilderMode(true);
    }
  }, {
    key: "loadData",
    value: function loadData(data) {
      _store2.default.setData(data);
      this.setBuilderMode(true);
    }
  }, {
    key: "getData",
    value: function getData() {
      return _store2.default.getData();
    }
  }, {
    key: "load",
    value: function load(code) {
      var data = this.props.getFormFunc(code);
      _store2.default.setData(data);
      this.setState({
        code: code
      });

      this.setBuilderMode(true);
    }
  }, {
    key: "download",
    value: function download() {
      var data = _store2.default.getData();
      var jsonContent = 'data:text/json;charset=utf-8,';
      jsonContent += JSON.stringify(data, null, 2);
      var encodedUri = jsonContent;
      var link = document.createElement("a");
      link.setAttribute("href", encodedUri);
      link.setAttribute("download", "form.json");
      document.body.appendChild(link);
      link.click();
    }
  }, {
    key: "upload",
    value: function upload(form, successFunc) {
      var file = form.files[0];
      var reader = new FileReader();
      reader.onload = function (theFile) {
        return function (e) {
          var data = JSON.parse(e.target.result);
          _store2.default.setData(data);
        };
      }(file);

      reader.readAsText(file);
    }
  }, {
    key: "handleShowDropzonesClick",
    value: function handleShowDropzonesClick(e, _ref) {
      var name = _ref.name,
          checked = _ref.checked;

      this.setBuilderMode(checked);
    }
  }, {
    key: "onChooseFileUpload",
    value: function onChooseFileUpload(e) {
      $('#builderUploadFile').click();
    }
  }, {
    key: "onChangeFileUpload",
    value: function onChangeFileUpload(e) {
      $('#builderUploadSubmit').click();
    }
  }, {
    key: "onUpload",
    value: function onUpload(e) {
      e.preventDefault();
      this.upload(document.getElementById("builderUploadFile"));
    }
  }, {
    key: "onDownload",
    value: function onDownload(e) {
      this.download();
    }
  }, {
    key: "showsample1",
    value: function showsample1() {
      this.load("invoiceform");
    }
  }, {
    key: "showsample2",
    value: function showsample2() {
      this.load("projectform");
    }
  }, {
    key: "getHeader",
    value: function getHeader() {
      var local = this.getCurrentLocalization();

      var spanSelectorStyle = this.state.dropzoneactive ? "" : "clover-formbuilder-selector-preview";
      return _react2.default.createElement(
        "div",
        { className: "clover-formbuilder-header" },
        _react2.default.createElement(
          "div",
          { className: "clover-formbuilder-header-left" },
          _react2.default.createElement("img", { className: "clover-formbuilder-header-logo", src: "/images/logo.svg" })
        ),
        _react2.default.createElement(
          "div",
          { className: "clover-formbuilder-header-center" },
          _react2.default.createElement(
            _semanticUiReact.Button,
            { name: "btnEmpty", className: "buttontype2", onClick: this.create.bind(this) },
            local.clearbutton
          ),
          _react2.default.createElement(
            _semanticUiReact.Button,
            { name: "btnSample1", className: "buttontype1", onClick: this.showsample1.bind(this) },
            "Sample 1"
          ),
          _react2.default.createElement(
            _semanticUiReact.Button,
            { name: "btnSample1", className: "buttontype1", onClick: this.showsample2.bind(this) },
            "Sample 2"
          )
        ),
        _react2.default.createElement(
          "div",
          { className: "clover-formbuilder-header-right" },
          _react2.default.createElement(
            "div",
            { className: "clover-formbuilder-selector" },
            _react2.default.createElement(
              "span",
              { className: spanSelectorStyle },
              "Preview"
            ),
            _react2.default.createElement(_semanticUiReact.Checkbox, { toggle: true, name: "cbShowDropzones", label: "Builder", checked: this.state.dropzoneactive, onChange: this.handleShowDropzonesClick.bind(this) })
          ),
          _react2.default.createElement(
            _semanticUiReact.Button,
            { name: "btnUpload", className: "buttontype2", onClick: this.onChooseFileUpload.bind(this) },
            local.uploadbutton
          ),
          _react2.default.createElement(
            _semanticUiReact.Button,
            { name: "btnDownload", className: "buttontype2", onClick: this.onDownload.bind(this) },
            local.downloadbutton
          ),
          _react2.default.createElement(
            "form",
            { action: "/", method: "post", id: "builderUploadForm", style: { display: "none" }, onSubmit: this.onUpload.bind(this) },
            _react2.default.createElement("input", { type: "file", id: "builderUploadFile", onChange: this.onChangeFileUpload.bind(this) }),
            _react2.default.createElement("input", { type: "submit", id: "builderUploadSubmit" })
          )
        )
      );
    }
  }, {
    key: "render",
    value: function render() {
      var localization = this.getCurrentLocalization();

      var className = "clover-formbuilder";
      if (this.state.dropzoneactive) {
        className += " clover-formbuilder-dropzoneactive";
      }

      var builder = _react2.default.createElement(
        "div",
        { className: className },
        _react2.default.createElement(
          "div",
          { className: "clover-formbuilder-content" },
          _react2.default.createElement(_preview2.default, {
            getFormFunc: this.props.getFormFunc,
            getFormFist: this.props.getFormFist,
            getAdditionalDataForControl: this.props.getAdditionalDataForControl,
            localization: localization.preview,
            downloadUrl: this.props.downloadUrl,
            uploadUrl: this.props.uploadUrl }),
          _react2.default.createElement(_editform2.default, { actions: this.state.actions, localization: localization.editforms })
        ),
        _react2.default.createElement(_toolbar2.default, { localization: localization.toolbar, templates: this.props.templates })
      );

      if (this.props.showHeader) {
        return _react2.default.createElement(
          "div",
          null,
          this.getHeader(),
          builder
        );
      }

      return builder;
    }
  }, {
    key: "getCurrentLocalization",
    value: function getCurrentLocalization() {
      if (this.props.localization != undefined) {
        return this.props.localization;
      }

      return _lang2.default;
    }
  }]);

  return CloverFormBuider;
}(_react2.default.Component);

exports.default = CloverFormBuider;

/***/ }),
/* 17 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _actions = __webpack_require__(3);

var _actions2 = _interopRequireDefault(_actions);

var _controls = __webpack_require__(4);

var _controls2 = _interopRequireDefault(_controls);

var _editformControls = __webpack_require__(9);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var Toolbar = function (_React$Component) {
  _inherits(Toolbar, _React$Component);

  function Toolbar(props) {
    _classCallCheck(this, Toolbar);

    var _this = _possibleConstructorReturn(this, (Toolbar.__proto__ || Object.getPrototypeOf(Toolbar)).call(this, props));

    var items = [].concat(_toConsumableArray(_controls2.default.Items));
    if (Array.isArray(_this.props.templates) && _this.props.templates.length > 0) {
      items.push({ key: "sepTemplates", title: 'Templates', isseparate: true, defaultopen: false });

      _this.props.templates.forEach(function (template) {
        items.push({
          key: template,
          builderType: "customblock",
          title: template,
          control: undefined,
          editControl: _editformControls.CustomBlockEditControl,
          defaultValues: { formname: template, sourceType: "form" } });
      });
    }

    _this.makeLocalization(items);

    _this.state = {
      items: items
    };
    return _this;
  }

  _createClass(Toolbar, [{
    key: 'makeLocalization',
    value: function makeLocalization(items) {
      if (this.props.localization == undefined) return;

      var local = this.props.localization;
      for (var i = 0; i < items.length; i++) {
        if (local[items[i].key] != undefined) {
          items[i].title = local[items[i].key];
        }
      }
    }
  }, {
    key: 'onDragStart',
    value: function onDragStart(item, e) {
      var selector = '.clover-formbuilder-zone';
      e.dataTransfer.setData('text', '');

      if (item.forContainerType != undefined) {
        var cTypes = item.forContainerType.split(',');
        var subSelector = "";
        cTypes.forEach(function (c) {
          if (subSelector.length > 0) subSelector += ",";
          subSelector += "[data-buildertype='" + c + "'] > " + selector;
        });
        selector = subSelector;
      }

      $(selector).addClass('clover-formbuilder-zone-active').on('dragenter', this.onTargetDragEnter.bind(this, item, 'clover-formbuilder-zone-select')).on('dragleave', this.onTargetDragLeave.bind(this, item, 'clover-formbuilder-zone-select')).on('dragover', function (e) {
        e.preventDefault();
      }).on('drop', this.onDrop.bind(this, item));
    }
  }, {
    key: 'onTargetDragEnter',
    value: function onTargetDragEnter(item, css, e) {
      $(e.target).addClass(css);
    }
  }, {
    key: 'onTargetDragLeave',
    value: function onTargetDragLeave(item, css, e) {
      $(e.target).removeClass(css);
    }
  }, {
    key: 'onDragEnd',
    value: function onDragEnd(item) {
      this.stop = false;
      var zones = $('.clover-formbuilder-zone');

      zones.removeClass('clover-formbuilder-zone-active');
      zones.removeClass('clover-formbuilder-zone-select');
      zones.off();
    }
  }, {
    key: 'onDrop',
    value: function onDrop(item, e) {
      var el = $(e.target);
      if (el.length > 0) {
        _actions2.default.add(item, el[0]);
      }

      this.onDragEnd(item);
      return false;
    }
  }, {
    key: 'onDoubleClick',
    value: function onDoubleClick(item) {
      _actions2.default.add(item);
    }
  }, {
    key: 'onExpand',
    value: function onExpand(item, value) {
      item.isexpanded = value;
      this.setCookie("toolbar_" + item.key, value);
      this.forceUpdate();
    }
  }, {
    key: 'render',
    value: function render() {
      var _this2 = this;

      var me = this;
      var expandedbock = false;
      return _react2.default.createElement(
        'div',
        { className: 'clover-formbuilder-toolbox' },
        _react2.default.createElement(
          'ul',
          null,
          this.state.items.map(function (item) {
            var title = item.title;
            if (me.props.localization != undefined && me.props.localization[item.key] != undefined) {
              title = me.props.localization[item.key];
            }

            if (item.isseparate) {
              var icon;
              var onclick;

              if (item.isexpanded == undefined) {
                var cookievalue = me.getCookie("toolbar_" + item.key);
                item.isexpanded = cookievalue != undefined ? cookievalue == "true" : item.defaultopen;
              }

              if (item.isexpanded) {
                expandedbock = true;
                onclick = me.onExpand.bind(me, item, false);
                icon = _react2.default.createElement(
                  'span',
                  null,
                  '\u2013'
                ); //<img  key="btnexpand" className="collapse" src="/images/collapse.svg"/>;
              } else {
                expandedbock = false;
                onclick = me.onExpand.bind(me, item, true);
                icon = _react2.default.createElement(
                  'span',
                  null,
                  '+'
                ); //<img key="btnexpand" className="expand" src="/images/expand.svg"/>;
              }

              return _react2.default.createElement(
                'li',
                { draggable: 'false', onClick: onclick, className: 'clover-formbuilder-toolbox-subheader', key: item.key },
                title,
                icon
              );
            }

            if (expandedbock) {
              var w = item.imagewidth != undefined ? item.imagewidth : 32;
              var h = item.imageheight != undefined ? item.imageheight : 32;

              return _react2.default.createElement(
                'li',
                { draggable: 'true', className: 'clover-formbuilder-toolbox-control',
                  key: item.key,
                  onDragStart: _this2.onDragStart.bind(_this2, item),
                  onDragEnd: _this2.onDragEnd.bind(_this2, item),
                  onDoubleClick: _this2.onDoubleClick.bind(_this2, item),
                  onDrag: _this2.onDrag.bind(_this2) },
                _react2.default.createElement('img', { className: 'clover-formbuilder-toolbox-control-icon', src: '/images/cloverbuilder-toolbar-move.png' }),
                _react2.default.createElement(
                  'div',
                  { className: 'clover-formbuilder-toolbox-control-text' },
                  title
                )
              );
            }
          })
        )
      );
    }
  }, {
    key: 'onDrag',
    value: function onDrag(e) {
      var step = 10;
      if (e.clientY < 150) {
        this.scroll(-step);
      }

      if (e.clientY > $(window).height() - 150) {
        this.scroll(step);
      }
    }
  }, {
    key: 'scroll',
    value: function (_scroll) {
      function scroll(_x) {
        return _scroll.apply(this, arguments);
      }

      scroll.toString = function () {
        return _scroll.toString();
      };

      return scroll;
    }(function (step) {
      var scrollY = $(window).scrollTop();
      $(window).scrollTop(scrollY + step);
      if (!stop) {
        setTimeout(function () {
          scroll(step);
        }, 20);
      }
    })
  }, {
    key: 'getCookie',
    value: function getCookie(name) {
      var matches = document.cookie.match(new RegExp("(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"));
      return matches ? decodeURIComponent(matches[1]) : undefined;
    }
  }, {
    key: 'setCookie',
    value: function setCookie(name, value, options) {
      options = options || {};

      var expires = options.expires;

      if (typeof expires == "number" && expires) {
        var d = new Date();
        d.setTime(d.getTime() + expires * 1000);
        expires = options.expires = d;
      }
      if (expires && expires.toUTCString) {
        options.expires = expires.toUTCString();
      }

      value = encodeURIComponent(value);

      var updatedCookie = name + "=" + value;

      for (var propName in options) {
        updatedCookie += "; " + propName;
        var propValue = options[propName];
        if (propValue !== true) {
          updatedCookie += "=" + propValue;
        }
      }

      document.cookie = updatedCookie;
    }
  }]);

  return Toolbar;
}(_react2.default.Component);

exports.default = Toolbar;

/***/ }),
/* 18 */
/***/ (function(module, exports) {

module.exports = __WEBPACK_EXTERNAL_MODULE_18__;

/***/ }),
/* 19 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _semanticUiReact = __webpack_require__(1);

var _collectioneditor = __webpack_require__(7);

var _collectioneditor2 = _interopRequireDefault(_collectioneditor);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var EventsEditor = function (_React$Component) {
    _inherits(EventsEditor, _React$Component);

    function EventsEditor(props) {
        _classCallCheck(this, EventsEditor);

        var _this = _possibleConstructorReturn(this, (EventsEditor.__proto__ || Object.getPrototypeOf(EventsEditor)).call(this, props));

        _this.state = {};
        return _this;
    }

    _createClass(EventsEditor, [{
        key: 'render',
        value: function render() {
            var me = this;
            var data = this.props.data;
            var events = this.props.events;
            var actionOptions = [];
            if (Array.isArray(this.props.actions)) {
                this.props.actions.forEach(function (a) {
                    actionOptions.push({ text: a, value: a });
                });
            }
            var targetOptions = [].concat(_toConsumableArray(this.props.targets));

            var res = [];
            events.forEach(function (e) {
                var key = e + "_events";
                var event = data != undefined ? data[e] : undefined;
                if (event == undefined) {
                    event = {};
                }

                if (event.actions == undefined) event.actions = [];
                if (event.targets == undefined) event.targets = [];
                if (event.parameters == undefined) event.parameters = [];

                if (Array.isArray(event.actions)) {
                    event.actions.forEach(function (a) {
                        var isFind = false;
                        for (var i = 0; i < actionOptions.length; i++) {
                            if (a == actionOptions[i].value) {
                                isFind = true;
                                break;
                            }
                        }

                        if (!isFind) {
                            actionOptions.push({ text: a, value: a });
                        }
                    });
                }

                if (Array.isArray(event.targets)) {
                    event.targets.forEach(function (a) {
                        var isFind = false;
                        for (var i = 0; i < targetOptions.length; i++) {
                            if (a == targetOptions[i].value) {
                                isFind = true;
                                break;
                            }
                        }

                        if (!isFind) {
                            targetOptions.push({ text: a, value: a });
                        }
                    });
                }

                res.push(_react2.default.createElement(
                    'div',
                    { key: key },
                    _react2.default.createElement(_semanticUiReact.Form.Checkbox, { width: 3, key: 'active', label: e, name: 'active', checked: event.active, onChange: me.handleChange.bind(me, e) }),
                    _react2.default.createElement(
                        'div',
                        { key: 'divGroup', style: event.active ? {} : { display: 'none' } },
                        _react2.default.createElement(
                            _semanticUiReact.Form.Group,
                            { key: 'Group' },
                            _react2.default.createElement(_semanticUiReact.Form.Dropdown, { key: 'actions', label: 'Actions', multiple: true, search: true, selection: true, allowAdditions: true,
                                name: 'actions', options: actionOptions, value: event.actions,
                                onAddItem: me.actionsOnAddItem.bind(me), onChange: me.handleChange.bind(me, e) }),
                            _react2.default.createElement(_collectioneditor2.default, { key: 'parameters',
                                columns: ['name', 'value'],
                                label: 'Parameters',
                                name: 'parameters',
                                value: event.parameters,
                                onChange: me.handleChange.bind(me, e) }),
                            _react2.default.createElement(_semanticUiReact.Form.Dropdown, { key: 'targets', label: 'Targets', multiple: true, search: true, selection: true,
                                name: 'targets', options: targetOptions, value: event.targets,
                                onChange: me.handleChange.bind(me, e) })
                        )
                    )
                ));
            });

            return _react2.default.createElement(
                'div',
                null,
                res
            );
        }
    }, {
        key: 'handleChange',
        value: function handleChange(eventName, e, _ref) {
            var name = _ref.name,
                value = _ref.value,
                checked = _ref.checked;

            var event = this.props.data[eventName];
            if (event == undefined) {
                event = {};
                this.props.data[eventName] = event;
            }

            if (value == undefined && checked != undefined) {
                event[name] = checked;
            } else {
                event[name] = value;

                if (value != undefined && value != "") {
                    event.active = true;
                }
            }
            if (this.props.onChange != undefined) this.props.onChange(e, { name: this.props.name, value: this.props.data });
        }
    }, {
        key: 'actionsOnAddItem',
        value: function actionsOnAddItem(e, _ref2) {
            var value = _ref2.value;

            if (this.props.onAdditionActions != undefined) this.props.onAdditionActions(e, { value: value });
        }
    }]);

    return EventsEditor;
}(_react2.default.Component);

exports.default = EventsEditor;

/***/ }),
/* 20 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _json = __webpack_require__(2);

var _json2 = _interopRequireDefault(_json);

var _semanticUiReact = __webpack_require__(1);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var MenuGroup = function (_React$Component) {
    _inherits(MenuGroup, _React$Component);

    function MenuGroup(props) {
        _classCallCheck(this, MenuGroup);

        var _this = _possibleConstructorReturn(this, (MenuGroup.__proto__ || Object.getPrototypeOf(MenuGroup)).call(this, props));

        _this.state = {};

        if (props.value != undefined) {
            _this.state.activeitem = props.value;
        } else if (props.activeitem != null) {
            _this.state.activeitem = props.activeitem;
        }
        return _this;
    }

    _createClass(MenuGroup, [{
        key: 'handleItemClick',
        value: function handleItemClick(e, _ref) {
            var name = _ref.name;

            if (this.props.handleEvent != undefined) {
                var res = this.props.handleEvent({
                    e: e,
                    key: this.props.name,
                    eventName: "onItemClick",
                    parameters: { target: name }
                });
                if (res != false) {
                    this.setState({ activeitem: name });
                }
            }
        }
    }, {
        key: 'handleItemClick2',
        value: function handleItemClick2(p, e) {
            this.handleItemClick(e, p);
            e.preventDefault();
        }
    }, {
        key: 'render',
        value: function render() {
            var items = this.props["data-items"];
            if (items == undefined || items == "") {
                items = [];
            } else if (!Array.isArray(items)) {
                items = _json2.default.parse(items);
            }

            var children = this.renderItems(items);

            var controlProps = {};
            for (var p in this.props) {
                if (p == "data-items" || p == 'activeitem' || p == 'handleEvent' || p == 'link') continue;
                controlProps[p] = this.props[p];
            }

            return _react2.default.createElement(
                _semanticUiReact.Menu,
                controlProps,
                children
            );
        }
    }, {
        key: 'renderItems',
        value: function renderItems(items, keyPrefix) {
            var children = [];
            if (keyPrefix === undefined) keyPrefix = "";

            for (var i = 0; i < items.length; i++) {
                var item = items[i];

                if (item.visibleCondition !== undefined && item.visibleCondition !== null && item.visibleCondition !== "") {
                    var args = '';
                    var body = 'return ' + item.visibleCondition;
                    try {
                        if (!new Function(args, body)()) {
                            continue;
                        }
                    } catch (e) {};
                }

                var key = String(keyPrefix) + String(i);
                var titleSpan = _react2.default.createElement('span', { dangerouslySetInnerHTML: { __html: item.title } });
                if (Array.isArray(item.children) && item.children.length > 0) {
                    children.push(_react2.default.createElement(
                        _semanticUiReact.Menu.Item,
                        null,
                        _react2.default.createElement(
                            _semanticUiReact.Menu.Header,
                            null,
                            titleSpan
                        ),
                        _react2.default.createElement(
                            _semanticUiReact.Menu.Menu,
                            null,
                            this.renderItems(item.children, key + "_")
                        )
                    ));
                } else {
                    var content = this.props.link ? _react2.default.createElement(
                        'a',
                        { style: { color: "inherit" }, href: item.target, onClick: this.handleItemClick2.bind(this, { name: item.target }) },
                        titleSpan
                    ) : titleSpan;

                    children.push(_react2.default.createElement(
                        _semanticUiReact.Menu.Item,
                        {
                            key: key,
                            name: item.target,
                            active: this.state.activeitem === item.target,
                            onClick: this.handleItemClick.bind(this) },
                        content
                    ));
                }
            }
            return children;
        }
    }], [{
        key: 'getDerivedStateFromProps',
        value: function getDerivedStateFromProps(nextProps, prevState) {
            if (prevState.activeitem !== nextProps.value) {
                return { activeitem: nextProps.value };
            }

            return null;
        }
    }]);

    return MenuGroup;
}(_react2.default.Component);

exports.default = MenuGroup;

/***/ }),
/* 21 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _semanticUiReact = __webpack_require__(1);

var _reactDataGrid = __webpack_require__(22);

var _reactDataGrid2 = _interopRequireDefault(_reactDataGrid);

var _functionalfilter = __webpack_require__(14);

var _moment = __webpack_require__(12);

var _moment2 = _interopRequireDefault(_moment);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; } /*
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               Filter object structure:
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               let filter = [
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               {column: "Name" | "Name1,Name2,Name3" | "*",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               value: value,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               term: ">" | "<" | "=" | ">=" | "<=" | "!=" | "like" | "like*" | "*like" | "*like*"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ]
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               "*like*" === "like"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                */

var CheckBoxFormatter = function (_React$Component) {
    _inherits(CheckBoxFormatter, _React$Component);

    function CheckBoxFormatter() {
        _classCallCheck(this, CheckBoxFormatter);

        return _possibleConstructorReturn(this, (CheckBoxFormatter.__proto__ || Object.getPrototypeOf(CheckBoxFormatter)).apply(this, arguments));
    }

    _createClass(CheckBoxFormatter, [{
        key: 'render',
        value: function render() {
            var value = Boolean(this.props.value);
            return _react2.default.createElement(_semanticUiReact.Checkbox, { checked: value, disabled: true });
        }
    }]);

    return CheckBoxFormatter;
}(_react2.default.Component);

var NumberFormatter = function (_React$Component2) {
    _inherits(NumberFormatter, _React$Component2);

    function NumberFormatter() {
        _classCallCheck(this, NumberFormatter);

        return _possibleConstructorReturn(this, (NumberFormatter.__proto__ || Object.getPrototypeOf(NumberFormatter)).apply(this, arguments));
    }

    _createClass(NumberFormatter, [{
        key: 'render',
        value: function render() {
            var value = this.props.value;
            return _react2.default.createElement(
                'span',
                { style: { textAlign: 'right' } },
                _react2.default.createElement(
                    'div',
                    { title: value },
                    value
                )
            );
        }
    }]);

    return NumberFormatter;
}(_react2.default.Component);

var DateFormatter = function (_React$Component3) {
    _inherits(DateFormatter, _React$Component3);

    function DateFormatter() {
        _classCallCheck(this, DateFormatter);

        return _possibleConstructorReturn(this, (DateFormatter.__proto__ || Object.getPrototypeOf(DateFormatter)).apply(this, arguments));
    }

    _createClass(DateFormatter, [{
        key: 'render',
        value: function render() {
            var value = (0, _moment2.default)(this.props.value);
            var strValue = "";
            if (value.isValid()) {
                var format = window.CloverLang !== undefined && window.CloverLang.common !== undefined && window.CloverLang.common.dateFormat != undefined ? window.CloverLang.common.dateFormat : "L";
                strValue = value.format(format);
            }
            return _react2.default.createElement(
                'span',
                { style: { textAlign: 'right' } },
                _react2.default.createElement(
                    'div',
                    { title: strValue },
                    strValue
                )
            );
        }
    }]);

    return DateFormatter;
}(_react2.default.Component);

var DateTimeFormatter = function (_React$Component4) {
    _inherits(DateTimeFormatter, _React$Component4);

    function DateTimeFormatter() {
        _classCallCheck(this, DateTimeFormatter);

        return _possibleConstructorReturn(this, (DateTimeFormatter.__proto__ || Object.getPrototypeOf(DateTimeFormatter)).apply(this, arguments));
    }

    _createClass(DateTimeFormatter, [{
        key: 'render',
        value: function render() {
            var value = (0, _moment2.default)(this.props.value);
            var strValue = "";
            if (value.isValid()) {
                var format = window.CloverLang !== undefined && CloverLang.common !== undefined && window.CloverLang.common.dateFormat != undefined ? window.CloverLang.common.dateFormat + " " + (window.CloverLang.common.timeFormat !== undefined ? window.CloverLang.common.timeFormat : "HH:mm") : "DD.MM.YYYY HH:mm";
                strValue = value.format(format);
            }
            return _react2.default.createElement(
                'span',
                { style: { textAlign: 'right' } },
                _react2.default.createElement(
                    'div',
                    { title: strValue },
                    strValue
                )
            );
        }
    }]);

    return DateTimeFormatter;
}(_react2.default.Component);

var TimeFormatter = function (_React$Component5) {
    _inherits(TimeFormatter, _React$Component5);

    function TimeFormatter() {
        _classCallCheck(this, TimeFormatter);

        return _possibleConstructorReturn(this, (TimeFormatter.__proto__ || Object.getPrototypeOf(TimeFormatter)).apply(this, arguments));
    }

    _createClass(TimeFormatter, [{
        key: 'render',
        value: function render() {
            var value = (0, _moment2.default)(this.props.value);
            var strValue = "";
            if (value.isValid()) {
                var format = window.CloverLang !== undefined && window.CloverLang.common !== undefined && window.CloverLang.common.timeFormat != undefined ? window.CloverLang.common.timeFormat : "HH:mm";
                strValue = value.format(format);
            }
            return _react2.default.createElement(
                'span',
                { style: { textAlign: 'right' } },
                _react2.default.createElement(
                    'div',
                    { title: strValue },
                    strValue
                )
            );
        }
    }]);

    return TimeFormatter;
}(_react2.default.Component);

var jsonEqual = function jsonEqual(a, b) {
    return JSON.stringify(a) === JSON.stringify(b);
};

var GridView = function (_React$Component6) {
    _inherits(GridView, _React$Component6);

    function GridView(props) {
        _classCallCheck(this, GridView);

        var _this6 = _possibleConstructorReturn(this, (GridView.__proto__ || Object.getPrototypeOf(GridView)).call(this, props));

        _this6.state = {
            items: [],
            sort: "",
            defaultSort: props.defaultSort,
            filter: props.filter,
            pageSize: 20,
            selectedIndexes: [],
            rowsCount: GridView.staticIsServerMode(props) ? undefined : 0
        };
        return _this6;
    }

    _createClass(GridView, [{
        key: 'isEditFormModal',
        value: function isEditFormModal() {
            return this.props.editFormShowType === "modal";
        }
    }, {
        key: 'isServerMode',
        value: function isServerMode() {
            return GridView.staticIsServerMode(this.props);
        }
    }, {
        key: 'refresh',
        value: function refresh() {
            if (this.isServerMode()) {
                this.setState({
                    items: [],
                    selectedIndexes: [],
                    rowsCount: undefined
                });
            } else {
                var newItems = Array.isArray(this.props.value) ? GridView.staticGetSortedAndFilteredItems(this.props.value, this.state.filter, this.state.sort, this.props.defaultSort) : [];
                this.setState({
                    items: newItems,
                    rowsCount: newItems.length,
                    selectedIndexes: [],
                    originalItems: this.props.value
                });
            }
        }
    }, {
        key: 'resetSelection',
        value: function resetSelection() {
            this.setState({
                selectedIndexes: []
            });
        }
    }, {
        key: 'render',
        value: function render() {
            var className = this.props.className;
            var style = _extends({}, this.props.style);
            var gridProps = this.getGridPropsByPagerType(this.props.pagerType);
            gridProps.columns = this.getColumns();
            gridProps.rowKey = this.props.rowKey;

            if (this.props.rowHeight !== undefined && this.props.rowHeight !== "") gridProps.rowHeight = this.props.rowHeight;

            if (this.props.autoHeight) {
                style.minHeight = this.props.minHeight;
                if (this.props.offSet !== undefined && this.props.offSet !== "") {
                    style.height = 'calc(100vh - ' + this.props.offSet + ')';
                } else {
                    style.height = "100vh";
                }

                className = (className === undefined ? "" : className + " ") + "clover-gridview-autoHeight";
            } else {
                if (this.props.minHeight !== undefined && this.props.minHeight !== "") {
                    gridProps.minHeight = this.props.minHeight;
                }
            }

            // if (Boolean(this.props.filterRow)) {
            //     gridProps.toolbar = <Toolbar enableFilter={true}/>;
            //     gridProps.onAddFilter = this.handleFilterChange.bind(this);
            //     gridProps.onClearFilters = this.onClearFilters.bind(this);
            // }

            if (Boolean(this.props.multiselect)) {
                gridProps.rowSelection = {
                    onRowsSelected: this.onRowsSelected.bind(this),
                    onRowsDeselected: this.onRowsDeselected.bind(this),
                    selectBy: {
                        indexes: this.state.selectedIndexes
                    }
                };
            }

            return _react2.default.createElement(
                'div',
                { key: this.props.name, name: this.props.name, className: className, style: style },
                _react2.default.createElement(_reactDataGrid2.default, _extends({ key: 'grid'
                }, gridProps, {
                    rowsCount: this.state.rowsCount,
                    rowGetter: this.gridRowGetter.bind(this),
                    onRowClick: this.gridOnRowClick.bind(this),
                    onGridSort: this.handleGridSort.bind(this) }))
            );
        }
    }, {
        key: 'getColumns',
        value: function getColumns() {
            var me = this;
            var columns = void 0;
            if (this.props.columns === undefined) {
                columns = [];
            } else if (Array.isArray(this.props.columns)) {
                columns = this.props.columns;
            } else {
                columns = JSON.parse(this.props.columns);
            }

            columns.forEach(function (item) {
                if (item.width !== null && item.width !== "" && item.width !== undefined) {
                    item.width = Number(item.width);
                }

                if (item.sortable !== false) {
                    item.sortable = !Boolean(me.props.disableSort);
                }
                item.filterable = Boolean(me.props.filterRow);
                item.resizable = Boolean(item.resizable);

                if (item.type === "number") item.formatter = NumberFormatter;else if (item.type === "checkbox") {
                    item.formatter = CheckBoxFormatter;
                } else if (item.type === "date") {
                    item.formatter = DateFormatter;
                } else if (item.type === "time") {
                    item.formatter = TimeFormatter;
                } else if (item.type === "datetime") {
                    item.formatter = DateTimeFormatter;
                } else if (item.type === "custom") {
                    item.getRowMetaData = function (row) {
                        return row;
                    };
                    item.formatter = function (args) {
                        if (item.customFormatter == undefined || typeof item.customFormatter != "function") {
                            return "";
                        }
                        return item.customFormatter({
                            row: args.dependentValues,
                            value: args.value,
                            column: item
                        });
                    };
                }
            });
            return columns;
        }
    }, {
        key: 'getGridPropsByPagerType',
        value: function getGridPropsByPagerType() {
            var gridProps = {};

            var pagerType = this.props.pagerType;
            if (pagerType === "server") {
                if (this.props.pageSize !== undefined) {
                    this.state.pageSize = this.props.pageSize;
                }
                gridProps.rowRenderer = RowLoadingRenderer;
                if (this.state.rowsCount === undefined) this.state.rowsCount = 1;
            } else {
                // if (Array.isArray(this.props.value)) {
                //     this.state.items = this.getSortedAndFilteredItems(this.props.value);
                // }
                //this.state.rowsCount = this.state.items.length;
            }
            return gridProps;
        }
    }, {
        key: 'getSeletedRowKeys',
        value: function getSeletedRowKeys() {
            var me = this;
            var selectedKeys = [];

            this.state.selectedIndexes.forEach(function (index) {
                var obj = me.gridRowGetter(index);
                if (obj !== undefined) {
                    selectedKeys.push(obj[me.props.rowKey]);
                }
            });
            return selectedKeys;
        }
    }, {
        key: 'gridRowGetter',
        value: function gridRowGetter(index) {
            if (index < 0) return undefined;

            var pagerType = this.props.pagerType;
            if (pagerType === "server") {
                if (this.state.items[index] === undefined) {
                    var pageSize = this.state.pageSize;
                    this.loadPage(index, pageSize);
                }
            }

            return this.state.items[index];
        }
    }, {
        key: 'loadPage',
        value: function loadPage(startIndex, pageSize) {
            var me = this;
            for (var i = 0; i < pageSize; i++) {
                this.state.items[i + startIndex] = { __loading: true };
            }

            if (this.props.getAdditionalDataForControl === undefined) {
                if (console !== undefined) console.log("GridView: For paging on server need to set getAdditionalDataForControl func!");
            } else {
                var sortString = this.state.sort;
                if (sortString === "" && this.props.defaultSort !== undefined) sortString = this.props.defaultSort;

                this.props.getAdditionalDataForControl(this, {
                    startIndex: startIndex,
                    pageSize: pageSize,
                    filters: this.state.filter !== undefined ? this.state.filter.GetFilterAsObjects() : [],
                    sort: sortString
                }, function (_ref) {
                    var sIndex = _ref.sIndex,
                        pSize = _ref.pSize,
                        rowsCount = _ref.rowsCount,
                        items = _ref.items;

                    if (rowsCount === undefined || items === undefined) {
                        me.state.rowsCount = 0;
                        me.setState({
                            rowsCount: 0,
                            items: []
                        });
                    } else {
                        me.state.rowsCount = rowsCount;
                        for (var _i = 0; _i < pSize; _i++) {
                            if (_i < items.length) {
                                me.state.items[sIndex + _i] = items[_i];
                            } else {
                                me.state.items[sIndex + _i] = undefined;
                            }
                        }
                        me.forceUpdate();
                    }
                });
            }
        }
    }, {
        key: 'gridOnRowClick',
        value: function gridOnRowClick(rowIdx, row) {
            if (row === undefined) return;

            var timenow = Date.now();
            if (this.rowClickTime !== undefined && this.rowClickTime.rowIdx === rowIdx && timenow - this.rowClickTime.time <= 1000) {
                this.rowClickTime = undefined;
                this.onRowDblClick(rowIdx, row);
            } else {
                this.rowClickTime = {
                    rowIdx: rowIdx,
                    time: timenow
                };

                if (this.props.handleEvent !== undefined) {
                    this.props.handleEvent({ key: this.props.name, eventName: "onRowClick", parameters: { rowIdx: rowIdx, row: row } });
                }
            }
        }
    }, {
        key: 'onRowDblClick',
        value: function onRowDblClick(rowIdx, row) {
            if (this.props.handleEvent !== undefined) {
                this.props.handleEvent({ key: this.props.name, eventName: "onRowDblClick", parameters: { rowIdx: rowIdx, row: row } });
            }
        }
    }, {
        key: 'onRowsSelected',
        value: function onRowsSelected(rows) {
            this.state.selectedIndexes = this.state.selectedIndexes.concat(rows.map(function (r) {
                return r.rowIdx;
            }));
            if (this.props.handleEvent !== undefined) {
                this.props.handleEvent({
                    key: this.props.name,
                    eventName: "onSelectionChanged",
                    parameters: { selectedIndexes: this.state.selectedIndexes }
                });
            }
            this.forceUpdate();
        }
    }, {
        key: 'onRowsDeselected',
        value: function onRowsDeselected(rows) {
            var rowIndexes = rows.map(function (r) {
                return r.rowIdx;
            });
            this.state.selectedIndexes = this.state.selectedIndexes.filter(function (i) {
                return rowIndexes.indexOf(i) === -1;
            });
            if (this.props.handleEvent !== undefined) {
                this.props.handleEvent({
                    key: this.props.name,
                    eventName: "onSelectionChanged",
                    parameters: { selectedIndexes: this.state.selectedIndexes }
                });
            }
            this.forceUpdate();
        }
    }, {
        key: 'handleGridSort',
        value: function handleGridSort(sortColumn, sortDirection) {
            var stateDelta = {};
            if (sortDirection === "NONE") stateDelta.sort = "";else stateDelta.sort = sortColumn + " " + sortDirection;

            var pagerType = this.props.pagerType;
            if (pagerType === "server") {
                stateDelta.items = [];
            } else {
                stateDelta.items = GridView.staticGetSortedAndFilteredItems(this.props.value, this.state.filter, stateDelta.sort, this.props.defaultSort);
            }

            stateDelta.selectedIndexes = [];
            this.setState(stateDelta);
        }
    }, {
        key: 'handleFilterChange',
        value: function handleFilterChange(filter) {
            var stateDelta = {};
            var key = filter.column.key;
            var id = "columnfilter_" + key;
            stateDelta.filter = this.state.filter !== undefined ? this.state.filter : new _functionalfilter.FunctionalFilter([], this.props.columns.map(function (c) {
                return c.key;
            }));
            stateDelta.filter.RemoveFilter({ name: key, id: id });
            if (filter.filterTerm !== "") {
                stateDelta.filter.AddFilter({ names: [key], expected: filter.filterTerm, term: _functionalfilter.FilterTerms.Like, id: id });
            }
            if (GridView.staticIsServerMode(this.props)) {
                stateDelta.items = [];
                stateDelta.selectedIndexes = [];
                stateDelta.rowsCount = undefined;
            } else {
                stateDelta.items = GridView.staticGetSortedAndFilteredItems(this.props.value, stateDelta.filter, this.state.sort, this.props.defaultSort);
                stateDelta.selectedIndexes = [];
                stateDelta.rowsCount = stateDelta.items.length;
            }
            this.setState(stateDelta);
        }
    }, {
        key: 'onClearFilters',
        value: function onClearFilters() {
            this.setState({ filter: this.props.filter });
        }
    }, {
        key: 'componentWillUnmount',


        ///----------
        ///Resize
        ///----------
        value: function componentWillUnmount() {
            this._isMounted = false;
        }
    }, {
        key: 'componentDidMount',
        value: function componentDidMount() {
            this._isMounted = true;
            this.recalcSizeParams();
        }
    }, {
        key: 'recalcSizeParams',
        value: function recalcSizeParams() {
            if (!this._isMounted) return;

            if (Boolean(this.props.autoHeight)) {
                var h = $(window).height();

                this.setState({
                    gridHeight: h - this.props.deltaHeight
                });
            }
        }
    }], [{
        key: 'getDerivedStateFromProps',
        value: function getDerivedStateFromProps(nextProps, prevState) {
            var newState = null;
            if (!jsonEqual(prevState.filter, nextProps.filter)) {
                newState = { filter: nextProps.filter };
                if (!GridView.staticIsServerMode(nextProps)) {
                    var newItems = Array.isArray(nextProps.value) ? GridView.staticGetSortedAndFilteredItems(nextProps.value, nextProps.filter, prevState.sort, nextProps.defaultSort) : [];
                    newState.items = newItems;
                    newState.selectedIndexes = [];
                    newState.rowsCount = newItems.length;
                } else {
                    newState.items = [];
                    newState.selectedIndexes = [];
                    newState.rowsCount = undefined;
                }
            } else {
                if (!GridView.staticIsServerMode(nextProps) && prevState.originalItems !== nextProps.value) {
                    newState = {};
                    var _newItems = Array.isArray(nextProps.value) ? GridView.staticGetSortedAndFilteredItems(nextProps.value, prevState.filter, prevState.sort, nextProps.defaultSort) : [];
                    newState.items = _newItems;
                    newState.rowsCount = _newItems.length;
                    newState.selectedIndexes = [];
                    newState.originalItems = nextProps.value;
                }
            }
            return newState;
        }
    }, {
        key: 'staticIsServerMode',
        value: function staticIsServerMode(props) {
            return props.pagerType === "server";
        }
    }, {
        key: 'staticGetSortedAndFilteredItems',
        value: function staticGetSortedAndFilteredItems(array, filter, sort, defaultSort) {
            var items = [];
            if (array === undefined) return items;
            if (filter !== undefined) {
                items = array.filter(function (r) {
                    return filter.IsRowMatched(r);
                });
            } else {
                items = array;
            }

            var currentSort = sort;
            if (sort === 'NONE' || sort === "") {
                if (defaultSort === undefined) {
                    return items;
                }
                currentSort = defaultSort;
            }

            var indexSpace = currentSort.indexOf(" ");
            var sortColumn = currentSort.substring(0, indexSpace);
            var sortDirection = currentSort.substring(indexSpace + 1, currentSort.length);

            //Sorting
            var comparer = function comparer(a, b) {
                var aValue = a[sortColumn] !== undefined && a[sortColumn] !== null && a[sortColumn].toLowerCase !== undefined ? a[sortColumn].toLowerCase() : a[sortColumn];
                var bValue = b[sortColumn] !== undefined && b[sortColumn] !== null && b[sortColumn].toLowerCase !== undefined ? b[sortColumn].toLowerCase() : b[sortColumn];

                if (aValue === bValue) {
                    return 0;
                }
                if (aValue === null || aValue === undefined) {
                    return 1;
                }
                if (bValue === null || bValue === undefined) {
                    return -1;
                }
                if (sortDirection === 'ASC') {
                    return aValue > bValue ? 1 : -1;
                } else if (sortDirection === 'DESC') {
                    return aValue < bValue ? 1 : -1;
                }
            };
            return items.slice(0).sort(comparer);
        }
    }]);

    return GridView;
}(_react2.default.Component);

exports.default = GridView;

var RowLoadingRenderer = function (_React$Component7) {
    _inherits(RowLoadingRenderer, _React$Component7);

    function RowLoadingRenderer() {
        _classCallCheck(this, RowLoadingRenderer);

        return _possibleConstructorReturn(this, (RowLoadingRenderer.__proto__ || Object.getPrototypeOf(RowLoadingRenderer)).apply(this, arguments));
    }

    _createClass(RowLoadingRenderer, [{
        key: 'setScrollLeft',
        value: function setScrollLeft(scrollBy) {
            this.row.setScrollLeft(scrollBy);
        }
    }, {
        key: 'getClassName',
        value: function getClassName() {
            return this.props.row.__loading ? 'clover-gridview-rowloading' : "";
        }
    }, {
        key: 'render',
        value: function render() {
            var _this8 = this;

            return _react2.default.createElement(
                'div',
                { className: this.getClassName() },
                _react2.default.createElement(_reactDataGrid.Row, _extends({ ref: function ref(node) {
                        return _this8.row = node;
                    } }, this.props))
            );
        }
    }]);

    return RowLoadingRenderer;
}(_react2.default.Component);

/***/ }),
/* 22 */
/***/ (function(module, exports) {

module.exports = __WEBPACK_EXTERNAL_MODULE_22__;

/***/ }),
/* 23 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _json = __webpack_require__(2);

var _json2 = _interopRequireDefault(_json);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var ChartView = function (_React$Component) {
    _inherits(ChartView, _React$Component);

    function ChartView(props) {
        _classCallCheck(this, ChartView);

        var _this = _possibleConstructorReturn(this, (ChartView.__proto__ || Object.getPrototypeOf(ChartView)).call(this, props));

        _this.state = {};
        return _this;
    }

    _createClass(ChartView, [{
        key: 'componentDidMount',
        value: function componentDidMount() {
            //window.addEventListener("resize", this.redrawChart.bind(this));
            this.redrawChart();
        }
    }, {
        key: 'componentDidUpdate',
        value: function componentDidUpdate() {
            this.redrawChart();
        }
    }, {
        key: 'componentWillUnmount',
        value: function componentWillUnmount() {
            if (this.state.chart != undefined) {
                this.state.chart.destroy();
            }
        }
    }, {
        key: 'redrawChart',
        value: function redrawChart() {
            if (this.state.chart != undefined) {
                this.state.chart.destroy();
                this.state.chart = undefined;
            }

            if (this.state.chart == undefined) {
                var ctx = document.getElementById(this.getDivId()).getContext("2d");
                var data = this.getChartData();
                var yAxes = undefined;
                if (data != undefined && Array.isArray(data.datasets)) {
                    var axis = [];
                    data.datasets.forEach(function (e) {
                        if (e.yAxisID != undefined && e.yAxisID != null) {
                            if (!axis.includes(e.yAxisID)) axis.push(e.yAxisID);
                        }
                    });

                    if (axis.length > 0) {
                        yAxes = [];
                        for (var i = 0; i < axis.length; i++) {
                            if (i == 0) {
                                yAxes.push({ type: 'linear', display: true, position: 'left', id: axis[i] });
                            } else {
                                yAxes.push({ type: 'linear', display: true, position: 'right', id: axis[i], gridLines: {
                                        drawOnChartArea: false
                                    } });
                            }
                        }
                    }
                }

                var config = {
                    type: this.props.chartType,
                    data: data,
                    options: {
                        responsive: Boolean(this.props.responsive),
                        legend: {
                            position: this.props.legendPosition
                        },
                        title: {
                            fontSize: this.props.titleSize == undefined ? 14 : this.props.titleSize,
                            display: this.props.title != undefined && this.props.title != "",
                            text: this.props.title
                        }
                    }
                };

                if (yAxes != undefined) config.options.scales = { yAxes: yAxes };

                this.state.chart = new Chart(ctx, config);
            } else {
                this.state.chart.update();
            }
        }
    }, {
        key: 'render',
        value: function render() {
            var style = this.props.style;
            var width = this.props.width != undefined ? this.props.width : "400px";
            if (style.width != undefined) width = style.width;
            var height = this.props.height != undefined ? this.props.height : "300px";
            if (style.height != undefined) {
                height = style.height;
            }

            if ((this.state.width != width || this.state.height != height) && this.state.chart != undefined) {
                this.state.chart.destroy();
                this.state.chart = undefined;
            }

            this.state.width = width;
            this.state.height = height;

            var className = "field";
            if (this.props.className != undefined) className += " " + this.props.className;

            return _react2.default.createElement(
                'div',
                { className: className, style: style },
                _react2.default.createElement('canvas', { id: this.getDivId(), width: width, height: height })
            );
        }
    }, {
        key: 'getDivId',
        value: function getDivId() {
            return "clover-chart-" + this.props.name;
        }
    }, {
        key: 'getChartData',
        value: function getChartData() {
            if (this.props.datasetCustom) {
                var me = this;

                var labels = [];
                if (me.props.dataLabels != undefined) {
                    labels = me.props.dataLabels.split(',');
                }

                var res = {
                    labels: labels,
                    datasets: [{
                        label: me.props.datasetLabel,
                        steppedLine: me.props.datasetSteppedLine,
                        borderColor: me.props.datasetBorderColor,
                        backgroundColor: me.props.datasetBackgroundColor,
                        fill: me.props.datasetFill,
                        borderWidth: me.props.datasetBorderWidth,
                        data: me.props.value
                    }]
                };
                return res;
            }

            return this.copyObj(this.props.value);
        }
    }, {
        key: 'copyObj',
        value: function copyObj(obj) {
            if (null == obj || "object" != (typeof obj === 'undefined' ? 'undefined' : _typeof(obj))) return obj;
            var copy = obj.constructor();

            for (var attr in obj) {
                if (obj.hasOwnProperty(attr)) copy[attr] = this.copyObj(obj[attr]);
            }
            return copy;
        }
    }]);

    return ChartView;
}(_react2.default.Component);

exports.default = ChartView;

/***/ }),
/* 24 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _semanticUiReact = __webpack_require__(1);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var WorkflowBar = function (_React$Component) {
  _inherits(WorkflowBar, _React$Component);

  function WorkflowBar(props) {
    _classCallCheck(this, WorkflowBar);

    var _this = _possibleConstructorReturn(this, (WorkflowBar.__proto__ || Object.getPrototypeOf(WorkflowBar)).call(this, props));

    _this.state = {
      commands: props.commands,
      states: props.states
    };

    _this.checkGetAdditionalDataForControl();
    return _this;
  }

  _createClass(WorkflowBar, [{
    key: 'componentDidMount',
    value: function componentDidMount() {
      this.isMount = true;
    }
  }, {
    key: 'componentWillUnmount',
    value: function componentWillUnmount() {
      this.isMount = false;
    }
  }, {
    key: 'checkGetAdditionalDataForControl',
    value: function checkGetAdditionalDataForControl() {
      if (this.props.getAdditionalDataForControl == undefined && this.props.commands == undefined && this.props.states == undefined) {
        if (console != undefined) {
          console.log("WorkflowBar: This control requres getAdditionalDataForControl or commands and states not undefined parameters!");
        }
      } else {
        var me = this;
        this.props.getAdditionalDataForControl(this, {}, function (_ref) {
          var commands = _ref.commands,
              states = _ref.states;

          me.state.commands = commands;
          me.state.states = states;

          if (me.props.handleEvent != undefined) {
            me.props.handleEvent({ key: me.props.name, eventName: "onReceivedCommands",
              parameters: {
                commands: me.state.commands,
                states: me.state.states
              }
            });
          }

          if (me.isMount) me.forceUpdate();
        });
      }
    }
  }, {
    key: 'render',
    value: function render() {
      var className = this.props.className + " clover-workflowbar";
      var style = this.props.style;

      var commands = this.state.commands != undefined ? this.state.commands : this.props.commands;
      var states = this.state.states != undefined ? this.state.states : this.props.states;

      return _react2.default.createElement(
        'div',
        { className: className, style: style },
        _react2.default.createElement(
          _semanticUiReact.Form.Group,
          null,
          this.renderCommands(commands),
          this.renderSetState(states)
        )
      );
    }
  }, {
    key: 'renderCommands',
    value: function renderCommands(commands) {
      if (Array.isArray(commands) && commands.length > 0) {
        var me = this;
        var res = [];

        commands.forEach(function (b) {
          res.push(_react2.default.createElement(
            _semanticUiReact.Button,
            { key: b.value, className: "buttontype" + b.type, onClick: me.onCommand.bind(me, b) },
            b.text
          ));
        });

        return res;
      }
      return undefined;
    }
  }, {
    key: 'renderSetState',
    value: function renderSetState(states) {
      if (Boolean(this.props.blockSetState)) {
        return;
      }

      if (Array.isArray(states) && states.length > 0) {
        var disableClick = this.state["setstate"] == undefined || this.state["setstate"] == "";

        var setStateButton = "Set state";

        if (this.props.setStateButton != undefined && this.props.setStateButton != "") {
          setStateButton = this.props.setStateButton;
        } else {
          if (window.CloverAdminLang != undefined && window.CloverAdminLang.workflowbar != undefined) {
            setStateButton = window.CloverAdminLang.workflowbar.setstate;
          }
        }

        return [_react2.default.createElement(_semanticUiReact.Form.Dropdown, {
          key: 'setstate',
          name: 'setstate',
          className: 'setstate',
          placeholder: 'States',
          options: states,
          onChange: this.handleChanged.bind(this),
          selection: true, fluid: true, search: true }), _react2.default.createElement(
          _semanticUiReact.Button,
          { key: 'btnsetstate', disabled: disableClick, className: 'buttontype2', onClick: this.onSetState.bind(this) },
          setStateButton
        )];
      }
      return undefined;
    }
  }, {
    key: 'onCommand',
    value: function onCommand(button) {
      if (this.props.handleEvent != undefined) {
        this.props.handleEvent({ key: this.props.name, eventName: "onCommandClick", parameters: { command: button } });
      }
    }
  }, {
    key: 'onSetState',
    value: function onSetState() {
      if (this.props.handleEvent != undefined) {

        var states = this.state.states != undefined ? this.state.states : this.props.states;
        var currentState = undefined;
        for (var i = 0; i < states.length; i++) {
          if (states[i].value == this.state.setstate) {
            currentState = states[i];
            break;
          }
        }

        this.props.handleEvent({ key: this.props.name, eventName: "onSetStateClick", parameters: { state: currentState } });
      }
    }
  }, {
    key: 'handleChanged',
    value: function handleChanged(e, _ref2) {
      var name = _ref2.name,
          value = _ref2.value;

      this.state[name] = value;
      this.forceUpdate();
    }
  }]);

  return WorkflowBar;
}(_react2.default.Component);

exports.default = WorkflowBar;

/***/ }),
/* 25 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _semanticUiReact = __webpack_require__(1);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var Dictionary = function (_React$Component) {
    _inherits(Dictionary, _React$Component);

    function Dictionary(props) {
        _classCallCheck(this, Dictionary);

        var _this = _possibleConstructorReturn(this, (Dictionary.__proto__ || Object.getPrototypeOf(Dictionary)).call(this, props));

        _this.state = {
            options: []
        };

        _this.pageSize = props.pageSize;
        if (_this.pageSize == undefined || _this.pageSize == "") _this.pageSize = 100;
        return _this;
    }

    _createClass(Dictionary, [{
        key: 'componentDidMount',
        value: function componentDidMount() {
            this.GetAdditionalData();
        }
    }, {
        key: 'componentDidUpdate',
        value: function componentDidUpdate(prevProps, prevState) {
            this.GetAdditionalData();
        }
    }, {
        key: 'GetAdditionalData',
        value: function GetAdditionalData() {
            if (this.state.dataModel === undefined) {
                if (console !== undefined && this.props.buildermode == true) console.log("Dictionary: Set DataModel label!");
            } else if (this.state.getAdditionalDataForControl === undefined) {
                if (console !== undefined && this.props.buildermode == true) console.log("Dictionary: For paging on server need to set getAdditionalDataForControl func!");
            } else {
                if (this.state.needFetch) {
                    var me = this;
                    var settings = { model: this.state.dataModel };
                    var lastLoadPage = 0;
                    if (this.props.paging) {
                        settings.startIndex = 0;
                        settings.pageSize = this.pageSize;
                    }

                    this.state.isFetching = true;
                    this.state.needFetch = false;
                    this.state.getAdditionalDataForControl(this, settings, function (_ref) {
                        var items = _ref.items,
                            rowsCount = _ref.rowsCount;
                        //TODO cancellation token from async request
                        me.setData({ items: items, rowsCount: rowsCount, page: lastLoadPage }, true);
                    });
                }

                if (this.state.needValueFetch) {
                    this.state.needValueFetch = false;
                    this.loadCurrentValue();
                }
            }
        }
    }, {
        key: 'render',
        value: function render() {
            var me = this;

            var controlProps = {};
            for (var p in this.props) {
                if (p == "parentIsForm" || p == "getAdditionalDataForControl" || p == "dataModel" || p == "clearable" || p == "columns" || p == "paging" || p == "pageSize") continue;
                controlProps[p] = this.props[p];
            }

            if (this.props.readOnly) controlProps.disabled = true;

            controlProps.options = this.state.options;
            controlProps.onChange = this.onChange.bind(this);
            if (this.props.paging) {
                controlProps.onSearchChange = this.handleSearchChange.bind(this);
                controlProps.onClose = this.onClose.bind(this);
                if (this.state.open) {
                    controlProps.open = true;
                }
            }

            if (controlProps.multiple) {
                if (controlProps.value == undefined || controlProps.value == null) {
                    controlProps.value = [];
                }

                if (!Array.isArray(controlProps.value)) {
                    controlProps.value = this.getArrayValues(controlProps.value);
                }
            }

            controlProps.loading = this.state.isFetching;
            controlProps.searchQuery = this.state.searchQuery;

            if (this.props.parentIsForm) {
                return _react2.default.createElement(_semanticUiReact.Form.Dropdown, controlProps);
            } else {
                var divClass = "ui labeled input";

                if (this.props.fluid) divClass += " fluid";

                if (this.props.error) divClass += " error";
                return _react2.default.createElement(
                    'div',
                    { className: divClass },
                    this.props.label != undefined && _react2.default.createElement(
                        'div',
                        { className: 'ui label label' },
                        this.props.label
                    ),
                    _react2.default.createElement(_semanticUiReact.Dropdown, controlProps)
                );
            }
        }
    }, {
        key: 'onChange',
        value: function onChange(e, _ref2) {
            var name = _ref2.name,
                value = _ref2.value;

            var loadFlag = false;
            if (this.props.multiple) {
                if (Array.isArray(value)) {
                    var isFind = false;
                    value.forEach(function (v) {
                        if (v === "__load") {
                            isFind = true;
                        }
                    });

                    if (isFind) {
                        loadFlag = true;
                    }
                }
            } else if (value === "__load") {
                loadFlag = true;
            }

            if (loadFlag) {
                this.state.open = true;
                this.setState({ isFetching: true });
                this.loadNextPage();
                value = this.props.value;
            } else if (this.state.open != undefined) {
                this.state.open = undefined;
            }

            if (this.props.onChange != undefined) this.props.onChange(e, { name: this.props.name, value: value });
        }
    }, {
        key: 'onClose',
        value: function onClose() {
            if (this.state.open != true && this.state.searchQuery != "") {
                this.state.isFetching = true;
                this.state.searchQuery = "";
                this.state.lastLoadPage = -1;

                this.loadNextPage(true);
            }
        }
    }, {
        key: 'handleSearchChange',
        value: function handleSearchChange(e, _ref3) {
            var searchQuery = _ref3.searchQuery;

            var me = this;
            setTimeout(function () {
                me.setState({
                    isFetching: true,
                    searchQuery: searchQuery,
                    lastLoadPage: -1
                });

                me.loadNextPage(true);
            }, 100);
        }
    }, {
        key: 'loadNextPage',
        value: function loadNextPage(reset) {
            var me = this;
            var settings = { model: this.state.dataModel };
            var page = this.state.lastLoadPage + 1;

            if (me.state.searchQuery != undefined && me.state.searchQuery != "") {
                settings.filters = [{
                    column: this.getCollumnsForFilter(),
                    term: "like",
                    value: me.state.searchQuery
                }];
            }

            settings.startIndex = page * this.pageSize;
            settings.pageSize = this.pageSize;

            this.state.getAdditionalDataForControl(this, settings, function (_ref4) {
                var items = _ref4.items,
                    rowsCount = _ref4.rowsCount;

                me.setData({ items: items, rowsCount: rowsCount, page: page }, reset);
            });
        }
    }, {
        key: 'setData',
        value: function setData(_ref5, reset) {
            var items = _ref5.items,
                rowsCount = _ref5.rowsCount,
                page = _ref5.page;

            var options = undefined;
            if (reset) {
                options = items;
                if (rowsCount > options.length) {
                    var text = (this.state.searchQuery != undefined ? this.state.searchQuery : "") + "...";
                    options.push({ key: "__load", value: "__load", text: text });
                }

                if (Boolean(this.props.clearable) && !Boolean(this.props.multiple)) {
                    options.unshift({ key: "__reset", value: "", text: "   " });
                }

                if (Boolean(this.props.multiple)) {
                    var values = this.getArrayValues(this.props.value);
                    for (var i = 0; i < values.length; i++) {
                        var value = values[i];
                        for (var j = 0; j < this.state.options.length; j++) {
                            var option = this.state.options[j];
                            if (value == option.value) {
                                options.unshift(option);
                            }
                        }
                    }
                }
            } else {
                options = this.state.options;
                var loadingItem = undefined;
                if (options.length > 0 && options[options.length - 1].key == "__load") {
                    loadingItem = options.pop();
                }

                for (var _i = 0; _i < items.length; _i++) {
                    var item = items[_i];
                    for (var _j = 0; _j < options.length; _j++) {
                        var _option = options[_j];
                        if (_option.key == item.key) {
                            options.splice(_j, 1);
                            break;
                        }
                    }
                    options.push(item);
                }

                if (loadingItem != undefined && rowsCount > options.length) options.push(loadingItem);
            }

            this.setState({
                needFetch: false,
                options: options,
                rowsCount: rowsCount,
                isFetching: false,
                lastLoadPage: page });
        }
    }, {
        key: 'getArrayValues',
        value: function getArrayValues(value) {
            var res = value;
            if (!Array.isArray(res)) {
                var valueArray = void 0;
                try {
                    valueArray = JSON.parse(res);
                } catch (e) {}
                ;

                if (!Array.isArray(valueArray)) {
                    valueArray = [res];
                }

                res = valueArray;
            }
            return res;
        }
    }, {
        key: 'loadCurrentValue',
        value: function loadCurrentValue() {
            var me = this;
            if (this.props.value != undefined && this.props.value != null) {
                if (this.props.multiple) {
                    var values = this.getArrayValues(this.props.value);
                    var unfindedValues = [];
                    for (var i = 0; i < values.length; i++) {
                        var value = values[i];
                        var isFind = false;
                        for (var j = 0; j < this.state.options.length; j++) {
                            var option = this.state.options[j];
                            if (option.value == value) {
                                isFind = true;
                                break;
                            }
                        }

                        if (!isFind) {
                            unfindedValues.push(value);
                        }
                    }

                    if (unfindedValues.length > 0) {
                        var settings = { model: this.state.dataModel };
                        settings.filters = [{
                            column: "__id",
                            term: 'in',
                            value: unfindedValues
                        }];
                        this.state.isFetching = true;

                        this.state.getAdditionalDataForControl(this, settings, function (_ref6) {
                            var items = _ref6.items;

                            me.addAdditionalOptions(items);
                        });
                    }
                } else {
                    var _isFind = false;
                    for (var _i2 = 0; _i2 < this.state.options.length; _i2++) {
                        var _option2 = this.state.options[_i2];
                        if (_option2.value == this.props.value) {
                            _isFind = true;
                            break;
                        }
                    }

                    if (!_isFind) {
                        var settings = { model: this.state.dataModel };
                        settings.filters = [{
                            column: "__id",
                            term: '=',
                            value: me.props.value
                        }];
                        this.state.isFetching = true;

                        this.state.getAdditionalDataForControl(this, settings, function (_ref7) {
                            var items = _ref7.items;

                            me.addAdditionalOptions(items);
                        });
                    }
                }
            }
        }
    }, {
        key: 'addAdditionalOptions',
        value: function addAdditionalOptions(items) {
            if (!Array.isArray(items) || items.length == 0) return;

            var options = this.state.options;

            for (var i = items.length - 1; i >= 0; i--) {
                var isFind = false;
                for (var j = 0; j < options.length; j++) {
                    if (options[j].key == items[i].key) {
                        isFind = true;
                        break;
                    }
                }

                if (!isFind) {
                    options.unshift(items[i]);
                }
            }

            this.state.isFetching = false;
            this.forceUpdate();
        }
    }, {
        key: 'getCollumnsForFilter',
        value: function getCollumnsForFilter() {
            var pattern = new RegExp(' asc', 'gi');
            var res = this.props.columns.replace(pattern, '');

            pattern = new RegExp(' desc', 'gi');
            res = res.replace(pattern, '');

            pattern = new RegExp(' ', 'gi');
            res = res.replace(pattern, '');

            return res;
        }
    }], [{
        key: 'getDerivedStateFromProps',
        value: function getDerivedStateFromProps(nextProps, prevState) {
            if (nextProps.dataModel != prevState.dataModel) {
                return {
                    getAdditionalDataForControl: nextProps.getAdditionalDataForControl,
                    dataModel: nextProps.dataModel,
                    needFetch: true,
                    needValueFetch: true
                };
            }

            if (nextProps.paging && nextProps.value != prevState.value && nextProps.value != undefined) {
                return {
                    needValueFetch: true
                };
            }

            return null;
        }
    }]);

    return Dictionary;
}(_react2.default.Component);

exports.default = Dictionary;

/***/ }),
/* 26 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _semanticUiReact = __webpack_require__(1);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var Container = function (_React$Component) {
  _inherits(Container, _React$Component);

  function Container(props) {
    _classCallCheck(this, Container);

    var _this = _possibleConstructorReturn(this, (Container.__proto__ || Object.getPrototypeOf(Container)).call(this, props));

    _this.state = {};
    return _this;
  }

  _createClass(Container, [{
    key: 'render',
    value: function render() {
      return _react2.default.createElement('div', this.props);
    }
  }]);

  return Container;
}(_react2.default.Component);

exports.default = Container;

/***/ }),
/* 27 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var StaticContent = function (_React$Component) {
  _inherits(StaticContent, _React$Component);

  function StaticContent(props) {
    _classCallCheck(this, StaticContent);

    var _this = _possibleConstructorReturn(this, (StaticContent.__proto__ || Object.getPrototypeOf(StaticContent)).call(this, props));

    _this.state = {};
    return _this;
  }

  _createClass(StaticContent, [{
    key: "render",
    value: function render() {
      var spanProps = {
        name: this.props.name,
        className: this.props["style-customcss"],
        style: this.props.style,
        "data-buildertype": this.props["data-buildertype"]
      };

      if (this.props.isHtml) {
        return _react2.default.createElement("span", _extends({}, spanProps, { dangerouslySetInnerHTML: { __html: this.props.content } }));
      } else {
        var content = this.props.content != undefined ? this.props.content.replace('\n', '<br/>') : undefined;
        return _react2.default.createElement(
          "span",
          spanProps,
          content
        );
      }
    }
  }]);

  return StaticContent;
}(_react2.default.Component);

exports.default = StaticContent;

/***/ }),
/* 28 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _actions = __webpack_require__(3);

var _actions2 = _interopRequireDefault(_actions);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var ControlBar = function (_React$Component) {
  _inherits(ControlBar, _React$Component);

  function ControlBar() {
    _classCallCheck(this, ControlBar);

    return _possibleConstructorReturn(this, (ControlBar.__proto__ || Object.getPrototypeOf(ControlBar)).apply(this, arguments));
  }

  _createClass(ControlBar, [{
    key: 'onDragStart',
    value: function onDragStart(item, e) {
      var selector = '.clover-formbuilder-zone';

      e.dataTransfer.setData('text', '');
      if (item.forContainerType != undefined) {
        var cTypes = item.forContainerType.split(',');
        var subSelector = "";
        cTypes.forEach(function (c) {
          if (subSelector.length > 0) subSelector += ",";
          subSelector += "[data-buildertype='" + c + "'] > " + selector;
        });
        selector = subSelector;
      }

      $(selector).addClass('clover-formbuilder-zone-active').on('dragenter', this.onTargetDragEnter.bind(this, item, 'clover-formbuilder-zone-select')).on('dragleave', this.onTargetDragLeave.bind(this, item, 'clover-formbuilder-zone-select')).on('dragover', function (e) {
        e.preventDefault();
      }).on('drop', this.onDrop.bind(this, item));
    }
  }, {
    key: 'onTargetDragEnter',
    value: function onTargetDragEnter(item, css, e) {
      $(e.target).addClass(css);
    }
  }, {
    key: 'onTargetDragLeave',
    value: function onTargetDragLeave(item, css, e) {
      $(e.target).removeClass(css);
    }
  }, {
    key: 'onDragEnd',
    value: function onDragEnd(item) {
      var zones = $('.clover-formbuilder-zone');

      zones.removeClass('clover-formbuilder-zone-active');
      zones.removeClass('clover-formbuilder-zone-select');
      zones.off();
    }
  }, {
    key: 'onDrop',
    value: function onDrop(item, e) {
      var el = $(e.target);
      if (el.length > 0) {
        _actions2.default.move(item.key, el[0]);
      }

      this.onDragEnd(item);
      return false;
    }
  }, {
    key: 'render',
    value: function render() {
      var className = "clover-formbuilder-item-toolbar-header";
      if (this.props.isGroup) className += " " + "clover-formbuilder-item-toolbar-controlbargroup";

      if (this.props.controlOnRight) {
        className += " " + "clover-formbuilder-item-toolbar-right";
      } else {
        className += " " + "clover-formbuilder-item-toolbar-left";
      }

      return _react2.default.createElement(
        'div',
        { className: className,
          onMouseOver: this.onMouseOver.bind(this),
          onMouseLeave: this.onMouseLeave.bind(this) },
        _react2.default.createElement(
          'div',
          { className: 'clover-formbuilder-item-toolbar-header-buttons' },
          _react2.default.createElement(
            'div',
            { className: 'clover-formbuilder-item-toolbar-header-title' },
            this.props.text
          ),
          _react2.default.createElement('img', { src: '/images/cloverbuilder-move.svg', className: 'move', height: '16px', draggable: true,
            onDragStart: this.onDragStart.bind(this, this.props.model),
            onDragEnd: this.onDragEnd.bind(this, this.props.model),
            onDrag: this.onDrag.bind(this) }),
          _react2.default.createElement('img', { src: '/images/cloverbuilder-edit.svg', height: '16px', onClick: this.props.onEdit.bind(this.props.parent, this.props.model) }),
          _react2.default.createElement('img', { src: '/images/cloverbuilder-copy.svg', height: '16px', onClick: this.props.onCopy.bind(this.props.parent, this.props.model) }),
          _react2.default.createElement('img', { src: '/images/cloverbuilder-delete.svg', height: '16px', onClick: this.props.onDelete.bind(this.props.parent, this.props.model) })
        )
      );
    }
  }, {
    key: 'onMouseOver',
    value: function onMouseOver(e) {
      var el = $(e.target).parents(".clover-formbuilder-item-toolbar-header");
      if (this.props.controlOnRight) {
        el.prev().addClass("clover-formbuilder-item-selected");
      } else {
        el.next().addClass("clover-formbuilder-item-selected");
      }
    }
  }, {
    key: 'onMouseLeave',
    value: function onMouseLeave(e) {
      var el = $(e.target);
      var parents = $(e.target).parents(".clover-formbuilder-item-toolbar-header");
      if (this.props.controlOnRight) {
        el.prev().removeClass("clover-formbuilder-item-selected");
        parents.prev().removeClass("clover-formbuilder-item-selected");
      } else {
        el.next().removeClass("clover-formbuilder-item-selected");
        parents.next().removeClass("clover-formbuilder-item-selected");
      }
    }
  }, {
    key: 'onDrag',
    value: function onDrag(e) {
      var step = 10;
      if (e.clientY < 150) {
        this.scroll(-step);
      }

      if (e.clientY > $(window).height() - 150) {
        this.scroll(step);
      }
    }
  }, {
    key: 'scroll',
    value: function (_scroll) {
      function scroll(_x) {
        return _scroll.apply(this, arguments);
      }

      scroll.toString = function () {
        return _scroll.toString();
      };

      return scroll;
    }(function (step) {
      var scrollY = $(window).scrollTop();
      $(window).scrollTop(scrollY + step);
      if (!stop) {
        setTimeout(function () {
          scroll(step);
        }, 20);
      }
    })
  }]);

  return ControlBar;
}(_react2.default.Component);

exports.default = ControlBar;

/***/ }),
/* 29 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _semanticUiReact = __webpack_require__(1);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var DropdownTrigger = function (_React$Component) {
  _inherits(DropdownTrigger, _React$Component);

  function DropdownTrigger(props) {
    _classCallCheck(this, DropdownTrigger);

    var _this = _possibleConstructorReturn(this, (DropdownTrigger.__proto__ || Object.getPrototypeOf(DropdownTrigger)).call(this, props));

    _this.state = {};
    return _this;
  }

  _createClass(DropdownTrigger, [{
    key: 'render',
    value: function render() {
      var me = this;

      var controlProps = {};
      for (var p in this.props) {
        if (p == "imageUrl" || p == "defaultValue" || p == "value" || p == "handleEvent" || p == "items") continue;
        controlProps[p] = this.props[p];
      }

      controlProps.options = [];
      this.props.items.forEach(function (item) {

        var isSkip = false;
        if (item.visibleCondition !== undefined && item.visibleCondition !== null && item.visibleCondition !== "") {
          var args = '';
          var body = 'return ' + item.visibleCondition;
          try {
            if (!new Function(args, body)()) {
              isSkip = true;
            }
          } catch (e) {};
        }

        if (!isSkip) controlProps.options.push({ value: item.target, text: item.title, target: item.target });
      });
      controlProps.onChange = this.onChange.bind(this);
      controlProps.trigger = _react2.default.createElement(
        'span',
        null,
        this.props.imageUrl != undefined && _react2.default.createElement(_semanticUiReact.Image, { avatar: true, src: this.props.imageUrl }),
        ' ',
        this.props.value != undefined ? this.props.value : this.props.defaultValue
      );
      return _react2.default.createElement(_semanticUiReact.Dropdown, _extends({}, controlProps, {
        onMouseDown: this.onMouseDown.bind(this)
      }));
    }
  }, {
    key: 'onChange',
    value: function onChange(e, _ref) {
      var name = _ref.name,
          value = _ref.value;

      if (this.state.opendialog == true) {
        this.state.opendialog = false;
        return;
      }

      if (this.props.handleEvent != undefined) {
        this.props.handleEvent({ e: e, key: this.props.name, eventName: "onItemClick", parameters: { target: value } });
      }
    }
  }, {
    key: 'onMouseDown',
    value: function onMouseDown(e) {
      this.state.opendialog = !Boolean(this.state.opendialog);
    }
  }]);

  return DropdownTrigger;
}(_react2.default.Component);

exports.default = DropdownTrigger;

/***/ }),
/* 30 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _semanticUiReact = __webpack_require__(1);

var _upload = __webpack_require__(10);

var _upload2 = _interopRequireDefault(_upload);

var _json = __webpack_require__(2);

var _json2 = _interopRequireDefault(_json);

var _datepicker = __webpack_require__(11);

var _datepicker2 = _interopRequireDefault(_datepicker);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var SemanticControl = function (_React$Component) {
  _inherits(SemanticControl, _React$Component);

  function SemanticControl(props) {
    _classCallCheck(this, SemanticControl);

    var _this = _possibleConstructorReturn(this, (SemanticControl.__proto__ || Object.getPrototypeOf(SemanticControl)).call(this, props));

    _this.state = {};
    return _this;
  }

  _createClass(SemanticControl, [{
    key: 'render',
    value: function render() {
      var _this2 = this;

      var me = this;
      var propsControl = {};
      for (var p in this.props) {
        if (p === "additionalParams" || p === "items") continue;

        propsControl[p] = this.props[p];
      }

      var model = this.props.additionalParams.model;
      var data = this.props.additionalParams.data;
      var errors = this.props.additionalParams.errors;
      var children = this.props.additionalParams.children;
      var parentItem = this.props.additionalParams.parentItem;
      var handleEvent = this.props.additionalParams.handleEvent;

      var type = model["data-buildertype"];

      var res;
      if (type === 'header') {
        res = _react2.default.createElement(_semanticUiReact.Header, _extends({}, propsControl, {
          textAlign: model.textAlign,
          size: model.size,
          content: this.props.content,
          subheader: this.props.subheader }));
      } else if (type === 'button') {
        propsControl.floated = model.floated;
        propsControl.size = model.size !== "" ? model.size : null;
        propsControl.content = model.content;
        propsControl.type = model.buttonType;
        propsControl.basic = model.basic;
        propsControl.circular = model.circular;
        propsControl.compact = model.compact;
        propsControl.disabled = model.disabled;
        propsControl.fluid = model.fluid;
        propsControl.inverted = model.inverted;
        propsControl.loading = model.loading;
        propsControl.primary = model.primary;
        propsControl.secondary = model.secondary;
        propsControl.toggle = model.toggle;

        if (handleEvent !== undefined) {
          propsControl.onClick = function (e) {
            return handleEvent({ syntheticEvent: e, key: propsControl.name, eventName: "onClick" });
          };
        }

        if (this.isForm(parentItem)) {
          res = _react2.default.createElement(_semanticUiReact.Form.Button, propsControl);
        } else {
          res = _react2.default.createElement(_semanticUiReact.Button, propsControl);
        }
      } else if (type === 'label') {
        res = _react2.default.createElement(_semanticUiReact.Label, _extends({}, propsControl, {
          size: model.size,
          content: this.props.content,
          attached: model.attached,
          basic: model.basic,
          circular: model.circular,
          corner: model.corner,
          floating: model.floating,
          horizontal: model.horizontal,
          pointing: model.pointing }));
      } else if (type === 'message') {
        res = _react2.default.createElement(_semanticUiReact.Message, _extends({}, propsControl, {
          floated: model.floated,
          size: model.size,
          content: this.props.content,
          compact: model.compact,
          error: model.error,
          floating: model.floating,
          info: model.info,
          negative: model.negative,
          positive: model.positive,
          success: model.success,
          warning: model.warning,
          header: this.props.header
        }));
      } else if (type === 'input') {
        propsControl.defaultValue = model.defaultvalue;
        propsControl.size = model.size;

        if (model.label != undefined && model.label != "") propsControl.label = model.label;

        propsControl.labelPosition = model.labelPosition;
        propsControl.placeholder = model.placeholder;
        propsControl.type = model.type;
        propsControl.loading = model.loading;
        propsControl.inverted = model.inverted;
        propsControl.error = model.error;
        propsControl.disabled = model.disabled;
        propsControl.transparent = model.transparent;
        propsControl.fluid = model.fluid;
        propsControl.readOnly = model.readOnly || this.props.readOnly;

        if (handleEvent != null) {
          propsControl.onChange = function (e, _ref) {
            var name = _ref.name,
                value = _ref.value;

            handleEvent({ syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: value });
          };
        }

        if (data != undefined && data != null) {
          propsControl.value = data[propsControl.name];
        } else propsControl.value = "";

        if ((typeof errors === 'undefined' ? 'undefined' : _typeof(errors)) === "object" && errors[model.key] !== undefined) {
          propsControl.error = Boolean(errors[model.key]);
        }

        if (propsControl.type === "file") {
          propsControl.isForm = this.isForm(parentItem);
          res = _react2.default.createElement(_upload2.default, _extends({}, propsControl, {
            downloadUrl: this.props.additionalParams.downloadUrl,
            uploadUrl: this.props.additionalParams.uploadUrl }));
        } else if (propsControl.type === "date" || propsControl.type === "time" || propsControl.type === "datetime") {
          propsControl.isForm = this.isForm(parentItem);
          // propsControl.dateFormat = model.dateFormat;
          res = _react2.default.createElement(_datepicker2.default, propsControl);
        } else {
          if (this.isForm(parentItem)) {
            res = _react2.default.createElement(_semanticUiReact.Form.Input, propsControl);
          } else {
            res = _react2.default.createElement(_semanticUiReact.Input, propsControl);
          }
        }
      } else if (type === 'textarea') {
        propsControl.placeholder = model.placeholder;
        propsControl.rows = model.rows !== null && model.rows !== undefined ? Number(model.rows) : undefined;

        if (model.label !== undefined && model.label !== "") propsControl.label = model.label;

        propsControl.autoHeight = model.autoHeight;
        propsControl.readOnly = model.readOnly || this.props.readOnly;

        if (handleEvent !== null) {
          propsControl.onChange = function (e, _ref2) {
            var name = _ref2.name,
                value = _ref2.value;

            handleEvent({ syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: value });
          };
        }

        if (data != undefined) propsControl.value = data[propsControl.name];

        if ((typeof errors === 'undefined' ? 'undefined' : _typeof(errors)) === "object" && errors[model.key] !== undefined) {
          propsControl.error = Boolean(errors[model.key]);
        }

        if (this.isForm(parentItem)) {
          res = _react2.default.createElement(_semanticUiReact.Form.TextArea, propsControl);
        } else {
          res = _react2.default.createElement(_semanticUiReact.TextArea, propsControl);
        }
      } else if (type === 'checkbox') {

        if (model.label !== undefined && model.label !== "") propsControl.label = model.label;

        propsControl.placeholder = model.placeholder;
        propsControl.type = model.type;
        propsControl.disabled = model.disabled;
        propsControl.fitted = model.fitted;
        propsControl.indeterminate = model.indeterminate;
        propsControl.readOnly = model.readOnly || this.props.readOnly;
        propsControl.slider = model.slider;
        propsControl.toggle = model.toggle;

        if (handleEvent !== null) {
          propsControl.onChange = function (e, _ref3) {
            var name = _ref3.name,
                checked = _ref3.checked;

            handleEvent({ syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: checked });
          };
        }

        if (data !== undefined) {
          if (typeof variable === "boolean") {
            propsControl.checked = data[propsControl.name];
          } else if (data[propsControl.name] === "true" || data[propsControl.name] === "1") {
            propsControl.checked = true;
          } else if (data[propsControl.name] === "false" || data[propsControl.name] === "0") {
            propsControl.checked = false;
          } else {
            propsControl.checked = Boolean(data[propsControl.name]);
          }
        }

        if ((typeof errors === 'undefined' ? 'undefined' : _typeof(errors)) === "object" && errors[model.key] !== undefined) {
          propsControl.error = Boolean(errors[model.key]);
        }

        if (this.isForm(parentItem)) {
          res = _react2.default.createElement(_semanticUiReact.Form.Checkbox, propsControl);
        } else {
          res = _react2.default.createElement(_semanticUiReact.Checkbox, propsControl);
        }
      } else if (type === 'dropdown') {
        var options = [];
        if (model["data-elements"] !== undefined) {
          if (Array.isArray(model["data-elements"])) {
            options = model["data-elements"];
          } else {
            options = _json2.default.parse(model["data-elements"]);
          }
        }

        if (model.label !== undefined && model.label !== "") propsControl.label = model.label;

        propsControl.defaultValue = model.defaultvalue;
        propsControl.placeholder = model.placeholder;
        propsControl.options = options;
        propsControl.loading = model.loading;
        propsControl.error = model.error;
        propsControl.fluid = model.fluid;
        propsControl.selection = model.selection;
        propsControl.multiple = model.multiple;
        propsControl.search = model.search;
        propsControl.disabled = model.disabled || model.readOnly || this.props.readOnly;

        if (data !== undefined) propsControl.value = data[propsControl.name];

        if ((typeof errors === 'undefined' ? 'undefined' : _typeof(errors)) === "object" && errors[model.key] !== undefined) {
          propsControl.error = Boolean(errors[model.key]);
        }

        if (handleEvent !== null) {
          propsControl.onChange = function (e, _ref4) {
            var name = _ref4.name,
                value = _ref4.value;

            handleEvent({ syntheticEvent: e, key: propsControl.name, eventName: "onChange", name: name, value: value });
          };
        }

        propsControl.allowAdditions = model.allowAddItems;
        if (propsControl.allowAdditions) {
          propsControl.onAddItem = function (e, _ref5) {
            var value = _ref5.value;

            var v = propsControl.value;
            if (Array.isArray(v)) v.push(value);else {
              v = [value];
            }

            propsControl.onChange(e, { name: propsControl.name, value: v });
          };
        }

        if (propsControl.multiple) {
          if (propsControl.value === undefined || propsControl.value === null) {
            propsControl.value = [];
          }

          if (!Array.isArray(propsControl.value)) {
            var valueArray = void 0;
            try {
              valueArray = _json2.default.parse(propsControl.value);
            } catch (e) {};

            if (!Array.isArray(valueArray)) {
              valueArray = [propsControl.value];
            }

            propsControl.value = valueArray;
          }

          if (propsControl.allowAdditions) {
            this.dropdownCheckAdditional(propsControl.value, propsControl.options);
          }
        }

        if (this.isForm(parentItem)) {
          res = _react2.default.createElement(_semanticUiReact.Form.Dropdown, propsControl);
        } else {
          res = _react2.default.createElement(_semanticUiReact.Dropdown, propsControl);
        }
      } else if (type === 'statistic') {
        var items = [];
        if (model["data-elements"] !== undefined) {
          if (Array.isArray(model["data-elements"])) {
            items = model["data-elements"];
          } else {
            items = _json2.default.parse(model["data-elements"]);
          }
        }

        res = _react2.default.createElement(_semanticUiReact.Statistic.Group, _extends({}, propsControl, {
          floated: model.floated,
          horizontal: model.horizontal,
          size: model.size,
          items: items }));
      } else if (type === 'image') {
        res = _react2.default.createElement(_semanticUiReact.Image, _extends({}, propsControl, {
          avatar: model.avatar,
          bordered: model.bordered,
          centered: model.centered,
          disabled: model.disabled,
          inline: model.inline,
          href: this.props.href,
          src: this.props.src,
          floated: model.floated,
          shape: model.shape,
          spaced: model.spaced,
          verticalAlign: model.verticalAlign,
          height: model.height,
          width: model.width }));
      } else if (type === 'form') {
        res = _react2.default.createElement(_semanticUiReact.Form, _extends({}, propsControl, {
          children: children,
          size: model.size,
          loading: model.loading,
          error: model.error,
          inverted: model.inverted,
          reply: model.reply,
          success: model.success,
          warning: model.warning }));
      } else if (type === 'formgroup') {
        var widths = model.widths;
        if (widths === "custom") widths = model.widthsCustom;

        if (model.orientation) propsControl[model.orientation] = true;

        res = _react2.default.createElement(_semanticUiReact.Form.Group, _extends({}, propsControl, {
          widths: widths,
          children: children }));
      } else if (type === 'breadcrumb') {
        var _children = [];
        if (Array.isArray(this.props.items)) {
          var _loop = function _loop(i) {
            var item = _this2.props.items[i];
            var childProps = { key: i };
            childProps.active = item.active;
            childProps.href = item.url;
            if (handleEvent !== null) {
              childProps.onClick = function (e, _ref6) {
                var name = _ref6.name,
                    checked = _ref6.checked;

                handleEvent({ syntheticEvent: e, key: propsControl.name, eventName: "onItemClick", parameters: { target: item.url } });
                e.preventDefault();
              };
            }
            _children.push(_react2.default.createElement(
              _semanticUiReact.Breadcrumb.Section,
              childProps,
              item.text === undefined ? "<not set>" : item.text
            ));
            if (i < _this2.props.items.length - 1) {
              var dividerProps = {
                key: i + "_d"
              };
              if (item.divider !== "") dividerProps.icon = item.divider;
              _children.push(_react2.default.createElement(_semanticUiReact.Breadcrumb.Divider, dividerProps));
            }
          };

          for (var i = 0; i < this.props.items.length; i++) {
            _loop(i);
          }
        }
        res = _react2.default.createElement(_semanticUiReact.Breadcrumb, _extends({}, propsControl, { children: _children }));
      } else {
        res = _react2.default.createElement(
          'span',
          null,
          'Unknow type \'',
          type,
          '\' of \'',
          this.props.name,
          '\' element.'
        );
      }
      return res;
    }
  }, {
    key: 'isForm',
    value: function isForm(m) {
      return m != null && (m["data-buildertype"] === "form" || m["data-buildertype"] === "formgroup");
    }
  }, {
    key: 'dropdownCheckAdditional',
    value: function dropdownCheckAdditional(value, options) {
      if (!Array.isArray(value)) return;
      value.forEach(function (v) {
        var isFind = false;
        for (var i = 0; i < options.length; i++) {
          var o = options[i];
          if (v === o.value) {
            isFind = true;
            break;
          }
        }

        if (isFind == false) {
          options.push({ value: v, text: v });
        }
      });
    }
  }]);

  return SemanticControl;
}(_react2.default.Component);

exports.default = SemanticControl;

/***/ }),
/* 31 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _semanticUiReact = __webpack_require__(1);

var _reactDropzoneComponent = __webpack_require__(32);

var _reactDropzoneComponent2 = _interopRequireDefault(_reactDropzoneComponent);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var Dropzone = function (_React$Component) {
  _inherits(Dropzone, _React$Component);

  function Dropzone(props) {
    _classCallCheck(this, Dropzone);

    var _this = _possibleConstructorReturn(this, (Dropzone.__proto__ || Object.getPrototypeOf(Dropzone)).call(this, props));

    _this.state = {
      commands: props.commands,
      states: props.states
    };
    return _this;
  }

  _createClass(Dropzone, [{
    key: 'componentDidMount',
    value: function componentDidMount() {
      this.isMount = true;
    }
  }, {
    key: 'componentWillUnmount',
    value: function componentWillUnmount() {
      this.isMount = false;
    }
  }, {
    key: 'render',
    value: function render() {
      var me = this;

      var data = this.props.additionalParams.data;
      var errors = this.props.additionalParams.errors;
      var parentItem = this.props.additionalParams.parentItem;
      var handleEvent = this.props.additionalParams.handleEvent;

      var iconFiletypes = undefined;
      if (this.props.iconFiletypes != undefined && this.props.iconFiletypes != "") {
        var types = this.props.iconFiletypes.split(",");
        if (Array.isArray(types) && types.length > 0) {
          iconFiletypes = [];
          types.forEach(function (t) {
            iconFiletypes.push(t.trim());
          });
        }
      }

      var djsConfig = {
        addRemoveLinks: this.props.addRemoveLinks,
        autoProcessQueue: this.props.autoProcessQueue && this.props.postUrl != undefined
      };

      var componentConfig = {
        iconFiletypes: iconFiletypes,
        showFiletypeIcon: this.props.showFiletypeIcon,
        postUrl: this.props.postUrl == undefined ? "no-url" : this.props.postUrl
      };

      var eventHandlers = {
        success: me.fileUploadSuccess.bind(this)
      };
      // if(handleEvent != undefined){
      //   var events = this.getEvents();
      //   events.forEach(function(e){
      //     eventHandlers[e] = handleEvent({ key: me.props.name, eventName: e});
      //   });
      // }

      var control = this.props.readOnly ? _react2.default.createElement('div', null) : _react2.default.createElement(_reactDropzoneComponent2.default, { config: componentConfig, eventHandlers: eventHandlers, djsConfig: djsConfig });

      var res = undefined;
      if (this.isForm(parentItem)) {
        res = _react2.default.createElement(
          'div',
          { className: 'field' },
          control
        );
      } else {
        res = control;
      }
      return res;
    }
  }, {
    key: 'isForm',
    value: function isForm(m) {
      return m != null && (m["data-buildertype"] == "form" || m["data-buildertype"] == "formgroup");
    }
  }, {
    key: 'fileUploadSuccess',
    value: function fileUploadSuccess(file, response) {
      var handleEvent = this.props.additionalParams.handleEvent;
      if (handleEvent != undefined) {
        handleEvent({ key: this.props.name,
          eventName: "success",
          name: this.props.name,
          value: response.message,
          parameters: {
            name: file.name,
            size: file.size,
            token: response.message
          }
        });

        setTimeout(function () {
          file._removeLink.click();
        }, 500);
      }
    }
  }, {
    key: 'getEvents',
    value: function getEvents() {
      return ["drop", "dragstart", "dragend", "dragenter", "dragover", "dragleave", "addedfile", "removedfile", "thumbnail", "error", "processing", "uploadprogress", "sending", "success", "complete", "canceled", "maxfilesreached", "maxfilesexceeded", "processingmultiple", "sendingmultiple", "successmultiple", "completemultiple", "canceledmultiple", "totaluploadprogress", "reset", "queuecompleted"];
    }
  }]);

  return Dropzone;
}(_react2.default.Component);

exports.default = Dropzone;

/***/ }),
/* 32 */
/***/ (function(module, exports) {

module.exports = __WEBPACK_EXTERNAL_MODULE_32__;

/***/ }),
/* 33 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _semanticUiReact = __webpack_require__(1);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var SearchControl = function (_React$Component) {
  _inherits(SearchControl, _React$Component);

  function SearchControl(props) {
    _classCallCheck(this, SearchControl);

    var _this = _possibleConstructorReturn(this, (SearchControl.__proto__ || Object.getPrototypeOf(SearchControl)).call(this, props));

    _this.state = { value: '' };
    return _this;
  }

  _createClass(SearchControl, [{
    key: 'render',
    value: function render() {
      var me = this;

      var controlProps = {};
      for (var p in this.props) {
        if (p == "value" || p == "handleEvent") continue;
        controlProps[p] = this.props[p];
      }

      return _react2.default.createElement(_semanticUiReact.Search, _extends({}, controlProps, {
        fluid: true,
        loading: this.state.isLoading,
        onResultSelect: this.handleResultSelect.bind(this),
        onSearchChange: this.handleSearchChange.bind(this),
        results: this.state.results,
        value: this.state.value
      }));
    }
  }, {
    key: 'resetSearch',
    value: function resetSearch() {
      this.setState({ isLoading: false, results: [] });
    }
  }, {
    key: 'handleResultSelect',
    value: function handleResultSelect(e, _ref) {
      var result = _ref.result;

      if (this.props.handleEvent !== undefined) {
        this.props.handleEvent({ key: this.props.name, eventName: "onSelect", parameters: result });
      }
    }
  }, {
    key: 'handleSearchChange',
    value: function handleSearchChange(e, _ref2) {
      var value = _ref2.value;

      var me = this;
      me.setState({ isLoading: true, value: value });

      setTimeout(function () {
        if (me.state.value === null || me.state.value === undefined || me.state.value.length < 2) {
          return me.resetSearch();
        }
        me.search(me.state.value);
      }, 200);
    }
  }, {
    key: 'search',
    value: function search(searchStr) {
      var me = this;
      var url = this.props.url;
      url += this.props.url.includes('?') ? "&" : "?";
      url += "term=" + searchStr;
      fetch(url, {
        credentials: 'same-origin'
      }).then(function (response) {
        return response.json();
      }).then(function (results) {
        me.setState({
          isLoading: false,
          results: results
        });
      }).catch(function (error) {
        if (console == undefined) alert(error);else console.error(error);
      });
    }
  }]);

  return SearchControl;
}(_react2.default.Component);

exports.default = SearchControl;

/***/ }),
/* 34 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _store = __webpack_require__(5);

var _store2 = _interopRequireDefault(_store);

var _actions = __webpack_require__(3);

var _actions2 = _interopRequireDefault(_actions);

var _controls = __webpack_require__(4);

var _controls2 = _interopRequireDefault(_controls);

var _semanticUiReact = __webpack_require__(1);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var Preview = function (_React$Component) {
  _inherits(Preview, _React$Component);

  function Preview(props) {
    _classCallCheck(this, Preview);

    var _this = _possibleConstructorReturn(this, (Preview.__proto__ || Object.getPrototypeOf(Preview)).call(this, props));

    _this.state = {
      data: [],
      editElement: null
    };

    _store2.default.listen(_this.dataChanged.bind(_this));
    return _this;
  }

  _createClass(Preview, [{
    key: 'dataChanged',
    value: function dataChanged(data) {
      this.setState({
        data: data,
        editElement: null
      });
    }
  }, {
    key: '_onEdit',
    value: function _onEdit(item) {
      _actions2.default.showEditForm(item.key);
    }
  }, {
    key: '_onCopy',
    value: function _onCopy(item) {
      _store2.default.copy(item);
    }
  }, {
    key: '_onDestroy',
    value: function _onDestroy(item) {
      _store2.default.remove(item);
    }
  }, {
    key: '_handleEvent',
    value: function _handleEvent(p) {
      // if(console != undefined){
      //   console.log("CloverFormBuilder: handleEvent", p);
      // }
    }
  }, {
    key: 'render',
    value: function render() {
      var items = _controls2.default.createControls(this, {
        model: this.state.data,
        data: undefined,
        buildermode: true,
        eventOnEdit: this._onEdit,
        eventOnDelete: this._onDestroy,
        eventOnCopy: this._onCopy,
        parentItem: undefined,
        handleEvent: this._handleEvent,
        getFormFunc: this.props.getFormFunc,
        getFormFist: this.props.getFormFist,
        getAdditionalDataForControl: this.props.getAdditionalDataForControl,
        disableRefs: true,
        downloadUrl: this.props.downloadUrl,
        uploadUrl: this.props.uploadUrl,
        controlsToReplace: [],
        needCheckReplace: false
      });

      var dropzonetext = undefined;
      if (this.props.localization != undefined && this.props.localization.preview != undefined) {
        dropzonetext = this.props.localization.preview.dropzonetext;
      }
      var dropzone = _controls2.default.createBuilderDropzone("dropzone_header", undefined, undefined, dropzonetext);
      var dropzone_footer = items.length > 0 ? _controls2.default.createBuilderDropzone("dropzone_footer", undefined, undefined, dropzonetext) : '';

      return _react2.default.createElement(
        'div',
        { className: 'clover-formbuilder-preview' },
        dropzone,
        items,
        dropzone_footer
      );
    }
  }]);

  return Preview;
}(_react2.default.Component);

exports.default = Preview;

/***/ }),
/* 35 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _reactDom = __webpack_require__(6);

var _reactDom2 = _interopRequireDefault(_reactDom);

var _store = __webpack_require__(5);

var _store2 = _interopRequireDefault(_store);

var _actions = __webpack_require__(3);

var _actions2 = _interopRequireDefault(_actions);

var _controls = __webpack_require__(4);

var _controls2 = _interopRequireDefault(_controls);

var _semanticUiReact = __webpack_require__(1);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var EditForm = function (_React$Component) {
  _inherits(EditForm, _React$Component);

  function EditForm(props) {
    _classCallCheck(this, EditForm);

    var _this = _possibleConstructorReturn(this, (EditForm.__proto__ || Object.getPrototypeOf(EditForm)).call(this, props));

    _this.state = {
      key: undefined,
      item: undefined,
      open: false
    };

    _store2.default.listenTo(_actions2.default.showEditForm, _this.onShow.bind(_this));
    return _this;
  }

  _createClass(EditForm, [{
    key: "handleChange",
    value: function handleChange(e, _ref) {
      var name = _ref.name,
          value = _ref.value,
          checked = _ref.checked;

      var data = this.state.item;

      if (value == undefined) data[name] = checked;else data[name] = value;

      this.setState({ item: data });
    }
  }, {
    key: "onShow",
    value: function onShow(key) {
      var data = _store2.default.getByKey(key);
      var item = {};
      for (var i in data) {
        if (_typeof(data[i]) == "object") {
          item[i] = JSON.parse(JSON.stringify(data[i]));
        } else {
          item[i] = data[i];
        }
      }

      this.setState({
        key: key,
        item: item,
        open: true
      });
    }
  }, {
    key: "isChangedItem",
    value: function isChangedItem() {
      var data = _store2.default.getByKey(this.state.key);
      var item = this.state.item;

      for (var i in item) {
        if (JSON.stringify(item[i]) != JSON.stringify(data[i])) if (i == "events" && (item[i] == undefined || JSON.stringify(item[i]) == "{}") && (data[i] == undefined || JSON.stringify(data[i]) == "{}")) {
          continue;
        } else {
          return true;
        }
      }
      return false;
    }
  }, {
    key: "getControlsList",
    value: function getControlsList() {
      return _store2.default.getAllKeys(_store2.default.getData());
    }
  }, {
    key: "showConfirm",
    value: function showConfirm(text, confirmHandle) {
      this.setState({ confirm: true, confirmtext: text, confirmHandle: confirmHandle });
    }
  }, {
    key: "onClose",
    value: function onClose() {
      var ischanged = this.isChangedItem();
      if (ischanged) {
        var msg = "Close without save?";
        if (this.props.localization != undefined) {
          msg = this.props.localization.base.closewithoutsavequestion;
        }

        this.showConfirm(msg, this.onCloseConfirmed.bind(this));
      } else {
        this.onCloseConfirmed();
      }
    }
  }, {
    key: "onSave",
    value: function onSave() {
      _store2.default.updateItemByKey(this.state.key, this.state.item);
      this.onCloseConfirmed();
    }
  }, {
    key: "onCloseConfirmed",
    value: function onCloseConfirmed() {
      this.setState({ open: false, confirm: false });
    }
  }, {
    key: "createError",
    value: function createError(text) {

      var closebtn = "Close";
      if (this.props.localization != undefined) {
        closebtn = this.props.localization.base.closebutton;
      }

      return _react2.default.createElement(
        _semanticUiReact.Modal,
        { open: this.state.open, onClose: this.onClose.bind(this) },
        _react2.default.createElement(
          _semanticUiReact.Modal.Header,
          null,
          "Error"
        ),
        _react2.default.createElement(
          _semanticUiReact.Modal.Content,
          null,
          _react2.default.createElement(
            "p",
            null,
            text
          )
        ),
        _react2.default.createElement(
          _semanticUiReact.Modal.Actions,
          null,
          _react2.default.createElement(
            _semanticUiReact.Button,
            { onClick: this.onClose.bind(this) },
            closebtn
          )
        )
      );
    }
  }, {
    key: "render",
    value: function render() {
      var _this2 = this;

      if (this.state.item == undefined) return _react2.default.createElement("div", null);

      var editForm = _controls2.default.getEditControlByType(this.state.item["data-buildertype"]);
      if (editForm == undefined) {
        return this.createError("EditForm is not found for this control!");
      }

      var okbtn = "OK";
      if (this.props.localization != undefined) {
        okbtn = this.props.localization.base.okbutton;
      }
      var cancelbtn = "Cancel";
      if (this.props.localization != undefined) {
        cancelbtn = this.props.localization.base.cancelbutton;
      }
      var questiontitle = "Question";
      if (this.props.localization != undefined) {
        questiontitle = this.props.localization.base.questiontitle;
      }

      var confirmHandleCancel = function confirmHandleCancel() {
        return _this2.setState({ confirm: false });
      };
      return _react2.default.createElement(
        "div",
        null,
        _react2.default.createElement(editForm, { key: "editform",
          data: this.state.item,
          parent: this,
          open: this.state.open,
          onSave: this.onSave,
          onClose: this.onClose,
          actions: this.props.actions,
          className: "clover-formbuilder-editform",
          localization: this.props.localization
        }),
        _react2.default.createElement(
          _semanticUiReact.Modal,
          { size: "small", open: this.state.confirm, dimmer: "inverted", onClose: confirmHandleCancel },
          _react2.default.createElement(
            _semanticUiReact.Modal.Header,
            null,
            questiontitle
          ),
          _react2.default.createElement(
            _semanticUiReact.Modal.Content,
            null,
            _react2.default.createElement(
              "p",
              null,
              this.state.confirmtext
            )
          ),
          _react2.default.createElement(
            _semanticUiReact.Modal.Actions,
            null,
            _react2.default.createElement(
              _semanticUiReact.Button,
              { className: "buttontype1", onClick: this.state.confirmHandle },
              okbtn
            ),
            _react2.default.createElement(
              _semanticUiReact.Button,
              { className: "buttontype2", onClick: confirmHandleCancel },
              cancelbtn
            )
          )
        )
      );
    }
  }]);

  return EditForm;
}(_react2.default.Component);

exports.default = EditForm;

/***/ }),
/* 36 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _base, _labelform;

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

var lang = {
  clearbutton: "Clear",
  uploadbutton: "Upload",
  downloadbutton: "Download",
  toolbar: {
    sepContainers: "Containers",
    container: "DIV",
    form: "Form",
    formgroup: "Form Group",
    menu: "Menu",
    workflowbar: "Workflow bar",
    customblock: "Custom block",
    sepCollection: "Collections",
    gridview: "GridView",
    collectioneditor: "Collection Editor",
    sepControls: "Controls",
    header: "Header",
    input: "Input",
    textarea: "TextArea",
    dictionary: "Dictionary",
    dropdown: "Dropdown",
    checkbox: "CheckBox",
    radiogroup: "Radio group",
    button: "Button",
    label: "Label",
    message: "Message",
    image: "Image",
    statistic: "Statistic",
    customcontrol: "Custom control",
    staticcontent: "Static Content",
    dropdowntrigger: "Dropdown trigger",
    sepCharts: "Charts",
    barchart: "Bar",
    linechart: "Line",
    scatterchart: "Scatter",
    doughnutchart: "Doughnut",
    piechart: "Pie",
    radarchart: "Radar"
  },
  preview: {
    dropzonetext: "DROP ZONE"
  },
  editforms: {
    base: (_base = {
      generaltab: "General",
      styletab: "Style",
      eventstab: "Events",
      othertab: "Other",
      widthfield: "Width",
      heightfield: "Height",
      margintopfield: "Margin Top",
      marginbottomfield: "Margin Bottom",
      marginleftfield: "Margin Left",
      marginrightfield: "Margin Right",
      customcssclassfield: "Custom CSS class",
      stylefield: "Style",
      hiddenfield: "Hidden",
      controlhasnoeventsmsg: "This control has no events.",
      eventsinfomsg: "These flags enable processing from this element.",

      requiredfield: "Required",
      defaultvaluefield: "Default value"
    }, _defineProperty(_base, "defaultvaluefield", "Default value"), _defineProperty(_base, "customvalidationfield", "Custom Validation"), _defineProperty(_base, "visibleconditionfield", "Visible condition"), _defineProperty(_base, "readonlyconditionfield", "ReadOnly condition"), _defineProperty(_base, "savebutton", "Save"), _defineProperty(_base, "cancelbutton", "Cancel"), _defineProperty(_base, "okbutton", "OK"), _defineProperty(_base, "closebutton", "Close"), _defineProperty(_base, "sizedefault", "Default"), _defineProperty(_base, "sizemini", "Mini"), _defineProperty(_base, "sizetiny", "Tiny"), _defineProperty(_base, "sizesmall", "Small"), _defineProperty(_base, "sizemedium", "Medium"), _defineProperty(_base, "sizelarge", "Large"), _defineProperty(_base, "sizebig", "Big"), _defineProperty(_base, "sizehuge", "Huge"), _defineProperty(_base, "sizemassive", "Massive"), _defineProperty(_base, "attachednone", "None"), _defineProperty(_base, "attachedtop", "Top"), _defineProperty(_base, "attachedbottom", "Bottom"), _defineProperty(_base, "attachedtopright", "Top right"), _defineProperty(_base, "attachedtopleft", "Top left"), _defineProperty(_base, "attachedbottomleft", "Bottom left"), _defineProperty(_base, "attachedbottomright", "Bottom right"), _defineProperty(_base, "labeldefault", "Default"), _defineProperty(_base, "labelleft", "Left"), _defineProperty(_base, "labelright", "Right"), _defineProperty(_base, "labelleftcorner", "Left corner"), _defineProperty(_base, "labelrightcorner", "Right corner"), _defineProperty(_base, "closewithoutsavequestion", "Close without save?"), _defineProperty(_base, "questiontitle", "Question"), _defineProperty(_base, "onchangetimeout", "onChange timeout"), _base),
    headerform: {
      namefield: "Name",
      sizefield: "Size",
      contentfield: "Content",
      textalignfield: "Text Align",
      textalignleft: "Left",
      textaligncenter: "Center",
      textalignright: "Right",
      subheaderfield: "Subheader"
    },
    buttonform: {
      namefield: "Name",
      typefield: "Type",
      typenonefield: "None",
      typesubmitfield: "Submit",
      sizefield: "Size",
      contentfield: "Content",
      optionsfield: "Options",
      basicfield: "Basic",
      circularfield: "Circular",
      compactfield: "Compact",
      disabledfield: "Disabled",
      fluidfield: "Fluid",
      invertedfield: "Inverted",
      loadingfield: "Loading",
      primaryfield: "Primary",
      secondaryfield: "Secondary",
      togglefield: "Toggle",
      floatedfield: "Floated",
      floateddefaultfield: "Default",
      floatedleftfield: "Left",
      floatedrightfield: "Right"
    },
    labelform: (_labelform = {
      namefield: "Name",
      attachedfield: "Attached",
      contentfield: "Content",
      sizefield: "Size",
      optionsfield: "Options"
    }, _defineProperty(_labelform, "contentfield", "Content"), _defineProperty(_labelform, "basicfield", "Basic"), _defineProperty(_labelform, "circularfield", "Circular"), _defineProperty(_labelform, "cornerfield", "Corner"), _defineProperty(_labelform, "floatingfield", "Floating"), _defineProperty(_labelform, "horizontalfield", "Horizontal"), _defineProperty(_labelform, "pointingfield", "Pointing"), _labelform),
    staticcontentform: {
      namefield: "Name",
      fontsizefield: "Font size",
      contentfield: "Content",
      allowhtmlfield: "Allow HTML"
    },
    messageform: {
      namefield: "Name",
      headerfield: "Header",
      optionsfield: "Options",
      compactfield: "Compact",
      errorfield: "Error",
      floatingfield: "Floating",
      infofield: "Info",
      negativefield: "Negative",
      positivefield: "Positive",
      successfield: "Success",
      warningfield: "Warning",
      contentfield: "Content",
      sizefield: "Size"
    },
    inputform: {
      namefield: "Name",
      labelfield: "Label",
      typefield: "Type",
      typetext: "Text",
      typenumber: "Number",
      typedate: "Date",
      typetime: "Time",
      typedatetime: "Date & Time",
      typepasswod: "Password",
      labelpositionfield: "Label position",
      optionsfield: "Options",
      loadingfield: "Loading",
      invertedfield: "Inverted",
      errorfield: "Error",
      disabledfield: "Disabled",
      transparentfield: "Transparent",
      fluidfield: "Fluid",
      readonlyfield: "Read only",
      placeholderfield: "Placeholder",
      sizefield: "Size",
      dateformatfield: "Date Format"
    },
    textareaform: {
      namefield: "Name",
      labelfield: "Label",
      rowsfield: "Rows",
      optionsfield: "Options",
      placeholderfield: "Placeholder",
      autoheightfield: "Auto height",
      readonlyfield: "Read only"
    },
    checkboxform: {
      namefield: "Name",
      labelfield: "Label",
      optionsfield: "Options",
      fittedfield: "Fitted",
      indeterminatefield: "Indeterminate",
      readonlyfield: "ReadOnly",
      disabledfield: "Disabled",
      sliderfield: "Slider",
      togglefield: "Toggle"
    },
    dropdownform: {
      namefield: "Name",
      labelfield: "Label",
      datafield: "Data",
      datakeycolumn: "Key",
      datavaluecolumn: "Value",
      datatextcolumn: "Text",
      optionsfield: "Options",
      loadingfield: "Loading",
      errorfield: "Error",
      disabledfield: "Disabled",
      fluidfield: "Fluid",
      multiplefield: "Multiple",
      searchfield: "Search",
      selectionfield: "Selection",
      readonlyfield: "Read only",
      clearablefield: "Clearable",
      allowAddItemsfield: "Allow add items"
    },
    dictionaryform: {
      namefield: "Name",
      labelfield: "Label",
      datamodelfield: "Data model",
      placeholderfield: "Placeholder",
      columnsfield: "Columns (Name ASC, Email)",
      optionsfield: "Options",
      loadingfield: "Loading",
      errorfield: "Error",
      disabledfield: "Disabled",
      fluidfield: "Fluid",
      multiplefield: "Multiple",
      searchfield: "Search",
      selectionfield: "Selection",
      readonlyfield: "Read only",
      clearablefield: "Clearable",
      pagingfield: "Server pagination",
      pagesizefield: "Page Size",
      parentidField: "Parent Field"
    },
    radiogroupform: {
      namefield: "Name",
      labelfield: "Label",
      datafield: "Data",
      datakeycolumn: "Key",
      datavaluecolumn: "Value",
      datatextcolumn: "Text",
      groupdirectfield: "Group direct",
      directiongorizontalfield: "Gorizontal",
      directionverticalfield: "Vertical",
      readonlyfield: "Read only"
    },
    form: {
      namefield: "Name",
      sizefield: "Size",
      optionsfield: "Options",
      loadingfield: "Loading",
      errorfield: "Error",
      invertedfield: "Inverted",
      replyfield: "Reply",
      successfield: "Success",
      warningfield: "Warning"
    },
    formgroupform: {
      namefield: "Name",
      widthsfield: "Widths",
      widthsdefaultfield: "Default",
      widthsequalfield: "Equal",
      widthscustomfield: "Custom (1 - 16)",
      typefield: "Type",
      orientationcolumnsfield: "Columns",
      orientationrowsfield: "Rows"
    },
    containerform: {
      namefield: "Name",
      floatfield: "Float",
      floatnonefield: "None",
      floatleftfield: "Left",
      floatrightfield: "Right"
    },
    imageform: {
      namefield: "Name",
      srcfield: "Src",
      hreffield: "Href",
      optionsfield: "Options",
      avatarfield: "Avatar",
      borderedfield: "Bordered",
      centeredfield: "Centered",
      disabledfield: "Disabled",
      inlinefield: "Inline",
      spacedfield: "Spaced",
      floatedfield: "Floated",
      floatedleftfield: "Left",
      floatedrightfield: "Right",
      verticalalignfield: "Vertical align",
      verticalaligntopfield: "Top",
      verticalalignmiddlefield: "Middle",
      verticalalignbottomfield: "Bottom"
    },
    statisticform: {
      namefield: "Name",
      optionsfield: "Options",
      floatedfield: "Floated",
      horizontalfield: "Horizontal",
      datafield: "Data",
      sizefield: "Size"
    },
    gridform: {
      namefield: "Name",
      optionsfield: "Options",
      multiselectfield: "Multiselect",
      filterrowfield: "Filter row",
      disablesortfield: "Disable sorting",
      editformfield: "Edit form",
      editformshowtypefield: "Edit form show type",
      editformtypedefaultfield: "Default",
      editformtypemodalfield: "Modal",
      columnsfield: "Columns",
      keycolumn: "Key",
      namecolumn: "Name",
      typecolumn: "Type",
      widthcolumn: "Width",
      resizablecolumn: "Resizable",
      rowkeyfield: "Row key",
      pagertypefield: "Pagination type",
      pagertypenonefield: "None",
      pagertypeserverfield: "Server",
      pagesizefield: "Page size",
      defaultsortfield: "Default sort",
      rowheightfield: "Row height",
      minheightfield: "Min height",
      autoheightfield: "Auto Height",
      offsetfield: "OffSet",
      editType: "Edit type",
      editflowfield: "Edit flow"
    },
    collectioneditorform: {
      namefield: "Name",
      idfield: "Id field",
      optionsfield: "Options",
      readonlyfield: "ReadOnly",
      draggablefield: "Draggable",
      hierarchicalfield: "Hierarchical",
      collapseallfield: "Collapse all",
      parentidfield: "ParentId field",
      columnsfield: "Columns",
      keycolumn: "Key",
      namecolumn: "Name",
      controlcolumn: "Control",
      widthcolumn: "Width",
      disableAdd: "Disable Add",
      childrenField: "Children field"
    },
    customform: {
      namefield: "Name",
      typefield: "Type control",
      propsfield: "Props",
      childrenfield: "Children"
    },
    customblockform: {
      namefield: "Name",
      sourcetypefield: "Source type",
      sourcetypeformfield: "Form name",
      sourcetypejsonfield: "JSON source",
      formnamefield: "Form name",
      sourcefield: "JSON source",
      placeholderfield: "Placeholder"
    },
    menuform: {
      namefield: "Name",
      activeitemfield: "Active Item",
      itemsfield: "Items",
      itemstargetcolumn: "Target",
      itemstitlecolumn: "Title",
      optionsfield: "Options",
      pointingfield: "Pointing",
      secondaryfield: "Secondary",
      tabularfield: "Tabular",
      fluidfield: "Fluid",
      verticalfield: "Vertical",
      linkfield: "Link",
      visibleConditioncolumn: "Visible Condition"
    },
    dropdowntriggerform: {
      namefield: "Name",
      defaultvaluefield: "Default Value",
      itemsfield: "Items",
      itemstargetcolumn: "Target",
      itemstitlecolumn: "Title",
      itemsvisibleconditioncolumn: "Visible Condition",
      imageurlfield: "ImageUrl"
    },
    chartform: {
      namefield: "Name",
      titlefield: "Title",
      titlesizefield: "Title size",
      legendpositionfield: "Legend position",
      responsivefield: "Responsive",
      datasetcustomfield: "Dataset custom",
      datalabelsplaceholder: "Q1, Q2, Q3, Q4",
      datalabelsfield: "Data labels",
      datasetlabelfield: "Dataset Label",
      datasetbackgroundcolorfield: "Dataset BackgroundColor"
    },
    workflowform: {
      namefield: "Name",
      setstatebuttonfield: "Set state button",
      blocksetstatefield: "Block SetState"
    },
    uploadform: {
      namefield: "Name",
      iconFiletypes: "Icon file types",
      customPostUrl: "Custom post url",
      showFiletypeIcon: "Show file type icon",
      autoProcessQueue: "Auto process queue",
      addRemoveLinks: "Add remove links",
      multile: "Multiple file upload"
    },
    breadcrumbform: {
      namefield: "Name",
      itemsfield: "Items",
      itemstextcolumn: "Text",
      itemsurlcolumn: "Url",
      itemsactivecolumn: "Active",
      itemsiconcolumn: "Divider Icon"
    },
    searchform: {
      namefield: "Name",
      urlfield: "Url",
      categoryfield: "Enable Categories"
    }
  }
};

module.exports = lang;

/***/ }),
/* 37 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(0);

var _react2 = _interopRequireDefault(_react);

var _reactDom = __webpack_require__(6);

var _reactDom2 = _interopRequireDefault(_reactDom);

var _store = __webpack_require__(5);

var _store2 = _interopRequireDefault(_store);

var _controls = __webpack_require__(4);

var _controls2 = _interopRequireDefault(_controls);

var _timeout = __webpack_require__(38);

var _timeout2 = _interopRequireDefault(_timeout);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var CloverForm = function (_React$Component) {
    _inherits(CloverForm, _React$Component);

    function CloverForm(props) {
        _classCallCheck(this, CloverForm);

        var _this = _possibleConstructorReturn(this, (CloverForm.__proto__ || Object.getPrototypeOf(CloverForm)).call(this, props));

        _this._asyncGetData = null;
        _this._asyncGetModel = null;

        _this.state = {
            data: props.data,
            model: props.model,
            extendedData: props.extendedData,
            controlsToReplace: null
        };
        // this.controlsToReplace = null;

        _this.checkLoadedState(_this.state.data, _this.state.model);
        return _this;
    }

    _createClass(CloverForm, [{
        key: 'componentDidMount',
        value: function componentDidMount() {
            this.PrepareState();
        }
    }, {
        key: 'componentDidUpdate',
        value: function componentDidUpdate(prevProps, prevState) {
            this.PrepareState();
        }
    }, {
        key: 'componentWillUnmount',
        value: function componentWillUnmount() {
            if (this._asyncGetData) {
                this._asyncGetData.abort();
            }
            if (this._asyncGetModel) {
                this._asyncGetModel.abort();
            }
        }
    }, {
        key: 'PrepareState',
        value: function PrepareState() {
            var me = this;
            if (this.state.needFetchModel) {
                me.setState({ needFetchModel: false });
                this._asyncGetModel = $.getJSON(this.state.modelurl).done(function (data) {
                    me._asyncGetModel = null;
                    me.modelChanged(data);
                }).fail(function (jqxhr, textStatus, error) {
                    me._asyncGetModel = null;
                    var err = textStatus + ", " + error;
                    me.handleErrEvent(err);
                });
            }

            if (this.state.needFetchData) {
                me.setState({ needFetchData: false });
                this._asyncGetData = $.getJSON(this.state.dataurl).done(function (data) {
                    me._asyncGetData = null;
                    me.dataChanged(data);
                }).fail(function (jqxhr, textStatus, error) {
                    me._asyncGetData = null;
                    var err = textStatus + ", " + error;
                    me.handleErrEvent(err);
                });
            }

            this.checkConditions(this.state.model);
            this.checkLoadedState(this.state.data, this.state.model);
        }
    }, {
        key: 'modelChanged',
        value: function modelChanged(model) {
            this.setState({
                model: model,
                controlsToReplace: null
            });

            this.checkConditions(model);
        }
    }, {
        key: 'dataChanged',
        value: function dataChanged(data) {
            this.setState({
                data: data
            });

            this.checkLoadedState(data, this.state.model);
        }
    }, {
        key: 'checkLoadedState',
        value: function checkLoadedState(data, model) {
            if (!this.state.isLoaded && data !== undefined && data !== null && model !== undefined && model !== null) {
                this.setState({ isLoaded: true });
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
    }, {
        key: 'handleEvent',
        value: function handleEvent(_ref) {
            var e = _ref.e,
                key = _ref.key,
                eventName = _ref.eventName,
                parameters = _ref.parameters,
                name = _ref.name,
                value = _ref.value;

            var me = this;
            var isOnchange = eventName === "onChange";
            if (isOnchange) {
                if (!Boolean(this.props.onlyExternalDataChanged)) {
                    if (this.state.data === undefined) {
                        this.state.data = {};
                    }
                    var data = this.state.data;
                    data[key] = value;
                    this.setState({ data: data });
                }

                if (this.props.dataChanged !== undefined) this.props.dataChanged(this, { key: key, value: value });

                this.onConditions(key, eventName, parameters, name, value);
            }

            if (this.props.eventFunc === undefined) return;

            var item = this.findModelItembyKey(key);
            if (item === undefined) return;

            if (item.events !== undefined && item.events[eventName] !== undefined && item.events[eventName].active) {
                var event = item.events[eventName];

                var eventParameters = _extends({}, parameters);
                if (Array.isArray(event.parameters) && event.parameters.length > 0) {
                    event.parameters.forEach(function (p) {
                        eventParameters[p.name] = p.value;
                    });
                }
                var sourceControl = me.refs[key];
                var sourceControlValue = value;
                var fireEvent = void 0;
                if (Array.isArray(event.targets) && event.targets.length > 0) {

                    fireEvent = function fireEvent() {
                        return event.targets.forEach(function (t) {
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
                    };
                } else {
                    fireEvent = function fireEvent() {
                        return me.props.eventFunc({
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
                    };
                }
                if (!isOnchange || item.onChangeTimeout === undefined || item.onChangeTimeout === "" || Number(item.onChangeTimeout) < 1) {
                    fireEvent();
                } else {
                    _timeout2.default.Set(key, fireEvent, Number(item.onChangeTimeout));
                }
            }
        }
    }, {
        key: 'checkConditions',
        value: function checkConditions(model, child) {
            var enableCheckConditions = false;
            if (Array.isArray(model)) {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]["other-visibleConition"] !== undefined && model[i]["other-visibleConition"] !== "" || model[i]["other-readOnlyConition"] !== undefined && model[i]["other-readOnlyConition"] !== "") {
                        enableCheckConditions = true;
                    }

                    if (Array.isArray(model[i].children)) {
                        enableCheckConditions = this.checkConditions(model[i].children, true);
                    }

                    if (enableCheckConditions) break;
                }
            }

            if (child) {
                return enableCheckConditions;
            }

            this.state.enableCheckConditions = enableCheckConditions;
        }
    }, {
        key: 'onConditions',
        value: function onConditions(key, eventName, parameters, name, value) {
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
    }, {
        key: 'handleErrEvent',
        value: function handleErrEvent(message) {
            if (this.props.eventErrFunc) {
                this.props.eventErrFunc(this, message);
            }
        }
    }, {
        key: 'findModelItembyKey',
        value: function findModelItembyKey(key, array) {
            if (array === undefined) {
                array = this.state.model;
            }

            for (var i = 0; i < array.length; i++) {
                if (array[i].key === key) return array[i];

                if (array[i].children !== undefined) {
                    var item = this.findModelItembyKey(key, array[i].children);
                    if (item !== undefined) return item;
                }

                if (array[i].placeholders !== undefined) {
                    for (var ph in array[i].placeholders) {
                        var item = this.findModelItembyKey(key, array[i].placeholders[ph]);
                        if (item !== undefined) return item;
                    }
                }
            }
            return undefined;
        }
    }, {
        key: 'render',
        value: function render() {
            var controlsToReplace = [];
            var needCheckReplace = false;

            if (this.state.model !== null && this.state.model !== undefined) {
                controlsToReplace = this.state.controlsToReplace === null ? [] : this.state.controlsToReplace;
                needCheckReplace = this.state.controlsToReplace === null;
            }

            var items = _controls2.default.createControls(this, {
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
            });

            if (needCheckReplace) {
                this.state.controlsToReplace = controlsToReplace;
            }

            var className = "clover-form" + (this.props.className === undefined ? "" : " " + this.props.className);

            return _react2.default.createElement(
                'div',
                { className: className },
                items
            );
        }
    }], [{
        key: 'getDerivedStateFromProps',
        value: function getDerivedStateFromProps(nextProps, prevState) {
            var stateDelta = {};
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
    }]);

    return CloverForm;
}(_react2.default.Component);

exports.default = CloverForm;

/***/ }),
/* 38 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var timeoutsIdNameMap = {};

var Timeout = function () {
    function Timeout() {
        _classCallCheck(this, Timeout);
    }

    _createClass(Timeout, null, [{
        key: "Set",
        value: function Set(name, callback, delay) {
            if (timeoutsIdNameMap.hasOwnProperty(name)) {
                clearTimeout(timeoutsIdNameMap[name]);
            }

            var timeoutId = setTimeout(callback, delay);
            timeoutsIdNameMap[name] = timeoutId;
        }
    }, {
        key: "Clear",
        value: function Clear(name) {
            if (timeoutsIdNameMap.hasOwnProperty(name)) {
                clearTimeout(timeoutsIdNameMap[name]);
                delete timeoutsIdNameMap[name];
            }
        }
    }]);

    return Timeout;
}();

exports.default = Timeout;

/***/ })
/******/ ]);
});
//# sourceMappingURL=swz-builder.js.map