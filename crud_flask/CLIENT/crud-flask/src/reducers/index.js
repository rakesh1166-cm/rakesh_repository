import { 
  ADD_ITEM, 
  UPDATE_ITEM, 
  DELETE_ITEM, 
  FETCH_ITEMS, 
  REGISTER_USER, 
  LOGIN_USER, 
  LOGOUT_USER, 
  HIGHLIGHT_ENTITY, 
  FETCH_ALL_ENTITIES, // Import the new action type
  EXTRACT_RESUME_INFO,
  PROCESS_TEXT_FEATURE,
  PROCESS_TEXT_FAILURE,
} from "../actions";

const initialState = {
  items: [],
  users: [],
  loggedInUser: localStorage.getItem("userEmail") || null,
  highlightedEntities: [], // State for highlighted entities
  allEntities: [], // State to store all database rows
  extractedInfo: null, // Store the extracted resume information
  processedText: "",
  error: null,
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
    case FETCH_ALL_ENTITIES:
      return {
        ...state,
        allEntities: action.payload, // Update the state with all entities
      };
      case EXTRACT_RESUME_INFO:
        return {
          ...state,
          extractedInfo: action.payload, // Update the state with extracted information
        }; 

      case PROCESS_TEXT_FEATURE:
      return { ...state, processedText: action.payload, error: null };
      case PROCESS_TEXT_FAILURE:
      return { ...state, processedText: "", error: action.payload };
         
    default:
      return state;
  }
};

export default rootReducer;