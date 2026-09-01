import React from 'react';
import {BaseEditControl, HeaderEditControl, ButtonEditControl, LabelEditControl, MessageEditControl, StaticContentEditControl,
          InputEditControl, TextAreaEditControl, DropdownEditControl, DictionaryEditControl, CheckboxEditControl, RadioGroupEditControl, DropdownTriggerEditControl,
          FormEditControl, FormGroupEditControl, CustomBlockEditControl, CustomEditControl, MenuEditControl, ContainerEditControl, CollectionEditorEditControl,
    ImageEditControl, StatisticEditControl, TabEditControl, GridEditControl, GridWithActionsEditControl, ChartEditControl, WorkflowBarEditControl, DropzoneEditControl, 
	BreadcrumbEditControl, SearchEditControl, SwzGridEditControl, SwzModalEditControl, 
    SwzImportEditControl, SwzExportEditControl, SwzHtmlEditControl, SwzHtmlViewEditControl, DplyChoiceQnnsEditControl, WordCloudEditControl, CardGridEditControl} from './editform-controls'
import RadioGroup from './control/radiogroup'
import MenuGroup from './control/menugroup'
import JSON5 from 'json5'
import GridView from './control/gridview';
import GridViewWithActions from './control/gridviewwithactions';
import ChartView from './control/chartview';
import WorkflowBar from './control/workflowbar';
import Dictionary from './control/dictionary';
import Container from './control/container';
import StaticContent from './control/staticcontent';
import CollectionEditor from './control/collectioneditor';
import ControlBar from './controlbar';
import DropdownTrigger from './control/dropdowntrigger'
import SemanticControl from './control/semanticcontrol';
import DropzoneControl from './control/dropzone';
import {FunctionalFilter,FilterTerms} from './functionalfilter.js'
import Search from './control/search.jsx'
import SwzGridView from './control/swzgridview';
import SwzModal from './control/swzmodal';
import SwzImport from './control/swzimport';
import SwzHtml from './control/swzhtml';
import SwzHtmlView from './control/swzhtmlview';
import SwzExport from './control/swzexport';
import DplyChoiceQnns from './control/dplychoiceqnns';
import WordCloudReport from './control/wordcloud';
import CardGrid from './control/cardgrid';
import TabGroup from './control/tabgroup';

