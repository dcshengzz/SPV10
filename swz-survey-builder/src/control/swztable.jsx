import React, { Component } from 'react'
import { Form, Radio } from 'semantic-ui-react'

export default class Swztable extends React.Component {
  constructor(props){
    super(props);
    this.state = {
    }
  }

  /* getDropZones = (children, rows, columns) => {
    
    var dropZones = [];
    var rowObj = {};
    var skipRow = {};
    {
    Bring in an array of unique rows
    Rows.length for loop
    Rows[j] == rowIndex
    }
    for(let j = 0; j < rows.length; j++){
      var rowDropZones = [];
        if(skipRow !== undefined){
          for(let i = 0; i < children.length; i++){
            if(children[i].key.includes('tableElement') && children[i].type == "div"){
                 //Get rowIndex
                var tableIndex = children[i].props.tableIndex;
                var rowIndex = tableIndex.substr(0, tableIndex.indexOf('_')); 
                if(rows[j] == rowIndex){
                  rowDropZones.push(children[i]);
                }else{
                  skipRow[j] == true;
                }             
               // dropZones.push(children[i]);
            }
          }
        }
      rowObj[j] = rowDropZones;
      dropZones.push(rowObj[j])
    }
    return dropZones;
  } */

  getTableDropZones = (children, tableIndexes, columns) => {
    
    var tableDropZones = [];
    var rowObj = {};
    var skipRow = {};
    if(tableIndexes == undefined)
      return []
    
    for(let j = 0; j < tableIndexes.length; j++){
      var rowControls = [];
      if(skipRow !== undefined){
        for(let i = 0; i < children.length; i++){
          if(children[i].key.includes('tableElement') && children[i].type == "div"){
            var tableIndex = children[i].props.tableIndex;
            if(tableIndexes[j] == tableIndex){
              rowControls.push(children[i]);
            }else{
              skipRow[j] = true;
            }
          }
        }
      }
      if(rowControls.length > 0)
        rowObj[tableIndexes[j]] = rowControls;
    }
    tableDropZones.push(rowObj);
    return tableDropZones[0];
  }

  getTableControls = (children, tableIndexes, columns) => {
    
    var tableControls = [];
    var rowObj = {};
    var skipRow = {};
    if(tableIndexes == undefined)
      return []
    
    for(let j = 0; j < tableIndexes.length; j++){
      var rowControls = [];
      if(skipRow !== undefined){
        for(let i = 0; i < children.length; i++){
          if(children[i].type !== "div"){ //Do not add additional dropzone
            var tableIndex = children[i].type.name == "ControlBar" /* || children[i].type.name == "TableControlBar" */?
                              children[i].props.model.tableIndex :
                              children[i].props.additionalParams.model.tableIndex;
            if(tableIndexes[j] == tableIndex){
              rowControls.push(children[i]);
            }else{
              skipRow[j] = true;
            }
          }
        }
      }
      if(rowControls.length > 0)
        rowObj[tableIndexes[j]] = rowControls;
    }
    tableControls.push(rowObj);
    return tableControls[0];
  }

  generateTableControls = (tableControlsObj, tableIndex) => {

    var rowData = [];
    var tableControl;
    var tableControls = tableControlsObj[tableIndex];
    var obj = {};
    var prevTableIndex = undefined;

    if(tableControls == undefined){
      obj = {
        tableControls: rowData,
        prevTableIndex: tableIndex
      }
      return obj;
    }
    for(let i = 0; i < tableControls.length; i++){
      var modelTableIndex = tableControls[i].type.name == "ControlBar" ? 
                            tableControls[i].props.model.tableIndex :
                            tableControls[i].props.additionalParams.model.tableIndex
      if(modelTableIndex == tableIndex){
        tableControl = tableControls[i]
        rowData.push(tableControl);
      }
      //Hack to check if there are more then 1 control to get prevTableIndex
      if(tableControls.length > 1){
        prevTableIndex = tableIndex
      }
    }
    obj = {
      tableControls: rowData,
      prevTableIndex
    }
    return obj
  }

