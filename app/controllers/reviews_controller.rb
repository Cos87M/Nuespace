class ReviewsController < ApplicationController
  # Displays the review form for a booking
  def new
    # Finds the booking associated with the review by using the booking_id from the params
    @booking = Booking.find(params[:booking_id])
    # Creates a new review instance and associates it with the found booking
    @review = Review.new
    @review.booking = @booking
    # Authorizes the review action using Pundit
    authorize @review
  end
  # Creates a new review for a booking
  def create
     # Creates a new review with the parameters submitted in the form
    @review = Review.new(review_params)
    # Finds the booking associated with the review 
    @booking = Booking.find(params[:booking_id]) 
    # Associates the review with the current booking and listing considering logged-in user
    @review.booking = @booking
    @review.user = current_user
    @review.booking.listing
    # Ensures the review creation is authorized using Pundit
    authorize @booking
    # Saves the review and redirects to the listing page of the reviewed booking if successful
    if @review.save
      redirect_to listing_path(@review.booking.listing), notice: "Review was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Displays the list of reviews
  def show
    # Retrieves all reviews using Pundit to apply any policies for the user's access
    @review = policy_scope(Review)
  end

  # # The destroy action
  # def destroy
  #   @review = Review.find(params[:id])
  #   @review.destroy
  #   flash[:success] = "The item was successfully destroyed."
  #   redirect_to listing_path(params[:listing_id]), status: :see_other
  # end

  private
  # Permit only the necessary attributes for creating a review
  def review_params
    params.require(:review).permit(:comment, :rating)
  end
end
