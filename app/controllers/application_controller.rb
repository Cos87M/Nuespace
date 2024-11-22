class ApplicationController < ActionController::Base
  # Runs methods before controller action
  before_action :configure_permitted_parameters, if: :devise_controller?  # Devise customization
  before_action :authenticate_user! # Ensures a user is logged in before accessing any action

  # Includes Pundit's authorization methods to manage access control
  include Pundit::Authorization

  # Configure additional parameters for Devise sign-up and account update forms
  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :address] )

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :address] )
  end

  # Pundit: allow-list approach
  after_action :verify_authorized, except: :index, unless: :skip_pundit?  # Verifies policy for all actions except `index`
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit? # Verifies scope usage for `index` actions

   # Handles cases where a user is not authorized to perform an action
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  # Method to handle unauthorized access
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)  # Redirects the user to the home page
  end

  # Determines if Pundit checks should be skipped
  def skip_pundit?
    # Skips Pundit for Devise controllers, Rails Admin, or Pages controllers
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
