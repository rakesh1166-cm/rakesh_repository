import React from "react";
import Sidebar from "./Sidebar"; // Import Sidebar component
import Nav from "./Nav"; // Import Nav component
import Footer from "./Footer"; // Import Footer component

const HighlightEntity = () => {
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
          <h1 style={{ marginBottom: "20px" }}>Highlight Entity</h1>
          <p>This is the content for the Highlight Entity page.</p>
        </div>

        {/* Footer */}
        <Footer style={{ flex: "0 0 50px" }} />
      </div>
    </div>
  );
};

export default HighlightEntity;
