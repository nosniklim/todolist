import React from "react";
import { createRoot } from "react-dom/client";
import Board from "./modules/Board";

document.addEventListener("turbolinks:load", () => {
  const el = document.getElementById("react-board");
  if (!el) return;

  const root = createRoot(el);
  root.render(<Board />);
});
