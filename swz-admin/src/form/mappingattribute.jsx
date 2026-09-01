import React from "react";
import ReactDOM from "react-dom";
import { Form, Input, Checkbox, Segment, Button, Modal, Message, Confirm, Icon} from 'semantic-ui-react'
import JSON5 from 'json5'
import BaseComponent from './../basecomponent'
import CloverAdminFormMappingColl from './mappingcoll'

export default class MappingAttribute extends BaseComponent {
    constructor(props) {
        super(props);

        this.state = {
            showref: false
        };
    }

    onShowRef(value) {
        var me = this;
        this.addMissingDataMap();
        this.setState({
            showref: value
        });
    }

    render() {
        var me = this;
        var item = this.props.item;
        var icon;
        var showref = this.state.showref;
        if (item.referenceEntityId != undefined && this.props.dataMap != undefined) {
            if (showref) {
                icon = <img onClick={this.onShowRef.bind(this, false)} className="clover-formadmin-imgbutton"
                            src="/images/collapse.svg"/>;
            }
            else {
                icon = <img onClick={this.onShowRef.bind(this, true)} className="clover-formadmin-imgbutton"
                            src="/images/expand.svg"/>;
            }
        }

        var dropzoneForControl;
        if (!this.props.hidedropzone) {
            if (item.control == undefined) {
                dropzoneForControl = <div key="dz" className="clover-formmapping-zone"
                                          data-id={item.id}>{CloverAdminLang.datamap.placefortoncroltitle}</div>
            }
            else {
                var mapdataObj = this.props.parent.props.parent;
                dropzoneForControl = <div key="control" className="mapdatacontrol" draggable="true"
                                          onDragStart={mapdataObj.onDragStart.bind(mapdataObj, item.control)}
                                          onDragEnd={mapdataObj.onDragEnd.bind(mapdataObj, item.control)}
                                          onDoubleClick={mapdataObj.onDoubleClick.bind(mapdataObj, item.control)}>
                    <span key="span">{item.control}</span>
                </div>;
            }
        }
        else {
            let alias = item.control == undefined ? "" : item.control;
            dropzoneForControl = <Form.Input key="control" name="control"
                                             list={this.props.datalist}
                                             placeholder="Alias" value={alias} onChange={this.handleChange.bind(this)}/>
        }

        return (<div key={this.props.item.id}>
            <Form.Group key="group" className="clover-formadmin-mapping-attribute">
                {icon != undefined &&
                <div className="clover-formadmin-imgbuttondiv">
                    {icon}
                </div>
                }
                <Form.Input key="attributeName" name="attributeName" value={item.attributeName} readOnly/>
                <Form.Checkbox className="gridcheckbox" key="isLoadable" label={CloverAdminLang.datamap.loadfield}
                               name="isLoadable" checked={item.isLoadable} onChange={this.handleChange.bind(this)}/>
                {dropzoneForControl}
            </Form.Group>
            {showref && <div key="ref" className="clover-formmapping-ref">{this.renderRef()}</div>}
        </div>);
    }

    renderRef() {
        let me = this;
        let res = [];
        let item = this.props.item;
        let dataMap = this.props.dataMap;
        dataMap.forEach(function (e) {
            if (e.parentId == item.id) {
                res.push(<MappingAttribute key={e.id} item={e} parent={me.props.parent} dataMap={dataMap}
                                           collectionId={me.props.collectionId}
                                           hidedropzone={me.props.hidedropzone}
                                           datalist={me.props.datalist}/>);
            }
        });

        return res;
    }

    handleChange(e, {name, checked, value}) {
        var item = this.props.item;
        if (name == "isLoadable" || name == "isEditable") {
            item[name] = checked;
        }
        else {
            item[name] = value;
            if (name == "control") {
                item["isLoadable"] = Boolean(value != undefined && value.length > 0);
            }
        }

        this.forceUpdate();
    }

    iAmInCollection() {
        return this.props.parent instanceof CloverAdminFormMappingColl;
    }

    addMissingDataMap() {
        const item = this.props.item;
        const dataMap = this.props.dataMap;
        if (dataMap.some(dm => dm.parentId === item.id))
            return;
        const mapDataEdit = this.props.parent.props.parent;
        const additionalDataMap = mapDataEdit.createDataMap(item.referenceEntityId, item.id, item.attributeName + '_', dataMap);
        if (!this.iAmInCollection()) {
            const newForm = mapDataEdit.state.form;
            newForm.dataMap = newForm.dataMap.concat(additionalDataMap);
            mapDataEdit.setState({form: newForm});
        }
        else {
            const collection = this.props.parent;
            const collectionId = this.props.collectionId;
            const newForm = mapDataEdit.state.form;
            const collectionForChange = newForm.dataColl.find (cl=>cl.id === collectionId);
            if (collectionForChange === undefined)
                return;
            collectionForChange.dataMap = collectionForChange.dataMap.concat(additionalDataMap);
            mapDataEdit.setState({form: newForm});
        }
    }
}