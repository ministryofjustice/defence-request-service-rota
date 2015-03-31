class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    session[:user_token] = auth_hash['credentials']['token']
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end