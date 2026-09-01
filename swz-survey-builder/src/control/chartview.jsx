import React, { Component } from 'react'
import JSON5 from 'json5'

export default class ChartView extends React.Component {
    constructor(props){
        super(props);

        this.state = {};
    }

    componentDidMount() {
        //window.addEventListener("resize", this.redrawChart.bind(this));
        this.redrawChart();
    }

    componentDidUpdate(){
        this.redrawChart();
    }

    componentWillUnmount(){
        if(this.state.chart != undefined){
            this.state.chart.destroy();
        }
    }

    redrawChart(){
        if(this.state.chart != undefined){
            this.state.chart.destroy();
            this.state.chart = undefined;
        }

        if(this.state.chart == undefined){
            var ctx = document.getElementById(this.getDivId()).getContext("2d");
            var data = this.getChartData();
            var yAxes = undefined;
            if(data != undefined && Array.isArray(data.datasets)){
                var axis = [];
                data.datasets.forEach(e => {
                    if(e.yAxisID != undefined && e.yAxisID != null){
                        if(!axis.includes(e.yAxisID))
                            axis.push(e.yAxisID);
                    }
                });

                if(axis.length > 0){
                    yAxes = [];
                    for(let i = 0; i < axis.length; i++){
                        if(i == 0){
                            yAxes.push({type: 'linear', display: true, position: 'left', id: axis[i]});
                        }
                        else{
                            yAxes.push({type: 'linear', display: true, position: 'right', id: axis[i], gridLines: {
                                drawOnChartArea: false
                            }});
                        }
                    }
                }
            }
            
            let config = {
                type: this.props.chartType,
                data,
                options: {
                    responsive: Boolean(this.props.responsive),
                    legend: {
                        position: this.props.legendPosition,
                    },
                    title: {
                        fontSize: (this.props.titleSize == undefined ? 14 : this.props.titleSize),
                        display: (this.props.title != undefined && this.props.title != ""),
                        text: this.props.title
                    }
                }
            };

            if(yAxes != undefined)
                config.options.scales = {yAxes: yAxes};

            this.state.chart = new Chart(ctx, config);
        }
        else{
            this.state.chart.update();
        }
    }

    render() {
        //(this.props);
        var style = this.props.style;
        var width = this.props.width != undefined ? this.props.width : "400px";
        if(style.width != undefined)
            width = style.width;
        var height = this.props.height != undefined ? this.props.height : "300px";
        if(style.height != undefined){
            height = style.height;  
        } 

        if((this.state.width != width || this.state.height != height) &&
            this.state.chart != undefined){
            this.state.chart.destroy();
            this.state.chart = undefined;
        }

        this.state.width = width;
        this.state.height = height;

        var className =  "field";
        if(this.props.className != undefined)
            className += " " + this.props.className;
            
        return <div className={className} style={style} >
            <canvas id={this.getDivId()} width={width} height={height}></canvas>
        </div>;
    }

    getDivId(){
        return "clover-chart-" + this.props.name;
    }

    getChartData(){
        if(this.props.datasetCustom){
            var me = this;

            var labels = [];
            if(me.props.dataLabels != undefined){
                labels = me.props.dataLabels.split(',');
            }

            var res = {
                labels,
                datasets: [{
                    label: me.props.datasetLabel,
                    steppedLine: me.props.datasetSteppedLine,
                    borderColor: me.props.datasetBorderColor,
                    backgroundColor: me.props.datasetBackgroundColor,
                    fill: me.props.datasetFill,
                    borderWidth: me.props.datasetBorderWidth,
                    data: me.props.value
                }]
            };
            return res;
        }
        
        return this.copyObj(this.props.value);
    }

    copyObj(obj) {
        if (null == obj || "object" != typeof obj) return obj;
        var copy = obj.constructor();
        
        for (var attr in obj) {
            if (obj.hasOwnProperty(attr)) copy[attr] = this.copyObj(obj[attr]);
        }
        return copy;
    }
}