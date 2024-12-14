import React from "react";
import { Link } from "react-router-dom";

const Sidebar = () => {
  return (
    <aside
      style={{
        width: "250px",
        backgroundColor: "#333",
        color: "white",
        padding: "30px",
        boxShadow: "2px 0 5px rgba(0, 0, 0, 0.1)",
      }}
    >
      <h3 style={{ marginBottom: "20px" }}>Sidebar</h3>
      <ul style={{ listStyleType: "none", padding: 0 }}>
        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <Link
            to="/dashboard"
            style={{ color: "white", textDecoration: "none" }}
          >
            Dashboard
          </Link>
        </li>
        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <Link
            to="/highlight-entity"
            style={{ color: "white", textDecoration: "none" }}
          >
            Highlight Entity
          </Link>
        </li>
        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <Link
            to="/detect-long-sentence"
            style={{ color: "white", textDecoration: "none" }}
          >
            Detecting Long Sentence
          </Link>
        </li>
        <li
          style={{
            marginBottom: "20px", /* Added margin-bottom for spacing */
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <Link
            to="/keyword-extractor"
            style={{ color: "white", textDecoration: "none" }}
          >
            Keyword Extractor
          </Link>
        </li>
        <li
          style={{
            marginBottom: "20px", /* Added margin-bottom for spacing */
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <Link
            to="/Blacklist"
            style={{ color: "white", textDecoration: "none" }}
          >
            Blacklist Detector
          </Link>
        </li>
      </ul>
    </aside>
  );
};

export default Sidebar;