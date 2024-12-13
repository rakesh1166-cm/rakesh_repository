import React, { useState, useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import { addItem, updateItem, deleteItem, fetchItems } from "../actions";
import Nav from "./Nav"; // Import Nav component
import Footer from "./Footer"; // Import Footer component
import "./CrudFlask.css";

const CrudFlask = () => {
  const items = useSelector((state) => state.items);
  const dispatch = useDispatch();

  const [formData, setFormData] = useState({ name: "", email: "" });
  const [editId, setEditId] = useState(null);
  const [showModal, setShowModal] = useState(false); // Toggle for modal visibility
  const [isLoggedIn, setIsLoggedIn] = useState(false); // State to track login status

  useEffect(() => {
    const userEmail = localStorage.getItem("userEmail");
    console.log("LocalStorage email:", userEmail);
    setIsLoggedIn(!!userEmail);
  }, []);

  useEffect(() => {
    dispatch(fetchItems());
  }, [dispatch]);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (editId) {
      dispatch(updateItem(editId, formData));
      setEditId(null);
    } else {
      dispatch(addItem(formData));
    }
    setFormData({ name: "", email: "" });
    setShowModal(false); // Close the modal after submission
  };

  const handleEdit = (id) => {
    const item = items.find((item) => item.id === id);
    setEditId(id);
    setFormData({ name: item.name, email: item.email });
    setShowModal(true); // Open the modal for editing
  };

  const handleDelete = (id) => {
    dispatch(deleteItem(id));
  };

  return (
    <>
      <Nav /> {/* Include Nav component */}
      <div className="App" style={{ marginTop: "70px" }}> {/* Adjust based on navbar height */}
        <h1>CRUD Flask</h1>

        {/* Show Add Student button only if logged in */}
        {isLoggedIn && (
          <button
            onClick={() => {
              setFormData({ name: "", email: "" });
              setEditId(null);
              setShowModal(true);
            }}
            style={{
              padding: "10px 20px",
              marginBottom: "20px",
              backgroundColor: "#007bff",
              color: "#fff",
              border: "none",
              borderRadius: "5px",
              cursor: "pointer",
            }}
          >
            Add Student
          </button>
        )}

        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {items.map((item, index) => (
              <tr key={index}>
                <td>{item.name}</td>
                <td>{item.email}</td>
                <td>
                  <div style={{ display: "flex", justifyContent: "center", gap: "10px" }}>
                    <button
                      onClick={() => handleEdit(item.id)}
                      style={{
                        padding: "5px 10px",
                        backgroundColor: "#007bff",
                        color: "#fff",
                        border: "none",
                        borderRadius: "5px",
                      }}
                    >
                      Edit
                    </button>
                    <button
                      onClick={() => handleDelete(item.id)}
                      style={{
                        padding: "5px 10px",
                        backgroundColor: "#ff4d4f",
                        color: "#fff",
                        border: "none",
                        borderRadius: "5px",
                      }}
                    >
                      Delete
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        {/* Modal */}
        {showModal && (
          <div
            style={{
              position: "fixed",
              top: "0",
              left: "0",
              width: "100%",
              height: "100%",
              backgroundColor: "rgba(0, 0, 0, 0.5)",
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
            }}
          >
            <div
              style={{
                backgroundColor: "#fff",
                padding: "20px",
                borderRadius: "10px",
                width: "400px",
                boxShadow: "0 4px 8px rgba(0, 0, 0, 0.2)",
              }}
            >
              <h2 style={{ textAlign: "center" }}>{editId ? "Edit Student" : "Add Student"}</h2>
              <form onSubmit={handleSubmit} style={{ display: "flex", flexDirection: "column", gap: "10px" }}>
                <input
                  type="text"
                  name="name"
                  placeholder="Enter Name"
                  value={formData.name}
                  onChange={handleChange}
                  required
                  style={{
                    padding: "10px",
                    borderRadius: "5px",
                    border: "1px solid #ccc",
                  }}
                />
                <input
                  type="email"
                  name="email"
                  placeholder="Enter Email"
                  value={formData.email}
                  onChange={handleChange}
                  required
                  style={{
                    padding: "10px",
                    borderRadius: "5px",
                    border: "1px solid #ccc",
                  }}
                />
                <div style={{ display: "flex", justifyContent: "space-between" }}>
                  <button
                    type="submit"
                    style={{
                      padding: "10px",
                      backgroundColor: "#28a745",
                      color: "#fff",
                      border: "none",
                      borderRadius: "5px",
                      cursor: "pointer",
                      flex: "1",
                      marginRight: "10px",
                    }}
                  >
                    {editId ? "Update" : "Add"}
                  </button>
                  <button
                    type="button"
                    onClick={() => setShowModal(false)}
                    style={{
                      padding: "10px",
                      backgroundColor: "#dc3545",
                      color: "#fff",
                      border: "none",
                      borderRadius: "5px",
                      cursor: "pointer",
                      flex: "1",
                    }}
                  >
                    Cancel
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}
      </div>
      <Footer /> {/* Include Footer component */}
    </>
  );
};

export default CrudFlask;
