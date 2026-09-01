import React, { Component } from 'react'
import GridView from './gridview';

export default class ChoiceCount extends React.Component {
  constructor(props){
    super(props);

    this.state = {
    }
  }



  gridColumns(){
    return [

        {
            key: 'AnsVal',
            name: 'Answer',
            resizable: true
        	},
    	{
            key: 'Text',
            name: 'Text',
            resizable: true
        	},
    	{
            key: 'AnsCount',
            name: 'Count',
            resizable: true
        	},
        {
            key: 'Percentage',
            name: 'Percentage',
            resizable: true
          },      
    ];
  }



  render() {
  
    var columns = this.gridColumns();
    var defaultSort = "Idx ASC";

    var res = (<div className='choicecount-qnn-block'>
        <div className='choicecount-qnn-block-title'>Question: {this.props.qnnFieldText}</div>
        <div className='choicecount-qnn-block-count'>Responses: {this.props.respCount}</div>
        <div className='choicecount-qnn-block-grid'><GridView key={this.props.qnnFieldId}
            rowKey="AnsVal" rowHeight={35} columns={columns}
            defaultSort={defaultSort}
            minHeight={150} 
            value={this.props.gridData.sort((a, b) => a.Idx - b.Idx)}
        /></div>

        </div>);
        return res;

  }

}