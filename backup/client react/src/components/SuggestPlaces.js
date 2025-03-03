import React, { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import Sidebar from "./Sidebar";
import Nav from "./Nav";
import { generatecustomText } from "../actions";

const SuggestPlaces = () => {
  const [city, setCity] = useState("");
  const [selectedChains, setSelectedChains] = useState([]);
  const [loading, setLoading] = useState(false);
  
  const dispatch = useDispatch();

  // Redux selector to get the response
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
    "bike_rental_suggestions",
    "place_recommendation",
    "route_suggestion",
    "weather_suggestion",
  ];

  const handleCheckboxChange = (chain) => {
    setSelectedChains((prev) =>
      prev.includes(chain) ? prev.filter((c) => c !== chain) : [...prev, chain]
    );
  };

  const handleSubmit = () => {
    if (!city) {
      alert("Please enter a city in India.");
      return;
    }
    if (selectedChains.length === 0) {
      alert("Please select at least one option.");
      return;
    }

    setLoading(true); // Show loading state while fetching data

    const requestBody = {
      city,
      selected_chains: selectedChains,
    };

    // Dispatch the action to get suggestions
    dispatch(generatecustomText("get_suggestions", requestBody));
  };

  return (
    <div style={{ display: "flex", flexDirection: "row", height: "100vh" }}>
      <Sidebar style={{ flex: "0 0 250px" }} />
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        <Nav style={{ flex: "0 0 60px" }} />
        <div style={{ flex: 1, padding: "20px", backgroundColor: "#f4f4f4" }}>
          <h2>Suggest Places & Routes</h2>
          <input
            type="text"
            placeholder="Enter city in India..."
            value={city}
            onChange={(e) => setCity(e.target.value)}
            style={{ width: "100%", padding: "10px", marginBottom: "10px" }}
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
            Get Suggestions
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

export default SuggestPlaces;
