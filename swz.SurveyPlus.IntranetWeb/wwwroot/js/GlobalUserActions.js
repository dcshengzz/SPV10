var globalUserActions = {

    downloadEmailTemplate: function (args) {
        let text = '';
        text += 'Example of token use:\n';
        text += 'ANNUAL SURVEY ON {DplyName} 2023 \n';
        text += 'Purpose of the Survey:\n';
        text += 'The purpose of the Survey is to obtain data for the period from 1 June to 31 May.\n';
        text += 'Statistics compiled from the collected data will be used to assist in policy-making efforts.\n';
        text += 'Submission of the Questionnaire:\n';
        text += 'We would be grateful if you could return the completed questionnaire by {DueDate}. \n';
        text += ' \n';
        text += 'The following is your login information:\n';
        text += 'Company name: {Name}\n';
        text += 'Username: {UID}\n';
        text += 'Password: {Password}\n';
        text += ' \n';

        text += 'Other tokens:\n';
        text += 'UID: {UID}\n';
        text += 'Password: {Password}\n';
        text += 'Survey Name: {SurveyName}\n';
        text += 'Questionnaire Name: {DplyQnn}\n';
        text += 'List Name: {DplyList}\n';
        text += 'Deployment Name: {DplyName}\n';
        text += 'Email: {ToEmails} {CcEmails}\n';
        text += 'Date: {Date}\n';
        text += 'Due Date: {DueDate} {DueDateISO} {DueDateNumeric} {DueDateChinese} {DueDateMalay} {DueDateTamil}\n';
        text += 'Address: {AddressLine1} {AddressLine2} {AddressLine3}\n';
        text += 'Account Active Status: {ActiveYN}\n';
        text += 'Delegation Code: {DelegationCode} (Master Delegation Code. Only available for deployments that require AccessCode)\n';
        text += 'Invitation Links: {InvitationLink} {InvitationUrl} (For use with invitation feature)\n';
        text += 'Direct Access Links: {SurveyQRLocation_ffff} {SurveyLinkLocation_ffff} {SurveyURLLocation_ffff}';
        text += '(For use with Direct Access surveys. Change ffff to the exact name of the Form)\n';
        text += '\n';
        text += 'Tokens are case-sensitive in this version of SurveyPlus.\n';
        text += 'You may also use custom List Sample Properties as tokens (if this is enabled for your SurveyPlus installation)\n';        
        
        const hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(text);
        hiddenElement.target = '_blank';
        hiddenElement.download = 'EmailTemplate.txt';
        hiddenElement.click();
    },

    goBack: function (args) {
        args.state.router.history.goBack();
    },

    redirectToForm: function (args) {
        //console.log('redirectoToForm args', args)
        const id = args.data.Id;
        const formName = args.parameters.formName;
        CloverApp.API.redirectToForm(formName, id);
    },

    init: function(args){
    	if(args.data) {
	        args.data.entityState = "Create";
	        if(args.data.Id) args.data.entityState = "Edit";
    	}
    },

    checkEntityState: function(args){	
        if (args.data && args.data.Id) {
            CloverApp.API.setDataField("entityState", "Edit");
        }
    },

    //create Tags button with redirection
    createTagsButton: function (name) {
        var url = new Array();
        url['name'] = "target";
        url['value'] = "/form/SwzTags/";// + name + "";//"&wrapresult=true&enableSecurity=true#";

        var clickEvent = [];
        clickEvent['onClick'] = new Array();
        clickEvent.onClick['actions'] = new Array("addTagsSession","redirect");
        clickEvent.onClick['parameters'] = new Array(url);
        clickEvent.onClick['active'] = true;

        var tag = new Array();
        tag['content'] = name;
        tag['data-buildertype'] = "button";
        tag['key'] = "tagKey_" + name;
        tag['events'] = clickEvent;
        tag['compact'] = true;
        tag['size'] = "mini";
        tag['style-marginTop'] = "2px";
        tag['style-marginBottom'] = "2px";
        tag['style-marginLeft'] = "2px";
        tag['style-marginRight'] = "2px";

        return tag;
    },

    //Create tag button on modal to add and remove on click action
    createSearchedTagsButton: function (name) {
        var clickEvent = [];
        clickEvent['onClick'] = new Array();
        clickEvent.onClick['actions'] = new Array("addTagToDropdown","removeTagInDiv");
        clickEvent.onClick['active'] = true;

        var tag = new Array();
        tag['content'] = name;
        tag['data-buildertype'] = "button";
        tag['key'] = "tagPopKey_" + name;
        tag['events'] = clickEvent;
        tag['compact'] = true;
        tag['size'] = "mini";

        return tag;
    },

    samplePasswordError: function (password) {
        if (password) {
            const req = new RegExp(/^[a-zA-Z0-9]{12,100}$/);
            const countChars = function (str, type) {
                let count = 0, len = str.length;
                for (let i = 0; i < len; i++) {
                    if (type == 0) {
                        if (/[A-Z]/.test(str.charAt(i))) count++;
                    }
                    else if (type == 1) {
                        if (/[a-z]/.test(str.charAt(i))) count++;
                    }
                    else if (type == 2) {
                        if (/[0-9]/.test(str.charAt(i))) count++;
                    }
                }
                return count;
            };

            if (!req.test(password)) {
                return "Password must contain alphanumeric characters only; password must be between 12 and 100 characters";
            }

            if (countChars(password, 0) < 3 || countChars(password, 1) < 3 || countChars(password, 2) < 3) {
                return "Password must contain at least 3 characters from each category (lowercase letter, uppercase letter, numeric digit)";
            }
        }
        return null; //ok
    }

}
