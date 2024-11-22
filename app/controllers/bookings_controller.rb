class BookingsController < ApplicationController
  # Runs the `set_listing` method before `new` and `create` actions
  before_action :set_listing, only: %i[new create]

  # Display the booking form
  def new
    @booking = Booking.new  # Initializes a new booking object
    authorize @booking  # Pundit authorization to ensure the user can create a booking
  end

  # Create a new booking
  def create
    @booking = Booking.new(booking_params)  # Initializes a booking with form parameters
    @booking.user = current_user  # Associates the booking with the currently logged-in user
    authorize @booking  # Pundit authorization to ensure user can perform this action
    @booking.listing = @listing # Associates the booking with the current listing
    # Attempts to save the booking
    if @booking.save
      # Redirects to the dashboard with a success message if the booking is saved
      redirect_to dashboard_path, notice: "Booking was successfully created."
    else
      # Re-renders the booking form with a 422 status code if saving fails
      render :new, status: :unprocessable_entity
    end
  end

  private
  # Finds the listing associated with the booking using the `listing_id` parameter
  def set_listing
    @listing = Listing.find(params[:listing_id])
  end
  # Permits only the `start_date` and `end_date` fields for a booking
  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
