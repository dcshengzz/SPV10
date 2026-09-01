{
    init: function(args) {
        Utils.loadingStart("Loading...");
        Utils.getRequest("/maintenance/license").then(
            response => {
                const details = response.item;
                console.log( "SurveyPlus License Details", response.item ); //don't remove - console provides more detail than UI
                const descriptionHtml = '<span style="font-style: italic;">' + Utils.encodeHTML(details.description) + '</span>';
                CloverApp.API.setDataField("license_host", details.host);
                CloverApp.API.setDataField("license_expiry", details.expiry);
                CloverApp.API.setDataField("license_description", descriptionHtml);
            }, reason => {
                console.error("Failed to fetch SurveyPlus License Details", reason);
                const errorHtml = '<span style="font-weight: bold; color: red;">Unable to get license details</span>';
                CloverApp.API.setDataField("license_description", errorHtml);
            }
        ).finally(Utils.loadingStop);
        
        maintenancetestsUserActions.onRefreshHangfireStatus(args);
    },
    
    performSmtpTest: function(args) {
        const behaviour = args.parameters.behaviour;
        const msgDuration = 30000; //Longer alert time on screen makes it easier to screenshot
        const url = "/maintenance/tests/smtp/" + encodeURIComponent(behaviour);
        const waitMessage = "Performing " + behaviour + " SMTP Test...";
        console.log(waitMessage);
        Utils.loadingStart(waitMessage);
        Utils.postFormRequest(url).then(
            response => {
                console.log( response.message );
                alertify.success(Utils.encodeHTML(response.message), msgDuration);
            }, reason => {
                console.error(reason);
                alertify.error(Utils.encodeHTML(reason), msgDuration);
            }
        ).finally(Utils.loadingStop);
    },
    
    onRefreshHangfireStatus: function(args) {
        Utils.loadingStart("Loading...");
        Utils.getRequest("/maintenance/hangfire/servers").then(
            response => {
                console.log( "Hangfire Server Status", response.item ); //don't remove - console provides more detail than UI
                const html 
                    =`<table style="border: 1px solid rgba(44, 51, 56, 0.165);">
                        <tr>
                            <th style="text-align: left; background-color: #d0d0d0;">&nbsp;Server&nbsp;</th>
                            <th style="text-align: center; background-color: #d0d0d0;">&nbsp;Started&nbsp;</th>
                            <th style="text-align: center; background-color: #d0d0d0;">&nbsp;Heartbeat&nbsp;</th>
                        </tr>
                        ${response.item.map(server => {
                            const name = Utils.encodeHTML(server.name);
                            const startedAt = Utils.formatDateTime(new Date(server.startedAt), true); //also converts to local time
                            const heartbeatDate = (server.heartbeat==null)?null:new Date(server.heartbeat);
                            const heartbeat = (heartbeatDate==null)?"None":Utils.formatDateTime(heartbeatDate, true); //also converts to local time
                            const isHeartbeatStale = !heartbeatDate || (Date.now() - heartbeatDate > 2 * 60 * 1000);
                            const hbcolor = isHeartbeatStale ? "#ffd0d0" : "#d0ffd0";
                            return `<tr style="background-color: #f0f0f0; margin-bottom: 5px;">
                                        <td style="text-align: left;">${name}</td>
                                        <td style="text-align: center;">${startedAt}</td>
                                        <td style="text-align: center; background-color: ${hbcolor}; text-align: center;">${heartbeat}</td>
                                    </tr>`;})
                            .join('')}
                      </table>`;
                CloverApp.API.setDataField("sc_hangfire_servers", html);
            }, reason => {
                console.error("Failed to fetch Hangfire Server Status", reason);
                const errorHtml = '<span style="font-weight: bold; color: red;">Unable to get status</span>';
                CloverApp.API.setDataField("sc_hangfire_servers", errorHtml );
            }
        ).finally(Utils.loadingStop);
    },
    
    onClickDashboard: function(args) {
        window.open("/hangfire/jobs/succeeded", "_blank");
    },
}