  generateTableDropZones = (dropZonesObj, tableIndex, tableControls, prevTableIndex) => {
    
    var onTempProps = function (obj, val) {
      let clone = Object.assign({}, obj);
      clone['elementafter'] = val;
      return clone
    }
    
    var lastElement = {};
    if(tableControls !== undefined && tableControls.length > 0 && tableControls[2] !== undefined){
      lastElement = {
        type: 'tablecontrol',
        value: tableControls[2].key
      }
    }else{
      lastElement = {
        type: 'tableindex',
        value: prevTableIndex
      }
    }
    var rowData = [];
    var tableDropZones = dropZonesObj[tableIndex];

    if(tableDropZones == undefined)
      return [];
      
    for(let i = 0; i < tableDropZones.length; i++){
      var modelTableIndex = tableDropZones[i].props.tableIndex;
      if(modelTableIndex == tableIndex){   
        
     /*    var tempProps = JSON.parse(JSON.stringify(tableDropZones[i]));
        
        tempProps.props['elementafter'] = JSON.stringify(lastElement);
        tempProps['$$typeof'] = Symbol.for('react.element'); 
        Object.preventExtensions(tempProps);*/
        var tempProps = onTempProps(tableDropZones[i], lastElement)
        
        rowData.push(tempProps)
      }  
    }
    return rowData
  }

  getFullTableIndex = (tableIndexes) => {
    var indexObj = {};
    var fullTableIndex = [];
    var rowObj = {};
    var locateRowArrayIndex = {}

    /*
      Objective: Compute full table index into respective rows
        1. For every row index,
          1.0.1. Check if it is a new or existing row index from RowArrayIndex

          1.1.0. If new row index, create a RowArray and insert values in relative to new rowIndex
          1.1.1. Push to FullTable
          1.1.2. Keep track of RowArrayIndex
          
          1.2.0. For existing row index, we locate it's RowArrayIndex
          1.2.1  Push to its RowArray accordingly
    */

    for(let j = 0; j < tableIndexes.length; j++){
      let rowIndex = tableIndexes[j].substr(0, tableIndexes[j].indexOf('_'));
    
      if(locateRowArrayIndex[rowIndex] == undefined){
        var rowIndexes = [];
        var rowElementObj = {
          'tableIndex': tableIndexes[j]
        }
        rowIndexes.push(rowElementObj);
        
        var rowArrayIndex = fullTableIndex.length;
        locateRowArrayIndex[rowIndex] = rowArrayIndex;
        fullTableIndex.push(rowIndexes);
      }else{
        var rowArrayIndex = locateRowArrayIndex[rowIndex];
        //var key = Object.keys(fullTableIndex[rowArrayIndex]);
        var addRowElementObj = {
          'tableIndex': tableIndexes[j]
        }
        fullTableIndex[rowArrayIndex].push(addRowElementObj);
      }
    }
    return fullTableIndex
  }

  generateTable = (dropZones, tableControls, tdStyles, trStyles, spanDict, tableindex) => {
 
    var fullTableIndex = this.getFullTableIndex(tableindex);
    var prevTableIndex;
    return fullTableIndex.map((rowZones) => 
    {
      return (<tr style={trStyles}>
                {
                    
                 rowZones.map((dropZone, i) =>
                   {
                    var tableIndex = dropZone['tableIndex'];
                    
                    var obj = this.generateTableControls(tableControls, tableIndex);
                    prevTableIndex = obj['prevTableIndex'] !== undefined ? obj['prevTableIndex'] : prevTableIndex;
                    
                    var dropZoneObj = {
                      children: [this.generateTableDropZones(dropZones, tableIndex, obj['tableControls'], prevTableIndex), obj['tableControls']]
                    }
                    
                    var test = tableIndex.length < 10 ? '' : tableIndex[tableIndex.length - 2].toString() + tableIndex[tableIndex.length - 1].toString();
                    var tableIndexText = tableIndex.substring(0,5);//tableIndex[0].toString() + tableIndex[1].toString() + tableIndex[2].toString() + test;
                    var rowSpan;
                    var colSpan;
                    var displayStyle = {};

                    if(spanDict !== undefined){
                      if(spanDict[tableIndex] !== undefined){
                        rowSpan = spanDict[tableIndex].rowSpan;
                        colSpan = spanDict[tableIndex].colSpan;
                      }else{
                        rowSpan = 1;
                        colSpan = 1;
                      }
                    }

                    //If col or span is 0, hide table data
                    displayStyle = {
                      display: rowSpan == 0 || colSpan == 0 ? 'none' : ''
                    }
                    
                    return (
                    <td style={{...tdStyles, ...displayStyle}} rowSpan={rowSpan} colSpan={colSpan}><div {...dropZoneObj}/>{ /* tableIndexText */ }</td>)
                   })
                }
      </tr>)  
    });
  }

