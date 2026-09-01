import React from 'react';
import {Input} from 'semantic-ui-react';

export default class SearchBox extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            value: "",
        }
        this.timeoutId = null;

        this.handleChange = this.handleChange.bind(this);        
    }


    handleChange() {
        this.setState({
            value: event.target.value,
        });
        if(this.timeoutId) {
            window.clearTimeout(this.timeoutId);
        }
        const me = this;
        this.timeoutId = window.setTimeout(function() {
            if(me.props.onChange) {
                //TODO - pass a proper event instead of just the value
                me.props.onChange(me.state.value);
            }
        }, 500);
        
    }

    render() {
        return (
            <Input 
                className="help-search-input"
                icon="search" 
                placeholder="Search..." 
                onChange={this.handleChange} 
                value={this.state.search} />
        );
    }

}







