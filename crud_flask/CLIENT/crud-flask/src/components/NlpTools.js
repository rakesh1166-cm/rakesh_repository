import React, { useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { processTextFeature } from "../actions"; // Import the Redux action
import Sidebar from "./Sidebar";
import Nav from "./Nav";
import TextProcessingPanel from "./TextProcessingPanel";


const NlpTools = () => {
  const [text, setText] = useState(""); // State for user input
  const [feature, setFeature] = useState(""); // Selected feature
  const [additionalInput, setAdditionalInput] = useState({}); // Additional input for specific features
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
  const processedText = useSelector((state) => state.textManipulation?.processedText || ""); // Updated state access

  const handleProcessText = () => {
    if (!feature) {
      alert("Please select a feature to process!");
      return;
    }

    const payload = { text, ...additionalInput };
    dispatch(processTextFeature(feature, payload)); // Dispatch the action to process text
  };

  const openModal = (modalType) => {
    setFeature(modalType);
    setIsModalOpen(true);
  };
  const closeModal = () => setIsModalOpen(false);

  const handleModalSubmit = () => {
  
     if (feature === "summarization") {
        setAdditionalInput({
          summarization_type: modalData.summarization_type,
          summarization_method: modalData.summarization_method,
          max_length: modalData.max_length,
          focus_area: modalData.focus_area,
        })
    }
     else if (feature === "text_similarity") {
      setAdditionalInput({ second_text: modalData.second_text });
    } else if (feature === "question_answering") {
      setAdditionalInput({ question: modalData.question });
    } else if (feature === "text_clustering") {
      setAdditionalInput({ num_clusters: modalData.num_clusters });
    } else if (feature === "translation") {
        setAdditionalInput({
          target_language: modalData.target_language,
          translation_method: modalData.translation_method,
        });
      } else if (feature === "relation_extraction") {
      setAdditionalInput({ entity_type: modalData.entity_type });
    } else if (feature === "sentence_reordering") {
        setAdditionalInput({
          reordering_criteria: modalData.reordering_criteria,
          reordering_method: modalData.reordering_method,
          ...(modalData.custom_criteria && { custom_criteria: modalData.custom_criteria }), // Include custom criteria if available
        });
      } else if (feature === "gender_bias_detection") {
      setAdditionalInput({ bias_type: modalData.bias_type });
    }else if (feature === "text_classification") {
        setAdditionalInput({
          classification_type: modalData.classification_type,
          classification_method: modalData.classification_method, // Include the selected classification method
          custom_labels: modalData.custom_labels
            ? modalData.custom_labels.split(",").map((label) => label.trim()) // Handle custom labels
            : [],
          model_file: modalData.model_file, // Pre-trained model file, if provided
        });
      } else if (feature === "advanced_sentiment_review") {
        setAdditionalInput({
          sentiment_type: modalData.sentiment_type,
          review_text: modalData.review_text,
          aspects: modalData.aspects,
          review_category: modalData.review_category,
          sentiment_model: modalData.sentiment_model, // Add the selected model
        });
      }
      if (feature === "extract_information") {
        setAdditionalInput({
          extraction_method: modalData.extraction_method,
          text_to_extract: modalData.text_to_extract,
        });
       
      }
      closeModal();
    };


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
  processedText={processedText}
  isModalOpen={isModalOpen}
  closeModal={closeModal}
  handleModalSubmit={handleModalSubmit} // Add this line
  modalData={modalData}
  setModalData={setModalData}
  categoryEntityLabels={categoryEntityLabels} // Pass the actual categoryEntityLabels object
/>
      </div>
    </div>
  );
};

export default NlpTools;
