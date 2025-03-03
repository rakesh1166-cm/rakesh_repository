import React, { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { generateText } from "../actions"; // Import the Redux action
import Sidebar from "./Sidebar";
import Nav from "./Nav";
import TextProcessingPanel from "./TextProcessingPanel";


const NlpTools = () => {
  const [text, setText] = useState(""); // State for user input
  const [feature, setFeature] = useState(""); // Selected feature
  const [additionalInput, setAdditionalInput] = useState({}); // Additional input for specific features
  const generatedText = useSelector((state) => state.generatedText || "");
   
  const [isModalOpen, setIsModalOpen] = useState(false); // Modal visibility
  const [modalData, setModalData] = useState({   
    second_text: "",
    question: "",
    num_clusters: 3,
    target_language: "",
    entity_type: "",
    reordering_criteria: "",
    bias_type: "",
    classification_type: "",
    classification_method: "",    
    custom_labels: "",
    model_file: null,
    sentiment_type: "", // General, Emotion-Based, Aspect-Based
    review_text: "",
    aspects: [], // For Aspect-Based Sentiment
    review_category: "", // Product, Service, Experience
    sentiment_model: "", // Add this field for selecting sentiment analysis model  
     extraction_method: "", // Method for extracting information (regex, NLP, heuristics, etc.)
     translation_method: "",
     reordering_method: "", // New field for reordering method
     custom_criteria: "", // Optional field for custom criteria
     summarization_type: "", // Extractive or Abstractive
     summarization_method: "", // NLP, Pre-trained Model, etc.
     max_length: 100, // Maximum length of the summary
     focus_area: "", // Optional focus area
  }); // Modal input data
  const error = useSelector((state) => state.textManipulation?.error || null); // Access the error from Redux state
    const loading = useSelector(
      (state) => state.textManipulation?.loading || false
    ); // Access the loading state from Redux state
  
    console.log("Current state - Text:", text);
    console.log("Selected feature:", feature);
    console.log("Processed text from Redux state:", generatedText);
    console.log("Loading state:", loading);
    console.log("Error state:", error);
  const categoryEntityLabels = {
    food_delivery: ["PRODUCT", "ORG", "TIME", "LOCATION", "ISSUES"],
    e_commerce: ["ORG", "PRODUCT", "PRICE", "BRAND", "CUSTOMER_FEEDBACK"],
    travel_booking: ["PERSON", "GPE", "DATE", "AIRLINE", "BOOKING_ID"],
    healthcare: ["PERSON", "DIAGNOSIS", "ORG", "PRESCRIBED_MEDS", "HOSPITAL"],
    legal_documents: ["ORG", "PERSON", "LAW_REFERENCE", "CASE_NUMBER", "VERDICT"],
    education: ["ORG", "TOPIC", "PERSON", "GRADE", "REMARKS"],
    entertainment: ["MOVIE", "GENRE", "PERSON", "RATING", "RECOMMENDATIONS"],
    real_estate: ["LOCATION", "PRICE", "PROPERTY_TYPE", "AMENITIES", "SELLER"],
    retail: ["PRODUCT", "ORG", "CUSTOMER_FEEDBACK", "STORE", "IMPROVEMENT_AREAS"],
    finance: ["MONEY", "ORG", "TRANSACTION_ID", "TYPE", "STATUS"],
    sports: ["TEAM", "EVENT", "SCORE", "PLAYER", "HIGHLIGHTS"],
  };
  const dispatch = useDispatch();
 
  useEffect(() => {
    console.log("Feature changed to:", feature);
  }, [feature]); // This will run every time the 'feature' state is updated

  const handleProcessText = () => {
    if (!feature) {
      alert("Please select a feature to process!");
      return;
    }

    const payload = { text, ...additionalInput };
    console.log(payload)
    console.log("payload is not fghf")
    dispatch(generateText(feature, payload)); // Dispatch the action to process text
  };

  const openModal = (modalType) => {
    setFeature(modalType); // Set the new feature
    setModalData({}); // Reset modalData to ensure no stale values are passed
    setIsModalOpen(true); // Open the modal
};



  const closeModal = () => setIsModalOpen(false);

  const handleFeatureSelection = (selectedFeature) => {
    setFeature(selectedFeature); // Set the selected feature
    console.log("feature coming")
    console.log(feature)
    const payload = { text, ...additionalInput };
    dispatch(generateText(selectedFeature, payload)); // Dispatch the action to process the text
  };

  const handleModalSubmit = () => {
    console.log("what is handleModalSubmit");
    console.log("Selected Feature:", feature);
    
    let updatedInput = {};

    if (feature === "summarization") {
        updatedInput = {
            summarization_type: modalData.summarization_type,
            summarization_method: modalData.summarization_method,
            max_length: modalData.max_length,
            focus_area: modalData.focus_area,
        };
    } else if (feature === "text_similarity") {
        updatedInput = { second_text: modalData.second_text };
    } else if (feature === "question_answering") {
        updatedInput = { question: modalData.question };
    } else if (feature === "text_clustering") {
        updatedInput = { num_clusters: modalData.num_clusters };
    } else if (feature === "translation") {
        updatedInput = {
            target_language: modalData.target_language,
            translation_method: modalData.translation_method,
        };
    } else if (feature === "relation_extraction") {
        updatedInput = { entity_type: modalData.entity_type };
    } else if (feature === "sentence_reordering") {
        updatedInput = {
            reordering_criteria: modalData.reordering_criteria,
            reordering_method: modalData.reordering_method,
        };
    } else if (feature === "gender_bias_detection") {
        updatedInput = { bias_type: modalData.bias_type };
    } else if (feature === "text_classification") {
        updatedInput = {
            classification_type: modalData.classification_type,
            classification_method: modalData.classification_method, 
            custom_labels: modalData.custom_labels
                ? modalData.custom_labels.split(",").map((label) => label.trim()) 
                : [],
            model_file: modalData.model_file, 
        };
    } else if (feature === "advanced_sentiment_review") {
        updatedInput = {
            sentiment_type: modalData.sentiment_type,
            review_text: modalData.review_text,
            aspects: modalData.aspects,
            review_category: modalData.review_category,
            sentiment_model: modalData.sentiment_model,
        };
    }

    setAdditionalInput(updatedInput);  // Update the state
};

// **Use `useEffect` to process text when `additionalInput` updates**
useEffect(() => {
    if (Object.keys(additionalInput).length > 0) {
        const payload = { text, ...additionalInput };
        console.log("Payload being sent:", payload);
        handleProcessText();
        closeModal();
    }
}, [additionalInput]); // Runs when `additionalInput` changes


    const lines =
    generatedText["Numbered lines"] ||
    generatedText["processed_text"] ||
    [];
  return (
    <div style={{ display: "flex", flexDirection: "row", height: "100vh" }}>
      <Sidebar style={{ flex: "0 0 250px" }} />
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        <Nav style={{ flex: "0 0 60px" }} />
        <TextProcessingPanel
  text={text}
  setText={setText}
  feature={feature}
  setFeature={setFeature}
  openModal={openModal}
  handleProcessText={handleProcessText}
  generatedText={generatedText}
  isModalOpen={isModalOpen}
  lines={lines} // Pass lines to the panel
  closeModal={closeModal}
  handleModalSubmit={handleModalSubmit} // Add this line
  modalData={modalData}
  setModalData={setModalData}
  categoryEntityLabels={categoryEntityLabels} // Pass the actual categoryEntityLabels object
  handleFeatureSelection={handleFeatureSelection} // Pass this new method to handle feature selection
/>
      </div>
    </div>
  );
};

export default NlpTools;
