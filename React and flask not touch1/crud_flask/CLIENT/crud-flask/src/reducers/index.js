import { 
  ADD_ITEM, 
  UPDATE_ITEM, 
  DELETE_ITEM, 
  FETCH_ITEMS, 
  REGISTER_USER, 
  LOGIN_USER, 
  LOGOUT_USER // New action type 
} from "../actions";

const initialState = {
  items: [],
  users: [], // State for registered users
  loggedInUser: localStorage.getItem("userEmail") || null,
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
        users: [...state.users, action.payload], // Add new user to the users array
      };
    case LOGIN_USER:
      return {
        ...state,
        loggedInUser: action.payload, // Update loggedInUser with user data
      };
    case LOGOUT_USER: // Clear loggedInUser on logout
      return {
        ...state,
        loggedInUser: null,
      };
    default:
      return state;
  }
};

export default rootReducer;
