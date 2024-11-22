class ListingsController < ApplicationController
   # Skips authentication for non-logged-in users accessing `index` or `show` actions
  skip_before_action :authenticate_user!, only: %i[index show ]
  # Sets a specific listing instance before actions: `show`, `edit`, `update`, `destroy`
  before_action :set_listing, only: %i[show edit update destroy]

    # Displays listings
  def index
    @listings = policy_scope(Listing) # Fetches listings scoped by Pundit
    # Filters listings based on search parameters
    if params[:name].present? && params[:address].present?
      # Search by name and description, then filter by proximity to the given address
      @listings = @listings.search_by_name_and_description(params[:name])
      @listings = @listings.near(params[:address], 150) # Listings within 150 km
    elsif params[:name].present?
      # Search by name only
      @listings = @listings.search_by_name_and_description(params[:name])
    elsif params[:address].present?
      # Filter by proximity to the given address
      @listings = @listings.near(params[:address], 150)
    end
    # Prepares markers for geocoded listings to display on a map
    @markers = @listings.geocoded.map do |listing|
      {
        lat: listing.latitude,
        lng: listing.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { listing: listing }),
        marker_html: render_to_string(partial: "marker", locals: { listing: listing })
      }
    end
  end

  # Displays a specific listing
  def show
    authorize @listing  # Ensures user is authorized to view the listing
    # @reviews_average = @listing.review.rating
  end

    # Displays the form to create a new listing
  def new
    @listing = Listing.new
    authorize @listing  # Ensures user is authorized to create a listing
  end

    # Handles the creation of a new listing
  def create
    @listing = Listing.new(listing_params)  # Initializes a listing with form parameters
    @listing.user = current_user  # Associates the listing with the current user
    authorize @listing  # Ensures user is authorized to create a listing
    # Attempts to save the listing
    if @listing.save
      redirect_to @listing, notice: "Listing was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

    # Displays the form to edit an existing listing
  def edit
    authorize @listing  # Ensures user is authorized to edit the listing
  end

     # Handles updates to an existing listing
  def update
    authorize @listing  # Ensures user is authorized to update the listing
    # Attempts to update the listing
    if @listing.update(listing_params)
      redirect_to @listing, notice: "Listing was successfully edited."
    else
      render :new, status: :unprocessable_entity
    end
  end

    # Deletes an existing listing
  def destroy
    authorize @listing  # Ensures user is authorized to delete the listing
    @listing.destroy
    flash[:success] = "The item was successfully destroyed."
    redirect_to listings_path, status: :see_other # Redirects to the listings index page
  end

private
   # Finds the listing by its ID for actions that require it
  def set_listing
    @listing = Listing.find(params[:id])
  end

    #Permits only the listed attributes for a listing
  def listing_params
    params.require(:listing).permit(
      :listing_name, :listing_address, :photo, :listing_amenities, :listing_description, photos: []
    )
  end
end
