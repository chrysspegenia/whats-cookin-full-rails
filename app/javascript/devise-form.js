document.addEventListener("turbo:load", function () {
  const chars = document.querySelectorAll(".char");
  const deviseBtn = document.querySelector(".devise-btn");

  if (deviseBtn) {
    deviseBtn.addEventListener("mouseover", function () {
      chars.forEach((char, index) => {
        char.style.transitionDelay = `${index * 0.02}s`;
        char.classList.add("hovered");
      });
    });

    deviseBtn.addEventListener("mouseout", function () {
      chars.forEach((char) => {
        char.classList.remove("hovered");
      });
    });
  }
});
