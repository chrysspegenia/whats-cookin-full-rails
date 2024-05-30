document.addEventListener("turbo:load", function () {
  function handleCheckboxes(selector) {
    document.querySelectorAll(selector).forEach((checkbox) => {
      if (checkbox.checked) {
        checkbox.parentElement.classList.add("checked");
      }
      checkbox.addEventListener("change", function () {
        this.parentElement.classList.toggle("checked", this.checked);
      });
    });
  }

  handleCheckboxes(".allergy-checkbox");
  handleCheckboxes(".ingredient-checkbox");

  const checkAllBtn = document.querySelector(".check-all-btn");

  checkAllBtn.addEventListener("click", function () {
    const checkboxes = document.querySelectorAll(".ingredient-checkbox");
    const allChecked = Array.from(checkboxes).every(
      (checkbox) => checkbox.checked
    );

    checkboxes.forEach((checkbox) => {
      checkbox.checked = !allChecked;
      checkbox.dispatchEvent(new Event("change")); // trigger change event to update parent class
    });

    // Update button text
    checkAllBtn.textContent = allChecked
      ? "Check All Ingredients"
      : "Uncheck All Ingredients";
  });

  // Initial check to set the button text correctly
  const ingredientCheckboxes = document.querySelectorAll(
    ".ingredient-checkbox"
  );
  const allCheckedInitial = Array.from(ingredientCheckboxes).every(
    (checkbox) => checkbox.checked
  );
  checkAllBtn.textContent = allCheckedInitial
    ? "Uncheck All Ingredients"
    : "Check All Ingredients";
});
