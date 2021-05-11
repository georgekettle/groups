class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_session_navigation

private

  def set_session_navigation
    session[:navigation] = params[:navigation] if params[:navigation]
  end
end
