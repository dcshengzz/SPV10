import { handleActions } from 'redux-actions'
import initialState from "../state.jsx"
import { convertParentChildArrayToTree, jsonEqual } from '../utils.jsx'
import formReducer from './formreducer.jsx'

const reducer = handleActions({
        APP: {
            USERINFO: {
                FETCH: {
                    BEGIN: (state) => (
                        {
                            ...state,
                            fetchCount: state.fetchCount + 1
                        }),
                    SUCCESS: (state, { payload: { user } }) => ({
                        ...state,
                        user: user,
                        fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1)
                    }),
                    FAILURE: (state, { payload: { error, details } }) => ({
                        ...state,
                        error: error,
                        errorDetails: details,
                        fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1)
                    })
                }
            },
            AUTOSAVE: {
                FETCH: {
                    BEGIN: (state) => (
                        {
                            ...state,
                        }),
                    SUCCESS: (state, { payload: { autosave } }) => ({
                        ...state,
                        autosave: autosave,
                    }),
                    FAILURE: (state, { payload: { error, details } }) => ({
                        ...state,
                        error: error,
                        errorDetails: details,
                    })
                }
            },
            CLEARERRORS: (state) => (
                {
                    ...state,
                    error: undefined,
                    errorLevel: undefined,
                    errorDetails: undefined
                }),
            FAILURE: (state, { payload: { error, details, level } }) => ({
                ...state,
                error: error,
                errorLevel: level,
                errorDetails: details,
                fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1)
            }),
            FETCHBEGIN: (state) => (
                {
                    ...state,
                    fetchCount: state.fetchCount + 1
                }),
            RESETFETCHCOUNT: (state) => (
                {
                    ...state,
                    fetchCount: 0
                }),
            FORM: formReducer
        }
    },
    initialState.app);

export default reducer;
