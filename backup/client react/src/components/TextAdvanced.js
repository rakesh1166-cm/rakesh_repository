import React, { useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { processTextFeature } from "../actions"; // Import the Redux action
import Sidebar from "./Sidebar";
import Nav from "./Nav";
import AdvancedTextToolsPanel from "./AdvancedTextToolsPanel";

const TextAdvanced = () => {
  const [text, setText] = useState(""); // State for user input
  const [feature, setFeature] = useState(""); // Selected feature
  const processedText = useSelector((state) => state.processedText || []); // Access processed text directly from root
  const [additionalInput, setAdditionalInput] = useState({}); // Additional input for specific features
  const [isModalOpen, setIsModalOpen] = useState(false); // Modal visibility
  const [modalData, setModalData] = useState({
    find_text: "",
    replace_text: "",
    char_count: 100,
    prefix: "",
    suffix: "",
    case_option: "",
    target_text: "",  
     method: "", // Add method for Find and Replace
     extraction_method: "", // Method for extracting information (regex, NLP, heuristics, etc.)    
     find_text_prefix: "", // New field for prefix
  find_text_suffix: "", // New field for suffix
    
  }); // Modal input data
const error = useSelector((state) => state.textManipulation?.error || null); // Access the error from Redux state
  const loading = useSelector(
    (state) => state.textManipulation?.loading || false
  ); // Access the loading state from Redux state

  console.log("Current state - Text:", text);
  console.log("Selected feature:", feature);
  console.log("Processed text from Redux state:", processedText);
  console.log("Loading state:", loading);
  console.log("Error state:", error);
  const dispatch = useDispatch();
 

  const handleProcessText = () => {
    if (!feature) {
      alert("Please select a feature to process!");
      return;
    }

    const payload = { text, ...additionalInput };
    console.log("come here");
    dispatch(processTextFeature(feature, payload)); // Dispatch the action to process text
  };

  const openModal = (modalType) => {
    setFeature(modalType);
    setIsModalOpen(true);
  };
  const closeModal = () => setIsModalOpen(false);

  const handleModalSubmit = () => {
    // Validate if a feature is selected
    if (!feature) {
      alert("Please select a feature to process!");
      return;
    }
  
    // Prepare the additional input based on the selected feature
    let additionalInput = {};
  
    if (feature === "replace_text") {
      additionalInput = {
        find_text: modalData.find_text,
        replace_text: modalData.replace_text,
        method: modalData.method, // Include the selected method
      };
    } else if (feature === "split_text_by_characters") {
      additionalInput = { char_count: modalData.char_count };
    } else if (feature === "add_prefix_suffix") {
      additionalInput = { prefix: modalData.prefix, suffix: modalData.suffix };
    } else if (feature === "change_case") {
      additionalInput = { case_option: modalData.case_option };
    } else if (feature === "change_case_find") {
      additionalInput = {
        target_text: modalData.target_text,
        case_option: modalData.case_option,
      };
    } else if (feature === "count_words_find") {
      additionalInput = { target_text: modalData.target_text };
    } else if (feature === "extract_information") {
      additionalInput = {
        extraction_method: modalData.extraction_method,
        text_to_extract: modalData.text_to_extract,
      };
   
    }
    else  if (feature === "add_custom_prefix_suffix") { // Update feature name
      additionalInput = {
        find_text_prefix: modalData.find_text_prefix,
        prefix: modalData.prefix,
        find_text_suffix: modalData.find_text_suffix,
        suffix: modalData.suffix,
      };
    }
    // Prepare the payload
    const payload = { text, ...additionalInput };
  
    // Dispatch the action to process the text
    dispatch(processTextFeature(feature, payload));
  
    // Close the modal
    closeModal();
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
        <AdvancedTextToolsPanel
  text={text}
  setText={setText}
  feature={feature}
  openModal={openModal}
  handleProcessText={handleProcessText}
  processedText={processedText}
  isModalOpen={isModalOpen}
  lines={lines} // Pass lines to the panel
  modalData={modalData}
  setModalData={setModalData}
  handleModalSubmit={handleModalSubmit}
  closeModal={closeModal}
/>;
      </div>
    </div>
  );
};

export default TextAdvanced;
