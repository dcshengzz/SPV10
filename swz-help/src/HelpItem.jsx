import React from 'react';
import {Accordion, Icon} from 'semantic-ui-react';

//Expects Heading (text) and Content (html) props.
//nb: Content is raw html so be careful re xss etc
export default class HelpItem extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            open: false,
        };
        this.handleClick = this.handleClick.bind(this);
        this.headingRef = React.createRef();
        this.contentRef = React.createRef();
    }

    componentDidMount() {
        //console.log("componentDidMount", this);
        this.markHighlights();        
    }

    componentDidUpdate(prevProps, prevState) {
        //console.log("componentDidUpdate", this, prevProps, prevState);
        this.markHighlights(); 
    }

    handleClick = (e, titleProps) => {
        //Just toggle whether its open or not
        this.setState( state => {
            return { open: !state.open };
        });
    }

    shouldComponentUpdate(nextProps, nextState) {
        if ( (nextProps.heading === this.props.heading) 
        && (nextProps.content === this.props.content)
        && (nextProps.highlights == this.props.highlights)
        && (nextState.open === this.state.open) ) {
          return false;
        } else {
          return true;
        }
    }

    //Use mark.js to highlight the search terms via DOM manipulation
    markHighlights() {
        //console.log("markHighlights", this.props.highlights);
        const mark = new Mark( [this.headingRef.current, this.contentRef.current] );
        mark.unmark();
        if(this.props.highlights) {
            mark.mark(this.props.highlights, {
                "wildcards": "enabled",
                //"accuracy": "exactly"
            });
        }
    }

    render() {
        const headingText = this.props.heading ? this.props.heading : "";
        const contentHtml = this.props.content ? this.props.content : "";
        return(
        <div className="help-sub-topic">
            <Accordion>
                <Accordion.Title active={this.state.open} onClick={this.handleClick} >
                <Icon name='dropdown' />
                <span className="help-sub-topic-heading" ref={this.headingRef}>{headingText}</span>
                </Accordion.Title>
                <Accordion.Content active={this.state.open}>
                    <div ref={this.contentRef} style={{paddingLeft: "20px", }} className="output" dangerouslySetInnerHTML={{ __html: contentHtml}} />
                </Accordion.Content>
            </Accordion>
        </div>
        );
    } //end render

}








