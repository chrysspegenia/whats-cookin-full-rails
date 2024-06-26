document.addEventListener("turbo:load", function () {
  function handleCheckboxes(selector) {
    const checkboxes = document.querySelectorAll(selector);
    if (checkboxes.length === 0) return; // Exit if no checkboxes found

    checkboxes.forEach((checkbox) => {
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

  if (checkAllBtn) {
    function updateButtonText() {
      const ingredientCheckboxes = document.querySelectorAll(
        ".ingredient-checkbox"
      );
      const allChecked = Array.from(ingredientCheckboxes).every(
        (checkbox) => checkbox.checked
      );
      checkAllBtn.textContent = allChecked
        ? "Unselect All Ingredients"
        : "Select All Ingredients";
    }

    checkAllBtn.addEventListener("click", function () {
      const checkboxes = document.querySelectorAll(".ingredient-checkbox");
      const allChecked = Array.from(checkboxes).every(
        (checkbox) => checkbox.checked
      );

      checkboxes.forEach((checkbox) => {
        checkbox.checked = !allChecked;
        checkbox.dispatchEvent(new Event("change")); // trigger change event to update parent class
      });

      updateButtonText();
    });

    // Initial check to set the button text correctly
    updateButtonText();
  }

  const displayIngredientsBtn = document.querySelector(
    ".display-ingredients-btn"
  );

  const ingredientsSearchWrapper = document.querySelector(
    ".ingredients-search-wrapper"
  );

  const searchSubSection = document.querySelector(".search-sub-section");

  function updateDisplayIngredients(wrapperElement, storageKey) {
    if (wrapperElement) {
      let isDisplayed = localStorage.getItem(storageKey) === "true";
      if (isDisplayed) {
        wrapperElement.classList.add("display");
        displayIngredientsBtn.classList.add("bxs-chevron-up");
      }

      displayIngredientsBtn.addEventListener("click", function () {
        wrapperElement.classList.toggle("display");
        localStorage.setItem(
          storageKey,
          wrapperElement.classList.contains("display")
        );

        if (wrapperElement.classList.contains("display")) {
          displayIngredientsBtn.classList.add("bxs-chevron-up");
        } else {
          displayIngredientsBtn.classList.remove("bxs-chevron-up");
        }
      });
    }
  }

  if (displayIngredientsBtn) {
    updateDisplayIngredients(
      ingredientsSearchWrapper,
      "displayIngredientsWrapper"
    );
    updateDisplayIngredients(searchSubSection, "displaySubSection");
  }
});
