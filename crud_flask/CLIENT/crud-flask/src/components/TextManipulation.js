import React, { useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { processTextFeature } from "../actions"; // Import the Redux action
import Sidebar from "./Sidebar";
import Nav from "./Nav";

const TextManipulation = () => {
  const [text, setText] = useState(""); // State for user input
  const [feature, setFeature] = useState(""); // Selected feature

  const dispatch = useDispatch();
  const processedText = useSelector((state) => state.processedText || []); // Access processed text directly from root
  const error = useSelector((state) => state.textManipulation?.error || null); // Access the error from Redux state
  const loading = useSelector(
    (state) => state.textManipulation?.loading || false
  ); // Access the loading state from Redux state

  console.log("Current state - Text:", text);
  console.log("Selected feature:", feature);
  console.log("Processed text from Redux state:", processedText);
  console.log("Loading state:", loading);
  console.log("Error state:", error);
  const handleProcessText = () => {
    if (!feature) {
      alert("Please select a feature to process!");
      return;
    }

    if (!text.trim()) {
      alert("Please enter text to process!");
      return;
    }

    const payload = { text };
    dispatch(processTextFeature(feature, payload)); // Dispatch the action to process text
  };

  const handleFeatureChange = (selectedFeature) => {
    setFeature(selectedFeature);
    dispatch({ type: "RESET_TEXT_PROCESSING" }); // Ensure to define this action in Redux
  };

  const formatFeatureName = (feature) => {
    const featureMap = {
      trim_whitespace: "Trim Whitespace",
      line_numbering: "Line Numbering",
      remove_duplicate_lines_sort: "Remove Duplicate Lines and Sort",
      remove_spaces_each_line: "Remove Spaces from Each Line",
      replace_space_with_dash: "Replace SPACE with Dash (-)",
      ascii_unicode_conversion: "ASCII/Unicode Conversion",
      count_words_characters: "Count Words and Characters",
      reverse_lines_words: "Reverse Lines or Words",
      remove_blank_lines: "Remove Blank Lines",
    };

    return featureMap[feature] || "Unknown Feature";
  };

  const styles = {
    textarea: {
      width: "100%",
      height: "150px",
      marginTop: "10px",
      padding: "10px",
      border: "1px solid #ccc",
      borderRadius: "4px",
      backgroundColor: "#f9f9f9",
    },
    button: {
      padding: "10px 20px",
      backgroundColor: "#007bff",
      color: "#fff",
      border: "none",
      borderRadius: "4px",
      cursor: "pointer",
    },
    error: {
      color: "red",
    },
    featureDescription: {
      fontWeight: "bold",
      marginBottom: "10px",
    },
  };
  const lines =
    processedText["Numbered lines"] ||
    processedText["processed_text"] ||
    [];

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
          <h1 style={{ marginBottom: "20px" }}>Text Manipulation</h1>
          <p>Select a feature and manipulate your text below:</p>
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

          <div style={{ marginBottom: "20px" }}>
            <div style={{ display: "flex", gap: "20px", alignItems: "center" }}>
            <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
                <input
                  type="radio"
                  name="feature"
                  value="trim_whitespace"
                  onChange={() => handleFeatureChange("trim_whitespace")}
                />
                Trim Whitespace
              </label>
              <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
                <input
                  type="radio"
                  name="feature"
                  value="line_numbering"
                  onChange={() => handleFeatureChange("line_numbering")}
                />
                Line Numbering
              </label>
              <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
                <input
                  type="radio"
                  name="feature"
                  value="remove_duplicate_lines_sort"
                  onChange={() => handleFeatureChange("remove_duplicate_lines_sort")}
                />
                Remove Duplicate Lines and Sort
              </label>
              <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
                <input
                  type="radio"
                  name="feature"
                  value="remove_spaces_each_line"
                  onChange={() => handleFeatureChange("remove_spaces_each_line")}
                />
                Remove Spaces from Each Line
              </label>
              <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
                <input
                  type="radio"
                  name="feature"
                  value="replace_space_with_dash"
                  onChange={() => handleFeatureChange("replace_space_with_dash")}
                />
                Replace SPACE with Dash (-)
              </label>
              </div>
              <div style={{ display: "flex", gap: "20px", alignItems: "center" }}>
              <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
                <input
                  type="radio"
                  name="feature"
                  value="ascii_unicode_conversion"
                  onChange={() => handleFeatureChange("ascii_unicode_conversion")}
                />
                ASCII/Unicode Conversion
              </label>
              <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
                <input
                  type="radio"
                  name="feature"
                  value="count_words_characters"
                  onChange={() => handleFeatureChange("count_words_characters")}
                />
                Count Words and Characters
              </label>
              <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
                <input
                  type="radio"
                  name="feature"
                  value="reverse_lines_words"
                  onChange={() => handleFeatureChange("reverse_lines_words")}
                />
                Reverse Lines or Words
              </label>
              <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
                <input
                  type="radio"
                  name="feature"
                  value="remove_blank_lines"
                  onChange={() => handleFeatureChange("remove_blank_lines")}
                />
                Remove Blank Lines
              </label>
            </div>
          </div>

          <button
            onClick={handleProcessText}
            disabled={loading}
            style={{
              ...styles.button,
              backgroundColor: loading ? "#ccc" : styles.button.backgroundColor,
            }}
          >
            {loading ? "Processing..." : "Process Text"}
          </button>

          {lines.length > 0 ? (
            <ul>
              {lines.map((line, index) => (
                <li key={index}>{line.trim() ? line.trim() : "Empty Line"}</li>
              ))}
            </ul>
          ) : (
            <p>No processed text available.</p>
          )}
        </div>
      </div>
    </div>
  );
};

export default TextManipulation;
