import React, { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { highlightEntity, fetchAllEntities } from "../actions"; // Import fetchAllEntities action
import Sidebar from "./Sidebar";
import Nav from "./Nav";


const HighlightEntity = () => {
  const [text, setText] = useState(""); // State for user input
  const dispatch = useDispatch();
  const highlightedEntities = useSelector((state) => state.highlightedEntities);
  const allEntities = useSelector((state) => state.allEntities); // Get all entities from Redux state

  const handleHighlightEntity = () => {
    dispatch(highlightEntity(text)); // Dispatch the highlightEntity action
  };

  useEffect(() => {
    dispatch(fetchAllEntities()); // Fetch all database rows on component mount
  }, [dispatch]);

  return (
    <div style={{ display: "flex", flexDirection: "row", height: "100vh" }}>
      <Sidebar style={{ flex: "0 0 250px" }} />
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        <Nav style={{ flex: "0 0 60px" }} />
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

          <div style={{ marginTop: "20px" }}>
            <h2>Highlighted Sentences and Entities:</h2>
            {highlightedEntities && highlightedEntities.length > 0 ? (
              <ul>
                {highlightedEntities.map((item, index) => (
                  <li key={index}>
                    <strong>Sentence:</strong> {item.sentence}
                    <ul>
                      {item.entities.map((entity, entityIndex) => (
                        <li key={entityIndex}>
                          {entity.text} ({entity.label})
                        </li>
                      ))}
                    </ul>
                  </li>
                ))}
              </ul>
            ) : (
              <p>No sentences or entities highlighted yet.</p>
            )}
          </div>

          <div style={{ marginTop: "20px" }}>
            <h2>Database Records:</h2>
            {allEntities.length > 0 ? (
              <table style={{ width: "100%", borderCollapse: "collapse" }}>
                <thead>
                  <tr>
                    <th style={{ border: "1px solid #ccc", padding: "8px" }}>ID</th>
                    <th style={{ border: "1px solid #ccc", padding: "8px" }}>Text</th>
                    <th style={{ border: "1px solid #ccc", padding: "8px" }}>Sentence</th>
                    <th style={{ border: "1px solid #ccc", padding: "8px" }}>Entities</th>
                    <th style={{ border: "1px solid #ccc", padding: "8px" }}>TextID</th>
                  </tr>
                </thead>
                <tbody>
                  {allEntities.map((entity) => (
                    <tr key={entity.id}>
                      <td style={{ border: "1px solid #ccc", padding: "8px" }}>{entity.id}</td>
                      <td style={{ border: "1px solid #ccc", padding: "8px" }}>{entity.text}</td>
                      <td style={{ border: "1px solid #ccc", padding: "8px" }}>{entity.sentence}</td>
                      <td style={{ border: "1px solid #ccc", padding: "8px" }}>
                        {entity.org
                          ? entity.org.map((e) => `${e.entity_text} (${e.entity_label})`).join(", ")
                          : "No entities"}
                      </td>
                      <td style={{ border: "1px solid #ccc", padding: "8px" }}>{entity.textid}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            ) : (
              <p>No database records found.</p>
            )}
          </div>
        </div>
      
      </div>
    </div>
  );
};

export default HighlightEntity;