import React, { Component } from 'react'
import { Form, Radio } from 'semantic-ui-react'
import { EditorState, convertToRaw , convertFromRaw, ContentState} from 'draft-js';
import draftToHtml from 'draftjs-to-html';


var htmlExample =[`<p></p>`]; //Add loading icon here

export default class Swzhtmlview extends React.Component {
  constructor(props){
    super(props);

    this.state = {
      htmlData: htmlExample, 
      isOnce: true
    }
  }

  componentWillReceiveProps = (nextProps) => {

    //console.log("NextProps from Resplogin ", nextProps);
    
    {/*Receiving Props*/}
    var items =  nextProps;
    var additionData = nextProps.value;
    if (additionData != null || additionData != undefined){
      //console.log("Component Received props", additionData );     
      var htmlDataArr = [];
      for (var i=0; i<additionData.length; i++){
        var htmlData = this.initHtml(additionData[i]);
            htmlDataArr.push(htmlData);
      }
      
      if (htmlData == null) return;
      //console.log('HTML data Arr is', htmlDataArr);
      this.setState({htmlData:htmlDataArr});
      return;
    }

    {/*Edit in Controls*/}
    if(nextProps.swzdata.viewState !== null && nextProps.swzdata.viewState !== undefined && nextProps.swzdata.viewState !== ""){
      if (this.state.isOnce == false) return;
      var viewArr = JSON.parse(nextProps.swzdata.viewState);
      //console.log("Overwriting the data using viewstate", viewArr);
      var htmlViewArr = [];
      for (var q=0; q<viewArr.length; q++){
        var viewItem = this.initHtml(viewArr[q]);
        htmlViewArr.push(viewItem);
      }
      //console.log("htmlView Arr is", htmlViewArr);
      this.setState({isOnce: false});
      this.setState({htmlData:htmlViewArr})
    } 
  }

  initHtml = (htmlJson) => {
    
    //console.log('initHTML' , htmlJson);
    if (typeof htmlJson == "string") {
      var htmlObj = JSON.parse(htmlJson);
    }
    else{
      var htmlObj = htmlJson
    }
    //console.log("after Parse", htmlObj);
    var jsonConvert = convertFromRaw(htmlObj);
    var htmldata = draftToHtml(convertToRaw(jsonConvert));
    return htmldata;
  } 

  htmlRender = () => { 
   
    const { htmlData } = this.state;
    var htmlItems = [];
    
    for (var i=0; i < htmlData.length; i++){
      htmlItems.push(<div className="output" style={this.props.swzdata.hideOutput} dangerouslySetInnerHTML={{ __html: htmlData[i]}} />);
    }

    return htmlItems;
  }
  render() {
   // https://stackoverflow.com/questions/29149169/how-to-loop-and-render-elements-in-react-js-without-an-array-of-objects-to-map
  
    return (this.htmlRender());
  }
}