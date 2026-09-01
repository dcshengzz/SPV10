import React from 'react';
import { render } from 'react-dom';
import Wordcloud from 'wordcloud';

export default class WordCloudReport extends React.Component {
    constructor(props) {     
        super(props);
    }

    componentWillReceiveProps = (nextProps) => {
      if (!nextProps.qnnField || !nextProps.dplyId) {
        this.element = document.getElementById('wordcloud_canvas');
        Wordcloud(this.element, {list: []});
      } else {
        let dplyId = nextProps.dplyId;
        let qnnField = nextProps.qnnField;
        var data = new Array();
        
        $('body').loadingModal({
            text: 'Loading...',
            animation: 'foldingCube',
            backgroundColor: '#1262E2'
        });
        data.push({ name: 'dplyId', value: dplyId });
        data.push({ name: 'qnnField', value: qnnField });
        $.ajax({
            url: "/report/wordcloudreport",
            async: true,
            type: "post",
            data: data,
            success: (response) => {
                $('body').loadingModal('destroy');
                if (response.success) {
                  
                    var wordcloudlist = [];
                    for (var i in response.item){
                      //Kludge to set minimum font size.
                      if(response.item[i]["AnsCount"] < 3)
                        response.item[i]["AnsCount"] = 3;
                      wordcloudlist.push([response.item[i]["AnsVal"],response.item[i]["AnsCount"]])
                    }
  
                    this.element = document.getElementById('wordcloud_canvas');
                    Wordcloud(this.element, 
                      {
                        list: wordcloudlist,  
                        minFontSize: 200,
                        fontFamily: 'Times, serif', 
                        rotateRatio: 0,
                        backgroundColor: '#fff',  
                        drawOutOfBound: true,
                        gridSize: Math.round(16 * jQuery('#wordcloud_canvas').width() / 1024),
                        weightFactor: 3,
                        shuffle: false
                      });
                }
                else {
                    alertify.error(response.message);
                }
            },
            error: function (jqXHR, exception) {
                var msg = "Error on the server! Please contact system administrator.";
                alertify.error(msg);
            }
        });
      }

  }

    
    render() {
        return (
          <div>
          <canvas id="wordcloud_canvas" width="1076" height="504" />
          </div>
          );

    }


}


