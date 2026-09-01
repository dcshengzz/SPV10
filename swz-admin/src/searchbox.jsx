import React from "react";
import ReactDOM from "react-dom";
import JSON5 from 'json5'
import { Search } from 'semantic-ui-react'

export default class SearchBox extends React.Component {
  constructor(props) {
    super(props);
    
    this.state = {value : ''};
  }

  resetSearch(){
    this.setState({ isLoading: true, results: []});
  }
  
  handleResultSelect(e, {result}){
    this.props.parent.openpage(result.panelindex, result.id);
  }

  handleSearchChange(e, {value}){
    var me = this;
    this.setState({ isLoading: true, value });
    setTimeout(function(){
      if (me.state.value.length < 1) 
        return me.resetSearch();
        me.setState({
          isLoading: false,
          results: me.search(me.state.value)
        });
    }, 500);
  }

  search(searchStr){
    var res = {};

    this.addResult(res, searchStr, CloverAdminLang.searchbox.model, this.props.data.dataModel, "datamodel", "id", ["name", "dbObjectName"]);
    this.addResult(res, searchStr, CloverAdminLang.searchbox.form, this.props.data.forms, "forms", "name", ["name"]);
    this.addResult(res, searchStr, CloverAdminLang.searchbox.formdata, this.props.data.forms, "formdata", "name", ["name"]);
    this.addResult(res, searchStr, CloverAdminLang.searchbox.actionhandler, this.props.data.forms, "actionhandlers", "name", ["name"]);
    this.addResult(res, searchStr, CloverAdminLang.searchbox.workflow, this.props.data.workflow, "workflow", "code", ["code"]);
    this.addResult(res, searchStr, CloverAdminLang.searchbox.user, this.props.data.users, "users", "id", ["name", "domainLogin", "login"]);
    this.addResult(res, searchStr, CloverAdminLang.searchbox.group, this.props.data.groups, "groups", "id", ["name"]);
    this.addResult(res, searchStr, CloverAdminLang.searchbox.role, this.props.data.roles, "roles", "id", ["code", "name"]);
    this.addResult(res, searchStr, CloverAdminLang.searchbox.codeaction, this.props.data.codeActions, "codeactions", "id", ["name"]);
    
    return res;
  }

  addResult(obj, searchStr, blockName, arr, panelindex, idfield, columns){
    var results = this.searchInArray(searchStr, arr, panelindex, idfield, columns);
    if(Array.isArray(results) && results.length > 0){
      obj[blockName] = {
        name: blockName,
        results: results
      };
    }
  }

  searchInArray(str, arr, panelindex, idfield, columns){
    var res = [];
    for(var i in arr){
      var item = arr[i];
      for(var j = 0; j < columns.length; j++){
        var col = columns[j];
        if(item[col] != undefined && item[col].search(new RegExp(str, "i")) >= 0){
          res.push({title: item[col], panelindex, id: item[idfield]});
          break;
        };
      }

      if(res.length > 4){
        res.push({title: '...', panelindex});
        break;
      }
    }
    return res;
  }

  render() {
    return (<Search
      category
      fluid={true}
      loading={this.state.isLoading}
      onResultSelect={this.handleResultSelect.bind(this)}
      onSearchChange={this.handleSearchChange.bind(this)}
      results={this.state.results}
      value={this.state.value}
      />);
  }
}