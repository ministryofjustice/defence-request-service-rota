class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :failure]

  def create
    session[:user_token] = auth_hash.fetch(:credentials).fetch(:token)

    redirect_to dashboard_url
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
