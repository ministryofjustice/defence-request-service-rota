module SSO
  module ControllerMethods
    def current_user
      session.fetch(:current_user) { fetch_current_user }
    end

    protected

    def authenticate_user!
      redirect_to "/auth/defence_request" unless current_user
    end

    def access_token
      session[:user_token]
    end

    def fetch_current_user
      return nil unless access_token

      User.new AuthService::UserInfo.new(strategy).get_user_info

    rescue OAuth2::Error
      session.clear
      nil
    end

    def strategy
      AuthService::Strategy.new(
        access_token,
        AuthService::TokenBuilder.new
      ).with_token
    end
  end
end
