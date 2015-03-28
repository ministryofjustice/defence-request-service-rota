class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  protected

  def authenticate_user!
    redirect_to '/auth/defence_request' unless current_user
  end

  def current_user 
    @current_user ||= fetch_current_user
  end

  def access_token
    session[:user_token]
  end

  #
  # Fetch the current users details from the Auth app
  # As we load the current user each request any changes are applied without needing to logout/login again
  # TODO: this may need to be cached at some point
  #
  # If access_token is not in session, or it is invalid then return nil
  #
  def fetch_current_user
    return nil unless access_token

    strat = OmniAuth::Strategies::DefenceRequest.new nil, Settings.authentication.application_id, Settings.authentication.application_secret

    strat.access_token = OAuth2::AccessToken.new strat.client, access_token

    User.new strat.raw_info

    rescue OAuth2::Error
      session.clear
      nil
  end
end
