import React, { Component } from 'react';
import { Button, Modal } from 'semantic-ui-react';
import 'altcha';

export default class SwzCaptcha extends Component {
  constructor(props) {
    super(props);
    this.state = {
      showCaptcha: false,
      isVerified: false,
      error: null,
      value: props.captchaValue
    };
    this.altchaWidgetRef = React.createRef();
  }

  componentDidUpdate(prevProps, prevState) {
    if (this.state.showCaptcha && !prevState.showCaptcha) {
      this.initAltcha();
    }
  }

  initAltcha = () => {
    const widget = this.altchaWidgetRef.current;
    if (widget) {
      widget.addEventListener('statechange', this.handleVerification);
    }
  };

  componentWillUnmount() {
    const widget = this.altchaWidgetRef.current;
    if (widget) {
      widget.removeEventListener('statechange', this.handleVerification);
    }
  }

handleVerification = async (event) => {
    if (!event.detail || !event.detail.payload) return;
    
    try {
      const verification = await fetch('/api/verify-captcha', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
          response: event.detail.payload 
        })
      });
      if (!verification.ok) throw new Error('Verification failed');

        var handleEvent = this.props.additionalParams.handleEvent;
        console.log(verification.ok);
        this.setState({value: verification.ok})
        if(handleEvent !== undefined){
        return handleEvent({syntheticEvent: null, key:  this.props.additionalParams.model.key, eventName: "onChange"});
    };
    } catch (error) {
    }
};

  resetAltcha = () => {
    const widget = this.altchaWidgetRef.current;
    if (widget) {
      widget.reset();
    }
  };

  render() {
    const { showCaptcha, isVerified, error } = this.state;
    const model = this.props.additionalParams?.model || {};

    return (
      <div>
        <Button
          {...{
            name: model.key || 'swzcaptcha',
            size: model.size || null,
            basic: model.basic,
            compact: model.compact,
            disabled: model.disabled,
            inverted: model.inverted,
            primary: model.primary,
            secondary: model.secondary
          }}
          onClick={() => this.setState({ showCaptcha: true, error: null })}
        >
          {isVerified ? '✓ Verified' : 'Verify CAPTCHA'}
        </Button>

        <Modal
          open={showCaptcha}
          onClose={() => this.setState({ showCaptcha: false })}
        >
          <Modal.Header>Security Verification</Modal.Header>
          <Modal.Content>
            {error && (
              <div className="error-message" style={{ color: 'red', marginBottom: '1em' }}>
                {error}
              </div>
            )}

            <div style={{ minHeight: '150px' }}>
              <altcha-widget
                ref={this.altchaWidgetRef}
                name={model.key || 'swzcaptcha'}
                style={{
                  '--altcha-max-width': '100%',
                }}
                challengeurl="/api/altcha/challenge"
              ></altcha-widget>
            </div>
          </Modal.Content>

          <Modal.Actions>
            <Button
              basic
              color="grey"
              onClick={() => this.setState({ showCaptcha: false })}
            >
              Close
            </Button>
          </Modal.Actions>
        </Modal>
      </div>
    );
  }
}