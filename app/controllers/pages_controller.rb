class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home # Skips authentication for the `home` action, allowing non-logged-in users to access it

  # Displays the homepage
  def home
    @listings = Listing.all # Fetches all listings to display on the home page
  end

  # Displays the dashboard for the logged-in user
  def dashboard
    # Fetches listings created by the current user
    @listings = current_user.listings
    # Fetches bookings made by the current user
    @bookings = current_user.bookings
    # Fetches all bookings received by the current user for their listings
    @received_bookings = current_user.listings.map do |listing|
      listing.bookings
    end.flatten # Combines bookings for all the user's listings into a single array
  end
end
