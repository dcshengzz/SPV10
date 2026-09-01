var _sessionTimeout_interval;
var _sessionTimeout_LogoffPage = '/resp/logoff';
var _sessionTimeout_LoginPage = '/';
var _anonymous_uid = 'swzanonymous'; //anonymous survey UID
var sessionTimeoutLogoff = function () {
    if (CloverApp.state.uid == _anonymous_uid) {
        location.reload();
    } else {
        fetch(_sessionTimeout_LogoffPage);
    }
};
var sessionTimeoutFunc = function () {
    clearInterval(_sessionTimeout_interval);
    var _sessionTimeout_timeoutMins = 15;
    var _sessionTimeout_alertMins = 13;
    var timeStart = Date.now();
    var isAlerted = false;
    var isLoggedOut = false;
    _sessionTimeout_interval = setInterval(function () {
        var timeLapse = (Math.floor((Date.now() - timeStart) / 1000));
        if (!isAlerted && (timeLapse >= _sessionTimeout_alertMins * 60) && (CloverApp.state.uid !== _anonymous_uid)) {
            alertify.alert("Your session will expire in " + (_sessionTimeout_timeoutMins - _sessionTimeout_alertMins) + " minutes. Click OK to continue session.");
            isAlerted = true;
        } else if (!isLoggedOut && (timeLapse >= _sessionTimeout_timeoutMins * 60)) {
            sessionTimeoutLogoff();
            if (CloverApp.state.uid !== _anonymous_uid) {
                alertify.hide();
                alertify.alert("Your session is expired. Click OK to login.", function () { window.location = _sessionTimeout_LoginPage; });
            }
            isLoggedOut = true;
        }
    }, 1000);
};
$(document).ready(function () {
    sessionTimeoutFunc();
    $(document).on('mouseup mousedown keydown', sessionTimeoutFunc);
});