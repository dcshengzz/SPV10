import React from 'react'
import {Input,Checkbox} from 'semantic-ui-react'
import moment from 'moment';

class CheckBoxFormatter extends React.Component {
  render(value){
      const formatterValue = Boolean(value);
      return (<Checkbox checked={Boolean(formatterValue)} disabled/>);
  }
}

class NumberFormatter extends React.Component {
  render(value) {
      const formatterValue = value;
      return (<span style={{textAlign: 'left'}}><div title={formatterValue}>{formatterValue}</div></span>);
  }
}

class DateFormatter extends React.Component {
  render(value) {
      const formatterValue = moment(value);
      let strValue = "";
      if(formatterValue.isValid()){
          let format = (window.CloverLang !== undefined && window.CloverLang.common !== undefined && window.CloverLang.common.dateFormat != undefined) 
              ? window.CloverLang.common.dateFormat 
              : "L";
          strValue = formatterValue.format(format);
      }
      return (<span style={{textAlign: 'left'}}><div title={strValue}>{strValue}</div></span>);
  }
}

class DateTimeFormatter extends React.Component {
  render(value) {
      const formatterValue = moment(value);
      let strValue = "";
      if(formatterValue.isValid()){
          let format = (window.CloverLang !== undefined && CloverLang.common !== undefined && window.CloverLang.common.dateFormat != undefined) 
              ? window.CloverLang.common.dateFormat + " " + 
              (window.CloverLang.common.timeFormat !== undefined ? window.CloverLang.common.timeFormat: "HH:mm")
              : "DD MMM YYYY HH:mm";
          strValue = formatterValue.format(format);
      }
      return (<span style={{textAlign: 'left'}}><div title={strValue}>{strValue}</div></span>);
  }
}

class TimeFormatter extends React.Component {
  render(value) {
      const formatterValue = moment(value);
      let strValue = "";
      if(formatterValue.isValid()){
          let format = (window.CloverLang !== undefined && window.CloverLang.common !== undefined && window.CloverLang.common.timeFormat != undefined) 
              ? window.CloverLang.common.timeFormat 
              : "HH:mm";
          strValue = formatterValue.format(format);
      }
      return (<span style={{textAlign: 'right'}}><div title={strValue}>{strValue}</div></span>);
  }
}

const jsonEqual =
  function(a, b) {
      return JSON.stringify(a) === JSON.stringify(b);
  };

export default class CardGrid extends React.Component {
  constructor(props) {
      super(props);

      this.state = {
          items: [],
          filteredItems: this.props.value,
          sort: "",
          defaultSort: props.defaultSort,
          filter: props.filter,
          itemsPerPage: 2,
          currentPage:1,
          selectedIndexes: [],
          rowsCount: 0,
          searchTerm: ''
      };
  }

  static getDerivedStateFromProps(nextProps, prevState) {
    let newState = null;
    if (!jsonEqual(prevState.filter, nextProps.filter)) {
      newState = {filter: nextProps.filter};
          const newItems = Array.isArray(nextProps.value) ? CardGrid.staticGetSortedAndFilteredItems(nextProps.value, nextProps.filter,
              prevState.sort,nextProps.defaultSort) : [];
          newState.items = newItems;
          newState.selectedIndexes = [];
          newState.rowsCount = newItems.length;
    }
    else {
        if (prevState.originalItems !== nextProps.value) {
            newState = {};
            const newItems = Array.isArray(nextProps.value) ? CardGrid.staticGetSortedAndFilteredItems(nextProps.value, prevState.filter,
                prevState.sort, nextProps.defaultSort) : [];

            newState.items = newItems;
            newState.rowsCount = newItems.length;
            newState.selectedIndexes = [];
            newState.originalItems = nextProps.value;
        }
    }
    return newState;
  }

  getColumnValue(item, column) {
    if (column.type === "") {
      return item[column.key];
    } else if (column.type !== "" && column.type !== "custom") {
      return column.formatter.prototype.render(item[column.key]);
    } else if (column.type === "custom" && typeof column.customFormatter === "function") {
      return column.customFormatter({ row: item, column: column });
    }
    return "";
  }

  getStatus(item) {
    const currentDate = new Date();
  
    if (item.DueDate < currentDate) {
      return ["Expired", "grey"];
    } else if (item.RespDateEnd !== null && item.RespDateEnd !== undefined && item.RespDateEnd !== "") {
      return ["Submitted", "green"];
    } else if (item.MaxResponse !== -1 && item.MaxResponse !== null && item.MaxResponse !== undefined && item.MaxResponse != "" 
               && item.MaxResponse <= item.TotalComplete ){
      return ["Quota Reached","red"];
    }else if (item.RespDateStart !== null && item.RespDateStart !== undefined && item.RespDateStart !== "") {
      return ["In-Progress", "orange"];
    } else {
      return ["Pending", "yellow"];
    }
  }

