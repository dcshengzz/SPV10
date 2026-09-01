var _sessionTimeout_interval;
var _sessionTimeout_LogoffPage = '/account/logoff';
var _sessionTimeout_LoginPage = '/account/login';
var sessionTimeoutMinutes = document.currentScript.getAttribute('sessionTimeoutMinutes');
var sessionTimeoutAlertMinutes = document.currentScript.getAttribute('sessionTimeoutAlertMinutes');
var _sessionTimeout_ActiveTime;
var _sessionTimeout_ActivePage = '/account/active';
var _sessionTimeout_ActiveResendMinutes = 1;
var sessionTimeoutLogoff = function () {
    fetch(_sessionTimeout_LogoffPage);
};
var sessionTimeoutFunc = function () {
    clearInterval(_sessionTimeout_interval);
    var timeStart = Date.now();
    var isAlerted = false;
    var isLoggedOut = false;
    _sessionTimeout_interval = setInterval(function () {
        var timeLapse = (Math.floor((Date.now() - timeStart) / 1000));
        if (!isAlerted && (timeLapse >= sessionTimeoutAlertMinutes * 60)) {
            alertify.alert("Your session will expire in " + (sessionTimeoutMinutes - sessionTimeoutAlertMinutes) + " minutes. Click OK to continue session.");
            isAlerted = true;
        } else if (!isLoggedOut && (timeLapse >= sessionTimeoutMinutes * 60)) {
            sessionTimeoutLogoff();
            alertify.hide();
            alertify.alert("Your session is expired. Click OK to login.", function () { window.location = _sessionTimeout_LoginPage; });
            isLoggedOut = true;
        }
    }, 1000);

	var activeLapse = (Math.floor((Date.now() - _sessionTimeout_ActiveTime) / 1000));
	if(_sessionTimeout_ActiveTime == null || activeLapse >= (_sessionTimeout_ActiveResendMinutes * 60)) {
		_sessionTimeout_ActiveTime = Date.now();
		sendAccountActive();
	}
};

async function sendAccountActive() {
  try {
    const response = await fetch(_sessionTimeout_ActivePage, {method: 'POST'});
    if (response.status === 403) {
		const data = await response.json();
		alertify.alert(data.Message, function () { window.location = _sessionTimeout_LoginPage; });
    }
  } catch (error) {
    console.error('Fetch error:', error.message);
  }
}

sessionTimeoutFunc();
$(document).on('mouseup mousedown keydown', sessionTimeoutFunc);