import { handleActions } from 'redux-actions'
import initialState from "../state.jsx"
import { isEmptyObject, mergeDeep} from '../utils.jsx'


const globalReducer = handleActions({
    UPDATESTATE: (state, { payload: { stateDelta } }) => {
        if (stateDelta && !isEmptyObject(stateDelta)) {
            let newState = mergeDeep(state, stateDelta);

            for (let p in newState.app.form.data.children) {
                if (newState.app.form.data.children.hasOwnProperty(p)) {
                    if (!newState.app.form.data.children[p]) {
                        delete newState.app.form.data.children[p];
                    }
                }
            }

            return newState;
        }
        return state;
    }
}, initialState);
        

export default globalReducer;

