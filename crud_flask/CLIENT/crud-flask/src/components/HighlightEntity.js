import React, { useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { highlightEntity } from "../actions"; // Import the action
import Sidebar from "./Sidebar"; // Import Sidebar component
import Nav from "./Nav"; // Import Nav component
import Footer from "./Footer"; // Import Footer component

const HighlightEntity = () => {
  const [text, setText] = useState(""); // State for user input
  const dispatch = useDispatch();
  const highlightedEntities = useSelector((state) => state.highlightedEntities); // Fetch from Redux

  const handleHighlightEntity = () => {
    dispatch(highlightEntity(text)); // Dispatch the action
  };

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
          <p>Enter your text below to highlight entity.</p>

          {/* Input text area */}
          <textarea
            placeholder="Enter your text here..."
            value={text}
            onChange={(e) => setText(e.target.value)}
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
            onClick={handleHighlightEntity}
            style={{
              padding: "10px 20px",
              backgroundColor: "#007bff",
              color: "#fff",
              border: "none",
              borderRadius: "4px",
              cursor: "pointer",
            }}
          >
            Highlight Entity
          </button>

          {/* Display results */}
          <div style={{ marginTop: "20px" }}>
            <h2>Highlighted Entities:</h2>
            {highlightedEntities && highlightedEntities.length > 0 ? (
              <ul>
                {highlightedEntities.map((entity, index) => (
                  <li key={index}>
                    {entity.text} ({entity.label})
                  </li>
                ))}
              </ul>
            ) : (
              <p>No entities highlighted yet.</p>
            )}
          </div>
        </div>

        {/* Footer */}
        <Footer style={{ flex: "0 0 50px" }} />
      </div>
    </div>
  );
};

export default HighlightEntity;