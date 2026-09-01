import { handleActions } from 'redux-actions'
import initialState from "../state.jsx"


const settingsReducer = handleActions({
        SETTINGS: {
        }
    },
    initialState.settings);

export default settingsReducer;
