import { Application } from "@hotwired/stimulus"
import { DragAndDropController } from "./drag_and_drop_controller"

const application = Application.start()
application.register("drag-and-drop", DragAndDropController)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
