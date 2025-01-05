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
import ResumeScreen from "./components/ResumeScreen";
import ReviewAnalysis from "./components/ReviewAnalysis";
import TextManipulation from "./components/TextManipulation";
import TextAdvanced from "./components/TextAdvanced";
import NlpTools from "./components/NlpTools";

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
          <Route path="/ner/highlight-entity" element={<HighlightEntity />} />
          <Route path="/ner/resume-screen" element={<ResumeScreen/>} />
          <Route path="/ner/review-analysis" element={<ReviewAnalysis />} />
          <Route path="/custom-pipeline/detect-long-sentence" element={<DetectLongSentence />} />
          <Route path="/custom-pipeline/keyword-extractor" element={<KeywordExtractor />} />
          <Route path="/custom-pipeline/Blacklist" element={<Blacklist />} />
          <Route path="/text-tools/text-manipulation" element={<TextManipulation/>} />
          <Route path="/text-tools/text-advanced" element={<TextAdvanced/>} />
          <Route path="/text-tools/nlp-tools" element={<NlpTools/>} /> 
        </Routes>
      </Router>
    </Provider>
  );
}

export default App;