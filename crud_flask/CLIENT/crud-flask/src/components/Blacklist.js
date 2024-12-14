import React from "react";
import Sidebar from "./Sidebar"; // Import Sidebar component
import Nav from "./Nav"; // Import Nav component
import Footer from "./Footer"; // Import Footer component

const BlacklistDetector = () => {
  return (
    <div style={{ display: "flex", flexDirection: "row", height: "100vh" }}>
      {/* Sidebar on the left */}
      <Sidebar style={{ flex: "0 0 250px" }} />

      {/* Main content area */}
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        {/* Navigation bar */}
        <Nav style={{ flex: "0 0 60px" }} />

        {/* Main content */}
        <div
          style={{
            flex: 1,
            padding: "20px",
            backgroundColor: "#f4f4f4",
            overflowY: "auto",
          }}
        >
          <h1 style={{ marginBottom: "20px" }}>Blacklist Detector</h1>
          <p>
            Enter your text below to detect any blacklisted words (e.g., spam,
            fake, scam).
          </p>

          {/* Input text area */}
          <textarea
            placeholder="Enter your text here..."
            style={{
              width: "100%",
              height: "100px",
              marginBottom: "20px",
              padding: "10px",
              border: "1px solid #ccc",
              borderRadius: "4px",
            }}
          ></textarea>

          {/* Submit button */}
          <button
            style={{
              padding: "10px 20px",
              backgroundColor: "#007bff",
              color: "#fff",
              border: "none",
              borderRadius: "4px",
              cursor: "pointer",
            }}
          >
            Detect Blacklist
          </button>
        </div>

        {/* Footer */}
        <Footer style={{ flex: "0 0 50px" }} />
      </div>
    </div>
  );
};

export default BlacklistDetector;