import React, { useState } from "react";
import { Link } from "react-router-dom";

const Sidebar = () => {
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [openSubMenu, setOpenSubMenu] = useState(null);

  const toggleSubMenu = (menu) => {
    setOpenSubMenu(openSubMenu === menu ? null : menu);
  };

  const handleToggleSidebar = () => {
    setIsCollapsed(!isCollapsed);
  };

  return (
    <aside
      style={{
        width: isCollapsed ? "80px" : "250px",
        backgroundColor: "#333",
        color: "white",
        padding: "20px",
        height: "100vh",
        boxShadow: "2px 0 5px rgba(0, 0, 0, 0.1)",
        overflowY: "auto",
        transition: "width 0.3s ease",
      }}
    >
      <div
        style={{
          display: "flex",
          justifyContent: isCollapsed ? "center" : "space-between",
          alignItems: "center",
          marginBottom: "20px",
        }}
      >
        {!isCollapsed && <h3>Sidebar</h3>}
        <button
          onClick={handleToggleSidebar}
          style={{
            backgroundColor: "transparent",
            color: "white",
            border: "none",
            cursor: "pointer",
            fontSize: "20px",
          }}
        >
          {isCollapsed ? "☰" : "✖"}
        </button>
      </div>
      <ul style={{ listStyleType: "none", padding: 0 }}>
        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
            textAlign: isCollapsed ? "center" : "left",
          }}
        >
          <Link
            to="/dashboard"
            style={{
              color: "white",
              textDecoration: "none",
              display: "block",
            }}
          >
            {isCollapsed ? "🏠" : "Dashboard"}
          </Link>
        </li>
        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("ner")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
                Named Entity Recognition
                <span>{openSubMenu === "ner" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "ner" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
              <li style={{ marginBottom: "10px" }}>
                <Link
                  to="/ner/highlight-entity"
                  style={{ color: "white", textDecoration: "none" }}
                >
                  Highlight Entity
                </Link>
              </li>
              <li style={{ marginBottom: "10px" }}>
                <Link
                  to="/ner/resume-screen"
                  style={{ color: "white", textDecoration: "none" }}
                >
                  Resume Screen
                </Link>
              </li>
              <li style={{ marginBottom: "10px" }}>
                <Link
                  to="/ner/review-analysis"
                  style={{ color: "white", textDecoration: "none" }}
                >
                  Review Analysis
                </Link>
              </li>             
            </ul>
          )}
        </li>

        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
           onClick={() => toggleSubMenu("custom-pipeline")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
              Custom Pipeline
              <span>{openSubMenu === "custom-pipeline" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "custom-pipeline" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
             <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/custom-pipeline/detect-long-sentence"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Detect Long Sentence
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/custom-pipeline/keyword-extractor"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         keyword-extractor
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/custom-pipeline/Blacklist"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Blacklist
                       </Link>
                 </li>        
            </ul>
          )}
        </li>

        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("text-classification")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
                Text-Classification
                <span>{openSubMenu === "text-classification" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "text-classification" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
              <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-classification/highlight-entity"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Highlight Entity
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-classification/sub-item-2"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 02
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-classification/sub-item-3"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 03
                       </Link>
                     </li>           
            </ul>
          )}
        </li>

        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("text-rank")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
              Text-Rank
              <span>{openSubMenu === "text-rank" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "text-rank" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
               <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-rank/highlight-entity"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Highlight Entity
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-rank/sub-item-2"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 02
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-rank/sub-item-3"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 03
                       </Link>
                     </li>          
            </ul>
          )}
        </li>

        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("Cosine-Similarity")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
                Cosine Similarity
                <span>{openSubMenu === "Cosine-Similarity" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "Cosine-Similarity" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
               <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/Cosine-Similarity/highlight-entity"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Highlight Entity
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/Cosine-Similarity/sub-item-2"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 02
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/Cosine-Similarity/sub-item-3"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 03
                       </Link>
                     </li>          
            </ul>
          )}
        </li>


        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("codegenerate")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
                code generation
                <span>{openSubMenu === "codegenerate" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "codegenerate" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
            <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/codegenerate/auto-codegeneration"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Code Generation
                       </Link>
                     </li>
            </ul>
          )}
        </li>

        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("text-blob")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
                Text-Blob
                <span>{openSubMenu === "text-blob" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "text-blob" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
              <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-blob/highlight-entity"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Highlight Entity
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-blob/sub-item-2"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 02
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-blob/sub-item-3"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 03
                       </Link>
                     </li>          
            </ul>
          )}
        </li>

        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("langchain")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
                Langchain
                <span>{openSubMenu === "langchain" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "langchain" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
            <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/langchain/recipe-recommendation"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Recipe Recommendation
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/langchain/faq-generation"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         FAQ Generation
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/langchain/job-recommendation"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Job Recommendation
                       </Link>
                     </li>   
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/langchain/movie-recommendation"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Movie Recommendation
                       </Link>
                     </li>    
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/langchain/task-scheduling"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Personal Assistant
                       </Link>
                     </li>    
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/langchain/suggest-places"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Suggest top  place to visit
                       </Link>
                     </li>          
            </ul>
          )}
        </li>

        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("summarizer")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
                Summarization
                <span>{openSubMenu === "summarizer" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "summarizer" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
               <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/summarizer/highlight-entity"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Highlight Entity
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/summarizer/sub-item-2"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 02
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/summarizer/sub-item-3"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 03
                       </Link>
                     </li>                
            </ul>
          )}
        </li>

       

        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("genism")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
               Gensim
               <span>{openSubMenu === "genism" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "genism" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
              <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/genism/highlight-entity"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Highlight Entity
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/genism/sub-item-2"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 02
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/genism/sub-item-3"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sub Item 03
                       </Link>
                     </li>            
            </ul>
          )}
        </li>

        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("api-lib")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
                 Custom Api
                 <span>{openSubMenu === "api-lib" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "api-lib" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
              <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/api-lib/Translator"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Translator
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/api-lib/Sentence-Transformers"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Sentence-Transformers
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/api-lib/question-answering"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                        question-answering
                       </Link>
                     </li>             
            </ul>
          )}
        </li>
        <li
          style={{
            marginBottom: "10px",
            padding: "10px",
            borderRadius: "5px",
            backgroundColor: "#444",
          }}
        >
          <div
            onClick={() => toggleSubMenu("text-tools")}
            style={{
              cursor: "pointer",
              display: "flex",
              justifyContent: isCollapsed ? "center" : "space-between",
              alignItems: "center",
            }}
          >
            {!isCollapsed ? (
              <>
                 Text Tools
                 <span>{openSubMenu === "text-tools" ? "-" : "+"}</span>
              </>
            ) : (
              "📂"
            )}
          </div>
          {!isCollapsed && openSubMenu === "text-tools" && (
            <ul style={{ listStyleType: "none", paddingLeft: "20px" }}>
              <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-tools/text-manipulation"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Text Simple Tools</Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-tools/text-advanced"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                         Text Advanced Tools
                       </Link>
                     </li>
                     <li style={{ marginBottom: "10px" }}>
                       <Link
                         to="/text-tools/nlp-tools"
                         style={{ color: "white", textDecoration: "none" }}
                       >
                        NLP Tools
                       </Link>
                     </li>             
            </ul>
          )}
        </li>
        {/* Additional menu items */}
      </ul>
    </aside>
  );
};

export default Sidebar;
