import React from 'react'
import { EditorState, convertToRaw , convertFromRaw} from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import draftToHtml from 'draftjs-to-html';


export default class Swzhtml extends React.Component {
  constructor(props){
    super(props);

    //console.log("EditorState Started, editorState: " , props.value);
    this.state = {
    editorState: null,//this.initEditor(props.value),
    jsonData: undefined,
    contentState: undefined,
    htmlData: "",
    isOnce: true,
    onShowOutput: false

    }
  }

  componentWillMount = () => {
    var hideOutput = this.props.swzData.hideOutput.display;
    

    if  (hideOutput == "none"){
      var onShowOutput = false;
      //Hide the output
    }
    else if (hideOutput == "block"){
      var onShowOutput = true
    }
    this.setState({onShowOutput});
  }

  componentWillReceiveProps = (nextProps) => {

    const {isOnce} = this.state;

    //Show intialeditor state only
    var editorState = nextProps.value;
    if(editorState !== null && editorState !== "" && editorState !== undefined){
      if (isOnce == false) return;
      this.setState({isOnce: false});
      var editorState = this.initEditor(editorState);
      this.setState({editorState})
    }

  }

  initEditor = (editorString) => {
    if (editorString == undefined || editorString == null ) return; 
      var contentBlock = convertFromRaw(JSON.parse(editorString));  
      var editorState = EditorState.createWithContent(contentBlock);
    return editorState;
  } 

  onEditorStateChange = (editorState) => {
    var contentState = editorState.getCurrentContent();
    var previousContentState = this.state.editorState ? this.state.editorState.getCurrentContent() : null;
    
    if (previousContentState !== contentState) {
      var blockMap = contentState.getBlockMap();
      var hasLink = blockMap.some(block => block.getCharacterList().some(char => char.getEntity() && contentState.getEntity(char.getEntity()).getType() === 'LINK'));
  
      if (hasLink) {
        var selectionState = editorState.getSelection();
        var newEditorState = EditorState.forceSelection(
          editorState,
          selectionState
        );
  
        this.setState({ editorState: newEditorState });
        return;
      }
    }
  
    this.setState({ editorState });
  };

  onContentStateChange = (contentState) => {
    this.setState({jsonData:contentState});
    var jsonConvert = convertFromRaw(contentState);
    const {onShowOutput} = this.state;
    if(onShowOutput){
        var htmlData = draftToHtml(convertToRaw(jsonConvert));
    	this.setState({htmlData});
    }

  };

  onChange(e){
    
    //console.log('OnChange SwzHtml', e)
    if(this.props.handleEvent !== undefined){
      this.props.handleEvent({syntheticEvent: e, key: this.props.name, eventName: "onChange"}); 
    }
}
  


  render() {

  const { editorState } = this.state;  
  var me = this;

  return (
  <div> 
      <Editor
        editorState={editorState}
        wrapperClassName="demo-wrapper"
        editorClassName="demo-editor"
        onEditorStateChange={this.onEditorStateChange}
        onContentStateChange={this.onContentStateChange}
        onChange={me.onChange.bind(this)}
        toolbar={{
          fontFamily: {
            options: ['Arial', 'Georgia', 'Impact', 'Open Sans', 'Tahoma', 'Times New Roman', 'Verdana'],
          },
        }}
      />
      
      
  </div>
    )
  }
  
}