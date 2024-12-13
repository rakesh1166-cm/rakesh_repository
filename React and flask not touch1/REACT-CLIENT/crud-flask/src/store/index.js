import { createStore, applyMiddleware } from 'redux';
import { thunk } from 'redux-thunk'; // Use the named export "thunk"
import rootReducer from '../reducers'; // If reducers is in src/

const store = createStore(rootReducer, applyMiddleware(thunk));
export default store;