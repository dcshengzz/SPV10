import React from "react";
import ReactDOM from "react-dom";
import HelpPage from './src/HelpPage';

//Test/dev app for the HelpPage 

const testData = [
  {
    Id: "1",
    Topic: "Test Topic",
    Heading: "First Heading",
    Content: {"blocks":[{"key":"dmc0l","text":"To make help content appear on the help page you must turn on the Status toggle. ","type":"unstyled","depth":0,"inlineStyleRanges":[{"offset":66,"length":7,"style":"BOLD"}],"entityRanges":[],"data":{}},{"key":"j16t","text":"You can leave the status toggle switched off while drafting content so that users will not see it until you are ready","type":"unstyled","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}],"entityMap":{}},
  }, {
    Id: "2",
    Topic: "Test Topic",
    Heading: "Second Heading",
    Content: {"blocks":[{"key":"dmc0l","text":"To make help content appear on the help page you must turn on the Status toggle. ","type":"unstyled","depth":0,"inlineStyleRanges":[{"offset":66,"length":7,"style":"BOLD"}],"entityRanges":[],"data":{}},{"key":"j16t","text":"XXXXXX You can leave the status toggle switched off while drafting content so that users will not see it until you are ready","type":"unstyled","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}],"entityMap":{}},
  }, {
    Id: "3",
    Topic: "Another Topic",
    Heading: "How do I make my help content show up?",
    Content: {"blocks":[{"key":"dmc0l","text":"To make help content appear on the help page you must turn on the Status toggle. ","type":"unstyled","depth":0,"inlineStyleRanges":[{"offset":66,"length":7,"style":"BOLD"}],"entityRanges":[],"data":{}},{"key":"j16t","text":"XXXXXX You can leave the status toggle switched off while drafting content so that users will not see it until you are ready","type":"unstyled","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}],"entityMap":{}},
  }, {
    Id: "3",
    Topic: "Another Topic",
    Heading: "Last heading",
    Content: {"blocks":[{"key":"dmc0l","text":"To make help content appear on the help page you must turn on the Status toggle. ","type":"unstyled","depth":0,"inlineStyleRanges":[{"offset":66,"length":7,"style":"BOLD"}],"entityRanges":[],"data":{}},{"key":"j16t","text":"XXXXXX You can leave the status toggle switched off while drafting content so that users will not see it until you are ready","type":"unstyled","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}],"entityMap":{}},
  }
];  

//Use data prop to test with predefined test data, or the getHelpUrl to fetch it from server
/*ReactDOM.render( (<HelpPage data={testData} />), document.getElementById('content') );*/
ReactDOM.render( (<HelpPage helpType="admin" getHelpUrl="http://localhost:48800/help/get" />), document.getElementById('content') );
