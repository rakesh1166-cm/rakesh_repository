import React from "react";

const Footer = () => {
  return (
    <footer
      style={{
        padding: "10px 20px",
        backgroundColor: "#f1f1f1",
        textAlign: "center",
        marginTop: "20px",
      }}
    >
      <p>&copy; {new Date().getFullYear()} CRUD Flask Application</p>
    </footer>
  );
};

export default Footer;