import React, { useState, useEffect } from "react";
import { useDispatch } from "react-redux";
import { useNavigate } from "react-router-dom";
import { registerUser, loginUser } from "../actions";

const Nav = () => {
 const [showLoginModal, setShowLoginModal] = useState(false);
  const [showRegisterModal, setShowRegisterModal] = useState(false);
  const [formData, setFormData] = useState({ username: "", email: "", password: "" });
  const [formloginData, setFormlogin] = useState({ email: "", password: "" });
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const dispatch = useDispatch();
  const navigate = useNavigate(); // Initialize useNavigate for redirection

  // Check login status on component mount
  useEffect(() => {
    const userEmail = localStorage.getItem("userEmail");
    setIsLoggedIn(!!userEmail); // If userEmail exists, set loggedIn state to true
  }, []);

  const handleOpenLoginModal = () => setShowLoginModal(true);
  const handleCloseLoginModal = () => setShowLoginModal(false);
  const handleOpenRegisterModal = () => setShowRegisterModal(true);
  const handleCloseRegisterModal = () => setShowRegisterModal(false);

  const handleLoginSubmit = (e) => {
    e.preventDefault();
    dispatch(loginUser(formloginData))
      .then(() => {
        localStorage.setItem("userEmail", formloginData.email);
        setIsLoggedIn(true);
        setFormlogin({ email: "", password: "" });
        setShowLoginModal(false);
        navigate("/dashboard"); // Redirect to Dashboard after login
      })
      .catch((error) => {
        console.error("Login failed:", error);
      });
  };

  const handleRegisterSubmit = (e) => {
    e.preventDefault();
    dispatch(registerUser(formData))
      .then(() => {
        setFormData({ username: "", email: "", password: "" }); // Reset form data
        setShowRegisterModal(false); // Close the modal
      })
      .catch((error) => {
        console.error("Registration failed:", error);
      });
  };

  const handleLogout = () => {
    // Remove user data from localStorage
    localStorage.removeItem("userEmail");
    setIsLoggedIn(false); // Update login status
    navigate("/"); // Redirect to Dashboard after login
    window.location.reload();
  };

  return (
    <>
      <nav
        style={{
          position: "fixed",
          top: 0,
          left: 0,
          width: "100%",
          backgroundColor: "#333",
          padding: "10px 20px",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          zIndex: 1000,
        }}
      >
        <div style={{ color: "white" }}>My App</div>
        <div>
          {isLoggedIn ? (
            <button onClick={handleLogout} style={{ marginRight: "10px" }}>
              Logout
            </button>
          ) : (
            <>
              <button onClick={handleOpenLoginModal} style={{ marginRight: "10px" }}>
                Login
              </button>
              <button onClick={handleOpenRegisterModal}>Register</button>
            </>
          )}
        </div>
      </nav>

      {/* Login Modal */}
      {showLoginModal && (
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
              backgroundColor: "white",
              padding: "20px",
              borderRadius: "8px",
              width: "300px",
            }}
          >
            <h2>Login</h2>
            <form onSubmit={handleLoginSubmit}>
              <div style={{ marginBottom: "10px" }}>
                <label style={{ display: "block", marginBottom: "5px" }}>Email</label>
                <input
                  type="email"
                  value={formloginData.email}
                  onChange={(e) => setFormlogin({ ...formloginData, email: e.target.value })}
                  required
                  style={{ width: "100%", padding: "8px" }}
                />
              </div>
              <div style={{ marginBottom: "10px" }}>
                <label style={{ display: "block", marginBottom: "5px" }}>Password</label>
                <input
                  type="password"
                  value={formloginData.password}
                  onChange={(e) => setFormlogin({ ...formloginData, password: e.target.value })}
                  required
                  style={{ width: "100%", padding: "8px" }}
                />
              </div>
              <div
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  marginTop: "20px",
                }}
              >
                <button type="submit" style={{ padding: "10px", flex: 1, marginRight: "5px" }}>
                  Login
                </button>
                <button
                  type="button"
                  onClick={handleCloseLoginModal}
                  style={{ padding: "10px", flex: 1, marginLeft: "5px" }}
                >
                  Close
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
              backgroundColor: "white",
              padding: "20px",
              borderRadius: "8px",
              width: "300px",
            }}
          >
            <h2>Register</h2>
            <form onSubmit={handleRegisterSubmit}>
              <div style={{ marginBottom: "10px" }}>
                <label style={{ display: "block", marginBottom: "5px" }}>Username</label>
                <input
                  type="text"
                  value={formData.username}
                  onChange={(e) => setFormData({ ...formData, username: e.target.value })}
                  required
                  style={{ width: "100%", padding: "8px" }}
                />
              </div>
              <div style={{ marginBottom: "10px" }}>
                <label style={{ display: "block", marginBottom: "5px" }}>Email</label>
                <input
                  type="email"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  required
                  style={{ width: "100%", padding: "8px" }}
                />
              </div>
              <div style={{ marginBottom: "10px" }}>
                <label style={{ display: "block", marginBottom: "5px" }}>Password</label>
                <input
                  type="password"
                  value={formData.password}
                  onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                  required
                  style={{ width: "100%", padding: "8px" }}
                />
              </div>
              <div
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  marginTop: "20px",
                }}
              >
                <button type="submit" style={{ padding: "10px", flex: 1, marginRight: "5px" }}>
                  Register
                </button>
                <button
                  type="button"
                  onClick={handleCloseRegisterModal}
                  style={{ padding: "10px", flex: 1, marginLeft: "5px" }}
                >
                  Close
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
