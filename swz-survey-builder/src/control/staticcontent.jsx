import React, { Component } from 'react';

const insertContent =`<p><h3>Insert content</h3></p>`; //Add loading icon here
export default class StaticContent extends React.Component {
  constructor(props){
    super(props);
      this.state = {
      };
  }
  
  render() {

    var spanProps = {
      name: this.props.name,
      className: this.props["style-customcss"],
      style: this.props.style,
      "data-buildertype" : this.props["data-buildertype"]
    };
    var content;
    {this.props.content != undefined ? content = this.props.content : 
      content = insertContent;
    }
   
    return( <span {...spanProps} dangerouslySetInnerHTML={{__html: content}} />
    )
  }
}