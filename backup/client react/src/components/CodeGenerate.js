import React, { useState } from "react";
import Sidebar from "./Sidebar";
import Nav from "./Nav";
import TaskDropdown from "./TaskDropdown"; // Import TaskDropdown component

const CodeGenerate = () => {
  const [selectedChains, setSelectedChains] = useState([]);
  const [selectedOption, setSelectedOption] = useState("");
  const [userInput, setUserInput] = useState("");
  const [selectedTasks, setSelectedTasks] = useState([]);
  const [isTaskDropdownOpen, setIsTaskDropdownOpen] = useState(false); // Controls visibility of task dropdown

  // Available chains and their dropdown options
  const chainOptions = [
    { id: "basic_operation", label: "Basic Operation", options: ["JavaScript", "Python", "Java"] },
    { id: "list_operation", label: "list Operation", options: ["REST", "GraphQL"] },
    { id: "dictionary_operation", label: "dictionary Operation", options: ["MySQL", "MongoDB"] },
  ];

  const handleCheckboxChange = (chainId) => {
    setSelectedChains([chainId]); // Select only one checkbox at a time by resetting others
    if (chainId !== "basic_operation") {
      setSelectedTasks([]); // Reset tasks if a chain other than basic_operation is selected
    }
  };

  const handleDropdownChange = (event) => {
    setSelectedOption(event.target.value);
  };

  const handleTaskCheckboxChange = (task) => {
    setSelectedTasks((prevTasks) =>
      prevTasks.includes(task)
        ? prevTasks.filter((t) => t !== task)
        : [...prevTasks, task] // Add or remove tasks from the selected array
    );
  };

  const toggleTaskDropdown = () => {
    setIsTaskDropdownOpen(!isTaskDropdownOpen); // Toggle the visibility of the task dropdown
  };

  const handleSubmit = () => {
    if (!userInput || selectedChains.length === 0 || !selectedOption || selectedTasks.length === 0) {
      alert("Please complete all fields.");
      return;
    }
    console.log("Selected chains:", selectedChains);
    console.log("Selected option:", selectedOption);
    console.log("Selected tasks:", selectedTasks); // Log selected tasks
    console.log("User input:", userInput);
    // You can dispatch actions here if necessary
  };

  return (
    <div style={{ display: "flex", flexDirection: "row", height: "100vh" }}>
      <Sidebar style={{ flex: "0 0 250px" }} />
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        <Nav style={{ flex: "0 0 60px" }} />
        <div style={{ flex: 1, padding: "20px", backgroundColor: "#f4f4f4" }}>
          <h2>Code Generation and Task Setup</h2>

          {/* Display selected tasks as tags */}
          <div style={{ marginBottom: "20px" }}>
            {selectedTasks.map((task, index) => (
              <span
                key={index}
                style={{
                  backgroundColor: "#007bff",
                  color: "white",
                  padding: "5px 10px",
                  borderRadius: "15px",
                  marginRight: "10px",
                }}
              >
                {task}{" "}
                <span
                  style={{
                    marginLeft: "8px",
                    cursor: "pointer",
                  }}
                  onClick={() => handleTaskCheckboxChange(task)}
                >
                  &times;
                </span>
              </span>
            ))}
          </div>

          <div>
            <h4>Select options:</h4>
            <div style={{ display: "flex", flexWrap: "wrap" }}>
              {chainOptions.map((chain) => (
                <label key={chain.id} style={{ display: "flex", marginRight: "20px", marginBottom: "10px" }}>
                  <input
                    type="checkbox"
                    checked={selectedChains.includes(chain.id)}
                    onChange={() => handleCheckboxChange(chain.id)}
                  />
                  {chain.label}
                </label>
              ))}
            </div>
          </div>

          {/* Dropdown for selected chain */}
          {selectedChains.length > 0 && (
            <div style={{ marginTop: "20px" }}>
              <h4>Select a chain option:</h4>
              <select value={selectedOption} onChange={handleDropdownChange} style={{ width: "100%", padding: "10px" }}>
                <option value="">-- Select an option --</option>
                {chainOptions
                  .filter((chain) => selectedChains.includes(chain.id))
                  .map((chain) =>
                    chain.options.map((option, idx) => (
                      <option key={idx} value={option}>
                        {option}
                      </option>
                    ))
                  )}
              </select>
            </div>
          )}

                {selectedChains.length > 0 && (
                <TaskDropdown
                    selectedChain={selectedChains[0]}  // Pass the selected chain, e.g., "basic_operation" or "list_operation"
                    selectedTasks={selectedTasks}
                    handleTaskCheckboxChange={handleTaskCheckboxChange}
                    isTaskDropdownOpen={isTaskDropdownOpen}
                    toggleTaskDropdown={toggleTaskDropdown}
                />
                )}


          {/* User input text field */}
          <div style={{ marginTop: "20px" }}>
            <input
              type="text"
              placeholder="Enter your input here..."
              value={userInput}
              onChange={(e) => setUserInput(e.target.value)}
              style={{ width: "100%", padding: "10px", marginBottom: "10px" }}
            />
          </div>

          {/* Submit button */}
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
            Submit
          </button>
        </div>
      </div>
    </div>
  );
};

export default CodeGenerate;
