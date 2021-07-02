class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!
  before_action :set_user_sign_in_as_permanent

  # sets highlighted navbar button
  before_action :set_session_navigation

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  private

  def set_user_sign_in_as_permanent
    if user_signed_in?
      cookies.permanent.signed["user_id"] = current_user&.id
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def skip_pundit?
    current_user.try(:admin) || devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def set_session_navigation
    session[:navigation] = params[:navigation] if params[:navigation]
  end
end
