import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.querySelectorAll("[draggable=true]").forEach(item => {
      item.addEventListener("dragstart", this.handleDragStart.bind(this));
    });

    this.dropAreas = this.element.querySelectorAll(".drop-area");
    this.dropAreas.forEach(area => {
      area.addEventListener("dragover", this.handleDragOver.bind(this));
      area.addEventListener("drop", this.handleDrop.bind(this));
      area.addEventListener("dragleave", this.handleDragLeave.bind(this));
    });

    document.addEventListener("dragend", this.handleDragEnd.bind(this));
  }

  handleDragStart(event) {
    event.dataTransfer.effectAllowed = 'copy';
    const target = event.target.closest("[draggable=true]");
    event.dataTransfer.setData("text/plain", event.target.id);
    this.currentDraggedElement = target;
    // console.log("Drag Start Event Triggered");
    // console.log("Dragged Element ID:", event.target.id);
    // console.log("Dragged Element:", event.target);
    // console.log("Dragged Element Data Attributes:", event.target.dataset);
  }

  handleDragOver(event) {
    event.preventDefault();
    const dropArea = event.target.closest(".drop-area");
    if (dropArea) {
      dropArea.classList.add("highlight-drop-area");
    }
    const dropDeletearea = event.target.closest(".delete-area");
    if (dropDeletearea) {
      dropDeletearea.classList.add("highlight-delete-area");
    }

  }

  handleDrop(event) {
    event.preventDefault();
    const data = event.dataTransfer.getData("text/plain");
    // console.log("Dragged Element ID:", data);
    const draggableElement = document.getElementById(data);
    // console.log("Dragged Element:", draggableElement);
    const dropArea = event.target.closest(".drop-area");
    // console.log("Drop Area:", dropArea);
    const deleteArea = event.target.closest(".delete-area");
    // console.log("Delete Area:", deleteArea);

    if (dropArea) {
      dropArea.classList.remove("highlight-drop-area");
      const existingMealPlans = dropArea.querySelectorAll('.meal-plan-item').length;
      if (existingMealPlans >= 3) {
        // Find and remove the last meal plan of the same meal type for this day
        const mealType = dropArea.dataset.mealType;
        const mealPlans = dropArea.querySelectorAll(`.meal-plan-item[data-meal-type="${mealType}"]`);
        const lastMealPlan = mealPlans[mealPlans.length - 1];
        if (lastMealPlan) {
          lastMealPlan.remove();
        }
      }

      const date = dropArea.dataset.date;
      const mealType = dropArea.dataset.mealType;
      const recipeId = draggableElement.dataset.recipeId;
      // console.log("Drop Area Date:", date);
      // console.log("Drop Area Meal Type:", mealType);
      // console.log("Dragged Element Recipe ID:", recipeId);

      if (recipeId) {
        fetch("/meal_planner", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").getAttribute("content")
          },
          body: JSON.stringify({
            date: date,
            meal_type: mealType,
            recipe_id: recipeId
          })
        })
        .then(response => response.text())
        .then(html => {
          const frame = document.getElementById("meal_planner_frame");
          frame.innerHTML = html;
        });

        const copy = draggableElement.cloneNode(true);
        copy.id = "";
        copy.classList.add("cloned");
        dropArea.appendChild(copy);
      }
    }

    if (draggableElement && deleteArea) {
      const mealPlanId = draggableElement.dataset.mealPlanId;
      // console.log("Meal Plan ID:", mealPlanId);

      if (mealPlanId) {
        fetch(`/meal_planner/${mealPlanId}`, {
          method: "DELETE",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").getAttribute("content")
          }
        })
        .then(response => response.text())
        .then(html => {
          const frame = document.getElementById("meal_planner_frame");
          frame.innerHTML = html;
        });

        draggableElement.remove();
      }
    }
  }

  handleDragLeave(event) {
    const dropArea = event.target.closest(".drop-area");
    if (dropArea) {
      dropArea.classList.remove("highlight-drop-area");
    }

    const dropDeletearea = event.target.closest(".delete-area");
    if (dropDeletearea) {
      dropDeletearea.classList.remove("highlight-delete-area");
    }
  }

  handleDragEnd(event) {
    if (!this.currentDraggedElement) return;

    const isOutsideCalendar = ![...document.querySelectorAll(".simple-calendar")].some(calendar => calendar.contains(this.currentDraggedElement));

    if (isOutsideCalendar && this.currentDraggedElement.classList.contains("cloned")) {
      this.currentDraggedElement.remove();
    }

    this.currentDraggedElement = null;
  }
}
