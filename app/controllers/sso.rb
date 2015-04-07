module SSO
  module ControllerMethods
    def current_user
      @current_user ||= fetch_current_user
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
      build_user

    rescue OAuth2::Error
      session.clear
      nil
    end

    def build_user
      User.build_from(AuthService::UserInfo.new(strategy).get_user_info)
    end

    def strategy
      AuthService::Strategy.new(
        access_token,
        AuthService::TokenBuilder.new
      ).with_token
    end
  end
end
