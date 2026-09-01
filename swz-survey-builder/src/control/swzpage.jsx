import React, { Component } from 'react'
import { Form, Radio, Button, Progress } from 'semantic-ui-react'
import BuilderActions from './../actions'
import SwzSideMenu from './swzsidemenu.jsx'

export default class SwzPage extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      onScrollToView: true,
    }
  }

  onHeaderControls = (theProps) => {  
    return (<div style={{width: '100%', float: 'left'}}>
              {theProps.swzPage.header.lastSaved &&
                <div style={{float: 'right'}}>
                  <Button onClick={this.buttonFunction.bind(this, "LastSaved")} className="ui secondary button">Skip To Last Saved</Button>
                </div>
              }{theProps.swzPage.header.print &&
                <div style={{float: 'right'}}>
                  <Button onClick={this.buttonFunction.bind(this, "Print")} className="ui secondary button">Print</Button>
                </div>
              }
           </div>
            )
 }

  buttonFunction = (type, e) =>{
    if(this.props.handleevent !== undefined){
      if(type){
        var eName = "onClick" + type;
        var onMenu = this.props.swzPage.main.onMenu ? this.props.swzPage.main.onMenu : false;
        if(eName == "onClickNext" || eName == "onClickSave")
          if(onMenu){
            this.props.handleevent({syntheticEvent: e, key: this.props.name, eventName: 'onPageValidationStatus'});
            this.props.handleevent({syntheticEvent: e, key: this.props.name, eventName: eName}); 
            return
          }

        this.props.handleevent({syntheticEvent: e, key: this.props.name, eventName: eName}); 
      }
    }
  }

  onFooterControls = (theProps, pageObj) => {
    
    var pages = pageObj && pageObj.pageItems && pageObj.pageItems[3] ? pageObj.pageItems[3] : [];
    var onPageStatus = theProps.swzPage.main.onStatusBar;
    var pagePercentage = pages ? Math.round(Number(pages.currentPage) / Number(pages.totalPage) * 100) : 0;

     return (
         <React.Fragment>
            <div className="swzpagebuttoncontainer">
              {
              (onPageStatus && pages && !isNaN(pagePercentage)) &&
                <React.Fragment>
                  {
                    //https://react.semantic-ui.com/modules/progress/#variations-inverted
                  }
                  <Progress percent={pagePercentage} color='grey' progress/>
                </React.Fragment>
              }
              <div className="swzpagebuttonsec">
              {theProps.swzPage.footer.exit &&
                <Button onClick={this.buttonFunction.bind(this, "Exit")} className="ui secondary button">Exit</Button>
              }{theProps.swzPage.footer.cancel &&
                <Button onClick={this.buttonFunction.bind(this, "Cancel")} className="ui secondary button">Cancel</Button>
              }{theProps.swzPage.footer.back &&
                <Button onClick={this.buttonFunction.bind(this, "Back")} className="ui secondary button">Back</Button>
              }
                </div>
            <div className="swzpagebuttonpri">
              {
                (this.props.swzPage.main['isInternetApplicationReadOnly'] || this.props.swzPage.main['isIntranetApplicationReadOnly'])?
                <React.Fragment>
              {theProps.swzPage.footer.next &&
                  <Button onClick={this.buttonFunction.bind(this, "NextNonUpdatedSurvey")} className="ui secondary button">Next</Button>
              }</React.Fragment>
                :
              <React.Fragment>
              {theProps.swzPage.footer.next &&
                <Button onClick={this.buttonFunction.bind(this, "Next")} className="ui secondary button">Next</Button>
              }{theProps.swzPage.footer.saveExit && 
                <Button onClick={this.buttonFunction.bind(this, "SaveExit")} className="ui secondary button">Save And Exit</Button>
              }{theProps.swzPage.footer.save &&
                <Button onClick={this.buttonFunction.bind(this, "Save")} className="ui primary button">Save</Button>
              }{theProps.swzPage.footer.submit &&
                <Button onClick={this.buttonFunction.bind(this, "Submit")} className="ui primary button">Submit</Button>
              }
              </React.Fragment>
            }
              </div>
          </div>
          </React.Fragment>
          )
  }

  componentDidUpdate = (prevProps) =>{
    var containItems = (prevProps.swzPage.main.items == undefined || prevProps.swzPage.main.items == null);
    var newChangeToProps = (prevProps.swzPage.main.items !== this.props.swzPage.main.items)

      if((containItems) || newChangeToProps){
        if(this.props.handleevent !== undefined ){
          this.props.handleevent({key: this.props.name, eventName: "onPageInit"});    
        }
      }

  } 
  

  onScroll = (id) => {
    document.getElementById(id).scrollIntoView({ block: 'start',  behavior: 'smooth' });
    BuilderActions.offScroll();
  }

  loadItems = (model) => {
    var items = [];
    var menuItems = [];
    var mapActive = {};
    var mapValid = {};
    var currentPage = 0;
    //var model = [{key: "Page1", onpagedisplay: true, validatedpages: ["Page1", "Page3"]}, {key: "Page2"}]
    if(model){
      for(let i = 0; i < model.length; i++){
        if(model[i].onpagedisplay == true){
          mapActive['activeItem'] = model[i].key;
          currentPage = i + 1;
        }
        if(model[i].validatedpages != undefined || model[i].validatedpages != null){
          mapValid['validatedPages'] = model[i].validatedpages;
        }
        var map = {
           target: model[i].key,
           title: model[i].key
        };
        menuItems.push(map);
      }
      items.push(mapActive);
      items.push(mapValid);
      items.push(menuItems);
      var pageStatus = {
        ['currentPage']: currentPage,
        ['totalPage'] : menuItems.length
      }
      items.push(pageStatus);
    return items
    }
  }

  onClickItem = (e, name) => {
    if(this.props.handleevent !== undefined){
      var res =
        this.props.handleevent({
        e,
        key: this.props.name,
        eventName: "onClickItem",
        parameters: {target: name}
      });
      if (res != false) {
          this.setState({activeitem: name});
      } 
    }
  }

  onSideMenuButton = () => {
    this.setState({isMenuActive: !this.state.isMenuActive});
  }

  render() {
    
    
    var onMenu = this.props.swzPage.main.onMenu;
    var items = this.props.swzPage.main.items ? this.loadItems(this.props.swzPage.main.items) : null;
    var activeItem;
    var validatedPages;
    var props = this.props;
    var pageObj = {};
    pageObj['pageItems'] = items;
    

    if(this.state.activeitem)
      activeItem = this.state.activeitem;
    
    if(items){
      if(items.length > 0){
        if(!items[0]){
          activeItem = undefined;
          validatedPages = undefined;
        }
        else{
          if(items[0].activeItem){
            activeItem = items[0].activeItem;
            validatedPages = items[1].validatedPages;
          }
          else{
            if(items[0].activeItem != undefined && items[0].activeItem != null){
              activeItem = items[0].activeItem;
              validatedPages = items[1].validatedPages;
            }
          }
          items = items[2];
        }
      }
    }
    
    var menuProps = {
      vertical: true,
      link: true,
      onClickItem: this.onClickItem.bind(this),
      ['data-items']: items,
      activeitem: activeItem,
      validatedpages: validatedPages,
    }

    var onPageBuilder = !this.props.swzPage.main.onPageDisplay ? 'clover-formbuilder-item-swzpagemain-offbuilder' : '';
   

       return (
         <div className={onPageBuilder}> 
            <div id={this.props.name} className='clover-formbuilder-item-swzpagemain'>
                <div className='swzpagemainheader'>
                  <div className='swzpagemainlabel'>
                  {this.props.swzPage.header.onImage &&
                    <img style={{width: this.props.swzPage.header.imageWidth + 'px'}} src={this.props.swzPage.header.imageSrc}></img>
                  }
                    <h2>{this.props.swzPage.header.headerLabel}</h2>
                      </div>
                
                      </div>
                {/*Children Div*/}
                <div className="swzpagecontent">
                {onMenu &&
                  <React.Fragment>
                    <Button className="clover-sidebar-btn" onClick={this.onSideMenuButton} />
                        <div className={this.state.isMenuActive ? "swzsidemenu active" : "swzsidemenu"}>
                          <SwzSideMenu {...menuProps}></SwzSideMenu>
                          </div>
                  </React.Fragment>
                  }
                  <div className={onMenu ? "swzpagecentercontent-menu" : "swzpagecentercontent"}>
                     {this.onHeaderControls(this.props)}
                     <div className='swzpagemaincontent'>
                      <div {...this.props} />
                     </div>
                     {this.onFooterControls(props, pageObj)}
                  </div>
                </div> 
                <div className='swzpagemainfooter'>
                  <div className='swzpagemainlabel'>
                    <h4>{this.props.swzPage.footer.footerLabel}</h4>
                  </div>
                </div>
            </div>
          </div>
        );
      }
    }
                
