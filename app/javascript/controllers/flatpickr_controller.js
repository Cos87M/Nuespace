import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
   // Defining Stimulus targets for DOM elements
  static targets = [ "startTime", "endTime" ] // Identifies elements for start and end times in the DOM

  // Called when the controller is connected to the DOM
  connect() {
    console.log("im here Hello!")
    // The `flatPickrChange` method is called for each target to apply configurations
    this.flatPickrChange(this.startTimeTarget)
    this.flatPickrChange(this.endTimeTarget)
  }
  // Method to configure flatpickr for a specific input
  flatPickrChange(date) {
    flatpickr(date, { minDate: "today" }) // Prevents selecting dates earlier than today
  }
}
