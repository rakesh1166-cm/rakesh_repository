// src/actions/index.js
export const ADD_ITEM = "ADD_ITEM";
export const UPDATE_ITEM = "UPDATE_ITEM";
export const DELETE_ITEM = "DELETE_ITEM";
export const FETCH_ITEMS = "FETCH_ITEMS";

// Action Creators
export const addItem = (item) => {
  return async (dispatch) => {
    try {
      const response = await fetch("http://127.0.0.1:5000/student/add", { // Correct the endpoint
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(item),
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      dispatch({
        type: ADD_ITEM,
        payload: data, // Add the new student to the Redux store
      });
    } catch (error) {
      console.error("Error adding item:", error);
    }
  };
};

export const updateItem = (id, item) => {
  return async (dispatch) => {
    try {
      const response = await fetch(`http://127.0.0.1:5000/student/${id}/`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(item),
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      dispatch({
        type: UPDATE_ITEM,
        payload: { id, item: data }, // Update the student in the Redux store
      });
    } catch (error) {
      console.error("Error updating item:", error);
    }
  };
};

export const deleteItem = (id) => {
  return async (dispatch) => {
    try {
      const response = await fetch(`http://127.0.0.1:5000/student/delete/${id}/`, {
        method: "DELETE",
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      await response.json();
      dispatch({
        type: DELETE_ITEM,
        payload: id, // Remove the student from the Redux store
      });
    } catch (error) {
      console.error("Error deleting item:", error);
    }
  };
};
export const REGISTER_USER = "REGISTER_USER";

// Register User
export const registerUser = (userData) => {
  return async (dispatch) => {
    try {
      const response = await fetch("http://127.0.0.1:5000/register", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(userData), // Send the correct payload
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();

      dispatch({
        type: REGISTER_USER,
        payload: data,
      });

      console.log("User registered successfully:", data);
    } catch (error) {
      console.error("Error registering user:", error);
    }
  };
};
export const fetchItems = () => {
  return async (dispatch) => {
    try {
      const response = await fetch("http://127.0.0.1:5000/student/"); // Correct the URL
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();

      // Dispatch the FETCH_ITEMS action with the fetched data
      dispatch({
        type: FETCH_ITEMS,
        payload: data.items || [], // Ensure payload is an array even if `items` is undefined
      });
    } catch (error) {
      console.error("Error fetching items:", error);
      // Optionally, dispatch an error action or show an error message
    }
  };
};
