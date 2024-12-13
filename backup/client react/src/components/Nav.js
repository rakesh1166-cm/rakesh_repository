import React, { useState } from "react";
import { useDispatch } from "react-redux";
import { registerUser } from "../actions";

const Nav = () => {
  const [showLoginModal, setShowLoginModal] = useState(false);
  const [showRegisterModal, setShowRegisterModal] = useState(false);
  const [formData, setFormData] = useState({ username: "", email: "", password: "" }); // Form data for registration
  const dispatch = useDispatch();

  const handleOpenLoginModal = () => setShowLoginModal(true);
  const handleCloseLoginModal = () => setShowLoginModal(false);
  const handleOpenRegisterModal = () => setShowRegisterModal(true);
  const handleCloseRegisterModal = () => setShowRegisterModal(false);

  const handleLoginSubmit = (e) => {
    e.preventDefault();
    console.log("Login submitted");
    setShowLoginModal(false); // Close login modal after submission
  };



  const handleRegisterSubmit = (e) => {
    e.preventDefault();
    dispatch(registerUser(formData)); // Dispatch the register action
    setFormData({ username: "", email: "", password: "" }); // Reset form data
    setShowRegisterModal(false); // Close the modal
  };

  return (
    <>
      <nav
        style={{
          position: "fixed",
          top: 0,
          left: 0,
          width: "100%",
          zIndex: 1000,
          backgroundColor: "#007bff",
          color: "#fff",
          padding: "10px 20px",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          boxShadow: "0 4px 6px rgba(0, 0, 0, 0.1)",
        }}
      >
        <h1 style={{ margin: 0 }}>CRUD App</h1>
        <ul
          style={{
            listStyleType: "none",
            display: "flex",
            gap: "20px",
            margin: 0,
            padding: 0,
          }}
        >
          <li>
            <a href="/" style={{ color: "#fff", textDecoration: "none" }}>
              Home
            </a>
          </li>
          <li>
            <a href="#students" style={{ color: "#fff", textDecoration: "none" }}>
              Students
            </a>
          </li>
          <li>
            <button
              onClick={handleOpenLoginModal}
              style={{
                backgroundColor: "#28a745",
                color: "#fff",
                border: "none",
                borderRadius: "5px",
                padding: "8px 16px",
                cursor: "pointer",
                marginRight: "10px", // Add margin between buttons
              }}
            >
              Login
            </button>
            <button
              onClick={handleOpenRegisterModal}
              style={{
                backgroundColor: "#ffc107",
                color: "#000",
                border: "none",
                borderRadius: "5px",
                padding: "8px 16px",
                cursor: "pointer",
              }}
            >
              Register
            </button>
          </li>
        </ul>
      </nav>

      {/* Login Modal */}
      {showLoginModal && (
        <div
          style={{
            position: "fixed",
            top: 0,
            left: 0,
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
            <h2 style={{ textAlign: "center" }}>Login</h2>
            <form
              onSubmit={handleLoginSubmit}
              style={{ display: "flex", flexDirection: "column", gap: "10px" }}
            >
              <input
                type="email"
                name="email"
                placeholder="Enter Email"
                required
                style={{
                  padding: "10px",
                  borderRadius: "5px",
                  border: "1px solid #ccc",
                }}
              />
              <input
                type="password"
                name="password"
                placeholder="Enter Password"
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
                    backgroundColor: "#007bff",
                    color: "#fff",
                    border: "none",
                    borderRadius: "5px",
                    cursor: "pointer",
                    flex: "1",
                    marginRight: "10px",
                  }}
                >
                  Login
                </button>
                <button
                  type="button"
                  onClick={handleCloseLoginModal}
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

      {/* Register Modal */}
      {showRegisterModal && (
        <div
          style={{
            position: "fixed",
            top: 0,
            left: 0,
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
            <h2 style={{ textAlign: "center" }}>Register</h2>
            <form
              onSubmit={handleRegisterSubmit}
              style={{ display: "flex", flexDirection: "column", gap: "10px" }}
            >
              <input
  type="text"
  name="username"
  placeholder="Enter Username"
  required
  value={formData.username} // Bind the state value
  onChange={(e) => setFormData({ ...formData, username: e.target.value })} // Update state
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
  required
  value={formData.email} // Bind the state value
  onChange={(e) => setFormData({ ...formData, email: e.target.value })} // Update state
  style={{
    padding: "10px",
    borderRadius: "5px",
    border: "1px solid #ccc",
  }}
/>
<input
  type="password"
  name="password"
  placeholder="Enter Password"
  required
  value={formData.password} // Bind the state value
  onChange={(e) => setFormData({ ...formData, password: e.target.value })} // Update state
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
                  Register
                </button>
                <button
                  type="button"
                  onClick={handleCloseRegisterModal}
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
    </>
  );
};

export default Nav;
