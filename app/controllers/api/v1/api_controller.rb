class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!
  before_action :authenticate_client!

  def authenticate_client!
    unauthorized! unless access_token && valid_access_token?
  end

  private
  def access_token
    if request.headers["Authorization"]
      request.headers["Authorization"].scan(/^Bearer ([0-9a-f]+)/).first.try(:first)
    end
  end

  def valid_access_token?
    (HTTParty.get(
      Settings.authentication.token_info_uri,
      headers: { "Authorization" => "Bearer #{access_token}" }
    )).code == 200
  end

  def unauthorized!
    render json: {
      errors: [
        "Not authorized, please provide a valid client token"
      ]
    }, status: :unauthorized
  end
end
