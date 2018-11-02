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
//import "isotope.pkgd";
// import "jarallax";
// import "magnific-popup";
//import "owl-carousel";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

let $body = document.body;
if ($body.dataset.preloader === "1") {
  $body.insertAdjacentHTML(
    "beforeend",
    `<div class='preloader preloader-1'><div><span></span></div></div>`
  );
}

window.onload = init;
function init() {
  $body.classList.add("loaded");
}
