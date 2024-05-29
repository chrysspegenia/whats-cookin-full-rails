document.addEventListener("turbo:load", function () {
  document.querySelectorAll(".allergy-checkbox").forEach((checkbox) => {
    // Add the 'checked' class to parent if the checkbox is checked on page load
    if (checkbox.checked) {
      checkbox.parentElement.classList.add("checked");
    }

    // Add event listener for change events
    checkbox.addEventListener("change", function () {
      if (this.checked) {
        this.parentElement.classList.add("checked");
      } else {
        this.parentElement.classList.remove("checked");
      }
    });
  });
});
