import React from 'react';
import {
    HeaderEditControl, ButtonEditControl, SwzStaticContentEditControl,
    InputEditControl, TextAreaEditControl, DropdownEditControl, CheckboxEditControl, RadioGroupEditControl, DropdownTriggerEditControl,
    FormEditControl, FormGroupEditControl, CustomBlockEditControl, MenuEditControl, ContainerEditControl, CollectionEditorEditControl,
    ImageEditControl, GridEditControl, ChartEditControl, DropzoneEditControl,
    BreadcrumbEditControl, SwzPageEditControl, SwzTableEditControl, SwzScannerEditControl, SwzCaptchaEditControl, DplyChoiceQnnsEditControl
} from './editform-controls'
import RadioGroup from './control/radiogroup'
import MenuGroup from './control/menugroup'
import JSON5 from 'json5'
import GridView from './control/gridview';
import ChartView from './control/chartview';
import Container from './control/container';
import SwzStaticContent from './control/staticcontent';
import CollectionEditor from './control/collectioneditor';
import ControlBar from './controlbar';
import SwzTableControlBar from './swztablecontrolbar'
import DropdownTrigger from './control/dropdowntrigger'
import SemanticControl from './control/semanticcontrol';
import DropzoneControl from './control/dropzone';
import { FunctionalFilter, FilterTerms } from './functionalfilter.js'
import SwzModal from './control/swzmodal';
import SwzPage from './control/swzpage';
import SwzTable from './control/swztable';
import SwzScanner from './control/swzscanner'
import SwzCaptcha from './control/swzcaptcha';
import DplyChoiceQnns from './control/dplychoiceqnns';

/* 
1. Controls must be placed under the block
    -Input controls
    -Table controls
    -Block group
2. Controls can be placed under table
    -All controls except block group
*/

