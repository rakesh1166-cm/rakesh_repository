// src/actions/index.js
export const ADD_ITEM = "ADD_ITEM";
export const UPDATE_ITEM = "UPDATE_ITEM";
export const DELETE_ITEM = "DELETE_ITEM";
export const FETCH_ITEMS = "FETCH_ITEMS";
export const LOGOUT_USER = "LOGOUT_USER"; // Add this
export const HIGHLIGHT_ENTITY = "HIGHLIGHT_ENTITY";
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
export const LOGIN_USER = "LOGIN_USER";

export const loginUser = (userData, navigate) => {
  return async (dispatch) => {
    try {
      const response = await fetch("http://127.0.0.1:5000/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(userData),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();

      // Store user email in localStorage
      localStorage.setItem("userEmail", data.user.email);

      dispatch({
        type: LOGIN_USER,
        payload: data,
      });
      navigate("/dashboard");
      // Optional: Redirect to a protected route after login
    } catch (error) {
      console.error("Error logging in:", error);
      // Dispatch an error action or show an error message to the user
    }
  };
};
export const logoutUser = () => {
  return (dispatch) => {
    // Clear localStorage
    localStorage.removeItem("userEmail");
    // Dispatch the LOGOUT_USER action
    dispatch({ type: LOGOUT_USER });
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


export const highlightEntity = (text) => {
  return async (dispatch) => {
    try {
      const response = await fetch("http://127.0.0.1:5000/highlight-entity", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ text }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();

      dispatch({
        type: HIGHLIGHT_ENTITY,
        payload: data, // Pass the highlighted entity data to the reducer
      });
    } catch (error) {
      console.error("Error highlighting entity:", error);
    }
  };
};
