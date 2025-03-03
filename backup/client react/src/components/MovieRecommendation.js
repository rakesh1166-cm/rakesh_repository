import React, { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import Sidebar from "./Sidebar";
import Nav from "./Nav";
import { generatecustomText } from "../actions";

const MovieRecommendation = () => {
  const [userInput, setUserInput] = useState("");
  const [reviews, setReviews] = useState("");
  const [selectedChains, setSelectedChains] = useState([]);
  const [loading, setLoading] = useState(false);
  
  const dispatch = useDispatch();


  
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
    "movie_recommendation",
    "latest_movie",
    "movie_genre",
    "movie_cast",
    "movie_ratings",
    "box_office",
    "sentiment_analysis",
    "review_summary",
  ];

  const handleCheckboxChange = (chain) => {
    setSelectedChains((prev) =>
      prev.includes(chain) ? prev.filter((c) => c !== chain) : [...prev, chain]
    );
  };

  const handleSubmit = () => {
    if (!userInput) {
      alert("Please enter your movie preferences.");
      return;
    }
    if (selectedChains.length === 0) {
      alert("Please select at least one option.");
      return;
    }
    setLoading(true); // Show loading state while fetching data
    const requestBody = {
      input: userInput,
      reviews,
      selected_chains: selectedChains,
    };
    // Dispatch the action to generate the movie recommendation    
 dispatch(generatecustomText("get_movie", requestBody));
  };

  return (
    <div style={{ display: "flex", flexDirection: "row", height: "100vh" }}>
      <Sidebar style={{ flex: "0 0 250px" }} />
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        <Nav style={{ flex: "0 0 60px" }} />
        <div style={{ flex: 1, padding: "20px", backgroundColor: "#f4f4f4" }}>
          <h2>Movie Recommendation System</h2>
          <textarea
            placeholder="Enter your movie preferences..."
            value={userInput}
            onChange={(e) => setUserInput(e.target.value)}
            style={{ width: "100%", height: "100px", marginBottom: "10px" }}
          ></textarea>
          <textarea
            placeholder="Enter movie reviews (optional)..."
            value={reviews}
            onChange={(e) => setReviews(e.target.value)}
            style={{ width: "100%", height: "100px", marginBottom: "10px" }}
          ></textarea>
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
            Get Movie Recommendation
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

export default MovieRecommendation;
