import React from "react";

const AdvancedTextToolsPanel = ({
  text,
  setText,
  feature,
  openModal,
  handleProcessText,
  processedText,
  isModalOpen,
  modalData,
  lines, // Receive lines as a prop
  setModalData,
  handleModalSubmit,
  closeModal,
}) => {
  return (
    <div
    style={{
      flex: 1,
      padding: "20px",
      backgroundColor: "#f4f4f4",
      overflowY: "auto",
    }}
  >
    <h1 style={{ marginBottom: "20px" }}>Text Advanced Tools</h1>
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
      {/* Feature Selection */}
      <div style={{ display: "flex", gap: "20px", alignItems: "center" }}>
      
        <label
          style={{
            display: "flex",
            alignItems: "center",
            gap: "5px",
            whiteSpace: "nowrap",
          }}
        >
           <input
            type="radio"
            name="feature"
            value="replace_text"
            onChange={() => openModal("replace_text")}
          />
          Find and Replace
        </label>
       
      <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
        <input
          type="radio"
          name="feature"
          value="extract_information"
          onChange={() => openModal("extract_information")}
         
        />
        Extract Emails & URLs
      </label>

     
  
    <label
          style={{
            display: "flex",
            alignItems: "center",
            gap: "5px",
            whiteSpace: "nowrap",
          }}
        >
           <input
            type="radio"
            name="feature"
            value="split_text_by_characters"
            onChange={() => openModal("split_text_by_characters")}
          />
          Split Text by Characters
        </label>
        <label
          style={{
            display: "flex",
            alignItems: "center",
            gap: "5px",
            whiteSpace: "nowrap",
          }}
        >
          <input
            type="radio"
            name="feature"
            value="change_case"
            onChange={() => openModal("change_case")}
          />
          Change Case
        </label>
        <label
          style={{
            display: "flex",
            alignItems: "center",
            gap: "5px",
            whiteSpace: "nowrap",
          }}
        >
           <input
            type="radio"
            name="feature"
            value="change_case_find"
            onChange={() => openModal("change_case_find")}
          />
          Change Case by Find
        </label>
        <label
          style={{
            display: "flex",
            alignItems: "center",
            gap: "5px",
            whiteSpace: "nowrap",
          }}
        >
          <input
            type="radio"
            name="feature"
            value="count_words_find"
            onChange={() => openModal("count_words_find")}
          />
          Count Words by Find
        </label>
        <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
      <input
            type="radio"
            name="feature"
            value="add_prefix_suffix"
            onChange={() => openModal("add_prefix_suffix")}
          />
        Add Prefix/Suffix to Lines
      </label>         
    </div>
    </div>
   

    <h2 style={{ marginTop: "20px" }}>Output:</h2>
    {lines.length > 0 ? (
            <ul>
              {lines.map((line, index) => (
                <li key={index}>{line.trim() ? line.trim() : "Empty Line"}</li>
              ))}
            </ul>
          ) : (
            <p>No processed text available.</p>
          )}
    {/* Modal for "Find and Replace" */}
    {isModalOpen && (
      <div
        style={{
          position: "fixed",
          top: "50%",
          left: "50%",
          transform: "translate(-50%, -50%)",
          backgroundColor: "#fff",
          padding: "20px",
          borderRadius: "8px",
          boxShadow: "0 4px 8px rgba(0, 0, 0, 0.2)",
          zIndex: 1000,
        }}
      >
      
       {feature === "replace_text" && (
          <>
            <h3>Find and Replace</h3>
            <div style={{ marginBottom: "10px" }}>
            <label>
              Find Text:
              <input
                type="text"
                value={modalData.find_text}
                onChange={(e) =>
                  setModalData({ ...modalData, find_text: e.target.value })
                }
                style={{ width: "100%", padding: "5px", marginTop: "5px" }}
              />
            </label>
            <label>
              Replace Text:
              <input
                type="text"
                value={modalData.replace_text}
                onChange={(e) =>
                  setModalData({ ...modalData, replace_text: e.target.value })
                }
                style={{ width: "100%", padding: "5px", marginTop: "5px" }}
              />
            </label>
            </div>
            <div style={{ marginBottom: "10px" }}>
<label>
  Select Method:
  <select
    value={modalData.method}
    onChange={(e) =>
      setModalData({ ...modalData, method: e.target.value })
    }
    style={{ width: "100%", padding: "5px", marginTop: "5px" }}
  >
   <option value="">Select</option>
<option value="python">Python</option>
<option value="regex">Regular Expression (RegEx)</option>
<option value="nlp">Natural Language Processing (NLP)</option>
<option value="string_matching">Simple String Matching</option>
<option value="case_insensitive">Case-Insensitive Matching</option>
<option value="fuzzy_matching">Fuzzy Matching</option>
<option value="machine_learning">Machine Learning</option>
<option value="custom_logic">Custom Logic</option>
<option value="template_based">Template-Based Replacement</option>
<option value="semantic_search">Semantic Search</option>
<option value="ai_powered">AI-Powered Replacement</option>
  </select>
</label>
</div>
          </>
        )}

{feature === "extract_information" && (
<>
<h3>Extract Emails & URLs</h3>
<div style={{ marginBottom: "10px" }}>
<label>
  Select Extraction Method:
  <select
    value={modalData.extraction_method}
    onChange={(e) =>
      setModalData({ ...modalData, extraction_method: e.target.value })
    }
    style={{ width: "100%", padding: "5px", marginTop: "5px" }}
  >
    <option value="">Select</option>
    <option value="regex">Regular Expression (RegEx)</option>
    <option value="nlp">Natural Language Processing (NLP)</option>
    <option value="heuristics">Heuristics</option>
    <option value="ai">AI-Powered Extraction</option>
  </select>
</label>
</div>
</>
        )}
{feature === "count_words_find" && (
          <>
            <h3>Count Words by Find</h3>
            <div style={{ marginBottom: "10px" }}>
              <label>
                Find Text/Word/Sentence:
                <input
                  type="text"
                  value={modalData.target_text}
                  onChange={(e) =>
                    setModalData({ ...modalData, target_text: e.target.value })
                  }
                  style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                />
              </label>
            </div>
          </>
        )}

{feature === "split_text_by_characters" && (
          <>
            <h3>Split Text by Characters</h3>
            <div style={{ marginBottom: "10px" }}>
            <label>
              Character Count:
              <input
                type="number"
                value={modalData.char_count}
                onChange={(e) =>
                  setModalData({ ...modalData, char_count: e.target.value })
                }
                style={{ width: "100%", padding: "5px", marginTop: "5px" }}
              />
            </label>
            </div>
          </>
        )}
      {feature === "add_prefix_suffix" && (
          <>
            <h3>Add Prefix/Suffix to Lines</h3>
            <div style={{ marginBottom: "10px" }}>
              <label>
                Prefix:
                <input
                  type="text"
                  value={modalData.prefix}
                  onChange={(e) =>
                    setModalData({ ...modalData, prefix: e.target.value })
                  }
                  style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                />
              </label>
              <label>
                Suffix:
                <input
                  type="text"
                  value={modalData.suffix}
                  onChange={(e) =>
                    setModalData({ ...modalData, suffix: e.target.value })
                  }
                  style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                />
              </label>
            </div>
          </>
        )}

{feature === "change_case" && (
          <>
            <h3>Change Case</h3>
            <div style={{ marginBottom: "10px" }}>
              <label>
                Select Case Option:
                <select
                  value={modalData.case_option}
                  onChange={(e) =>
                    setModalData({ ...modalData, case_option: e.target.value })
                  }
                  style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                >
                  <option value="">Select</option>
                  <option value="uppercase">Uppercase</option>
                  <option value="lowercase">Lowercase</option>
                  <option value="capitalize">Capitalize</option>
                </select>
              </label>
            </div>
          </>
        )}
        {feature === "change_case_find" && (
          <>
            <h3>Change Case by Find</h3>
            <div style={{ marginBottom: "10px" }}>
              <label>
                Find Text/Word/Sentence:
                <input
                  type="text"
                  value={modalData.target_text}
                  onChange={(e) =>
                    setModalData({ ...modalData, target_text: e.target.value })
                  }
                  style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                />
              </label>
              <label>
                Select Case Option:
                <select
                  value={modalData.case_option}
                  onChange={(e) =>
                    setModalData({ ...modalData, case_option: e.target.value })
                  }
                  style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                >
                  <option value="">Select</option>
                  <option value="uppercase">Uppercase</option>
                  <option value="lowercase">Lowercase</option>
                  <option value="capitalize">Capitalize</option>
                </select>
              </label>
            </div>
          </>
        )}

        <button
          onClick={handleModalSubmit}
          style={{
            padding: "10px",
            marginRight: "10px",
            backgroundColor: "#007bff",
            color: "#fff",
            border: "none",
            borderRadius: "4px",
            cursor: "pointer",
          }}
        >
          Submit
        </button>
        <button
          onClick={closeModal}
          style={{
            padding: "10px",
            backgroundColor: "#ccc",
            border: "none",
            borderRadius: "4px",
            cursor: "pointer",
          }}
        >
          Cancel
        </button>
      </div>
    )}

    {/* Modal Overlay */}
    {isModalOpen && (
      <div
        onClick={closeModal}
        style={{
          position: "fixed",
          top: 0,
          left: 0,
          width: "100%",
          height: "100%",
          backgroundColor: "rgba(0, 0, 0, 0.5)",
          zIndex: 999,
        }}
      />
    )}
  </div>
  );
};

export default AdvancedTextToolsPanel;