  getUniqueRowsColumns = (tableIndex) => {
    var uniqueRows = [];
    var uniqueColumns = [];
    var rowObj = {};
    var columnObj = {};
    var uniqueObj = {};

    if(tableIndex !== undefined && tableIndex.length > 0){
      for(let k = 0; k < tableIndex.length; k++){
        let rowIndex = tableIndex[k].substr(0, tableIndex[k].indexOf('_'));
        let columnIndex = tableIndex[k].substr(tableIndex[k].indexOf('_') + 1, tableIndex[k].length);
        if(rowObj[rowIndex] == undefined){
          uniqueRows.push(rowIndex);
          rowObj[rowIndex] = "Not unique row anymore"
        }
        if(columnObj[columnIndex] == undefined){
          uniqueColumns.push(columnIndex);
          columnObj[columnIndex] = "Not unique column anymore"
        }
      }
      uniqueObj['uniqueRows'] = uniqueRows;
      uniqueObj['uniqueColumns'] = uniqueColumns;
    }
    return uniqueObj
  }
  
  renderTable = (propStuff) => {
    
    var additionalStyle = propStuff.style;
    var borderWidth = propStuff.borderwidth == undefined ? '2' : propStuff.borderwidth;
    var borderColor = propStuff.bordercolor == undefined ? 'grey' : propStuff.bordercolor;
    var tableBorder = propStuff.bordertype == "none" ? '0' : borderWidth + "px " + propStuff.bordertype + " " + borderColor;
    var tableBorderLine = propStuff.borderline == undefined ? 'border' : propStuff.borderline;
    let tableheight;
    let tablewidth;
    
    if(propStuff.tableheight.includes("%")){
     tableheight = propStuff.tableheight;
    }else{
      tableheight = propStuff.tableheight + "px";
    }

    if(propStuff.tablewidth.includes("%")){
      tablewidth = propStuff.tablewidth;
    }else{
       tablewidth = propStuff.tablewidth + "px";
    }


    var tableStyles = {
      height: (propStuff['style'] !== undefined && propStuff['style'].height !== undefined && propStuff['style'].height !== '')
      ? propStuff['style'].height : tableheight,
      width: (propStuff['style'] !== undefined && propStuff['style'].width !== undefined && propStuff['style'].width !== '')
      ? propStuff['style'].width : tablewidth
    }
    var trStyles = {

    }

    var tdStyles = {
      padding: propStuff.cellpadding + "px",
 /*      [tableBorderLine]: tableBorder, */
      textAlign: propStuff.tablealign      
    }
    
    if(propStuff.bordertype !== "none")
      tdStyles[tableBorderLine] = tableBorder;
  
    var uniqueObj = propStuff.uniqueObj == undefined ? this.getUniqueRowsColumns(propStuff.tableindex) : propStuff.uniqueObj;
    //var dropZones = this.getDropZones(propStuff.children, uniqueObj['uniqueRows'], uniqueObj['uniqueColumns']);

    var dropZonesObj = this.getTableDropZones(propStuff.children, propStuff.tableindex);
    var tableControlsObj = this.getTableControls(propStuff.children, propStuff.tableindex);
    var spanDict = propStuff.spandict;
    var templateClass = propStuff.className !== undefined && propStuff.className !== null ? ' ' + propStuff.className : '';

    return (
        <div className="swzTableDiv">  
            <table className={"swzTable" + templateClass} style={{...additionalStyle,...tableStyles}}>
              {this.generateTable(dropZonesObj, tableControlsObj, tdStyles, trStyles, spanDict, propStuff.tableindex)}
            </table>
        </div>
    )
  }

  render() {

    //console.log("The props for SWZTABLE are", this.props);
    return (
        <React.Fragment>
          {this.props.tableindex != undefined && this.props.tableindex.length > 0 ?
            this.renderTable(this.props) 
            /*<div {...this.props}></div>*/:
            <h3>Insert table</h3>
          }
        </React.Fragment>);    
  }
}