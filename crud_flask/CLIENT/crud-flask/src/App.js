import React from "react";
import { Provider } from "react-redux";
import CrudFlask from "./components/CrudFlask";
import store from "./store";

function App() {
  return (
    <Provider store={store}>
      <CrudFlask />
    </Provider>
  );
}

export default App;