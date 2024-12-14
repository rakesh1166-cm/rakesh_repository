import React from "react";
import { Provider } from "react-redux";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import store from "./store";

// Import your components
import CrudFlask from "./components/CrudFlask";
import Dashboard from "./components/Dashboard";
import DetectLongSentence from "./components/DetectLongSentence";
import HighlightEntity from "./components/HighlightEntity";
import KeywordExtractor from "./components/KeywordExtractor";
import Blacklist from "./components/Blacklist";

function App() {
  return (
    <Provider store={store}>
      <Router>
        <Routes>
          {/* Define routes for each component */}
          <Route path="/" element={<CrudFlask />} />
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/detect-long-sentence" element={<DetectLongSentence />} />
          <Route path="/highlight-entity" element={<HighlightEntity />} />
          <Route path="/keyword-extractor" element={<KeywordExtractor />} />
          <Route path="/Blacklist" element={<Blacklist />} />
        </Routes>
      </Router>
    </Provider>
  );
}

export default App;