class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!
end
