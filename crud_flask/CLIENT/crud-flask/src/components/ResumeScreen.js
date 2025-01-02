// ResumeScreen.js
import React, { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { extractResumeInfo } from "../actions"; // Import Redux action
import Sidebar from "./Sidebar";
import Nav from "./Nav";
import Footer from "./Footer";

const ResumeScreen = () => {
  const [file, setFile] = useState(null);
  const dispatch = useDispatch();
  const extractedInfo = useSelector((state) => state.extractedInfo); // Get extracted info from Redux state

  const handleFileChange = (event) => {
    setFile(event.target.files[0]);
  };

  const handleExtractInformation = () => {
    if (!file) {
      alert("Please upload a file first.");
      return;
    }

    const reader = new FileReader();
    reader.onload = (e) => {
      const fileContent = e.target.result;
      dispatch(extractResumeInfo(fileContent)); // Dispatch action with file content
    };
    reader.readAsText(file);
  };

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
          <h1>Resume Screen</h1>
          <div style={{ marginBottom: "20px" }}>
            <input
              type="file"
              accept=".pdf,.doc,.docx,.txt"
              onChange={handleFileChange}
            />
          </div>
          <button
            style={{ padding: "10px 20px", cursor: "pointer" }}
            onClick={handleExtractInformation}
          >
            Extract Information
          </button>
          {extractedInfo && (
            <div style={{ marginTop: "20px" }}>
              <h2>Extracted Information:</h2>
              <pre>{JSON.stringify(extractedInfo, null, 2)}</pre>
            </div>
          )}
        </div>
        <Footer style={{ flex: "0 0 50px" }} />
      </div>
    </div>
  );
};

export default ResumeScreen;
