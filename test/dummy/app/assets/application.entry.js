import _ from "lodash";

require.context("images", true, /\.(jpg|jpeg|png|gif)$/i);

import age from "./user/age";
// import Logo from "./images/webpack_logo.svg";
import "./user/index.css";

console.log(`User is ${age} years old`);

function component() {
  const element = document.createElement("div");

  // Lodash, now imported by this script
  element.innerHTML = _.join(["Hello", "webpack"], " ");
  element.classList.add("hello");

  // Add the image to our existing div.
  const myLogo = new Image();
  myLogo.src = Logo;

  element.appendChild(myLogo);

  return element;
}

document.body.appendChild(component());
