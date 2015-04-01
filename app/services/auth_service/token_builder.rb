module AuthService
  class TokenBuilder
    def call(client, access_token)
      OAuth2::AccessToken.new(client, access_token)
    end
  end
end
