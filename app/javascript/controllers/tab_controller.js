import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tab"
export default class extends Controller {
  // Declaring controller targets
  static targets = ["booking", "tab_booking", "listing", "tab_listing", "received_listing", "tab_received_listing"]
  connect() {
    // console.log("The 'tabs' controller is now loaded!")
  }
  // Method to display the bookings content and highlight the tab
  display_bookings(event) {
    event.preventDefault()  // Prevent default link or button behavior

    // Show the bookings content and activate the bookings tab
    this.bookingTarget.classList.remove("hide-info")  // Unhides the bookings section
    this.tab_bookingTarget.classList.add("active")  // Highlights the bookings tab

    // Hide other content sections and deactivate their tabs
    this.listingTarget.classList.add("hide-info") // Hides the listings section
    this.tab_listingTarget.classList.remove("active") // Removes highlight from listings tab
    this.received_listingTarget.classList.add("hide-info")  // Hides received listings section
    this.tab_received_listingTarget.classList.remove("active")  // Removes highlight from received
  }
    // Method to display the listings content and highlight the tab
  display_listings(event) {
    event.preventDefault()
    // Show the listings content and activate the listings tab
    this.listingTarget.classList.remove("hide-info")  // Unhides the listings section
    this.tab_listingTarget.classList.add("active")  // Highlights the listings tab

    // Hide other content sections and deactivate their tabs
    this.bookingTarget.classList.add("hide-info") // Hides the bookings section
    this.tab_bookingTarget.classList.remove("active") // Removes highlight from bookings tab

    this.received_listingTarget.classList.add("hide-info")  // Hides received listings section
    this.tab_received_listingTarget.classList.remove("active")  // Removes highlight from received listings tab
  }
  // Method to display the received listings content and highlight the tab
  display_received_listings(event) {
    event.preventDefault()
    // Show the received listings content and activate the received listings tab
    this.received_listingTarget.classList.remove("hide-info") // Unhides received listings section
    this.tab_received_listingTarget.classList.add("active") // Highlights the received listings tab

    // Hide other content sections and deactivate their tabs
    this.bookingTarget.classList.add("hide-info") // Hides the bookings section
    this.tab_bookingTarget.classList.remove("active") // Removes highlight from bookings tab
    this.listingTarget.classList.add("hide-info") // Hides the listings section
    this.tab_listingTarget.classList.remove("active") // Removes highlight from listings tab
  }

}