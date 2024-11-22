import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String, // API key for authenticating with Mapbox
    markers: Array  // Array of marker data (coordinates)
  }

  connect() {
    // console.log("hello from controller")
    mapboxgl.accessToken = this.apiKeyValue   // Setting the Mapbox access token using the API key passed as a value

    // Initializing the Mapbox map instance
    this.map = new mapboxgl.Map({
      container: this.element,  // The element to render the map in
      style: "mapbox://styles/vivian423/clfaz5bsd00i701moxw3co0ff"  // Custom Mapbox style URL
    })
    // Adding markers to the map and fitting the map to include all markers
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }
  // Adds markers to the map
  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      // Creating a popup for the marker using the provided HTML
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      // Creating a custom marker element using the provided HTML
      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html
      // Adding the custom marker to the map at the specified coordinates
      new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])  // Marker coordinates
        .setPopup(popup)    // Associating the popup with the marker
        .addTo(this.map)    // Adding the marker to the map instance
    })
  }
  //  Adjusts the map's bounds to fit all markers
  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()  // Initializing bounds for markers
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))  // Extending the bounds to include each marker's coordinates
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })   // Fitting the map to the bounds with padding and zoom constraints
  }
}