//------CloverFormControls-----------
//var onAutoSave = true;
var timeoutId = null;
//var autoSaveDuration = 3000;
let CloverFormControls = {
    Items: [
        { key: "MainSepContainers", title: "Blocks", isseparate: true, defaultopen: true },
        {
            key: "swzPage",
            title: 'Page Block',
            control: SwzPage,
            editControl: SwzPageEditControl,
            defaultValues: {
                headerlabel: "Insert Page header name",
                back: true,
                next: true,
                save: true,
                cancel: true,
                onpagedisplay: true,
                buildermode: true,
                onstatusbar: true,
                events: {
                    onClickBack: { active: true, actions: ["swzBack"] },
                    onClickNext: { active: true, actions: ["swzSinglePageValidate", "swzSilentSave", "swzNext"] },
                    onClickNextNonUpdatedSurvey: { active: true, actions: ["swzNext"] },
                    onClickSave: { active: true, actions: ["swzSave"] },
                    onPageValidationStatus: { active: true, actions: ["swzPageValidationStatus"] },
                    onClickSaveExit: { active: true, actions: ["swzSave", "swzExit"] },
                    onClickExit: { active: true, actions: ["confirm", "swzExit"] },
                    onClickCancel: { active: true, actions: ["confirm", "swzReturnToPreviousPage"] },
                    onClickSubmit: { active: true, actions: ["swzSubmit", "swzExit"] },
                    onClickItem: { active: true, actions: ["swzPageValidationStatus", "swzSinglePageValidate", "swzItemClick"] },
                    onPageInit: { active: true, actions: ["swzPageInit"] },
                    onClickLastSaved: { active: true, actions: ["swzClearRadio"] },
                    onClickPrint: { active: true, actions: ["swzPrint"] }
                }
            }
        },
        { key: "block", title: 'Block', control: Container, editControl: ContainerEditControl },
        {
            key: "formgroup",
            title: 'Block Group',
            control: SemanticControl,
            editControl: FormGroupEditControl,
            defaultValues: {
                widths: "equal",
                /*  ['style-source']: 'overflow-x: auto;'*/
            }
        },
        {
            key: "swzDivider",
            title: 'Divider',
            control: Container,
            editControl: ContainerEditControl,
            defaultValues: {
                ['style-customcss']: 'clover-formbuilder-item-swzdivider'
            }
        },
        /*{key: "dplychoiceqnns", title: 'DplyChoiceQnns', control: DplyChoiceQnns, editControl: DplyChoiceQnnsEditControl},*/
        { key: "MainSepDesign", title: "Design", isseparate: true },
        {
            key: "swztable", title: 'Table', control: SwzTable, editControl: SwzTableEditControl,
            defaultValues: {
                tablewidth: "100%",
                tableheight: "100%",
                cellpadding: "20",
                tablealign: "left",
                bordertype: "solid",
                borderwidth: "2",
                bordercolor: "Grey",
                borderline: "border"

            }
        },
        {
            key: "header",
            title: 'Header',
            control: SemanticControl,
            editControl: HeaderEditControl,
            defaultValues: { content: "Header", size: "medium" }
        },
        /* {
            key: "dropzonecontrol",
            title: 'File Upload',
            control: DropzoneControl,
            editControl: DropzoneEditControl,
            defaultValues: {
                showFiletypeIcon: false,
                autoProcessQueue: true,
                addRemoveLinks: true,
                multile: true
            }
        }, */
        {
            key: "button",
            title: 'Button',
            control: SemanticControl,
            editControl: ButtonEditControl,
            defaultValues: {
                content: "Button",
                events: {
                    onClick: {
                        active: true,
                        actions: ["applyServerDateTime"],
                        parameters: [
                            { name: "format", value: "yyyy-MM-dd HH:mm:ss" },
                        ]
                    },
                }
            }
        },
        {
            key: "swzscanner",
            title: 'Scanner',
            control: SwzScanner,
            editControl: SwzScannerEditControl,
            defaultValues: {
                events: {
                    onChange: {
                        active: true,
                        actions: ["applyScanValue"],
                    },
                }
            }
        },
        {
            key: "swzcaptcha",
            title: 'Captcha',
            control: SwzCaptcha,
            editControl: SwzCaptchaEditControl,
            defaultValues: {
                events: {
                    onChange: {
                        active: true,
                        actions: ["applyCaptchaValue"],
                    },
                }
            }
        },
        {
            key: "staticcontent",
            title: 'Static Content',
            control: SwzStaticContent,
            editControl: SwzStaticContentEditControl,
        },
        {
            key: "menu", title: 'Menu', control: MenuGroup, editControl: MenuEditControl,
            defaultValues: {
                items: [
                    { target: 'menu1', title: 'Menu 1' },
                    { target: 'menu2', title: 'Menu 2' },
                    { target: 'menu3', title: 'Menu 3' }]
            }
        },
        /* {
            key: "breadcrumb",
            title: 'Bread Crumb',
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
        }, */
        {
            key: "image",
            title: 'Image',
            control: SemanticControl,
            editControl: ImageEditControl,
            defaultValues: { src: './images/unknown.png' }
        },
        /*    {
               key: "customblock",
               title: 'Custom Block',
               control: undefined,
               editControl: CustomBlockEditControl,
               defaultValues: {sourceType: 'form'}
           }, */
        { key: "MainSepControls", title: "Inputs", isseparate: true },
        {
            key: "input",
            title: 'Input',
            control: SemanticControl,
            editControl: InputEditControl,
            defaultValues: {
                label: "Input", type: 'text', fluid: true, onChangeTimeout: 200, imagemaxwidth: 1024, imagemaxquality: 75,
                events: {
                    onChangeTimeOut: { active: true, actions: ["swzSave"] }
                }
            }
        },
        {
            key: "textarea",
            title: 'TextArea',
            control: SemanticControl,
            editControl: TextAreaEditControl,
            defaultValues: {
                label: "TextArea", fluid: true, type: "text",
                events: {
                    onChangeTimeOut: { active: true, actions: ["swzSave"] }
                }
            }
        },
        {
            key: "dropdown",
            title: 'Dropdown',
            control: SemanticControl,
            editControl: DropdownEditControl,
            defaultValues: {
                label: "Dropdown",
                fluid: true,
                selection: true,
                onScrollNextControl: true,
                "data-elements": [
                    { key: 1, value: '1', text: 'Item 1' },
                    { key: 2, value: '2', text: 'Item 2' },
                    { key: 3, value: '3', text: 'Item 3' }],
                events: {
                    onChangeTimeOut: { active: true, actions: ["swzSave"] }
                }
            }
        },
        {
            key: "checkbox",
            title: 'CheckBox',
            control: SemanticControl,
            editControl: CheckboxEditControl,
            defaultValues: {
                label: "Checkbox",
                events: {
                    onChangeTimeOut: { active: true, actions: ["swzSave"] }
                }
            }
        },
        {
            key: "radiogroup",
            title: 'Radio Group',
            control: RadioGroup,
            editControl: RadioGroupEditControl,
            defaultValues: {
                label: "Radio",
                onScrollNextControl: true,
                "data-elements": [
                    { key: 1, value: '1', text: 'Item 1', hide: '' },
                    { key: 2, value: '2', text: 'Item 2', hide: '' },
                    { key: 3, value: '3', text: 'Item 3', hide: '' }],
                events: {
                    onClick: { active: true, actions: ["swzClearRadio"] },
                    onChangeTimeOut: { active: true, actions: ["swzSave"] }
                }
            }
        },
    ],

    createControls: function (parentComponent,
        { swzPageInPage,
            model, data, errors,
            eventOnEdit, eventOnDelete, eventOnCopy, handleEvent, swzEventOnHide, swzEventOnShow,
            swzEventOnColumnAddBefore, swzEventOnColumnAddAfter, swzEventOnRowAddBefore, swzEventOnRowAddAfter,
            swzEventOnRowDelete, swzEventOnColumnDelete,
            swzEventOnMerge, swzEventOnSplit,
            parentItem, nextModels,
            getFormFunc, getAdditionalDataForControl,
            buildermode,
            hideControls, readOnlyControls,
            readOnly, disableRefs,
            uploadUrl, downloadUrl, extendedData, controlsToReplace, needCheckReplace, hideSideMenu,
            parentPlaceholder,
            formItem,
            controlBarRight,
            loadTemplate,
            loadTemplateBlock,
            printMode

        }) {
        let res = [];
        if (model === null || model === undefined)
            return res;

        var foundPage = false;

        for (let i = 0; i < model.length; i++) {

            if (Array.isArray(hideControls) && hideControls.includes(model[i].key)) {
                continue;
            }

            let item;
            const dbtype = model[i]["data-buildertype"];
            let parentControls = [];
            var isTableChild = false;

            var control = this.getControlByType(dbtype);
            if (control === null) {
                item = <div key={model[i].key}>{dbtype} is unsupported</div>;
            }
            else {
                if (parentItem !== undefined) {
                    if (parentItem['data-buildertype'] == "swztable" && parentItem['tableindex'] !== undefined && parentItem['tableindex'].length > 0) {
                        for (let k = 0; k < parentItem['tableindex'].length; k++) {
                            if (parentItem['tableindex'][k].includes(model[i]['tableIndex'])) {
                                isTableChild = true;
                                break;
                            }
                        }
                        if (!isTableChild) {
                            model.splice(i, 1);
                            i--;
                            continue;
                        }
                    }
                }

                if (buildermode) {
                    //Temp solution to ensure that all existing survey adds this function
                    /*if(this.isPageContainer(dbtype) && model[i].events){
                        model[i].events.onClickNextNonUpdatedSurvey = {active: true, actions: ["swzNext"]};
                        model[i].events.onClickPrint = {active: true, actions: ["swzPrint"]};
                    } */

                    /*Function to ensure inputs are in order*/
                    if (model[i]['data-buildertype'] == 'swztable') {
                        if (model[i]['tableindex'] !== undefined && model[i]['tableindex'].length > 0 && model[i]['children'] !== undefined && model[i]['children'].length > 0) {
                            var tableIndex = model[i]['tableindex'];

                            var sortArray = tableIndex.map(function (data, idx) {
                                return { idx: idx, data: data }
                            })

                            sortArray.sort(function (a, b) {
                                let aRow = parseInt(a.data.substr(0, a.data.indexOf('_')).slice(0, 8));
                                let bRow = parseInt(b.data.substr(0, b.data.indexOf('_')).slice(0, 8));

                                if (aRow == bRow) {
                                    return -1;
                                } else {
                                    1;
                                }
                            });

                            sortArray.sort(function (a, b) {
                                let aRow = parseInt(a.data.substr(0, a.data.indexOf('_')).slice(0, 8));
                                let bRow = parseInt(b.data.substr(0, b.data.indexOf('_')).slice(0, 8));

                                let aCol = parseInt(a.data.substr(a.data.indexOf('_') + 1, a.data.length).slice(0, 8));
                                let bCol = parseInt(b.data.substr(b.data.indexOf('_') + 1, b.data.length).slice(0, 8));

                                if (aRow == bRow) {
                                    return aCol - bCol;
                                } else {
                                    1;
                                }
                            });

                            tableIndex = sortArray.map(function (val) {
                                return val.data
                            });

                            model[i]['children'].sort(function (a, b) {
                                return tableIndex.indexOf(a['tableIndex']) - tableIndex.indexOf(b['tableIndex']);
                            });
                        }
                    }

                    /*
                    //IMDA MP2020 survey to quickly propagate to round off no to 1
                      if(model[i]["data-buildertype"] == "input" && model[i]["type"] == "number"){
                         if(model[i].isautosum && !model[i].roundoffno)
                          model[i].roundoffno = 1;
                      }
                  */
                    if (this.isInput(dbtype)) {
                        if (!model[i]['events']) {
                            var eventObj = {
                                onChangeTimeOut: { active: true, actions: ["swzSave"] },
                            };
                            model[i]['events'] = eventObj;
                        } else {
                            model[i]['events']['onChangeTimeOut'] = { active: true, actions: ["swzSave"] };
                        }
                    }
                }

                if (parentItem) {
                    //Add only the parent controls
                    if (parentItem['parentcontrols'] && parentItem['parentcontrols'].length > 0) {
                        //Concat existing and add your own parentItem
                        parentControls = parentControls.concat(parentItem['parentcontrols']);
                        //Add your parent block if you are a block

                        if (this.isContainer(parentItem['data-buildertype']))
                            parentControls.push(parentItem.key);
                        model[i]['parentcontrols'] = parentControls;

                        //Create new
                    } else if (this.isContainer(parentItem['data-buildertype']) || this.isPageContainer(parentItem['data-buildertype'])) {
                        parentControls.push(parentItem.key);
                        model[i]['parentcontrols'] = parentControls;
                    }
                }

                if (this.isContainer(dbtype) || this.isPageContainer(dbtype)) {

                    var swzPageInPage = false;
                    let newFormItem = formItem;

                    if (!foundPage && data && this.isPageContainer(dbtype) && data['RespId'] && data['LastSavedPage'] && !data['PageFirstLoad']) {

                        if (data['LastSavedPage'] == model[i].key) {
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                            model[i].onpagedisplay = true;
                            if (i !== 0)
                                model[0].onpagedisplay = false;

                            foundPage = true;
                        }
                    }

                    if (this.isContainer(dbtype)) {
                        if (parentItem['data-buildertype'] !== "block" && parentItem['data-buildertype'] !== "formgroup") {
                            model[i]['parentPage'] = parentItem.key;
                        } else {
                            model[i]['parentPage'] = parentItem.parentPage;
                        }
                    }

                    if (newFormItem == undefined && parentItem != undefined && parentItem.sourceType == "form") {
                        newFormItem = parentItem;
                    }
                    var isGorizontalGroup = buildermode && model[i]["data-buildertype"] === "formgroup" && model[i].orientation !== "grouped";

                    var nextModels = null;
                    if (model[i + 1]) {
                        if (model[i + 1]['data-buildertype'] !== "swzPage")
                            nextModels = model[i + 1];
                        else if (model[i + 1].children)
                            nextModels = model[i + 1].children;
                    } else if (model[i].children)
                        nextModels = model[i].children;

                    let children = this.createControls(parentComponent,
                        {
                            swzPageInPage,
                            swzEventOnHide: swzEventOnHide,
                            swzEventOnShow: swzEventOnShow,
                            swzEventOnColumnAddBefore, swzEventOnColumnAddAfter, swzEventOnRowAddBefore, swzEventOnRowAddAfter,
                            swzEventOnRowDelete, swzEventOnColumnDelete,
                            swzEventOnMerge, swzEventOnSplit,
                            model: model[i].children,
                            data: data,
                            nextModels,
                            children: null,
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
                            uploadUrl, downloadUrl, controlsToReplace, needCheckReplace, hideSideMenu,
                            parentPlaceholder: undefined,
                            formItem: newFormItem,
                            controlBarRight: isGorizontalGroup,
                            loadTemplate,
                            loadTemplateBlock,
                            printMode
                        });
                    var PageInPage = false;

                    if (buildermode) {
                        if (children.length > 0) {
                            let textDZ = isGorizontalGroup ? "..." : "... " + model[i].key + " down ...";
                            var dropzone_footer = this.createBuilderDropzone(model[i].key + "-dropzone_footer", model[i].key, undefined, textDZ);
                            children.push(dropzone_footer);
                        }
                        let textDZb = isGorizontalGroup ? "..." : "... " + model[i].key + " up ...";
                        var dropzone_header = this.createBuilderDropzone(model[i].key + "-dropzone_header", model[i].key, undefined, textDZb);
                        children.unshift(dropzone_header);


                        if (model[i]['data-buildertype'] == "swztable") {
                            if (model[i].tableindex !== undefined && model[i].tableindex.length > 0) {
                                var tableindex = model[i].tableindex;
                                var uniqueObj = this.getUniqueRowsColumns(tableindex);
                                model[i]['uniqueRowsColumns'] = uniqueObj;
                                for (let m = tableindex.length - 1; m >= 0; m--) {

                                    var tableZones = this.createBuilderDropzone('tableElement' + tableindex[m], model[i]['key'], undefined, undefined, undefined, tableindex[m]);
                                    var modelTableIndex =
                                    {
                                        'model': {
                                            'tableIndex': tableindex[m],
                                        }
                                    }

                                    var buildertablecontrol = (
                                        <SwzTableControlBar
                                            key={'tableElement' + tableindex[m] + "_controlbar"}
                                            id={'tableElement' + tableindex[m] + "_controlbar"} //React use key internally hence we use id
                                            text={''} //Add text if required
                                            model={model[i]}
                                            additionalParams={modelTableIndex}
                                            children={children}

                                            onDelete={eventOnDelete} onEdit={eventOnEdit} onCopy={eventOnCopy} swzOnHide={swzEventOnHide} swzOnShow={swzEventOnShow}
                                            swzColumnAddBefore={swzEventOnColumnAddBefore} swzColumnAddAfter={swzEventOnColumnAddAfter}
                                            swzRowAddBefore={swzEventOnRowAddBefore} swzRowAddAfter={swzEventOnRowAddAfter}
                                            swzRowDelete={swzEventOnRowDelete} swzColumnDelete={swzEventOnColumnDelete}
                                            swzMerge={swzEventOnMerge} swzSplit={swzEventOnSplit}
                                            parent={parentItem}
                                            //parent={parentItem}
                                            controlOnRight={controlBarRight}
                                        />);

                                    children.unshift(buildertablecontrol);
                                    children.unshift(tableZones);
                                }
                            }
                        }
                    }

                    item = this.createControl(parentComponent, control,
                        {
                            swzPageInPage: PageInPage,
                            model: model[i],
                            data,
                            errors,
                            parentItem, nextModels,
                            buildermode,
                            children,
                            handleEvent,
                            getAdditionalDataForControl,
                            readOnlyControls,
                            readOnly,
                            disableRefs,
                            parentPlaceholder,
                            controlsToReplace,
                            needCheckReplace, hideSideMenu,
                            eventOnEdit, eventOnDelete, eventOnCopy, swzEventOnHide, swzEventOnShow,
                            swzEventOnColumnAddBefore, swzEventOnColumnAddAfter, swzEventOnRowAddBefore, swzEventOnRowAddAfter,
                            swzEventOnRowDelete, swzEventOnColumnDelete,
                            swzEventOnMerge, swzEventOnSplit,
                            printMode
                        });
                }
                else {
                    item = this.createControl(parentComponent, control,
                        {
                            swzPageInPage,
                            model: model[i],
                            data,
                            errors,
                            parentItem, nextModels,
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
                            needCheckReplace, hideSideMenu,
                            eventOnEdit, eventOnDelete, eventOnCopy, swzEventOnHide, swzEventOnShow,
                            swzEventOnColumnAddBefore, swzEventOnColumnAddAfter, swzEventOnRowAddBefore, swzEventOnRowAddAfter,
                            swzEventOnRowDelete, swzEventOnColumnDelete,
                            swzEventOnMerge, swzEventOnSplit,
                            printMode
                        });
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
                        onDelete={eventOnDelete} onEdit={eventOnEdit} onCopy={eventOnCopy} swzOnHide={swzEventOnHide} swzOnShow={swzEventOnShow}
                        isGroup={model[i]["data-buildertype"] === "formgroup"}
                        loadTemplate={loadTemplate}
                        loadTemplateBlock={loadTemplateBlock}
                        controlOnRight={controlBarRight}
                        swzPageInPage={swzPageInPage} />);

                if (controlBarRight) {
                    res.push(item);
                    res.push(buildercontrol);
                }
                else {
                    res.push(buildercontrol);
                    res.push(item);
                }
            }

            else {
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

    regexForReplace: /{\S+}/gm,

    createControl(parentComponent, control,
        {
            swzPageInPage,
            model, data, errors,
            parentItem, nextModels,
            buildermode, children,
            handleEvent, getAdditionalDataForControl,
            readOnlyControls, readOnly,
            disableRefs,
            uploadUrl, downloadUrl, extendedData, controlsToReplace, needCheckReplace, hideSideMenu,
            eventOnEdit, eventOnDelete, eventOnCopy, swzEventOnHide, swzEventOnShow,
            printMode
        }) {

        var me = this;
        let i;
        var res = undefined;
        var props = {
            builderMode: buildermode,
            key: model.key,
            name: model.key,
            className: model["style-customcss"],
            style: this.getStyle(model, buildermode),
            "data-buildertype": model["data-buildertype"],
        };
        const dataBuilderType = props["data-buildertype"];
        const needReplace = needCheckReplace || controlsToReplace.includes(model.key);

        if (buildermode && this.isPageContainer(props["data-buildertype"])) {
            props.className = (props.className == undefined ? "" : (props.className + " "))
                + "clover-formbuilder-item-swzpage";
        }


        if (buildermode && this.isDividerContainer(props["data-buildertype"])) {
            props.className = (props.className == undefined ? "" : (props.className + " "))
                + "clover-formbuilder-item-swzdivider";
        }

        if (buildermode && this.isContainer(props["data-buildertype"])) {
            props.className = (props.className == undefined ? "" : (props.className + " "))
                + "clover-formbuilder-item-container";
        }

        if (!disableRefs) {
            props.ref = model.key;
        }

        if (model.readOnly !== undefined) {
            props.readOnly = model.readOnly;
        }

        if (model.parentcontrols !== undefined) {
            props.parentcontrols = model.parentcontrols;
        }

        if (readOnly || Array.isArray(readOnlyControls) && readOnlyControls.includes(model.key)) {
            props.readOnly = true;
        }

        if (window.onAutoSave == null) {
            window.onAutoSave = true;
        }

        if (window.onAutoSave && this.isInput(props["data-buildertype"]) && handleEvent !== null) {
            props.autoSave = function () {
                me.autoSave(function (e) {
                    handleEvent({ syntheticEvent: e, key: props.key, eventName: "onChangeTimeOut", parameters: { onHideLoadAnimation: true, onAutoSave: window.onAutoSave } });
                });
            }
        }

        const regexForReplace = this.regexForReplace;
        const replaceControlValue = function (originalValue) {
            if (!needReplace || originalValue === undefined || originalValue === null)
                return originalValue;
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
                            if (v[p] !== undefined && v[p] !== null && typeof v[p] === "string") {
                                newV[p] = v[p].replace(regexForReplace, (m) => replaceFromData(m));
                                if (!needPushKey && needCheckReplace && newV[p] !== v[p]) needPushKey = true;
                            }
                            else if (Array.isArray(v[p])) {
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
        };
        if (control === SemanticControl) {
            if (dataBuilderType === "header") {
                props.content = replaceControlValue(model.content);
                props.subheader = replaceControlValue(model.subheader);
            }
            else if (dataBuilderType === "image") {
                props.src = replaceControlValue(model.src);
                props.href = replaceControlValue(model.href);
            }
            else if (dataBuilderType === "breadcrumb") {
                props.items = replaceControlValue(model.items);
            }

            props.randomise = model.randomise;
            if (printMode) {

            }
            else {
                props.isautosum = model.isautosum;
            }
            props.disableupdownkey = model.disableupdownkey;
            props.roundoffno = model.roundoffno;
            if (model["data-elements"] !== undefined) {
                if (Array.isArray(model["data-elements"])) {
                    items = model["data-elements"];
                }
                else {
                    items = JSON5.parse(model["data-elements"]);
                }
            }

            props.nextModels = nextModels;
            props.getNextModelFromArr = this.getNextModelFromArr.bind(this);

            res = <SemanticControl {...props} additionalParams={{
                items,
                model, data, errors, children, handleEvent, parentItem, uploadUrl, downloadUrl
            }} />;
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
        else if (control === RadioGroup) {
            props.getNextModelFromArr = this.getNextModelFromArr.bind(this);
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
                props.onChange = function (e, { name, value }) {
                    handleEvent({ syntheticEvent: e, key: props.key, eventName: "onChange", name: name, value: value });
                    if (data["prePopulatedFields"] !== undefined) {
                        var newPopulatedFields = data["prePopulatedFields"].filter(item => item !== props.key);
                        handleEvent({ syntheticEvent: e, key: "prePopulatedFields", eventName: "onChange", name: "prePopulatedFields", value: newPopulatedFields });
                    }

                };

                props.onClick = function (e, value) {
                    var scrollKey = null;
                    if (model.onScrollNextControl) {
                        scrollKey = Array.isArray(nextModels) ? (this.getNextModelFromArr(props.key, nextModels)) : nextModels;
                        //if do not found scrollKey/nextModels
                        if (scrollKey == null) {
                            //find the element of parent block -> next Element
                            var scrollElement = (document.getElementsByName(model.parentcontrols[model.parentcontrols.length - 1]))[0];
                            while (scrollElement.parentElement.getAttribute("name") == null
                                && scrollElement.parentElement.getAttribute("data-buildertype=") !== "swzPage"
                                && scrollElement.parentElement.nextElementSibling !== null) {
                                scrollElement = scrollElement.parentElement;
                            }

                            if (scrollElement.parentElement.nextElementSibling !== null) {
                                scrollKey = scrollElement.parentElement.nextElementSibling.getAttribute("name");
                            }
                        } else {
                            scrollKey = scrollKey.key;
                        }

                        if (scrollKey) {
                            if (document.getElementsByName(scrollKey)[0] !== undefined) {
                                (document.getElementsByName(scrollKey))[0].scrollIntoView({ block: 'start', behavior: 'smooth' });
                            }
                        }
                    }

                    handleEvent({ syntheticEvent: e, key: props.key, eventName: "onClick", parameters: { key: model.key, value: value } });
                };
            }

            if (typeof errors === "object" && errors[model.key] !== undefined) {
                props.error = errors[model.key];
            }

            if (data !== undefined) {
                props.value = data[props.key];
                if (data["prePopulatedFields"] !== undefined) {
                    var prePopulatedFields = data["prePopulatedFields"];
                    props.isPrePopulated = prePopulatedFields.includes(props.key);
                }

            }

            props.randomise = model.randomise;
            props.sliderForm = model.sliderForm;
            props.builderMode = buildermode;
            props.onScrollNextElement = model.onScrollNextElement;

            if (data && data['isInternetApplication'] && data['formIsReadOnly'])
                props.readOnly = true;

            res = (<RadioGroup {...props}
                label={model.label}
                direction={model.direction}
                placeholder={model.placeholder}
                items={items}
                additionalParams={{
                    model, data, errors, children, handleEvent, parentItem, uploadUrl, downloadUrl
                }}>
            </RadioGroup>);
        }
        else if (control === CollectionEditor) {

            //Added by Swz
            props.disableDelete = model.disableDelete;
            props.header = model.header;
            props.headerTitle = model.headerTitle;
            props.headerSize = model.headerSize;

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
                    let control = CloverFormControls.getControlByType(databuildertype);
                    if (control == undefined) {
                        console.error("Control is unsupported!", databuildertype, parentControl, parameters);
                        return;
                    }

                    let item = CloverFormControls.createControl(parentControl, control, parameters);
                    let res = [];
                    if (parameters.buildermode) {
                        var buildercontrol = (
                            <ControlBar key={parameters.model.key + "_controlbar"}
                                model={parameters.model} parent={parentComponent}
                                loadTemplate={loadTemplate}
                                onDelete={eventOnDelete} onEdit={eventOnEdit} onCopy={eventOnCopy} swzOnHide={swzEventOnHide} swzOnShow={swzEventOnShow} />);
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
                props.onChange = function (e, { name, value }) {
                    handleEvent({ syntheticEvent: e, key: props.key, eventName: "onChange", name: name, value: value });
                };
            }
            else if (buildermode) {
                props.onChange = function (e, { name, value }) {
                    props.value = value;
                }
            }

            if (data !== undefined)
                props.value = data[props.key];

            if (errors !== undefined)
                props.error = errors[props.key];

            if (buildermode && props.value === undefined && props.columns !== undefined) {
                props.buildermode = buildermode;
                props.createBuilderDropzone = function (columnName, value) {
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

            if (data !== undefined)
                props.value = data[props.key];

            res = (<MenuGroup {...props} additionalParams={{
                model, data, errors, children, handleEvent, parentItem, uploadUrl, downloadUrl
            }} />);
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
                        [{ x: 6, y: -12 },
                        { x: 11, y: 1 },
                        { x: 24, y: 5 },
                        { x: 40, y: 32 }
                        ];

                    props.value = {
                        labels: ["Q1", "Q2", "Q3", "Q4"],
                        datasets: [{
                            data: testData
                        }]
                    };
                }
            }
            else {
                if (data !== undefined)
                    props.value = data[props.key];
            }

            res = (<ChartView {...props} />);
        }
        else if (control === Container) {
            props.randomise = model.randomise;
            props.templateBlock = model.templateBlock;
            if (data !== undefined)
                props.data = data;

            res = (<Container {...props} children={children} additionalParams={{
                model,
                children
            }} />);
        }
        else if (control === SwzPage) {
            props.swzPage = {
                main: {
                    onPageDisplay: model.onpagedisplay,
                    onScrollToView: model.onscrolltoview,
                    builderMode: model.buildermode,
                    onMenu: hideSideMenu || buildermode ? false : model.onmenu,
                    onStatusBar: model.onstatusbar,
                    items: model.items,
                    validatedPages: model.validatedpages
                },
                header: {
                    headerLabel: model.headerlabel,
                    lastSaved: model.lastsaved,
                    onImage: model.onimage,
                    imageSrc: model.imagesrc,
                    imageWidth: model.imagewidth,
                    print: model.print
                },
                footer: {
                    footerLabel: model.footerlabel,
                    back: model.back,
                    next: model.next,
                    exit: model.exit,
                    cancel: model.cancel,
                    save: model.save,
                    saveExit: model.saveexit,
                    submit: model.submit
                }
            }
            if (data && data['isInternetApplication'] && data['formIsReadOnly']) {
                props.swzPage.main['isInternetApplicationReadOnly'] = true;

            }
            if (data && data['isIntranetApplication'] && data['formIsReadOnly'] && data['isCleared']) {
                props.swzPage.main['isIntranetApplicationReadOnly'] = true;

            }
            props.handleevent = handleEvent;
            res = (<div>
                <SwzPage {...props} children={children} />
            </div>);
        }
        else if (control === SwzTable) {
            props.handleevent = handleEvent;
            props.tableindex = model.tableindex;
            props.uniqueRowsColumns = model.uniqueRowsColumns
            props.rows = model.rows;
            props.columns = model.columns;
            props.spandict = model.spandict;

            props.tablewidth = model.tablewidth;
            props.tableheight = model.tableheight;
            props.cellpadding = model.cellpadding;
            props.tablealign = model.tablealign;
            props.bordertype = model.bordertype;
            props.borderwidth = model.borderwidth;
            props.bordercolor = model.bordercolor;
            props.borderline = model.borderline;

            res = (<SwzTable {...props} children={children} />);
        }
        else if (control === SwzModal) {
            if (model.content === undefined || model.content === null) {
                var buttonContent = "Button"
            } else {
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
        else if (control === SwzScanner) {

            props.handleEvent = handleEvent;
            props.scanValue = model.scanValue;
            res = (<SwzScanner {...props} additionalParams={{
                model, data, errors, children, handleEvent
            }} />);
        }
        else if (control === SwzCaptcha) {

            props.handleEvent = handleEvent;
            props.captchaValue = model.captchaValue;
            res = (<SwzCaptcha {...props} additionalParams={{
                model, data, errors, children, handleEvent
            }} />);
        }
        else if (control === DplyChoiceQnns) {
            if (data !== undefined)
                props.value = data[props.key];
            res = (<DplyChoiceQnns {...props} />);
        }
        else if (control === SwzStaticContent) {
            props.content = model.content;
            props.isHtml = model.isHtml;
            if (data !== undefined)
                props.value = data[props.key];

            res = (<SwzStaticContent {...props} additionalParams={{
                model, data, errors, children, handleEvent, parentItem, uploadUrl, downloadUrl
            }} />);
        }
        else if (control === DropzoneControl) {
            props.iconFiletypes = model.iconFiletypes;
            props.postUrl = uploadUrl;
            props.showFiletypeIcon = model.showFiletypeIcon;
            props.autoProcessQueue = model.autoProcessQueue;
            props.addRemoveLinks = model.addRemoveLinks;
            res = (<DropzoneControl {...props}
                additionalParams={{ model, data, errors, children, handleEvent, parentItem }} />);
        }
        else {
            console.error("Control is unsupported!", control, model);
        }

        return res;
    },
    autoSave: function (func) {

        console.log("AutoSave function trigger");
        if (timeoutId) {
            clearTimeout(timeoutId)
        };
        timeoutId = setTimeout(() => {
            //Make ajax call to save data.
            if (func)
                func();

        }, (window.autoSaveDelay ?? 3) * 1000);

    },
    isInput: function (key) {
        return (key === 'dropdown' || key === 'radiogroup' ||
            key === 'checkbox' || key === 'textarea' || key === 'input')
    },
    getNextModelFromArr: function (key, nextModels) {
        if (nextModels && nextModels.length > 0) {
            for (var i = 0; i < nextModels.length; i++) {
                if (nextModels[i].key == key && nextModels[i + 1])
                    return nextModels[i + 1];
            }
        }
        return null;
    },
    isContainer: function (key) {
        return (key === 'form' || key === 'formgroup' ||
            key === 'grid' || key === 'gridrow' || key === 'gridcolumn' ||
            key === 'card' || key === 'cardcontent' ||
            key === 'container' || key === 'div' || key === 'swzmodal' || key === 'block' || key === 'swztable');
    },
    isPageContainer: function (key) {
        return (key === 'swzPage');
    },
    isDividerContainer: function (key) {
        return (key === 'swzDivider');
    },
    isForm: function (model) {
        return (model !== null && model !== undefined &&
            (model["data-buildertype"] === "form" ||
                model["data-buildertype"] === "formgroup"));
    },
    createBuilderDropzone: function (key, elementToInsert, elementafter, text, placeholderKey, tableIndex) {
        // if(text === undefined)
        text = "DROP ZONE";
        return <div /* onClick={() => console.log("Click dropzone", this)} */ name={key} key={key} elementafter={elementafter} elementtoinsert={elementToInsert} placeholderkey={placeholderKey} tableIndex={tableIndex} className="clover-formbuilder-zone">{text}</div>
    },

    fillDefaultValues: function (model, defaultValues) {

        var control = undefined;
        for (var k in defaultValues) {
            if (model[k] === undefined)
                model[k] = defaultValues[k];
        }
        return model;
    },

    getUniqueRowsColumns: function (tableIndex) {
        var uniqueRows = [];
        var uniqueColumns = [];
        var rowObj = {};
        var columnObj = {};
        var uniqueObj = {};

        if (tableIndex !== undefined && tableIndex.length > 0) {
            for (let k = 0; k < tableIndex.length; k++) {
                let rowIndex = tableIndex[k].substr(0, tableIndex[k].indexOf('_'));
                let columnIndex = tableIndex[k].substr(tableIndex[k].indexOf('_') + 1, tableIndex[k].length);
                if (rowObj[rowIndex] == undefined) {
                    uniqueRows.push(rowIndex);
                    rowObj[rowIndex] = "Not unique row anymore"
                }
                if (columnObj[columnIndex] == undefined) {
                    uniqueColumns.push(columnIndex);
                    columnObj[columnIndex] = "Not unique column anymore"
                }
            }
            uniqueObj['uniqueRows'] = uniqueRows;
            uniqueObj['uniqueColumns'] = uniqueColumns;
        }
        return uniqueObj
    }
};

module.exports = CloverFormControls;