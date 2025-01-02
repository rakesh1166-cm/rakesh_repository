import React, { useState } from "react";
import { Link } from "react-router-dom";

const Sidebar = () => {
  const [openSubMenu, setOpenSubMenu] = useState(null);

  const toggleSubMenu = (menu) => {
    setOpenSubMenu(openSubMenu === menu ? null : menu);
  };

  return (
    <aside
      style={{
        width: "250px",
        backgroundColor: "#333",
        color: "white",
        padding: "30px",
        height: "100vh", // Ensure full height for the sidebar
        boxShadow: "2px 0 5px rgba(0, 0, 0, 0.1)",
        overflowY: "auto", // Enable scrolling in the sidebar if needed
      }}
    >
      <h3 style={{ marginBottom: "20px" }}>Sidebar</h3>
      <ul style={{ listStyleType: "none", padding: 0 }}>
        {/* Dashboard */}
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

        {/* Highlight Entity with Submenu */}
        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("highlight-entity")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: "space-between",
              alignItems: "center",
            }}
          >
            Highlight Entity
            <span>{openSubMenu === "highlight-entity" ? "-" : "+"}</span>
          </div>
          {openSubMenu === "highlight-entity" && (
            <ul style={{ listStyleType: "none", padding: "10px", paddingLeft: "20px" }}>
              <li style={{ marginBottom: "10px" }}>
                <Link
                  to="/highlight-entity/sub-item-1"
                  style={{ color: "white", textDecoration: "none" }}
                >
                  Sub Item 01
                </Link>
              </li>
              <li style={{ marginBottom: "10px" }}>
                <Link
                  to="/highlight-entity/sub-item-2"
                  style={{ color: "white", textDecoration: "none" }}
                >
                  Sub Item 02
                </Link>
              </li>
              <li style={{ marginBottom: "10px" }}>
                <Link
                  to="/highlight-entity/sub-item-3"
                  style={{ color: "white", textDecoration: "none" }}
                >
                  Sub Item 03
                </Link>
              </li>
            </ul>
          )}
        </li>

        {/* Detect Long Sentence */}
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

        {/* Keyword Extractor */}
        <li
          style={{
            marginBottom: "10px",
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

        {/* Blacklist Detector */}
        <li
          style={{
            marginBottom: "10px",
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
