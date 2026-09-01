import { createStore, combineReducers, applyMiddleware } from 'redux'
import { composeWithDevTools } from 'redux-devtools-extension';
import thunkMiddleware from 'redux-thunk'
//import { routerReducer, routerMiddleware } from 'react-router-redux'
import reducer from './reducers/index.jsx'
import globalReducer from './reducers/globalreducer.jsx'
import routerReducer from './reducers/routerreducer.jsx'
import settingsReducer from './reducers/settingsreducer.jsx'
import initialState from './state.jsx'

const reducerWithRouting = combineReducers({
    "":globalReducer,
    app: reducer,
    router: routerReducer,
    settings: settingsReducer
});

const combinedReducer = (state = {}, action) => {
    //
    if (action.type === 'UPDATESTATE') {
        return globalReducer(state, action);
    }
    return {
        app: reducer(state.app, action, state),
        router: routerReducer(state.router, action, state),
        settings: settingsReducer(state.settings, action, state)
    };
}

const store = createStore(combinedReducer,
    initialState,
    composeWithDevTools(applyMiddleware(thunkMiddleware)));

store.getState().app.addQueryParams = function (obj) {
    if (store.additionalParams == undefined){
        store.additionalParams = {};
    }
    
    for(var p in obj){
        store.additionalParams[p] = obj[p];
    }
};

store.resetForm = function (){
    store.getState().app.form = initialState.app.form;
};

window.CloverStore = store;

export default store;