  handleClick = (event, pageNumber) => {
    event.preventDefault();
    this.setState({ currentPage: pageNumber });
  }

  render() {
    if (!this.props.value) {
        return null;
    }

    const { currentPage, itemsPerPage } = this.state;

    let gridProps = {};
    gridProps.columns = this.getColumns();
    gridProps.items = this.props.value;

    const headerColumns = [];
    const bodyLeftColumns = [];
    const bodyRightColumns = [];
    const bodyBottomLeftColumns = [];
    const bodyBottomRightColumns = [];
    const footerColumns = [];

    gridProps.columns.forEach((column) => {
      switch (column.group) {
        case 'header':
          headerColumns.push(column);
          break;
        case 'body-left':
          bodyLeftColumns.push(column);
          break;
        case 'body-right':
          bodyRightColumns.push(column);
          break;
        case 'body-bottom-left':
          bodyBottomLeftColumns.push(column);
          break;
        case 'body-bottom-right':
          bodyBottomRightColumns.push(column);
          break;
        case 'footer':
          footerColumns.push(column);
          break;
        default:
          break;
      }     
    });

    const handleSearch = (event) => {
        const searchTerm = event.target.value;
        let filteredItems;
      
        if (searchTerm.trim() === '') {
          // If the search term is empty, reset the items to the original items
          filteredItems = gridProps.items;
        } else {
          filteredItems = gridProps.items.filter((item) => {
            // Check if any of the header columns' values contain the search term
            return headerColumns.some((column) => {
              const columnValue = this.getColumnValue(item, column).toLowerCase();
              return columnValue.includes(searchTerm.toLowerCase());
            });
          });
        }
    
        this.setState({
          searchTerm,
          filteredItems : filteredItems,
          currentPage: 1,
        });
    };

    let currentItem = this.state.filteredItems;
    if(this.state.filteredItems === undefined) {
        currentItem = gridProps.items;
    } else if(gridProps.items.length < 1) {
        //do nothing
    }
    // Calculate the index range of items to display on the current page
    const indexOfLastItem = currentPage * itemsPerPage;
    const indexOfFirstItem = indexOfLastItem - itemsPerPage;
    const currentItems = currentItem.slice(indexOfFirstItem, indexOfLastItem);

    // Calculate the total number of pages
    const totalPages = Math.ceil(currentItem.length / itemsPerPage);

    return (
        <div className="cardgrid-main">
          <section>
            <div className="search-container">
                <span className="search-icon">
                    <i className="search icon"></i>
                </span>
                <input
                type="text"
                placeholder="Search Survey Title"
                value={this.state.searchTerm}
                onChange={handleSearch}
                className="search-input"
                />
            </div>
            <div className="cardgrid-cards">
              {currentItems.length === 0 ? (<div className="empty-text">Empty</div>) 
              :  currentItems.map((item, i) => (
                // Render card component for each item
                <div key={i} className="cardgrid-card">
                  <div className="cardgrid-header">
                    {headerColumns.map((column, c) => {
                        const columnValue = this.getColumnValue(item, column);
                        const [status, color] = this.getStatus(item);
                        return <CardHeader key={c} columnValue={columnValue} status={status} color={color} />
                    })}
                  </div>
                  <div className="cardgrid-line"></div>
                  <div className="cardgrid-body">
                    {/* body-left */}
                    <div className="body-left">
                      {bodyLeftColumns.map((column, c) => {
                        const columnValue = this.getColumnValue(item, column);
                        return <CardBody key={c} columnValue={columnValue} column={column} />
                      })}
                    </div>
                    
                    {/* body-right */}
                    <div className="body-right">
                      {bodyRightColumns.map((column, c) => {
                        const columnValue = this.getColumnValue(item, column);
                        return <CardBody key={c} columnValue={columnValue} column={column} />
                      })}
                    </div>
                    
                    {/* body-bottom-left */}
                    <div className="body-bottom-left">
                      {bodyBottomLeftColumns.map((column, c) => {
                        const columnValue = this.getColumnValue(item, column);
                        return <CardBody key={c} columnValue={columnValue} column={column} />
                      })}
                    </div>

                    {/* body-bottom-right*/}
                    <div className="body-bottom-right">
                      {bodyBottomRightColumns.map((column, c) => {
                        const columnValue = this.getColumnValue(item, column);
                        return <CardBody key={c} columnValue={columnValue} column={column} />
                      })}
                    </div>
                  </div>
                  <div className="cardgrid-line"></div>
                  <div className="cardgrid-footer">
                    {footerColumns.map((column, c) => {
                      const columnValue = this.getColumnValue(item, column);
                      return <CardFooter key={c} columnValue={columnValue}
                      />
                    })}
                  </div>
                </div>
              ))}
            </div>
          </section>
          <div className="pagination">
            {currentPage > 1 && (
            <button
                className="pagination-btn"
                onClick={(e) => this.handleClick(e, currentPage - 1)}
            >
                &lt;
            </button>
            )}
            {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => (
            <button
                key={page}
                className={`pagination-btn ${
                page === currentPage ? "pagination-active" : ""
                }`}
                onClick={(e) => this.handleClick(e, page)}
            >
                {page}
            </button>
            ))}
            {currentPage < totalPages && (
            <button
                className="pagination-btn"
                onClick={(e) => this.handleClick(e, currentPage + 1)}
            >
                &gt;
            </button>
            )}
        </div>
        </div>
      );   
  }

  
  getColumns() {
    const me = this;
    let columns;
    if (this.props.columns === undefined) {
        columns = [];
    }
    else if (Array.isArray(this.props.columns)) {
        columns = this.props.columns;
    }
    else {
        columns = JSON.parse(this.props.columns);
    }

    columns.forEach(function (item) {
        if (item.width !== null && item.width !== "" && item.width !== undefined) {
            item.width = Number(item.width);
        }

        if (item.type === "number")
            item.formatter = NumberFormatter;
        else if (item.type === "checkbox") {
            item.formatter = CheckBoxFormatter;
        }
        else if (item.type === "date") {
            item.formatter = DateFormatter;
        }
        else if (item.type === "time") {
            item.formatter = TimeFormatter;
        }
        else if (item.type === "datetime") {
            item.formatter = DateTimeFormatter;
        }
        else if (item.type === "custom") {
            item.getRowMetaData = (row) => row;
            item.formatter = (args) => {
                if(item.customFormatter == undefined || typeof(item.customFormatter) != "function"){
                    return "";
                }
                return item.customFormatter({
                    row: args.dependentValues,
                    value: args.value,
                    column: item
                });
            };
        }
    });
    return columns;
  }

  static staticGetSortedAndFilteredItems(array,filter,sort,defaultSort)
  {
      let items = [];
      if (array === undefined)
          return items;
      if (filter !== undefined) {
          items = array.filter((r) => filter.IsRowMatched(r));
      }
      else {
          items = array;
      }

      let currentSort = sort;
      if (sort === 'NONE' || sort === "") {
          if (defaultSort === undefined) {
              return items;
          }
          currentSort = defaultSort;
      }

      const indexSpace = currentSort.indexOf(" ");
      const sortColumn = currentSort.substring(0, indexSpace);
      const sortDirection = currentSort.substring(indexSpace + 1, currentSort.length);

      //Sorting
      const comparer = (a, b) => {
          let aValue = (a[sortColumn] !== undefined  && a[sortColumn] !== null && a[sortColumn].toLowerCase !== undefined)
              ? a[sortColumn].toLowerCase()
              : a[sortColumn];
          let bValue = (b[sortColumn] !== undefined && b[sortColumn] !== null && b[sortColumn].toLowerCase !== undefined)
              ? b[sortColumn].toLowerCase()
              : b[sortColumn];

          if (aValue === bValue)
          {
              return 0;
          }
          if (aValue === null || aValue === undefined)
          {
              return 1;
          }
          if (bValue === null || bValue === undefined)
          {
              return -1;
          }
          if (sortDirection === 'ASC') {
              return (aValue > bValue) ? 1 : -1;
          } else if (sortDirection === 'DESC') {
              return (aValue < bValue) ? 1 : -1;
          }
      };
      return items.slice(0).sort(comparer);
  }

  componentWillUnmount() {
  }

  componentDidMount() {
  }
}

  class CardHeader extends React.Component {
    render() {
        const { columnValue, status, color } = this.props;
  
      return (
        <div className="card-header">
          <div className="ui large header" id="card-header-title">
            {columnValue}
          </div>
          <div className="card-header-status">
            <span className={`ui ${color} basic button`} style={{ width: "150px", height: "40px", marginTop: "10px" }}>
              {status}
            </span>
          </div>
        </div>

      );
    }
  }
  
  class CardBody extends React.Component {
    render() {
      const { columnValue, column } = this.props;
      return ( 
            <div className="column-content">
              <div className="ui medium header">
                  <div className="column-name">{column.name}</div>
                  <div className="sub header" style={{color: 'black'}}>{columnValue}</div>
              </div>
            </div>
      );
    }
  }
  
  class CardFooter extends React.Component {
    render() {
        const { columnValue } = this.props;
        
      return (
        <div className="sub header">
          {columnValue}
        </div>
      );
    }
  }