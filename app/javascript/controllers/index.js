import { Application } from "@hotwired/stimulus";
import DragAndDropController from "./drag_and_drop_controller.js";

const application = Application.start();

application.register("drag-and-drop", DragAndDropController);

application.debug = false;
window.Stimulus = application;

export { application };
