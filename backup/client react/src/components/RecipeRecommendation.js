import React, { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { generatecustomText } from "../actions";
import Sidebar from "./Sidebar";
import Nav from "./Nav";

const RecipeRecommendation = () => {
  const [query, setQuery] = useState("");
  const [selectedChains, setSelectedChains] = useState([]);
  const [loading, setLoading] = useState(false);
  const dispatch = useDispatch();

  // Place useSelector here to get the response from Redux store
  const response = useSelector((state) => {
    console.log("Redux State:", state.generatedcustomText); // This logs the Redux state
    return state.generatedcustomText;
  });


  const chainOptions = [
    "recommendation",
    "cooking_instructions",
    "nutrition_analysis",
    "vitamin_minerals",
    "health_benefits",
  ];


  useEffect(() => {
    // Log response whenever it changes to ensure we are receiving it
    console.log("Response updated in component:", response);
  
    // Check if the response has the expected data
    if (response && Object.keys(response).length > 0) {
      setLoading(false); // Set loading to false once data is received
    }
  }, [response]); 




  const handleCheckboxChange = (chain) => {
    setSelectedChains((prev) =>
      prev.includes(chain) ? prev.filter((c) => c !== chain) : [...prev, chain]
    );
  };

  const handleSubmit = () => {
    if (!query || selectedChains.length === 0) {
      alert("Please enter a cuisine type and select at least one option.");
      return;
    }
    setLoading(true); // Show loading state while fetching data
    const requestBody = {
      query,
      selected_chains: selectedChains,
    };
    dispatch(generatecustomText("get_recipe", requestBody));
  };

  // Log the response to inspect it properly
  console.log('Response:', response);
  // Log a more defensive check for response and response.results
  console.log('Response Check:', response ? response.results : 'Response is undefined');



  return (
    <div style={{ display: "flex", height: "100vh" }}>
      <Sidebar style={{ width: "250px", backgroundColor: "#f8f9fa" }} />
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        <Nav style={{ flex: "0 0 60px", backgroundColor: "#343a40", color: "white" }} />
        <div style={{ flex: 1, padding: "20px", backgroundColor: "#f4f4f4" }}>
          <h2>Recipe Generator</h2>
          <input
            type="text"
            placeholder="Enter a cuisine (e.g., Italian, Mexican)..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            style={{ padding: "10px", width: "100%", marginBottom: "10px" }}
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
            style={{
              marginTop: "10px",
              padding: "10px 20px",
              backgroundColor: "#007bff",
              color: "white",
              border: "none",
              cursor: "pointer",
            }}
          >
            Generate Recipe
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

export default RecipeRecommendation;
