import React, { Component } from 'react'
import JSON5 from 'json5'
import { Tab } from 'semantic-ui-react'

export default class TabGroup extends React.Component {
    constructor(props) {
        super(props);
        this.state = {};

        if (props.value != undefined) {
            this.state.activeitem = props.value;
        }
        else if (props.activeitem != null) {
            this.state.activeitem = props.activeitem;
        }
    }

    static getDerivedStateFromProps(nextProps, prevState) {
        if (prevState.activeitem !== nextProps.value)
        {
            return {activeitem: nextProps.value};
        }

        return null;
    }

    handleItemClick(e, {name}) {
        if (this.props.handleEvent != undefined) {
            var res = this.props.handleEvent({
                e,
                key: this.props.name,
                eventName: "onItemClick",
                parameters: {target: name}
            });
            if (res != false) {
                this.setState({activeitem: name});
                this.setState({open: false});
            }
        }
    }

    
    render() {
        var children = this.props.additionalParams.children;

        var controlProps = {};
        for(var p in this.props){
            if(p == 'activeitem' || p == 'handleEvent' || p == 'link')
                continue;
            controlProps[p] = this.props[p];
        }
        if(this.props.icon)
            controlProps.icon = 'labeled';

        const panes = [];
        let items = this.props.items;
        if (items == undefined || items == "") {
            items = [];
        }
        let rowCount = 0;

        if(items !== undefined || items == "" || items == []){
            items.map((item,i) => {
                if (
                    this.props.isDisplayCount &&
                    children &&
                    children[i] &&
                    children[i][0] &&
                    children[i][0].props &&
                    children[i][0].props.children &&
                    children[i][0].props.children[0] &&
                    children[i][0].props.children[0].props &&
                    children[i][0].props.children[0].props.value
                ){
                    rowCount = children[i][0].props.children[0].props.value.length;
                }
                const displayedTitle = this.props.isDisplayCount 
                    ? item.title + "(" + rowCount + ")" 
                    : item.title;
                let pane = { 
                    menuItem: displayedTitle,
                    render: () => <Tab.Pane attached={false}>{children[i]}</Tab.Pane>
                }
                panes.push(pane);
            });
        }
        return  <div key={this.props.name} className="tap-resp">
                    <Tab 
                        menu={{ 
                            pointing: !!this.props.pointing,
                            secondary: !!this.props.secondary, 
                            tabular: !!this.props.tabular,
                            fluid: !!this.props.fluid,
                            vertical: !!this.props.vertical,
                            compact: !!this.props.compact }} 
                        panes={panes} />
                </div>
        }
} 