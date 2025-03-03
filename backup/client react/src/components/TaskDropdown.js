import React from 'react';

// Define tasks for each chain type inside TaskDropdown
const tasksByChain = {
  basic_operation: [
    "Remove Blank Lines",
    "Replace Text",
    "Trim Whitespace",
    "Line Numbering",
    "Remove Duplicate Lines Sort",
    "Remove Spaces Each Line",
    "Replace Space with Dash",
    "ASCII Unicode Conversion",
    "Count Words Characters",
    "Reverse Lines Words",
    "Extract Information",
    "Split Text by Characters",
    "Change Case",
    "Change Case by Find",
    "Count Words by Find",
    "Add Prefix/Suffix",
    "Add Custom Prefix/Suffix",
  ],
  list_operation: [
    "Append an element to a list",
    "Remove an element from a list",
    "Sort a list",
    "Filter a list",
    "Find the length of a list",
  ],
  dictionary_operation: [
    "Add a key-value pair",
    "Remove a key-value pair",
    "Get value by key",
    "List all keys",
    "List all values"
  ]
};

const TaskDropdown = ({ selectedChain, selectedTasks, handleTaskCheckboxChange, isTaskDropdownOpen, toggleTaskDropdown }) => {
  const tasks = tasksByChain[selectedChain] || []; // Get tasks based on selectedChain

  return (
    <div style={{ marginTop: "20px" }}>
      <h4>Select tasks under {selectedChain.replace('_', ' ')}:</h4>
      <div
        style={{
          padding: "10px",
          border: "1px solid #ccc",
          borderRadius: "5px",
          cursor: "pointer",
        }}
        onClick={toggleTaskDropdown}
      >
        <span style={{ fontWeight: "bold" }}>
          {selectedTasks.length === 0 ? "Select tasks..." : "Selected tasks"}
        </span>
        <br />
        {/* Dropdown for task options */}
        {isTaskDropdownOpen && (
          <div style={{ marginTop: "10px" }}>
            {tasks.map((task, idx) => (
              <div
                key={idx}
                style={{
                  display: "grid",
                  gridTemplateColumns: "20px auto",
                  alignItems: "center",
                  marginBottom: "5px",
                }}
              >
                <input
                  type="checkbox"
                  id={task}
                  checked={selectedTasks.includes(task)}
                  onChange={() => handleTaskCheckboxChange(task)}
                  style={{ margin: 0 }}
                />
                <label htmlFor={task} style={{ cursor: "pointer", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
                  {task}
                </label>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default TaskDropdown;
