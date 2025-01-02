import React, { useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { processTextFeature } from "../actions"; // Import the Redux action
import Sidebar from "./Sidebar";
import Nav from "./Nav";

const TextManipulation = () => {
  const [text, setText] = useState(""); // State for user input
  const [feature, setFeature] = useState(""); // Selected feature
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
     method: "", // Add method for Find and Replace
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
    if (feature === "replace_text") {
        setAdditionalInput({
          find_text: modalData.find_text,
          replace_text: modalData.replace_text,
          method: modalData.method, // Include the selected method
        });
      } else if (feature === "split_text_by_characters") {
      setAdditionalInput({ char_count: modalData.char_count });
    } else if (feature === "add_prefix_suffix") {
      setAdditionalInput({ prefix: modalData.prefix, suffix: modalData.suffix });
    } else if (feature === "change_case") {
      setAdditionalInput({ case_option: modalData.case_option });
    }
    else if (feature === "summarization") {
        setAdditionalInput({
          summarization_type: modalData.summarization_type,
          summarization_method: modalData.summarization_method,
          max_length: modalData.max_length,
          focus_area: modalData.focus_area,
        })
    }
     else if (feature === "change_case_find") {
      setAdditionalInput({ target_text: modalData.target_text, case_option: modalData.case_option });
    } else if (feature === "count_words_find") {
      setAdditionalInput({ target_text: modalData.target_text });
    } else if (feature === "text_similarity") {
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
                  value="trim_whitespace"
                  onChange={() => setFeature("trim_whitespace")}
                />
                Trim Whitespace
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
                  value="replace_text"
                  onChange={() => openModal("replace_text")}
                />
                Find and Replace
              </label>
              <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
              <input
                type="radio"
                name="feature"
                value="line_numbering"
                onChange={() => setFeature("line_numbering")}
              />
              Line Numbering
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

            <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
              <input
                type="radio"
                name="feature"
                value="line_numbering"
                onChange={() => setFeature("line_numbering")}
              />
              Line Numbering
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
         
           </div>


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
                  value="remove_duplicate_lines_sort"
                  onChange={() => setFeature("remove_duplicate_lines_sort")}
                />
                Remove Duplicate Lines and Sort
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
                  value="remove_spaces_each_line"
                  onChange={() => setFeature("remove_spaces_each_line")}
                />
                Remove Spaces from Each Line
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
                  value="replace_space_with_dash"
                  onChange={() => setFeature("replace_space_with_dash")}
                />
                Replace SPACE with Dash (-)
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
           
           </div>



           <div style={{ display: 'flex', gap: '20px', alignItems: 'center' }}>
          
           <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
              <input
                type="radio"
                name="feature"
                value="ascii_unicode_conversion"
                onChange={() => setFeature("ascii_unicode_conversion")}
              />
              ASCII/Unicode Conversion
            </label>

            {/* New Features */}
            <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
              <input
                type="radio"
                name="feature"
                value="count_words_characters"
                onChange={() => setFeature("count_words_characters")}
              />
              Count Words and Characters sentence or paragraph
            </label>
            <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
              <input
                type="radio"
                name="feature"
                value="reverse_lines_words"
                onChange={() => setFeature("reverse_lines_words")}
              />
              Reverse Lines or Words or sentence
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
            <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
              <input
                type="radio"
                name="feature"
                value="remove_blank_lines"
                onChange={() => setFeature("remove_blank_lines")}
              />
              Remove Blank Lines
            </label>

            </div>

            <div style={{ display: "flex", gap: "20px", alignItems: "center" }}>
            <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
    <input
      type="radio"
      name="feature"
      value="summarization"
      onChange={() => openModal("summarization")}
  
    />
    Summarization
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
  <input
                  type="radio"
                  name="feature"
                  value="text_classification"
                  onChange={() => openModal("text_classification")}
                />
    Text Classification
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
    <input
      type="radio"
      name="feature"
      value="find_toxic_words"
      onChange={() => setFeature("find_toxic_words")}
    />
    Find Toxic Words
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
  <input
                  type="radio"
                  name="feature"
                  value="sentence_reordering"
                  onChange={() => openModal("sentence_reordering")}
                />
    Sentence Reordering
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
    <input
      type="radio"
      name="feature"
      value="topic_extraction"
      onChange={() => setFeature("topic_extraction")}
    />
    Topic Extraction
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
  <input
                  type="radio"
                  name="feature"
                  value="advanced_sentiment_review"
                  onChange={() => openModal("advanced_sentiment_review")}
                />
    Sentiment Analysis
  </label>
</div>

<div style={{ display: "flex", gap: "20px", alignItems: "center" }}>
<label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
<input
                  type="radio"
                  name="feature"
                  value="text_similarity"
                  onChange={() => openModal("text_similarity")}
                />
    Text Similarity
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
  <input
                  type="radio"
                  name="feature"
                  value="question_answering"
                  onChange={() => openModal("question_answering")}
                />
    Extractive Question Answering
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
  <input
                  type="radio"
                  name="feature"
                  value="text_clustering"
                  onChange={() => openModal("text_clustering")}
                />
    Text Clustering
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
    <input
      type="radio"
      name="feature"
      value="language_detection"
      onChange={() => setFeature("language_detection")}
    />
    Language Detection
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
    <input
      type="radio"
      name="feature"
      value="fake_news_detection"
      onChange={() => setFeature("fake_news_detection")}
    />
    Fake News Detection
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
  <input
                  type="radio"
                  name="feature"
                  value="gender_bias_detection"
                  onChange={() => openModal("gender_bias_detection")}
                />
    Gender and Bias Detection
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
  <input
                  type="radio"
                  name="feature"
                  value="relation_extraction"
                  onChange={() => openModal("relation_extraction")}
                />
    Relation Extraction
  </label>

  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
    <input
      type="radio"
      name="feature"
      value="translation"
      onChange={() => openModal("translation")}
    />
    Translation
  </label>
</div>
          </div>

          <button
            onClick={handleProcessText}
            style={{
              padding: "10px 20px",
              backgroundColor: "#007bff",
              color: "#fff",
              border: "none",
              borderRadius: "4px",
              cursor: "pointer",
            }}
          >
            Process Text
          </button>

          <h2 style={{ marginTop: "20px" }}>Output:</h2>
          <textarea
            value={processedText}
            readOnly
            style={{
              width: "100%",
              height: "150px",
              marginTop: "10px",
              padding: "10px",
              border: "1px solid #ccc",
              borderRadius: "4px",
              backgroundColor: "#f9f9f9",
            }}
          ></textarea>

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
               {feature === "text_classification" && (
  <>
    <h3>Text Classification</h3>
    <div style={{ marginBottom: "10px" }}>
      <label>
        Select Classification Type:
        <select
          value={modalData.classification_type}
          onChange={(e) =>
            setModalData({ ...modalData, classification_type: e.target.value })
          }
          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
        >
          <option value="">Select</option>
          <option value="spam_detection">Spam Detection</option>
          <option value="topic_classification">Topic Classification</option>
          <option value="intent_detection">Intent Detection</option>
          <option value="custom">Custom Classification</option>
        </select>
      </label>
    </div>
    {modalData.classification_type && (
      <div style={{ marginBottom: "10px" }}>
        <label>
          Select Classification Method:
          <select
            value={modalData.classification_method}
            onChange={(e) =>
              setModalData({ ...modalData, classification_method: e.target.value })
            }
            style={{ width: "100%", padding: "5px", marginTop: "5px" }}
          >
            <option value="">Select</option>
            <option value="textblob">TextBlob</option>
            <option value="spacy">SpaCy</option>
            <option value="nltk">NLTK</option>
            <option value="huggingface">Hugging Face</option>
            <option value="openai">OpenAI</option>
            <option value="scikit_learn">Scikit-learn</option>
            <option value="fasttext">FastText</option>
          </select>
        </label>
      </div>
    )}
    {modalData.classification_type === "custom" && (
      <div style={{ marginBottom: "10px" }}>
        <label>
          Enter Custom Labels (comma-separated):
          <input
            type="text"
            value={modalData.custom_labels}
            onChange={(e) =>
              setModalData({ ...modalData, custom_labels: e.target.value })
            }
            style={{ width: "100%", padding: "5px", marginTop: "5px" }}
          />
        </label>
        <label>
          Upload Pre-Trained Model:
          <input
            type="file"
            onChange={(e) =>
              setModalData({ ...modalData, model_file: e.target.files[0] })
            }
            style={{ width: "100%", padding: "5px", marginTop: "5px" }}
          />
        </label>
      </div>
    )}
  </>
)}
{feature === "summarization" && (
  <>
    <h3>Summarization</h3>
    <div style={{ marginBottom: "10px" }}>
      <label>
        Select Summarization Type:
        <select
          value={modalData.summarization_type}
          onChange={(e) =>
            setModalData({ ...modalData, summarization_type: e.target.value })
          }
          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
        >
          <option value="">Select</option>
          <option value="extractive">Extractive Summarization</option>
          <option value="abstractive">Abstractive Summarization</option>
        </select>
      </label>
    </div>
    <div style={{ marginBottom: "10px" }}>
      <label>
        Select Summarization Method:
        <select
          value={modalData.summarization_method}
          onChange={(e) =>
            setModalData({ ...modalData, summarization_method: e.target.value })
          }
          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
        >
          <option value="">Select</option>
          <option value="spacy">SpaCy</option>
          <option value="nltk">NLTK</option>
          <option value="huggingface">Hugging Face Transformers</option>
          <option value="openai">OpenAI GPT</option>
        </select>
      </label>
    </div>
    <div style={{ marginBottom: "10px" }}>
      <label>
        Enter Maximum Length (Words/Sentences):
        <input
          type="number"
          value={modalData.max_length}
          onChange={(e) =>
            setModalData({ ...modalData, max_length: e.target.value })
          }
          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
        />
      </label>
    </div>
    <div style={{ marginBottom: "10px" }}>
      <label>
        Focus Area (Optional):
        <input
          type="text"
          value={modalData.focus_area}
          onChange={(e) =>
            setModalData({ ...modalData, focus_area: e.target.value })
          }
          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
        />
      </label>
    </div>
  </>
)}
               {feature === "advanced_sentiment_review" && (
                <>
                  <h3>Advanced Sentiment/Review Analysis</h3>
                  <div style={{ marginBottom: "10px" }}>
                    <label>
                      Select Sentiment Type:
                      <select
                        value={modalData.sentiment_type}
                        onChange={(e) =>
                          setModalData({ ...modalData, sentiment_type: e.target.value })
                        }
                        style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                      >
                        <option value="">Select</option>
                        <option value="general">General Sentiment</option>
                        <option value="emotion_based">Emotion-Based Sentiment</option>
                        <option value="aspect_based">Aspect-Based Sentiment</option>
                      </select>
                    </label>
                  </div>
                  <div style={{ marginBottom: "10px" }}>
                    <label>
                      Enter Review Text:
                      <textarea
                        value={modalData.review_text}
                        onChange={(e) =>
                          setModalData({ ...modalData, review_text: e.target.value })
                        }
                        style={{ width: "100%", height: "100px", padding: "5px", marginTop: "5px" }}
                      ></textarea>
                    </label>
                  </div>
                  {modalData.sentiment_type === "aspect_based" && (
                    <div style={{ marginBottom: "10px" }}>
                      <label>
                        Select Aspects:
                        <select
                          multiple
                          value={modalData.aspects}
                          onChange={(e) =>
                            setModalData({
                              ...modalData,
                              aspects: Array.from(e.target.selectedOptions, (option) => option.value),
                            })
                          }
                          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                        >
                          <option value="service">Service</option>
                          <option value="price">Price</option>
                          <option value="quality">Quality</option>
                          <option value="delivery">Delivery</option>
                        </select>
                      </label>
                    </div>
                  )}
                  <div style={{ marginBottom: "10px" }}>
                    <label>
                      Select Review Category:
                      <select
                        value={modalData.review_category}
                        onChange={(e) =>
                          setModalData({ ...modalData, review_category: e.target.value })
                        }
                        style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                      >
                        <option value="">Select</option>
                        <option value="product">Product Reviews</option>
                        <option value="service">Service Reviews</option>
                        <option value="experience">Experience Reviews</option>
                      </select>
                    </label>
                  </div>
                  <div style={{ marginBottom: "10px" }}>
      <label>
        Select Sentiment Model:
        <select
          value={modalData.sentiment_model}
          onChange={(e) =>
            setModalData({ ...modalData, sentiment_model: e.target.value })
          }
          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
        >
          <option value="">Select</option>
          <option value="huggingface">HuggingFace</option>
          <option value="nltk">NLTK</option>
          <option value="spacy">SpaCy</option>
          <option value="textblob">TextBlob</option>
          <option value="google_cloud">Google Cloud NLP</option>
          <option value="openai_gpt">OpenAI GPT</option>
        </select>
      </label>
    </div>
                </>
              )}
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
               {feature === "text_similarity" && (
                <>
                  <h3>Text Similarity</h3>
                  <div style={{ marginBottom: "10px" }}>
                    <label>
                      Enter Second Text:
                      <textarea
                        value={modalData.second_text}
                        onChange={(e) =>
                          setModalData({ ...modalData, second_text: e.target.value })
                        }
                        style={{ width: "100%", height: "100px", padding: "5px", marginTop: "5px" }}
                      ></textarea>
                    </label>
                  </div>
                </>
              )}
              {feature === "question_answering" && (
                <>
                  <h3>Extractive Question Answering</h3>
                  <div style={{ marginBottom: "10px" }}>
                    <label>
                      Enter Question:
                      <input
                        type="text"
                        value={modalData.question}
                        onChange={(e) =>
                          setModalData({ ...modalData, question: e.target.value })
                        }
                        style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                      />
                    </label>
                  </div>
                </>
              )}
              {feature === "text_clustering" && (
                <>
                  <h3>Text Clustering</h3>
                  <div style={{ marginBottom: "10px" }}>
                    <label>
                      Number of Clusters:
                      <input
                        type="number"
                        value={modalData.num_clusters}
                        onChange={(e) =>
                          setModalData({ ...modalData, num_clusters: e.target.value })
                        }
                        style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                      />
                    </label>
                  </div>
                </>
              )}
           {feature === "translation" && (
  <>
    <h3>Translation</h3>
    <div style={{ marginBottom: "10px" }}>
      <label>
        Select Translation Method:
        <select
          value={modalData.translation_method}
          onChange={(e) =>
            setModalData({ ...modalData, translation_method: e.target.value })
          }
          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
        >
          <option value="">Select</option>
          <option value="textblob">TextBlob</option>
  <option value="spacy">SpaCy</option>
  <option value="google_translate">Google Translate</option>
  <option value="huggingface_transformers">Hugging Face (Transformers)</option>
  <option value="openai">OpenAI (GPT-3/4)</option>
  <option value="deepl">DeepL</option>
  <option value="aws_translate">AWS Translate</option>
  <option value="azure_translate">Azure Translator</option>
        </select>
      </label>
    </div>
    <div style={{ marginBottom: "10px" }}>
      <label>
        Select Target Language:
        <select
          value={modalData.target_language}
          onChange={(e) =>
            setModalData({ ...modalData, target_language: e.target.value })
          }
          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
        >
          <option value="">Select</option>
          <option value="es">Spanish</option>
          <option value="fr">French</option>
          <option value="de">German</option>
          <option value="zh">Chinese</option>
          <option value="hi">Hindi</option>
          <option value="ar">Arabic</option>
          <option value="ja">Japanese</option>
          <option value="ko">Korean</option>
          <option value="it">Italian</option>
          <option value="pt">Portuguese</option>
        </select>
      </label>
    </div>
  </>
)}
             {feature === "relation_extraction" && (
  <>
    <h3>Relation Extraction (NER)</h3>
    <div style={{ marginBottom: "10px" }}>
      <label>
        Select Entity Type:
        <select
          value={modalData.entity_type}
          onChange={(e) => {
            const selectedCategory = e.target.value;
            setModalData({ ...modalData, entity_type: selectedCategory });
          }}
          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
        >
          <option value="">Select a Category</option>
          <option value="food_delivery">Food Delivery Feedback</option>
          <option value="e_commerce">E-Commerce</option>
          <option value="travel_booking">Travel Booking Systems</option>
          <option value="healthcare">Healthcare</option>
          <option value="legal_documents">Legal Document Analysis</option>
          <option value="education">Educational Content Analysis</option>
          <option value="entertainment">Entertainment Recommendations</option>
          <option value="real_estate">Real Estate Listings</option>
          <option value="retail">Retail Store Feedback</option>
          <option value="finance">Financial Transactions</option>
          <option value="sports">Sports Events Analysis</option>
        </select>
      </label>
    </div>

    {/* Dynamically Render Entity Labels as Radio Buttons */}
    {modalData.entity_type && categoryEntityLabels[modalData.entity_type] && (
      <div style={{ marginTop: "10px" }}>
        <h4>Relevant Entity Labels:</h4>
        <div style={{ display: "flex", flexWrap: "wrap", gap: "10px" }}>
          {categoryEntityLabels[modalData.entity_type].map((label, index) => (
            <label
              key={index}
              style={{ display: "flex", alignItems: "center", gap: "5px" }}
            >
              <input
                type="radio"
                name="entityLabel"
                value={label}
                onChange={(e) =>
                  setModalData({ ...modalData, selectedEntityLabel: e.target.value })
                }
              />
              {label}
            </label>
          ))}
        </div>
      </div>
    )}
  </>
)}
             {feature === "sentence_reordering" && (
  <>
    <h3>Sentence Reordering</h3>
    <div style={{ marginBottom: "10px" }}>
      <label>
        Select Reordering Criteria:
        <select
          value={modalData.reordering_criteria}
          onChange={(e) =>
            setModalData({ ...modalData, reordering_criteria: e.target.value })
          }
          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
        >
          <option value="">Select</option>
          <option value="importance">Importance</option>
          <option value="coherence">Coherence</option>
          <option value="readability">Readability</option>
          <option value="semantic_similarity">Semantic Similarity</option>
          <option value="chronological_order">Chronological Order</option>
          <option value="custom">Custom Reordering</option>
        </select>
      </label>
    </div>

    {/* Allow the user to input custom criteria if "custom" is selected */}
    {modalData.reordering_criteria === "custom" && (
      <div style={{ marginBottom: "10px" }}>
        <label>
          Define Custom Criteria:
          <textarea
            value={modalData.custom_criteria}
            onChange={(e) =>
              setModalData({ ...modalData, custom_criteria: e.target.value })
            }
            style={{ width: "100%", height: "100px", padding: "5px", marginTop: "5px" }}
          ></textarea>
        </label>
      </div>
    )}

    {/* Add method selection */}
    <div style={{ marginBottom: "10px" }}>
      <label>
        Select Reordering Method:
        <select
          value={modalData.reordering_method}
          onChange={(e) =>
            setModalData({ ...modalData, reordering_method: e.target.value })
          }
          style={{ width: "100%", padding: "5px", marginTop: "5px" }}
        >
          <option value="">Select</option>
          <option value="nlp">NLP-based (SpaCy, NLTK, etc.)</option>
          <option value="embedding">Embeddings (e.g., BERT, SentenceTransformers)</option>
          <option value="tfidf">TF-IDF Similarity</option>
          <option value="rank_bm25">Rank-BM25</option>
          <option value="openai_gpt">OpenAI GPT-based Reordering</option>
          <option value="llm">LLM-based (Large Language Model)</option>
          <option value="rule_based">Rule-Based Reordering</option>
        </select>
      </label>
    </div>
  </>
)}
              {feature === "gender_bias_detection" && (
                <>
                  <h3>Gender and Bias Detection</h3>
                  <div style={{ marginBottom: "10px" }}>
                    <label>
                      Select Bias Type:
                      <select
                        value={modalData.bias_type}
                        onChange={(e) =>
                          setModalData({ ...modalData, bias_type: e.target.value })
                        }
                        style={{ width: "100%", padding: "5px", marginTop: "5px" }}
                      >
                        <option value="">Select</option>
                        <option value="gender">Gender</option>
                        <option value="racial">Racial</option>
                        <option value="age">Age</option>
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
      </div>
    </div>
  );
};

export default TextManipulation;
