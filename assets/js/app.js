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

const applicationServerPublicKey =
  "BH_5ldXY7JmsaFZYnY5mO7mUcyeq79lQn1uwbkc-ODj-ST-agceIYNX24bBqm-TsACWWcldMtZXfpi2koAOrIjI";

const pushButton = document.querySelector(".js-push-btn-toggle");

const pushIcon = document.querySelector(".sw");
const nofity_h3 = document.querySelector(".modal-body h3");

const notification_notes = document.querySelector(
  ".modal-body .notification-notes"
);

let isSubscribed = false;
let swRegistration = null;

function urlB64ToUint8Array(base64String) {
  const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding)
    .replace(/\-/g, "+")
    .replace(/_/g, "/");

  const rawData = window.atob(base64);
  const outputArray = new Uint8Array(rawData.length);

  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

function updateBtn() {
  console.log(Notification.permission);
  if (Notification.permission === "denied") {
    updateSubscriptionOnServer(null);
    return;
  }

  if (isSubscribed) {
    pushIcon.classList.remove("fa-bell");
    pushIcon.classList.add("far", "fa-bell-slash");
    nofity_h3.innerText = "Notifications On.";
    pushButton.innerHTML =
      ' <i class="far fa-bell-slash"></i> Disable Noficiations';
    notification_notes.innerText =
      "Notifications are currently enabled. Click button to disable.";
    pushButton.classList.remove("btn-success");
    pushButton.classList.add("btn-danger");
  } else {
    pushIcon.classList.remove("fa-bell-slash");
    pushIcon.classList.add("far", "fa-bell");
    nofity_h3.innerText = "Get Notified";
    pushButton.innerHTML = ' <i class="far fa-bell"></i> Enable Noficiations';
    notification_notes.innerText = "Enable to get periodic notifications.";
    pushButton.classList.add("btn-success");
    pushButton.classList.remove("btn-danger");
  }

  pushButton.disabled = false;
}

function updateSubscriptionOnServer(subscription) {
  // TODO: Send subscription to application server
  if (subscription) {
    console.debug(JSON.stringify(subscription));
    postPushSubscription(`/api/push_subscribers/`, {
      subscription: subscription
    })
      .then(data => console.log(JSON.stringify(data))) // JSON-string from `response.json()` call
      .catch(error => console.error(error));
  }
}
function postPushSubscription(url = ``, data = {}) {
  // Default options are marked with *
  return fetch(url, {
    method: "POST", // *GET, POST, PUT, DELETE, etc.
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data) // body data type must match "Content-Type" header
  }).then(response => response.json()); // parses response to JSON
}

function subscribeUser() {
  const applicationServerKey = urlB64ToUint8Array(applicationServerPublicKey);

  swRegistration.pushManager
    .subscribe({
      userVisibleOnly: true,
      applicationServerKey: applicationServerKey
    })
    .then(function(subscription) {
      console.log("User is subscribed.");

      updateSubscriptionOnServer(subscription);

      isSubscribed = true;

      updateBtn();
    })
    .catch(function(err) {
      console.log("Failed to subscribe the user: ", err);
      updateBtn();
    });
  console.log("wtf");
}

function unsubscribeUser() {
  swRegistration.pushManager
    .getSubscription()
    .then(function(subscription) {
      if (subscription) {
        //TODO send unsubscribe to server
        //console.debug(JSON.stringify(subscription));

        return subscription.unsubscribe();
      }
    })
    .catch(function(error) {
      //console.log("Error unsubscribing", error);
      // send to sentory
    })
    .then(function() {
      updateSubscriptionOnServer(null);

      //console.log("User is unsubscribed.");
      isSubscribed = false;

      updateBtn();
    });
}

function initializeUI() {
  pushButton.addEventListener("click", function() {
    // console.log(isSubscribed);
    pushButton.disabled = true;
    if (isSubscribed) {
      unsubscribeUser();
    } else {
      subscribeUser();
    }
  });

  // Set the initial subscription value
  swRegistration.pushManager.getSubscription().then(function(subscription) {
    isSubscribed = !(subscription === null);
    updateSubscriptionOnServer(subscription);
    updateBtn();

    if (isSubscribed) {
      pushIcon.classList.remove("fa-bell");
      pushIcon.classList.add("far", "fa-bell-slash");
      console.log("User IS subscribed.");
      nofity_h3.innerText = "Notifications On.";
      pushButton.innerHTML =
        ' <i class="far fa-bell-slash"></i> Disable Noficiations';
      notification_notes.innerText =
        "Notifications are currently enabled. Click button to disable.";
      pushButton.classList.remove("btn-success");
      pushButton.classList.add("btn-danger");
    } else {
      pushIcon.classList.add("far", "fa-bell");
      pushIcon.classList.remove("fa-bell-slash");

      console.log("User is NOT subscribed.");
    }
  });
}

if ("serviceWorker" in navigator && "PushManager" in window) {
  navigator.serviceWorker
    .register("js/sw.js")
    .then(function(swReg) {
      console.log("Service Worker is registered", swReg);
      swRegistration = swReg;
      initializeUI();
    })
    .catch(function(error) {
      pushIcon.classList.remove("far", "fa-bell");
      pushIcon.classList.remove("far", "fa-bell-slash");
      console.error("Service Worker Error", error);
    });
} else {
  //console.warn("Push messaging is not supported");
  pushIcon.classList.remove("far", "fa-bell");
  pushIcon.classList.remove("far", "fa-bell-slash");
}

$("#myModal").on("shown.bs.modal", function() {
  $("#myInput").trigger("focus");
});
