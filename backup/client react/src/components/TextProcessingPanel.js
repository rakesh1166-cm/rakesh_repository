import React from "react";

const TextProcessingPanel = ({
  text,
  setText,
  feature,
  setFeature,
  openModal,
  handleProcessText,
  handleModalSubmit, // Include this prop
  lines, // Receive lines as a prop
  generatedText,
  isModalOpen,
  closeModal,
  modalData,
  setModalData,
  categoryEntityLabels,
  handleFeatureSelection,  // Added prop
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
          <h1 style={{ marginBottom: "20px" }}>NLP Tools</h1>
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
      onChange={() => handleFeatureSelection("find_toxic_words")} 
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
      onChange={() => handleFeatureSelection("topic_extraction")}
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
      onChange={() =>handleFeatureSelection("language_detection")} 
    />
    Language Detection
  </label>
  <label style={{ display: 'flex', alignItems: 'center', gap: '5px', whiteSpace: 'nowrap' }}>
    <input
      type="radio"
      name="feature"
      value="fake_news_detection"
      onChange={() =>handleFeatureSelection("fake_news_detection")}  
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

         
          <h2 style={{ marginTop: "20px" }}>Output:</h2>
{generatedText && generatedText.length > 0 ? (
  generatedText.map((result, index) => {
    const feature = Object.keys(result)[0]; // Get the feature name
    const summary = Object.values(result)[0]; // Get the summary text

    return (
      <div key={index} style={{ marginBottom: "20px" }}>
        <h3>{feature}</h3> {/* Display the feature name */}

        {/* Handle Insight Summary by splitting points into individual lines */}
        {feature === "Insight Summary" ? (
          <ul>
            {summary
              .split("\n") // Assuming points are separated by new lines
              .map((point, idx) => (
                <li key={idx}>{point}</li> // Display each point in a list item
              ))}
          </ul>
        ): feature === "Bullet Point Summary" ? (
          <>
            <h4>Bullet Points:</h4>
            <ul>
              {summary
                .split("\n") // Assuming bullet points are separated by new lines
                .map((point, idx) => (
                  <li key={idx}>{point.trim()}</li> // Trim each bullet point and render it
                ))}
            </ul>
          </>
        ):feature === "Fact-Check Summary" ? (
          <>
            <h4>Fact-Check Summary:</h4>
            <ul>
              {/* Split the summary by newlines or other delimiters for fact and verification */}
              {summary.split("\n").map((line, idx) => (
                <li key={idx}>{line.trim()}</li> // Display each line in a list item
              ))}
            </ul>
          </>
        ) : feature === "Headline Summary" ? (
          <>
            <h4>Headline:</h4>
            <p>{summary.split("\n")[0]}</p> {/* Treat the first line as the headline */}
            <h4>Summary:</h4>
            <p>{summary.split("\n").slice(1).join(" ")}</p> {/* Treat the rest as the summary */}
          </>
        ) : feature === "Keywords" ? (
          <>
            <h4>Keywords:</h4>
            <ul>
              {summary
                .split(",") // Assuming keywords are comma-separated
                .map((keyword, idx) => (
                  <li key={idx}>{keyword.trim()}</li> // Display each keyword in a list item
                ))}
            </ul>
          </>
        ) : (
          <p>{summary}</p> // For other features, just display the text as it is
        )}
      </div>
    );
  })
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
            setModalData({ ...modalData, reordering_criteria: e.target.value }) // Update the reordering_criteria dynamically
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

export default TextProcessingPanel;
