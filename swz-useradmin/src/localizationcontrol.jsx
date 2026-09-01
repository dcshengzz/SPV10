import React from "react";
import ReactDOM from "react-dom";
import JSON5 from 'json5'
import { Dropdown } from 'semantic-ui-react'
//import { isRegExp } from "util"; //unused-code (Function to check if a value is a regular expression)

const LOCALE_COOKIE_KEY = "cloveradmin_locale";

export default class LocalizationControl extends React.Component {
  constructor(props) {
    super(props);
    
    this.state = {};
    this.init(props.folder, props.locale);
  }

  render() {
    
    if(Array.isArray(this.state.options)){
        return <div className="localization">
            <Dropdown selection options={this.state.options} value={this.state.locale} onChange={this.onChange.bind(this)} />
        </div>;
    }
    else{
        return <div/>;
    }
  }

  init(folder, defaultLocale){
    if(folder == undefined)
        return;

    var me = this;
    fetch(folder + "localization_manifest.json")
      .then(response => response.json())
      .then(data => {
        let options = [];
        let i = 0;
        data.langs.forEach(function(item){
            options.push({key: i, 
                value: item.locale, 
                flag: (item.flag ? item.flag : item.locale), 
                text: item.name});
            i++;
        });
        
        let locale = defaultLocale;
        if(locale == undefined || locale == "")
            locale = me.getCookie(LOCALE_COOKIE_KEY);
        if(locale == undefined || locale == "")
            locale = "en";
        
        me.state.options = options;
        me.state.langs = data.langs;
        me.registerLocale(locale);
        me.forceUpdate();
    });
  }

  registerLocale(locale){
    var me = this;
    if(!(me.state.locale == undefined && locale == "en")){
        var langs = me.state.langs;
        var lang = undefined;
        for(var l in langs){
            if(langs[l].locale == locale){
                lang = langs[l];
                break;
            }
        }

        if(lang != undefined){
            if(Array.isArray(lang.scripts)){
                lang.scripts.forEach(function(s){
                    me.loadScript(me.props.folder + s);
                });
            }
            me.setCookie(LOCALE_COOKIE_KEY, locale);
        }
    }

    me.setState({ locale });

    if(me.props.parent != undefined)
        setTimeout(function(){
            me.props.parent.forceUpdate();
        }, 200);
  }

  onChange(e, data){
      if(data.value == this.state.locale)
        return;
        
      this.registerLocale(data.value)
  }

  getCookie(name) {
    var matches = document.cookie.match(new RegExp(
      "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
    ));
    return matches ? decodeURIComponent(matches[1]) : undefined;
  }

  setCookie(name, value, options) {
    options = options || {};

    var expires = options.expires;

    if (typeof expires == "number" && expires) {
      var d = new Date();
      d.setTime(d.getTime() + expires * 1000);
      expires = options.expires = d;
    }
    if (expires && expires.toUTCString) {
      options.expires = expires.toUTCString();
    }

    value = encodeURIComponent(value);

    var updatedCookie = name + "=" + value;

    for (var propName in options) {
      updatedCookie += "; " + propName;
      var propValue = options[propName];
      if (propValue !== true) {
        updatedCookie += "=" + propValue;
      }
    }

    document.cookie = updatedCookie;
  }

  loadScript(src) {
    var tag = document.createElement('script');
    tag.async = false;
    tag.src = src;
    document.getElementsByTagName('body')[0].appendChild(tag);
  }
}