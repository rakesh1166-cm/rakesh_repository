import React, { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import Sidebar from "./Sidebar";
import Nav from "./Nav";
import { generatecustomText } from "../actions";

const TaskScheduling = () => {
  const [userInput, setUserInput] = useState("");
  const [tasks, setTasks] = useState("");
  const [prioritizedTasks, setPrioritizedTasks] = useState("");
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
    "suggest_task_prompt",
    "prioritize_task_prompt",
    "schedule_prompt",
  ];

  const handleCheckboxChange = (chain) => {
    setSelectedChains((prev) =>
      prev.includes(chain) ? prev.filter((c) => c !== chain) : [...prev, chain]
    );
  };

  const handleSubmit = () => {
    if (!userInput) {
      alert("Please enter your tasks or input.");
      return;
    }
    if (selectedChains.length === 0) {
      alert("Please select at least one option.");
      return;
    }
    setLoading(true); // Show loading state while fetching data
    const requestBody = {
      input: userInput,
      tasks,
      prioritized_tasks: prioritizedTasks,
      selected_chains: selectedChains,
    };
    // Dispatch the action to generate the task schedule
   dispatch(generatecustomText("task_schedule", requestBody));
  };

  return (
    <div style={{ display: "flex", flexDirection: "row", height: "100vh" }}>
      <Sidebar style={{ flex: "0 0 250px" }} />
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        <Nav style={{ flex: "0 0 60px" }} />
        <div style={{ flex: 1, padding: "20px", backgroundColor: "#f4f4f4" }}>
          <h2>Task Scheduling System</h2>
          <textarea
            placeholder="Enter your tasks or input..."
            value={userInput}
            onChange={(e) => setUserInput(e.target.value)}
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
            Generate Task Schedule
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

export default TaskScheduling;
