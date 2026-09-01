import React, { Component } from 'react'

export default class StaticContent extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      fetchData: undefined,
      staticContent: "<p></p>"
    }
  }

  componentWillReceiveProps = (nextProps) => {
    
      var onFetchData = nextProps.fetchData
      var staticValue = nextProps.value;
    if (onFetchData != null || onFetchData != undefined){
      this.setState({fetchData: onFetchData});
    }

    if (staticValue != null || staticValue != undefined){
      //console.log("Component Received props", additionData );     
      this.setState({staticContent:staticValue})
    }
  }
  render() {

    const {fetchData} = this.state;
    const {staticContent} = this.state;
    var spanProps = {
      name: this.props.name,
      className: this.props["style-customcss"],
      style: this.props.style,
      "data-buildertype" : this.props["data-buildertype"]
    };
    //console.log("fetchData", fetchData);
    //console.log("StaticContent Props is ", this.props);
    //console.log("staticContent", staticContent);
    if(fetchData){
      if(this.props.isHtml){
        return <span {...spanProps} dangerouslySetInnerHTML={{__html: staticContent}} />
      }
    }
    else{
      if(this.props.isHtml){
        return <span {...spanProps} dangerouslySetInnerHTML={{__html: this.props.content}} />
      }
      else{
          var content = this.props.content != undefined ? 
            this.props.content.replace('\n','<br/>'):
            undefined;
	  if(this.props.isPre){
          	return (<pre>{this.props.content}</pre>);
	  }
          return (<span {...spanProps}>{content}</span>);
      }
    }
  }
}