//------CloverFormControls-----------
let CloverFormControls = {
    Items: [
        {key: "sepContainerszz", title: 'SWZ-Custom', isseparate: true, defaultopen: true},
        {
            key: "swzgridview", title: 'SwzGridView', control: SwzGridView, editControl: SwzGridEditControl, defaultValues: {
            columns: [
                {key: 'id', name: 'ID'},
                {key: 'title', name: 'Title'},
                {key: 'count', name: 'Count'},
            ]
        }
        },
        {key: "swzmodal", title: 'SwzModal', control: SwzModal, editControl: SwzModalEditControl},
        {key: "swzimport", title: 'SwzImport', control: SwzImport, editControl: SwzImportEditControl},
        {key: "swzexport", title: 'SwzExport', control: SwzExport, editControl: SwzExportEditControl},
        {   key: "swzhtml", title: 'SwzHtmlEditor', control: SwzHtml, editControl: SwzHtmlEditControl,
        defaultValues: {hideOutput: "block"}
        },
        {   key: "swzhtmlview", title: 'SwzHtmlView', control: SwzHtmlView, editControl: SwzHtmlViewEditControl, 
        defaultValues: {hideOutput: "block"}
        },
        {key: "dplychoiceqnns", title: 'DplyChoiceQnns', control: DplyChoiceQnns, editControl: DplyChoiceQnnsEditControl},
        {key: "WordCloudReport", title: 'WordCloudReport', control: WordCloudReport, editControl: WordCloudEditControl},
        {key: "sepContainers", title: 'Containers', isseparate: true, defaultopen: true},
        {key: "container", title: 'DIV', control: Container, editControl: ContainerEditControl},
        {key: "form", title: 'Form', control: SemanticControl, editControl: FormEditControl},
        {
            key: "formgroup",
            title: 'Form Group',
            control: SemanticControl,
            editControl: FormGroupEditControl,
            defaultValues: {widths: "equal"}
        },
        {
            key: "tab",
            title: 'Tab',
            control: TabGroup,
            editControl: TabEditControl,
            defaultValues: {
                items: [
                    {title: 'Tab 1'},
                    {title: 'Tab 2'}
                ]
            }
        },
        {
            key: "menu", title: 'Menu', control: MenuGroup, editControl: MenuEditControl,
            defaultValues: {
                items: [
                    {target: 'menu1', title: 'Menu 1'},
                    {target: 'menu2', title: 'Menu 2'},
                    {target: 'menu3', title: 'Menu 3'}]
            }
        },
        {
            key: "workflowbar",
            title: 'Workflow bar',
            control: WorkflowBar,
            editControl: WorkflowBarEditControl,
            defaultValues: {
                events: {
                    onCommandClick: {active: true, actions: ["workflowExecuteCommand"]},
                    onSetStateClick: {active: true, actions: ["workflowSetState"]}
                }
            }
        },
        {
            key: "customblock",
            title: 'Custom block',
            control: undefined,
            editControl: CustomBlockEditControl,
            defaultValues: {sourceType: 'form'}
        },
        {key: "sepCollection", title: 'Collections', isseparate: true},
        {
            key: "gridview", title: 'GridView', control: GridView, editControl: GridEditControl, defaultValues: {
            columns: [
                {key: 'id', name: 'ID'},
                {key: 'title', name: 'Title'},
                {key: 'count', name: 'Count'}
            ]
        }
        },
        {
            key: "gridviewwithactions", title: 'GridViewWithActions', control: GridViewWithActions, editControl: GridWithActionsEditControl, defaultValues: {
            columns: [
                {key: 'id', name: 'ID'},
                {key: 'title', name: 'Title'},
                {key: 'count', name: 'Count'}
            ]
        }
        },
        {
            key: "collectioneditor",
            title: 'Collection Editor',
            control: CollectionEditor,
            editControl: CollectionEditorEditControl,
            defaultValues: {
                idField: "Id",
                parentIdField: "ParentId",
                columns: [
                    {key: 'Id', name: 'ID'},
                    {key: 'Title', name: 'Title'},
                    {key: 'Count', name: 'Count'}
                ]
            }
        },
        {
            key: "cardgrid", title: 'CardGrid', control: CardGrid, editControl: CardGridEditControl, defaultValues: {
            columns: [
                {key: 'id', name: 'ID'},
                {key: 'title', name: 'Title'},
                {key: 'count', name: 'Count'}
            ]
        }
        },
        {key: "sepControls", title: 'Controls', isseparate: true},
        {
            key: "header",
            title: 'Header',
            control: SemanticControl,
            editControl: HeaderEditControl,
            defaultValues: {content: "Header", size: "medium"}
        },
        {
            key: "input",
            title: 'Input',
            control: SemanticControl,
            editControl: InputEditControl,
            defaultValues: {label: "Input", fluid: true, onChangeTimeout: 200}
        },
        {
            key: "textarea",
            title: 'TextArea',
            control: SemanticControl,
            editControl: TextAreaEditControl,
            defaultValues: {label: "TextArea", fluid: true}
        },
        {
            key: "dictionary",
            title: 'Dictionary',
            control: Dictionary,
            editControl: DictionaryEditControl,
            defaultValues: {label: "Dictionary", fluid: true, selection: true}
        },
        {
            key: "dropdown",
            title: 'Dropdown',
            control: SemanticControl,
            editControl: DropdownEditControl,
            defaultValues: {
                label: "Dropdown", fluid: true, selection: true,
                "data-elements": [
                    {key: 1, value: 1, text: 'Item 1'},
                    {key: 2, value: 2, text: 'Item 2'},
                    {key: 3, value: 3, text: 'Item 3'}]
            }
        },
        {
            key: "checkbox",
            title: 'CheckBox',
            control: SemanticControl,
            editControl: CheckboxEditControl,
            defaultValues: {label: "Checkbox"}
        },
        {
            key: "radiogroup",
            title: 'Radio group',
            control: RadioGroup,
            editControl: RadioGroupEditControl,
            defaultValues: {
                label: "Radio",
                "data-elements": [
                    {key: 1, value: 1, text: 'Item 1'},
                    {key: 2, value: 2, text: 'Item 2'},
                    {key: 3, value: 3, text: 'Item 3'}]
            }
        },
        {
            key: "button",
            title: 'Button',
            control: SemanticControl,
            editControl: ButtonEditControl,
            defaultValues: {content: "Button"}
        },
        {
            key: "label",
            title: 'Label',
            control: SemanticControl,
            editControl: LabelEditControl,
            defaultValues: {content: "Label"}
        },
        {
            key: "message",
            title: 'Message',
            control: SemanticControl,
            editControl: MessageEditControl,
            defaultValues: {header: "Message", content: "Description..."}
        },
        {
            key: "image",
            title: 'Image',
            control: SemanticControl,
            editControl: ImageEditControl,
            defaultValues: {src: '/images/unknown.png'}
        },
        {
            key: "statistic", title: 'Statistic', control: SemanticControl, editControl: StatisticEditControl,
            defaultValues: {
                "data-elements": [
                    {label: 'Score', value: '22,1%'},
                    {label: 'Views', value: '30,000'},
                    {label: 'Points', value: '500'}]
            }
        },
        {
            key: "customcontrol",
            title: 'Custom control',
            control: undefined,
            editControl: CustomEditControl,
            defaultValues: {props: "{  }"}
        },
        {
            key: "staticcontent",
            title: 'Static Content',
            control: StaticContent,
            editControl: StaticContentEditControl,
            defaultValues: {content: "Text..."}
        },
        {
            key: "dropdowntrigger",
            title: 'Dropdown trigger',
            control: DropdownTrigger,
            editControl: DropdownTriggerEditControl,
            defaultValues: {
                defaultValue: "User",
                items: [
                    {target: '#1', title: 'Item 1'},
                    {target: '#2', title: 'Item 2'},
                    {target: '#3', title: 'Item 3'}]
            }
        },
        {
            key: "dropzonecontrol",
            title: 'Dropzone',
            control: DropzoneControl,
            editControl: DropzoneEditControl,
            defaultValues: {
                showFiletypeIcon: false,
                autoProcessQueue: true,
                addRemoveLinks: true,
                multile: true
            }
        },
        {
            key: "breadcrumb",
            title: 'Breadcrumbs',
            control: SemanticControl,
            editControl: BreadcrumbEditControl,
            defaultValues: {
                items: [
                    {"text": "Home", "url": "/"},
                    {"divider": "right angle", "text": "Page1", "url": "/page1"},
                    {"text": "Page2", "active": true}],
                events: {
                        onItemClick: {active: true, actions: ["redirect"]}
                    }
            }
        },
        {
            key: "search",
            title: 'Search',
            control: Search,
            editControl: SearchEditControl,
            defaultValues: {}
        },
        {key: "sepCharts", title: 'Charts', isseparate: true},
        {
            key: "barchart",
            title: 'Bar',
            control: ChartView,
            editControl: ChartEditControl,
            defaultValues: {chartType: "bar", datasetLabel: ""}
        },
        {
            key: "linechart",
            title: 'Line',
            control: ChartView,
            editControl: ChartEditControl,
            defaultValues: {chartType: "line", datasetLabel: ""}
        },
        {
            key: "scatterchart",
            title: 'Scatter',
            control: ChartView,
            editControl: ChartEditControl,
            defaultValues: {chartType: "scatter", datasetLabel: ""}
        },
        {
            key: "doughnutchart",
            title: 'Doughnut',
            control: ChartView,
            editControl: ChartEditControl,
            defaultValues: {chartType: "doughnut", datasetLabel: ""}
        },
        {
            key: "piechart",
            title: 'Pie',
            control: ChartView,
            editControl: ChartEditControl,
            defaultValues: {chartType: "pie", datasetLabel: ""}
        },
        {
            key: "radarchart",
            title: 'Radar',
            control: ChartView,
            editControl: ChartEditControl,
            defaultValues: {chartType: "radar", datasetLabel: ""}
        },
    ],

    createControls: function (parentComponent,
        {
            model, data, errors,
            eventOnEdit, eventOnDelete, eventOnCopy, handleEvent,
            parentItem,
            getFormFunc, getAdditionalDataForControl,
            buildermode,
            hideControls, readOnlyControls,
            readOnly, disableRefs,
            uploadUrl, downloadUrl, extendedData,controlsToReplace,needCheckReplace,
            parentPlaceholder,
            formItem,
            controlBarRight
        }){
       
        let res = [];
        if (model === null || model === undefined)
            return res;

        for (let i = 0; i < model.length; i++) {
            if (Array.isArray(hideControls) && hideControls.includes(model[i].key)) {
                continue;
            }

            let item;
            const dbtype = model[i]["data-buildertype"];
            if (dbtype === "customcontrol") {
                if (model[i].type === undefined || model[i].type === "") {
                    item =
                        <div className="clover-formbuilder-empty" key={model[i].key}>Fill Type property for rendering the
                            control.</div>;
                }
                else {
                    const controlPropsInit = model[i].props === undefined ? {} : JSON5.parse(model[i].props);
                    let controlProps = {
                        ...controlPropsInit,
                        key: model[i].key,
                        name: model[i].key,
                        className: model[i]["style-customcss"],
                        style: this.getStyle(model[i], buildermode),
                        "data-buildertype": model[i]["data-buildertype"],
                        getAdditionalDataForControl: getAdditionalDataForControl,
                        uploadUrl, downloadUrl
                    };

                    if (readOnly || (Array.isArray(readOnlyControls) && readOnlyControls.includes(controlProps.key)))
                        controlProps.readOnly = true;

                    let children = model[i].children;
                    if (model[i].children !== undefined) {
                        try {
                            children = JSON5.parse(model[i].children);
                        } catch (e) {
                        }
                    }

                    if (children === undefined || (Array.isArray(children) && children.length === 0)) {
                        item = React.createElement(
                            model[i].type,
                            controlProps
                        );
                    }
                    else {
                        item = React.createElement(
                            model[i].type,
                            controlProps,
                            children
                        );
                    }
                }
            }
            else if (dbtype === "customblock") {
                let children_source = [];
                let renderempty = false;
                let cbbuildermode = false;
                let addDropZones = false;
                let newParentItem = model[i];
                let newParentPlaceholder = parentPlaceholder;
                let newFormItem = formItem;

                if (model[i].sourceType === 'form' || model[i].sourceType === undefined) {
                    if (model[i].children !== undefined && model[i].children !== "") {
                        children_source = model[i].children;
                    }
                    else {
                        if (getFormFunc === undefined) {
                            console.error('Error: "getFormFunc" parameter is undefined!. Please, set "getFormFunc" parameter for CloverBuilder or CloverForm!');
                            continue;
                        }

                        if (model[i].formname !== undefined && model[i].formname !== "") {
                            children_source = getFormFunc(model[i].formname);
                        }
                        else {
                            renderempty = true;
                        }
                    }
                }
                else if (model[i].sourceType === 'placeholder') {
                    cbbuildermode = eventOnEdit !== undefined;
                    addDropZones = eventOnEdit !== undefined;
                    newParentItem = parentItem;

                    if (newParentPlaceholder === undefined)
                        newParentPlaceholder = model[i];

                    if(newFormItem === undefined){
                        newFormItem = parentItem;
                    }

                    if (newFormItem !== undefined &&
                        newFormItem.placeholders !== undefined &&
                        newFormItem.placeholders[model[i].key] !== undefined) {

                        children_source = newFormItem.placeholders[model[i].key];
                    }
                }
                else {
                    if (model[i].source !== undefined && model[i].source !== "")
                        children_source = JSON5.parse(model[i].source);
                    else
                        renderempty = true;
                }

                if (renderempty) {
                    item = <div className="clover-formbuilder-empty" key={model[i].key}>Set a form name or source in
                        propepries.</div>;
                }
                else {
                    let children = this.createControls(parentComponent,
                        {
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
                            disableRefs,
                            uploadUrl, downloadUrl, controlsToReplace, needCheckReplace,
                            parentPlaceholder: newParentPlaceholder,
                            formItem: newFormItem
                        });

                    let className = model[i]["style-customcss"];
                    if(buildermode){
                        className = (className == undefined ? "" : (className+" ")) + "clover-formbuilder-item-container";
                    }

                    let formProps = {
                        key: model[i].key,
                        name: model[i].key,
                        className: className,
                        style: this.getStyle(model[i], buildermode),
                        "data-buildertype": model[i]["data-buildertype"]
                    };

                    if (addDropZones) {
                        if (children === undefined)
                            children = [];

                        if (children.length > 0) {
                            let dz_footer = CloverFormControls.createBuilderDropzone(
                                model[i].key + "_dropzone_footer",
                                newFormItem === undefined ? undefined : newFormItem.key,//parentItem === undefined ? undefined : parentItem.key,
                                children[children.length - 1].key,
                                model[i].key,
                                model[i].key);
                            children.push(dz_footer);
                        }

                        let dz = CloverFormControls.createBuilderDropzone(
                            model[i].key + "_dropzone_header",
                            newFormItem === undefined ? undefined : newFormItem.key,//parentItem === undefined ? undefined : parentItem.key,
                            undefined,
                            model[i].key,
                            model[i].key);
                        children.unshift(dz);
                    }

                    item = React.createElement(
                        'div',
                        formProps,
                        children
                    );
                }
            }
            else {
                var control = this.getControlByType(dbtype);
                if (control === null) {
                    item = <div key={model[i].key}>{dbtype} is unsupported</div>;
                }
                else {
                    if (this.isContainer(dbtype)) {
                        let newFormItem = formItem;
                        if(newFormItem == undefined && parentItem != undefined && parentItem.sourceType == "form"){
                            newFormItem = parentItem;
                        }

                        var isGorizontalGroup = buildermode && model[i]["data-buildertype"] === "formgroup" && model[i].orientation !== "grouped";
                        let children = this.createControls(parentComponent,
                            {
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
                                disableRefs,
                                uploadUrl, downloadUrl, controlsToReplace, needCheckReplace,
                                parentPlaceholder: undefined,
                                formItem: newFormItem,
                                controlBarRight: isGorizontalGroup
                            });
                        if (buildermode) {
                            if (children.length > 0) {
                                let textDZ = isGorizontalGroup ? "..." : "... " + model[i].key + " down ...";
                                var dropzone_footer = this.createBuilderDropzone(model[i].key + "-dropzone_footer", model[i].key, undefined, textDZ);
                                children.push(dropzone_footer);
                            }

                            let textDZ = isGorizontalGroup ? "..." : "... " + model[i].key + " up ...";
                            var dropzone_header = this.createBuilderDropzone(model[i].key + "-dropzone_header", model[i].key, undefined, textDZ);
                            children.unshift(dropzone_header);

                        }
                        let tabchildren = [];
                        if(model[i]["data-buildertype"] === "tab"){
                            //if(parentComponent._reactInternalFiber.lastEffect !== undefined && parentComponent._reactInternalFiber.lastEffect !== null){
                            //}
                            for(var b = 0; b < model[i].items.length; b++){
                                let tabchild =[];
                                if(model[i].children !== undefined) {
                                    if(model[i].children[b] !== undefined)
                                    tabchild.push(model[i].children[b]);
                                }
 
                                let tabitems = this.createControls(parentComponent,
                                    {
                                        model: model[i].children === undefined ? undefined : tabchild,
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
                                        disableRefs,
                                        uploadUrl, downloadUrl, controlsToReplace, needCheckReplace,
                                        parentPlaceholder: undefined,
                                        formItem: newFormItem,
                                        controlBarRight: isGorizontalGroup
                                    });
                                if (buildermode) {
                                    if (tabitems.length > 0) {
                                        let textDZ = isGorizontalGroup ? "..." : "... " + model[i].key + " down ...";
                                        var dropzone_footer = this.createBuilderDropzone(model[i].key + "-dropzone_footer-" + b, model[i].key, undefined, textDZ);
                                        tabitems.push(dropzone_footer);
                                    }
        
                                    let textDZ = isGorizontalGroup ? "..." : "... " + model[i].key + " up ...";
                                    var dropzone_header = this.createBuilderDropzone(model[i].key + "-dropzone_header-" + b, model[i].key, undefined, textDZ);
                                    tabitems.unshift(dropzone_header);

                                }
                                tabchildren[b] = tabitems ;
                            }
                            children = tabchildren;
                        }
                        item = this.createControl(parentComponent, control,
                            {
                                model: model[i],
                                data,
                                errors,
                                parentItem,
                                buildermode,
                                children,
                                handleEvent,
                                getAdditionalDataForControl,
                                readOnlyControls,
                                readOnly,
                                disableRefs,
                                parentPlaceholder,
                                controlsToReplace,
                                needCheckReplace,
                                eventOnEdit, eventOnDelete, eventOnCopy
                            });
                    }
                    else {
                        item = this.createControl(parentComponent, control,
                            {
                                model: model[i],
                                data,
                                errors,
                                parentItem,
                                buildermode,
                                handleEvent,
                                getAdditionalDataForControl,
                                readOnlyControls,
                                readOnly,
                                disableRefs,
                                uploadUrl,
                                downloadUrl,
                                extendedData,
                                parentPlaceholder,
                                controlsToReplace,
                                needCheckReplace,
                                eventOnEdit, eventOnDelete, eventOnCopy
                            });
                    }
                }
            }

            if (buildermode) {
                if (i > 0 && i < model.length) {
                    var dropzone_bw = this.createBuilderDropzone(model[i].key + "-dropzone_bw",
                        parentItem === undefined ? undefined : parentItem.key,
                        model[i].key,
                        "...",
                        parentPlaceholder === undefined ? undefined : parentPlaceholder.key);
                    res.push(dropzone_bw);
                }

                var buildercontrol = (
                    <ControlBar key={model[i].key + "_controlbar"}
                                text={model[i]["data-buildertype"]}
                                model={model[i]} parent={parentComponent}
                                onDelete={eventOnDelete} onEdit={eventOnEdit} onCopy={eventOnCopy}
                                isGroup={model[i]["data-buildertype"] === "formgroup"}
                                controlOnRight={controlBarRight} />);
                
                if(controlBarRight){
                    res.push(item);
                    res.push(buildercontrol);
                }
                else{
                    res.push(buildercontrol);
                    res.push(item);
                }
            }
            else{
                res.push(item);
            }
            
        }

        return res;
    },

    getControlByType: function (buildertype) {
        var control = undefined;
        for (var i = 0; i < this.Items.length; i++) {
            if (this.Items[i].key === buildertype) {
                control = this.Items[i].control;
                break;
            }
        }
        return control;
    },
    getEditControlByType: function (buildertype) {
        var control = undefined;
        for (var i = 0; i < this.Items.length; i++) {
            if (this.Items[i].key === buildertype) {
                control = this.Items[i].editControl;
                break;
            }
        }
        return control;
    },

    getStyle(model, buildermode) {
        var style = {
            marginTop: model["style-marginTop"],
            marginBottom: model["style-marginBottom"],
            marginLeft: model["style-marginLeft"],
            marginRight: model["style-marginRight"],
            width: model["style-width"],
            height: model["style-height"]
        };
        if (model["style-display"] !== undefined) {
            style.display = model["style-display"];//SwzModal display
        }

        if (model["style-float"] !== undefined) {
            style.float = model["style-float"];
        }

        if (model["style-hidden"]) {
            if (buildermode)
                style.opacity = 0.2;
            else
                style.display = "none";
        }

        if (model["style-source"] !== undefined) {
            var properties = model["style-source"].split(';');
            properties.forEach(function (property) {
                var tup = property.split(':');
                if (tup.length === 2) {
                    let p = tup[0].replace(/^\s+|\s+$/g, '');
                    style[p] = tup[1].replace(/^\s+|\s+$/g, '');
                }
            });
        }

        if (model["style-font-size"] !== undefined) {
            style["font-size"] = model["style-font-size"];
        }

        return style;
    },

    regexForReplace: /{\S+?}/gm,

    createControl(parentComponent, control,
                  {
                      model, data, errors,
                      parentItem,
                      buildermode, children,
                      handleEvent, getAdditionalDataForControl,
                      readOnlyControls, readOnly,
                      disableRefs,
                      uploadUrl, downloadUrl, extendedData, controlsToReplace, needCheckReplace,
                      eventOnEdit, eventOnDelete, eventOnCopy
                  }) {

        let obj;
        let i;
        var res = undefined;
        var props = {
            key: model.key,
            name: model.key,
            className: model["style-customcss"],
            style: this.getStyle(model, buildermode),
            "data-buildertype": model["data-buildertype"],
        };
        const dataBuilderType = props["data-buildertype"];
        const needReplace = needCheckReplace || controlsToReplace.includes(model.key);;

        if(buildermode && this.isContainer(props["data-buildertype"])){
            props.className = (props.className == undefined ? "": (props.className + " "))
                + "clover-formbuilder-item-container";
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
        const regexForReplace =  this.regexForReplace;
        const replaceControlValue = function (originalValue) {
            
            if (originalValue === undefined || originalValue === null)
                return originalValue;
            const includeStr = originalValue.includes("{") && originalValue.includes("}");
            if ((!needReplace && !includeStr))
                return originalValue

            const replaceFromData = (m) => {
                if (data === undefined || data === null)
                    return "";
                const value = data[m.slice(1, m.length - 1)];
                if (value === null || value === undefined) return "";
                return value;
            };
            if (Array.isArray(originalValue)) {
                const newValue = [];
                let needPushKey = false;
                originalValue.forEach((v) => {
                    const newV = {};
                    for (let p in v) {
                        if (v.hasOwnProperty(p)) {
                            if ( v[p] !== undefined && v[p] !== null && typeof v[p] === "string") {
                                newV[p] = v[p].replace(regexForReplace, (m) => replaceFromData(m));
                                if (!needPushKey && needCheckReplace && newV[p] !== v[p]) needPushKey = true;
                            }
                            else if(Array.isArray(v[p])){
                                newV[p] = replaceControlValue(v[p]);
                            }
                            else {
                                newV[p] = v[p];
                            }
                        }
                    }
                    newValue.push(newV);
                });
                if (needPushKey) controlsToReplace.push(model.key);
                return newValue;
            }
            else {
                if (typeof originalValue !== "string")
                    return originalValue;
                let newValue = originalValue.replace(regexForReplace, (m) => replaceFromData(m));
                if (needCheckReplace && originalValue !== newValue) {
                    controlsToReplace.push(model.key);
                }
                return newValue;
            }
        }; //end of replaceControlValue

        if (control === SemanticControl) {
            let useUploadUrl = uploadUrl;

            if (dataBuilderType === "header"){
                props.content = replaceControlValue(model.content);
                props.subheader = replaceControlValue(model.subheader);
            }
            else if(dataBuilderType === "label") {
                props.content = replaceControlValue(model.content);
            }
            else if (dataBuilderType === "message"){
                props.content = replaceControlValue(model.content);
                props.header = replaceControlValue(model.header);

            } 
            else if (dataBuilderType === "image") {
                props.src = replaceControlValue(model.src);
                props.href = replaceControlValue(model.href);
            }
            else if (dataBuilderType === "breadcrumb") {
                props.items = replaceControlValue(model.items);
            }
            else if (dataBuilderType == 'input' && model.type=='file') {
                if(model.customPostUrl) {
                    useUploadUrl = model.customPostUrl;
                }
            }
            res = <SemanticControl {...props} additionalParams={{
                model, data, errors, children, handleEvent, parentItem, uploadUrl : useUploadUrl, downloadUrl
            }}/>;
        }
        else if (control === Dictionary) {
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
	    props.filters = replaceControlValue(model.filters);
            if (typeof errors === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }

            if (handleEvent !== null) {
                props.onChange = function (e, {name, value}) {
                    handleEvent({syntheticEvent: e, key: props.key, eventName: "onChange", name: name, value: value});
                };
            }
            props.parentIsForm = this.isForm(parentItem);

            if (data !== undefined)
                props.value = data[props.key];

            res = (<Dictionary {...props} />);
        }
        else if (control === DropdownTrigger) {
            props.defaultValue = model.defaultValue;
            props.items = model.items;
            props.imageUrl = model.imageUrl;
            props.handleEvent = handleEvent;

            if (data !== undefined)
                props.value = data[props.key];

            res = (<DropdownTrigger {...props} />);
        }
        else if (control === Search) {
            props.url = model.url;
            props.category = model.category;
            props.handleEvent = handleEvent;

            if (data !== undefined)
                props.value = data[props.key];

            res = (<Search {...props} />);
        }
        else if (control === RadioGroup) {
            var items = [];
            if (model["data-elements"] !== undefined) {
                if (Array.isArray(model["data-elements"])) {
                    items = model["data-elements"];
                }
                else {
                    items = JSON5.parse(model["data-elements"]);
                }
            }

            if (handleEvent !== null) {
                props.onChange = function (e, {name, value}) {
                    handleEvent({syntheticEvent: e, key: props.key, eventName: "onChange", name: name, value: value});
                };
            }

            if (typeof errors === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }

            if (data !== undefined)
                props.value = data[props.key];

            res = (<RadioGroup {...props}
                               label={model.label}
                               direction={model.direction}
                               placeholder={model.placeholder}
                               items={items}>
            </RadioGroup>);
        }
        else if (control === CollectionEditor) {
            /*
            props.swzData = {
                disableDelete: true//model.disableDelete 
            }*/
            //Added by Swz
            props.disableDelete = model.disableDelete; 
            props.header = model.header;
            props.headerTitle = model.headerTitle;
            props.headerSize = model.headerSize;
            props.layoutOption = model.layoutOption;

            props.columns = model.columns;
            props.draggable = model.draggable;
            props.hierarchical = model.hierarchical;
            props.parentIdField = model.parentIdField;
            props.idField = model.idField;
            props.childrenField = model.childrenField;
            props.collapseAll = model.collapseAll;
            props.disableAdd = model.disableAdd;
            props.placeholders = model.placeholders;
            
            if(props.placeholders != undefined){
                props.getAdditionalDataForControl = getAdditionalDataForControl;
                props.createControl = function(parentControl, databuildertype, parameters){
                    let control = CloverFormControls.getControlByType(databuildertype);
                    if(control == undefined){
                        console.error("Control is unsupported!", databuildertype, parentControl, parameters);
                        return;
                    }

                    let item = CloverFormControls.createControl(parentControl, control, parameters);
                    let res = [];
                    if(parameters.buildermode){
                        var buildercontrol = (
                        <ControlBar key={parameters.model.key + "_controlbar"}
                                    model={parameters.model} parent={parentComponent}
                                    onDelete={eventOnDelete} onEdit={eventOnEdit} onCopy={eventOnCopy}/>);
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
                props.onChange = function (e, {name, value}) {
                    handleEvent({syntheticEvent: e, key: props.key, eventName: "onChange", name: name, value: value});
                };
            }
            else if (buildermode) {
                props.onChange = function (e, {name, value}) {
                    props.value = value;
                }
            }

            if (data !== undefined)
                props.value = data[props.key];
                
            if (errors !== undefined)
                props.error = errors[props.key];

            if (buildermode && props.value === undefined && props.columns !== undefined) {
                props.buildermode = buildermode;
                props.createBuilderDropzone = function(columnName, value){
                    return CloverFormControls.createBuilderDropzone(
                        props.key, props.key, undefined, columnName, columnName
                    );
                } 
                props.value = [];
                for (i = 0; i < 5; i++) {
                    props.value.push({});
                }

                if (Boolean(model.hierarchical) &&
                    model.parentIdField !== undefined && model.parentIdField !== "" &&
                    model.idField !== undefined && model.idField !== "") {
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

            res = (<CollectionEditor {...props} />);
        }
        else if (control === GridView) {
            props.columns = model.columns;
            props.multiselect = model.multiselect;
            props.rowKey = model.rowKey;
            props.editForm = model.editForm;
            props.editFlow = model.editFlow;
            props.editType = model.editType;
            props.pagerType = model.pagerType;
            props.pageSize = model.pageSize;
            props.rowHeight = model.rowHeight;
            props.headerRowHeight = model.headerRowHeight;
            props.minHeight = model.minHeight;
            props.autoHeight = model.autoHeight;
            props.offSet = model.offSet;
            props.disableSort = model.disableSort;
            props.resizeColumns = model.resizeColumns;
            props.editFormShowType = model.editFormShowType;
            props.getAdditionalDataForControl = getAdditionalDataForControl;
            props.handleEvent = handleEvent;
            props.defaultSort = model.defaultSort;

            if (typeof errors === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }

            if (data !== undefined)
                props.value = data[props.key];

            if (buildermode && props.value === undefined) {
                props.value = [];
                for (i = 0; i < 30; i++) {
                    let obj = {};
                    props.columns.forEach(function (c) {
                        obj[c.key] = c.key + "_" + i;
                    });
                    props.value.push(obj);
                }
            }
            if (extendedData !== undefined && extendedData.filters !== undefined && extendedData.filters[props.key] !== undefined) {
                props.filter = new FunctionalFilter(extendedData.filters[props.key], props.columns.map(c => c.key));
            }
            res = (<GridView {...props} />);
            
        }
        else if (control === CardGrid) {
            props.columns = model.columns;
            props.multiselect = model.multiselect;
            props.rowKey = model.rowKey;
            props.editForm = model.editForm;
            props.editFlow = model.editFlow;
            props.pagerType = model.pagerType;
            props.pageSize = model.pageSize;
            props.editFormShowType = model.editFormShowType;
            props.getAdditionalDataForControl = getAdditionalDataForControl;
            props.handleEvent = handleEvent;
            props.defaultSort = model.defaultSort;
            
            if (typeof errors === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }

            if (data !== undefined)
                props.value = data[props.key];

            if (buildermode && props.value === undefined) {
                props.value = [];
                for (i = 0; i < 4; i++) {
                    let obj = {};
                    props.columns.forEach(function (c) {
                        obj[c.key] = c.key + "_" + i;
                    });
                    props.value.push(obj);
                }
            }
            if (extendedData !== undefined && extendedData.filters !== undefined && extendedData.filters[props.key] !== undefined) {
                props.filter = new FunctionalFilter(extendedData.filters[props.key], props.columns.map(c => c.key));
            }
            res = (<CardGrid {...props} />);
        }
        else if (control === GridViewWithActions) {
            props.columns = model.columns;
            props.multiselect = model.multiselect;
            props.rowKey = model.rowKey;
            props.editForm = model.editForm;
            props.reviewForm = model.reviewForm;
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
            if (typeof errors === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }
            if (data !== undefined)
                props.value = data[props.key];
            if (buildermode && props.value === undefined) {
                props.value = [];
                for (i = 0; i < 30; i++) {
                    let obj = {};
                    props.columns.forEach(function (c) {
                        obj[c.key] = c.key + "_" + i;
                    });
                    props.value.push(obj);
                }
            }
            if (extendedData !== undefined && extendedData.filters !== undefined && extendedData.filters[props.key] !== undefined) {
                props.filter = new FunctionalFilter(extendedData.filters[props.key], props.columns.map(c => c.key));
            }
            res = (<GridViewWithActions {...props} />);
        }
        else if (control === SwzGridView) {
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
            if (typeof errors === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }
            if (data !== undefined)
                props.value = data[props.key];
                //values
            if (buildermode && props.value === undefined) {
                props.value = [];
               // const swzActionButton = this.swzActionButton
                for (i = 0; i < 30; i++) {
                    let obj = {};
                    props.columns.forEach(function (c) {  
                  /*  if (c.key === 'swzactions'){
                       // var editIndex = "Edit" //+ i;
                        //var reviewIndex = "Review"// + i;
                        //obj[c.key] = [{edit: editIndex, review: reviewIndex}]
                        obj[c.key] = swzActionButton;
                    }else{
                        obj[c.key] = c.key + "_" + i;
                    }*/
                      obj[c.key] = c.key + "_" + i;
                    });
                    props.value.push(obj);
                }
            }
            if (extendedData !== undefined && extendedData.filters !== undefined && extendedData.filters[props.key] !== undefined) {
                props.filter = new FunctionalFilter(extendedData.filters[props.key], props.columns.map(c => c.key));
            }
            res = (<SwzGridView {...props} />);
        }
        else if (control === MenuGroup) {
            props["data-items"] = replaceControlValue(model.items);
            props.pointing = model.pointing;
            props.secondary = model.secondary;
            props.tabular = model.tabular;
            props.fluid = model.fluid;
            props.vertical = model.vertical;
            props.activeitem = model.activeitem;
            props.link = model.link;
            props.handleEvent = handleEvent;
            props.icon = model.icon;
            props.compact = model.compact;
            if (data !== undefined)
                props.value = data[props.key];

            res = (<MenuGroup {...props} />);
        }
        else if (control === TabGroup) {
            props.items = model.items;
            props.pointing = model.pointing;
            props.secondary = model.secondary;
            props.tabular = model.tabular;
            props.fluid = model.fluid;
            props.vertical = model.vertical;
            props.activeitem = model.activeitem;
            props.handleEvent = handleEvent;
            props.compact = model.compact;
            props.isDisplayCount = model.isDisplayCount;

            if (data !== undefined)
                props.value = data[props.key];
            res = (<TabGroup {...props} additionalParams={{children}}/>);
        }
        else if (control === ChartView) {
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
                }
                else {

                    let testData = props.chartType !== "scatter" ?
                        [6, 23, 15, 3] :
                        [{x: 6, y: -12},
                            {x: 11, y: 1},
                            {x: 24, y: 5},
                            {x: 40, y: 32}
                        ];

                    props.value = {
                        labels: ["Q1", "Q2", "Q3", "Q4"],
                        datasets: [{
                            data: testData
                        }]
                    };
                }
            }
            else{
                if (data !== undefined)
                    props.value = data[props.key];
            }

            res = (<ChartView {...props} />);
        }
        else if (control === WorkflowBar) {
            props.blockSetState = model.blockSetState;
            props.setStateButton = model.setStateButton;
            props.handleEvent = handleEvent;
            props.getAdditionalDataForControl = getAdditionalDataForControl;

            if (typeof errors === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }

            if (buildermode) {
                props.commands = [
                    {value: "approve", text: "Approve", type: 1},
                    {value: "back", text: "Back", type: 2}
                ];

                props.states = [
                    {value: "draft", text: "Draft"},
                    {value: "state1", text: "State 1"},
                    {value: "state2", text: "State 2"},
                    {value: "state3", text: "State 3"},
                    {value: "finish", text: "Finish"}
                ];
            }

            res = (<WorkflowBar {...props} />);
        }
        else if (control === Container) {
            res = (<Container {...props} children={children}/>);
        }
        else if (control === SwzModal) {
            if (model.content === undefined || model.content === null  ){
                var buttonContent = "Button"
            }else{
                var buttonContent = model.content;    
            }
                props.swzData = {
                isOpen: model.isOpen,
            }
            props.swzButton = {
                size: model.size,
                content: buttonContent,
                basic: model.basic,
                compact: model.compact,
                disabled: model.disabled,
                inverted: model.inverted,
                primary: model.primary,
                secondary: model.secondary,
            }
            props.handleEvent = handleEvent;
            res = (<SwzModal {...props} >{children}</SwzModal>);
        }
        else if (control === SwzImport) {
            res = (<SwzImport {...props} />);
        }
        else if (control === SwzHtml) {
            props.swzData = {
                editorState: model.editorState,
                hideOutput: {
                    display: model.hideOutput
                 }
             }
             if (data !== undefined)
                props.value = data[props.key];
            
            props.handleEvent = handleEvent;
            res = (<SwzHtml {...props} />);
        }
        else if (control === SwzHtmlView) {
            props.swzdata = {
                viewState: model.viewState,
                  hideOutput: {
                    display: model.hideOutput,
                 },
             }
             if (data !== undefined)
                    props.value = data[props.key];

            res = (<SwzHtmlView {...props}  
			additionalParams={{model, data, errors, children, handleEvent, parentItem, uploadUrl, downloadUrl}}/>);
        }
        else if (control === DplyChoiceQnns) {
            if (data !== undefined)
                props.value = data[props.key];
            res = (<DplyChoiceQnns {...props} />);
        }
        else if (control === WordCloudReport) {
            if (data !== undefined){
                props.dplyId = data.dplyId;
                props.qnnField = data.qnnField;
            }
            res = (<WordCloudReport {...props} />);
        }
        
        else if (control === SwzExport) {
            props.swzButton = {
                size: model.size,
                basic: model.basic,
                compact: model.compact,
                disabled: model.disabled,
                inverted: model.inverted,
                primary: model.primary,
                secondary: model.secondary,
                content: model.content
            }
            props.swzData = {
                data: model.jsonData
            }
            props.handleEvent = handleEvent;
            res = (<SwzExport {...props} />);
        }
        else if (control === StaticContent) {
            props.content = replaceControlValue(model.content);
            props.isHtml = model.isHtml;
            props.isPre = model.isPre;
            props.fetchData = model.fetchData;
            if (data !== undefined)
                props.value = data[props.key];

            res = (<StaticContent {...props} />);
        }
        else if (control === DropzoneControl) {
            props.iconFiletypes = model.iconFiletypes;
            props.postUrl = (model.customPostUrl != undefined && model.customPostUrl != "")
                ? model.customPostUrl
                : uploadUrl;
            props.showFiletypeIcon = model.showFiletypeIcon;
            props.autoProcessQueue = model.autoProcessQueue;
            props.addRemoveLinks = model.addRemoveLinks;
            res = (<DropzoneControl {...props}
                                    additionalParams={{model, data, errors, children, handleEvent, parentItem}}/>);
        }
        else {
            console.error("Control is unsupported!", control, model);
        }

    return res;
  },
  isContainer: function(key){
    return (key === 'form' || key === 'formgroup' ||
      key === 'grid' || key === 'gridrow' || key === 'gridcolumn' ||
      key === 'card' || key === 'cardcontent' ||
      key === 'container' || key === 'div' || key === 'swzmodal' || key === 'tab');
  },
  isForm: function(model){
    return (model !== null && model !== undefined &&
        (model["data-buildertype"] === "form" ||
        model["data-buildertype"] === "formgroup"));
  },
  createBuilderDropzone: function(key, elementToInsert, elementafter, text, placeholderKey){
     // if(text === undefined)
    text =  "DROP ZONE";
    return <div name={key} key={key} elementafter={elementafter} elementtoinsert={elementToInsert} placeholderkey={placeholderKey} className="clover-formbuilder-zone">{text}</div>
  },

    fillDefaultValues: function (model, defaultValues) {
        var control = undefined;
        for (var k in defaultValues) {
            if (model[k] === undefined)
                model[k] = defaultValues[k];
        }
        return model;
    }
};

module.exports = CloverFormControls;