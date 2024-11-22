import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

// Connects to data-controller="address-autocomplete"
export default class extends Controller {
  static values = { api: String }  // Allows passing the Mapbox API key as a value
  static targets = ["address"]    // Defines the `address` target for DOM manipulation

  connect() {
    // Initializing the MapboxGeocoder instance with API key and options
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiValue, // Uses the API key passed as a value
      types: "country,region,place,postcode"    // Limits search to specific location types
    })
    console.log(this.geocoder)    // Debugging message to log the geocoder instance
    this.geocoder.addTo(this.element)   // Adding the geocoder widget to the DOM element 

    // Listening for the "result" event and setting the input value accordingly
    this.geocoder.on("result", event => this.#setInputValue(event))   
    // Listening for the "clear" event to reset the input value
    this.geocoder.on("clear", () => this.#clearInputValue())
  }
  // Called when the controller is disconnected from the DOM
  disconnect() {
    this.geocoder.onRemove()  // Removes the geocoder instance from the DOM
  }
  // Sets the value of the address target when a result is selected
  #setInputValue(event) {
    this.addressTarget.value = event.result["place_name"] // Assigns the place name to the target input
  }
  // Clears the value of the address target when the geocoder is cleared
  #clearInputValue() {
    this.addressTarget.value = "" // Resets the input value to an empty string
  }
}
