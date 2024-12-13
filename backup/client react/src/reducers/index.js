import { ADD_ITEM, UPDATE_ITEM, DELETE_ITEM, FETCH_ITEMS, REGISTER_USER } from "../actions";

const initialState = {
  items: [],
  users: [], // New state for registered users
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
    default:
      return state;
  }
};

export default rootReducer;