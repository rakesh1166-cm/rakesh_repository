import React, { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import Sidebar from "./Sidebar"; // Import Sidebar component
import Nav from "./Nav"; // Import Nav component
import Footer from "./Footer"; // Import Footer component

const Dashboard = () => {
  const navigate = useNavigate();

  useEffect(() => {
    const isLoggedIn = !!localStorage.getItem("userEmail");
    if (!isLoggedIn) {
      navigate("/"); // Redirect to Landing Page if not logged in
    }
  }, [navigate]);

  return (
    <div style={{ display: "flex", flexDirection: "row", height: "100vh" }}>
      {/* Sidebar on the left */}
      <Sidebar style={{ flex: "0 0 250px" }} />

      {/* Main content area */}
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        {/* Navigation bar */}
        <Nav style={{ flex: "0 0 60px" }} />

        {/* Dashboard content */}
        <div
          style={{
            flex: 1,
            padding: "20px",
            backgroundColor: "#f4f4f4",
            overflowY: "auto",
          }}
        >
          <h1 style={{ marginBottom: "20px" }}>Welcome to the Dashboard</h1>
          <p>
            This is the main dashboard content. Add your dynamic content or
            additional components here.
          </p>
        </div>

        {/* Footer */}
        <Footer style={{ flex: "0 0 50px" }} />
      </div>
    </div>
  );
};

export default Dashboard;