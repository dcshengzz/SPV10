import React from 'react'
import { render } from 'react-dom'
import ChoiceCount from './choicecount'

export default class DplyChoiceQnns extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            dplyId: null,
            dplyName: null,
            qnnTitle: null,
            data: null

        }
    }

    componentWillReceiveProps = (nextProps) => {
        //console.log("NextProps in DplyChoiceQnns ", nextProps);
        if (!nextProps.value) {
            this.setState({ data: null });
            return;
        }
        this.setState({ dplyId: nextProps.value });
        let dplyId = nextProps.value;
        var data = new Array();
        
        $('body').loadingModal({
            text: 'Loading...',
            animation: 'foldingCube',
            backgroundColor: '#1262E2'
        });

        data.push({ name: 'dplyId', value: dplyId });
        $.ajax({
            url: "/report/answerchoicecount",
            async: true,
            type: "post",
            data: data,
            success: (response) => {
                $('body').loadingModal('destroy');
                if (response.success) {
                    this.setState({
                        dplyName: response.dplyName,
                        qnnTitle: response.qnnTitle,
                        respCount: response.respCount,
                        data: response.items
                    });
                }
                else {
                    alertify.error(response.message);
                }
            },
            error: function (jqXHR, exception) {
                var msg = "Error on the server! Please contact system administrator.";
                alertify.error(msg);;
            }
        });
    }

    groupBy(array, f) {
        const groups = {};
        array.forEach(function (o) {
            const group = JSON.stringify(f(o));
            groups[group] = groups[group] || [];
            groups[group].push(o);
        });
        return Object.keys(groups).map(function (group) {
            return groups[group];
        });
    }

    render() {
        const { data, dplyName, qnnTitle } = this.state;
        if (!data) return (<div>
            </div>);

        const sorted = this.groupBy(data, function (item) {
            return [item.QnnFieldId];
        });

        let res =[];
        res.push(<div className='dplychoiceqnns-title'><h3>{ qnnTitle }</h3></div>);

        for (var i=0; i < sorted.length; i++) {
            let qnnFieldId = sorted[i][0]["QnnFieldId"];
            let qnnFieldText = sorted[i][0]["Name"];
            let respCount = sorted[i][0]["RespCount"];
            let gridData = sorted[i];
            res.push(<div className="dplychoiceqnns-choicecount-item"><ChoiceCount qnnFieldText={qnnFieldText} respCount={respCount} qnnFieldId={qnnFieldId} gridData={gridData} /></div>);

        }
        
        return res;

    }


}


