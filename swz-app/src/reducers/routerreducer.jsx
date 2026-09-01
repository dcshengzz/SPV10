import { handleActions } from 'redux-actions'
import initialState from "../state.jsx"


const routerReducer = handleActions({
        ROUTER: {
            ROUTECHANGED: (state, { payload: { history, location } }) => (
                {
                    ...state,
                    push: null,
                    redirect: null,
                    refresh: null,
                    history: history,
                    location: location

                }),
            PUSH: (state, { payload: { newurl } }) => ({
                    ...state,
                    push: newurl,
                    redirect: null,
                    refresh: null,
                }
            ),
            REDIRECT: (state, { payload: { newurl } }) => ({
                    ...state,
                    redirect: newurl,
                    push: null,
                    refresh: null,
                }
            ),
            REFRESH: (state, { payload: { newurl } }) => ({
                    ...state,
                    refresh: newurl,
                    redirect: null,
                    push: null

                }
            ),
            CHANGEURLFILTER: (state, { payload: { newfilter } }) => {
                let locations = document.location.pathname.split("/");
                if (locations.length > 3)
                    locations[3] = newfilter;
                else
                    locations.push(newfilter);

                let newurl = locations.join('/');
                return {
                    ...state,
                    redirect: newurl,
                    push: null,
                    refresh: null
                };
            }
        }
    },
    initialState.router);

export default routerReducer;
