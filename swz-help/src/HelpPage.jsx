import React from 'react';
import { convertToRaw, convertFromRaw } from 'draft-js';
import draftToHtml from 'draftjs-to-html';
import lunr from 'lunr';
import HelpItem from "./HelpItem";
import {Loader, Dimmer} from 'semantic-ui-react';
import SearchBox from './SearchBox';

export default class HelpPage extends React.Component {

    constructor(props) {
        super(props);
        console.log("props to HelpPage", props);
        
        this.state = {
            data: [],
            index: null,
            hasError: false,
            isLoading: this.props.getHelpUrl ? true : false,
            search: "",
        }

        this.minScore = 0.5;

        this.load = this.load.bind(this);
        this.handleSearchChange = this.handleSearchChange.bind(this);
        this.getFilteredData = this.getFilteredData.bind(this);
        this.setDataAndBuildIndex = this.setDataAndBuildIndex.bind(this);
    }

    componentDidMount() {
        if(this.props.getHelpUrl) {
            this.load();
        } else if(this.props.data) {
            this.setDataAndBuildIndex( this.props.data );
        } else {
            this.setDataAndBuildIndex( [] );
        }
    }

    setDataAndBuildIndex(data) {
        const start = Date.now();
        const processedData = [];
        const lunrIndex = lunr(function () {
            const thisLunr = this;
            thisLunr.ref("Id");
            //thisLunr.field("Topic", { boost: 1 });
            thisLunr.field("Heading", { boost: 2});
            thisLunr.field("ContentText", { boost: 1});
            data.forEach(item => {                
                const contentState = convertFromRaw(item.Content);
                const text = contentState.getPlainText();
                const raw = convertToRaw(contentState); //Must roundtrip it for draftToHtml to work, ie getBlockMap etc
                const html = draftToHtml(raw);
                const processedItem = {
                    Id: item.Id,
                    Topic: item.Topic,
                    Heading: item.Heading,
                    Content: item.Content,
                    ContentHTML: html,
                    ContentText: text,
                };
                processedData.push( processedItem );
                thisLunr.add(processedItem);
                delete processedItem.ContentText; //can release this memory now
            }); //end of forEach item
        }); //end of lunr(...)
        const elapsed = Date.now() - start;
        console.log("processed data and built index in " + elapsed + "ms");
        this.setState( {
            index: lunrIndex,
            data: processedData,
        } );        
    }

    load() {
        var me = this;
        let helpUrl = me.props.getHelpUrl;
        if(helpUrl.indexOf('?')==-1) {
            helpUrl += "?";
        }
        const helpType = me.props.helpType ? me.props.helpType : "resp";
        const usp = new URLSearchParams();
        usp.append("helpType", helpType); //admin vs resp
        helpUrl += usp;
        $.ajax({
            url: helpUrl,
            method: "GET",
            async: true,
            success: function (response) {
                if(Array.isArray(response)) {
                    //server returns the ContentState in string form but we will need it as an object
                    response.forEach(item => {
                        if("string"===typeof(item.Content)) {
                            item.Content = JSON.parse(item.Content);
                        }                    
                    });
                    me.setState({ 
                        hasError: false,
                        isLoading: false,
                     });
                     me.setDataAndBuildIndex(response);
                } else {
                    console.error("Bad response from server", response);
                    me.setState({ 
                        data: [],
                        hasError: true,
                        isLoading: false,
                    });
                }                
            },
            error: function (jqXHR, exception){
                console.error("Failed to get help information",jqXHR, exception);
                me.setState( { 
                  data: [], 
                  hasError: true, 
                  isLoading: false,
                } );
            }
        });
    }

    //callback method we provide to SearchBox to inform us of changes to the search value
    //SearchBox manages short-term state then calls us back after a while (eg 500ms) 
    //if no further typing is happening
    handleSearchChange(value) {
        this.setState( {search: value});
    }

    getFilteredData() {
        const allHelpItems = this.state.data ? this.state.data : [];
        const searchQuery = this.state.search;
        if(""===searchQuery || this.state.index===null) {
            return allHelpItems;
        } else {
            try{
                const searchResultList = this.state.index.search(searchQuery);
                console.log("minScore=" + this.minScore + ", searchResultList:", searchResultList);
    
                const searchResultIdSet = new Set( searchResultList
                    .filter(result => result.score > this.minScore)
                    .map(result => result.ref) 
                );            
                const filteredHelpItems = allHelpItems.filter(item => searchResultIdSet.has(item.Id));
                return filteredHelpItems; 
            }catch(ex){
                console.log("Error", ex);
                return allHelpItems;
            }
        }
    }

    render() {
        //IT IS ASSUMED THAT data IS SORTED BY TOPIC FIRST 
        const me = this;
        const start = Date.now();

        if(this.state.hasError) { return( <div>An error occured</div> ); }        
        if(this.state.isLoading) { return ( <Dimmer active><Loader /></Dimmer> ); }

        const makeTopicJsx = function(topic, itemsJsx) {
            return (
                <div className="help-topic" key={topic} >
                    <h3 className="help-topic-heading" style={{marginTop: "10px", marginBottom: "0px"}}>{topic}</h3>
                    {itemsJsx}
                </div>
            );
        }
        const data = this.getFilteredData();
        const topicsJsx = [];
        var previousTopic = null;
        var itemsJsx = [];        
        data.forEach( (itemData, index) => {

            const isLastItem = (index == data.length-1);
            const isNewTopic = (itemData.Topic != previousTopic);
            const isCompletingTopic = (itemsJsx.length > 0) && (isNewTopic);

            if(isCompletingTopic) {
                //Create a topic thing for the previous bunch of items before starting a new bunch with this one
                topicsJsx.push( makeTopicJsx(previousTopic, itemsJsx) );
                itemsJsx = [];
            }

            itemsJsx.push( 
                <HelpItem 
                    key={itemData.Id} 
                    highlights={this.state.search}
                    heading={itemData.Heading}  
                    content={itemData.ContentHTML} />
             );
            previousTopic = itemData.Topic;

            if(isLastItem) {
                //Create a topic thing for the previous bunch of items because we are about to exit the loop
                topicsJsx.push( makeTopicJsx(previousTopic, itemsJsx) );
                itemsJsx = [];
            }
        } );

        const display = (
            <div className="help-page">
                <div className="help-page-heading">Help</div>
                <div className="help-search" >
                    <SearchBox onChange={this.handleSearchChange} />
                </div>
                <div className="help-content">
                    {topicsJsx.length === 0 ?
                        <div className="help-content-empty">No content available.</div>
                        :
                        topicsJsx    
                    }
                </div>
            </div>
        );

        const elapsed = Date.now() - start;
        console.log("rendered HelpPage in " + elapsed + "ms");
        return display;  
    } //end render

}







