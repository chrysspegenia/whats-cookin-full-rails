document.addEventListener("turbo:load", function () {
  const toggleWidthBtn = document.getElementById("toggle-width-btn");
  const navItemText = document.querySelectorAll(".nav-item-text");
  const navHeader = document.querySelector(".nav-header");
  const navHeaderLogo = document.querySelector(".nav-header-logo");

  // Function to toggle the active class and store the state in localStorage
  function toggleActiveState() {
    navItemText.forEach((item) => {
      item.classList.toggle("active");
    });

    navHeader.classList.toggle("active");

    navHeaderLogo.classList.toggle("active");

    // Store the current state in localStorage
    const isActive =
      navItemText[0].classList.contains("active") &&
      navHeader.classList.contains("active") &&
      navHeaderLogo.classList.contains("active");
    localStorage.setItem("navItemTextActive", isActive);
  }

  // Add event listener to toggleWidthBtn
  toggleWidthBtn.addEventListener("click", toggleActiveState);

  // Check if the active state is stored in localStorage
  const isActiveStored = localStorage.getItem("navItemTextActive");

  // If active state is stored, apply it to navItemText elements
  if (isActiveStored && isActiveStored === "true") {
    navItemText.forEach((item) => {
      item.classList.add("active");
    });

    navHeader.classList.add("active");
    navHeaderLogo.classList.add("active");
  }
});
