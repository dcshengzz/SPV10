import  store  from './store.jsx';
import  actions  from './actions';

const detectlocationapi = {
    ipLookUp: function ipLookUp(propertyName) {
        $.ajax('http://ip-api.com/json').then(function success(response) {
            console.log('User\'s Ip Address ', response.query);
            store.dispatch(actions.app.form.data.update(propertyName, response.query));
        }, function fail(data, status) {
            alert('Request failed.  Returned status of', status);
            console.log('Request failed.  Returned status of', status);
        });
    },
    getCurrentPosition: function getCurrentPosition(propertyName) {
        if ("geolocation" in navigator) {
            // check if geolocation is supported/enabled on current browser
            navigator.geolocation.getCurrentPosition(function success(position) {
                // for when getting location is a success
                console.log('latitude', position.coords.latitude, 'longitude', position.coords.longitude);
                var latLong = position.coords.latitude + ', ' + position.coords.longitude;
                store.dispatch(actions.app.form.data.update(propertyName, latLong));
            }, function error(error_message) {
                alert('An error has occured while retrieving location, please ensure browser location is turned on');
                // for when getting location results in an error
                console.error('An error has occured while retrieving' + 'location', error_message);
            });
        }
    }
};

export {detectlocationapi};