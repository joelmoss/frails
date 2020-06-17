// Relative import.
import firstName from "../../lib/first_name";

// Absolute import where root is app/assets.
import lastName from "lib/last_name";

import "./index.css";
import styles from "./styles.module.css";

document.addEventListener("DOMContentLoaded", () => {
  const ul = document.querySelector("ul");
  ul.className = styles.list;

  log("Loaded entry point: 'blocks/assets/index.entry.js'", ul);
  log(`Name: ${firstName} ${lastName}`, ul);
});

function log(msg, node) {
  const li = document.createElement("li");
  li.append(msg);
  node.append(li);
}
