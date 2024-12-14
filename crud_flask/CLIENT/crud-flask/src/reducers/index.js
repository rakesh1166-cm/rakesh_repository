import { 
  ADD_ITEM, 
  UPDATE_ITEM, 
  DELETE_ITEM, 
  FETCH_ITEMS, 
  REGISTER_USER, 
  LOGIN_USER, 
  LOGOUT_USER,
  HIGHLIGHT_ENTITY // New action type 
} from "../actions";

const initialState = {
  items: [],
  users: [],
  loggedInUser: localStorage.getItem("userEmail") || null,
  highlightedEntities: [], // State for highlighted entities
};

const rootReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_ITEMS:
      return {
        ...state,
        items: action.payload,
      };
    case ADD_ITEM:
      return {
        ...state,
        items: [...state.items, action.payload],
      };
    case UPDATE_ITEM:
      return {
        ...state,
        items: state.items.map((item) =>
          item.id === action.payload.id ? { ...item, ...action.payload.item } : item
        ),
      };
    case DELETE_ITEM:
      return {
        ...state,
        items: state.items.filter((item) => item.id !== action.payload),
      };
    case REGISTER_USER:
      return {
        ...state,
        users: [...state.users, action.payload],
      };
    case LOGIN_USER:
      return {
        ...state,
        loggedInUser: action.payload,
      };
    case LOGOUT_USER:
      return {
        ...state,
        loggedInUser: null,
      };
    case HIGHLIGHT_ENTITY:
      return {
        ...state,
        highlightedEntities: action.payload, // Update the state with highlighted entities
      };
    default:
      return state;
  }
};

export default rootReducer;
