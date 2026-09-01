import React, { Component } from "react";
import ReactDOM from 'react-dom';
import { Modal, Button } from 'semantic-ui-react';

class ConfirmComponent extends Component {

    constructor(props) {
        super(props);
    }

    componentDidMount() {
        this.promise = new Promise((resolve, reject) => {
            this.resolve = resolve;
            this.reject = reject;
        });
    }

    abort = () => {
        this.reject();
    }

    confirm = () => {
        this.resolve();
    }

    render() {

        return (
            <Modal open>
                <Modal.Header>{this.props.title}</Modal.Header>
                <Modal.Content>
                    {this.props.text}
                </Modal.Content>
                <Modal.Actions>{this.props.ok &&
                    <Button className="buttontype1" content={this.props.ok} onClick={this.confirm} />
                }<Button className="buttontype2" content={this.props.cancel} onClick={this.abort} />
                </Modal.Actions>
            </Modal>
        );
    }
}

export default function confirm(messages) {

    const wrapper = document.body.appendChild(document.createElement('div'));
    const component = ReactDOM.render(React.createElement(ConfirmComponent, messages), wrapper);
    const cleanup = () => {
        ReactDOM.unmountComponentAtNode(wrapper);
        return setTimeout(() => wrapper.remove());
    };

    return component.promise.finally(cleanup);
}