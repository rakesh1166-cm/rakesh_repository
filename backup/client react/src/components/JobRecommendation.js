import React, { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { generatecustomText } from "../actions";
import Sidebar from "./Sidebar";
import Nav from "./Nav";

const JobRecommendation = () => {
    const [query, setQuery] = useState("");
    const [userProfile, setUserProfile] = useState("");
    const [resumeFile, setResumeFile] = useState(null);
    const [loading, setLoading] = useState(false);
    const dispatch = useDispatch();
    const [selectedChains, setSelectedChains] = useState([]);
  

    const response = useSelector((state) => {
      console.log("Redux State:", state.generatedcustomText); // This logs the Redux state
      return state.generatedcustomText;
    });
  
   useEffect(() => {
      // Log response whenever it changes to ensure we are receiving it
      console.log("Response updated in component:", response);    
      // Check if the response has the expected data
      if (response && Object.keys(response).length > 0) {
        setLoading(false); // Set loading to false once data is received
      }
    }, [response]); 
  const chainOptions = [
    "job_recommendation",
    "resume_optimization",
    "cover_letter_generation",
    "salary_package_estimation",
    "job_type_classification",
    "future_demand_prediction",
    "career_growth_analysis",
  ];

  const handleCheckboxChange = (chain) => {
    setSelectedChains((prev) =>
      prev.includes(chain) ? prev.filter((c) => c !== chain) : [...prev, chain]
    );
  };

  const handleFileChange = (event) => {
    setResumeFile(event.target.files[0]);
  };

const handleSubmit = () => {
  if (!userProfile || selectedChains.length === 0 || !resumeFile) {
    alert("Please enter your user profile, select at least one option, and upload a resume file.");
    return;
  }

  setLoading(true); // Show loading state while fetching data

  const reader = new FileReader();
  reader.readAsDataURL(resumeFile); // Convert file to Base64
  reader.onload = () => {
    const base64File = reader.result.split(",")[1]; // Extract Base64 data

    const requestBody = {
      query: userProfile, // User profile text
      selected_chains: selectedChains, // Selected options
      resume: base64File, // Resume file as Base64 string
      filename: resumeFile.name, // Sending filename for reference
    };

    dispatch(generatecustomText("get_jobrecommend", requestBody));
  };

  reader.onerror = (error) => {
    console.error("File conversion error:", error);
    alert("Failed to process the resume file. Please try again.");
  };
};

  

  return (
    <div style={{ display: "flex", flexDirection: "row", height: "100vh" }}>
      <Sidebar style={{ flex: "0 0 250px" }} />
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        <Nav style={{ flex: "0 0 60px" }} />
        <div style={{ flex: 1, padding: "20px", backgroundColor: "#f4f4f4" }}>
          <h2>Job Recommendation System</h2>
          <textarea
            placeholder="Enter your user profile..."
            value={userProfile}
            onChange={(e) => setUserProfile(e.target.value)}
            style={{ width: "100%", height: "100px", marginBottom: "10px" }}
          ></textarea>
          <input
            type="file"
            onChange={handleFileChange}
            style={{ marginBottom: "10px" }}
          />
          <div>
            <h4>Select options:</h4>
            {chainOptions.map((chain) => (
              <label key={chain} style={{ display: "block", marginBottom: "5px" }}>
                <input
                  type="checkbox"
                  checked={selectedChains.includes(chain)}
                  onChange={() => handleCheckboxChange(chain)}
                />
                {chain.replace("_", " ").toUpperCase()}
              </label>
            ))}
          </div>
          <button
            onClick={handleSubmit}
            style={{ marginTop: "10px", padding: "10px 20px", backgroundColor: "#007bff", color: "white", border: "none", cursor: "pointer" }}
          >
            Generate Job Recommendations
          </button>
          {loading ? (
  <div style={{ marginTop: "20px" }}>
    <h3>Results:</h3>
    <p>Loading...</p>
  </div>
) : (
  <div style={{ marginTop: "20px" }}>
    <h3>Results:</h3>
    {/* Check if response has data */}
    {response && Object.keys(response).length > 0 ? (
      <div>
        {Object.entries(response).map(([key, value]) => (
          <div key={key} style={{ marginBottom: "20px" }}>
            <strong>{key.replace("_", " ").toUpperCase()}:</strong>
            <p>{value}</p>
          </div>
        ))}
      </div>
    ) : (
      <p>No results to display</p>
    )}
  </div>
)}
        </div>
      </div>
    </div>
  );
};

export default JobRecommendation;
