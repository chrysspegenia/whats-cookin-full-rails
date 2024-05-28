document.addEventListener("turbo:load", function () {
  var noticeModal = document.getElementById("notice-modal");
  var alertModal = document.getElementById("alert-modal");

  if (noticeModal) {
    showModal(noticeModal);
  }

  if (alertModal) {
    showModal(alertModal);
  }
});

function showModal(modal) {
  modal.style.display = "block";
  setTimeout(function () {
    fadeOut(modal);
  }, 5000);
}

function fadeOut(element) {
  var op = 1; // initial opacity
  var timer = setInterval(function () {
    if (op <= 0.1) {
      clearInterval(timer);
      element.style.display = "none";
    }
    element.style.opacity = op;
    element.style.filter = "alpha(opacity=" + op * 100 + ")";
    op -= op * 0.1;
  }, 50);
}

function closeModal(modalId) {
  var modal = document.getElementById(modalId);
  modal.style.display = "none";
}
