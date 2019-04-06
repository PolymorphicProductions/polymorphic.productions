// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";
import "bootstrap";
//import "appear";
// import "easing";
// import "retinajs";
// import "imagesloaded";

// import "magnific-popup";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
import "./functions";

import { photoswipe_init } from "./photoswipe_init";
if (document.getElementsByClassName("gallery").length) {
  photoswipe_init(".gallery");
}

// Works but only with divs. Lacks Mark down.
// import Quill from "quill";
// var container = document.getElementById("body");

// var options = {
//   theme: "snow"
// };

// var editor = new Quill(container, options);
import * as SimpleMDE from "simplemde";
const simplemde = new SimpleMDE({
  element: document.getElementById("post-body")
});

