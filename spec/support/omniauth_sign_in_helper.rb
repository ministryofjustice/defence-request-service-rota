module OmniauthSignInHelper
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:defence_request] = OmniAuth::AuthHash.new({
    provider: "defence_request",
    uid: "123456789",
    info: {
      email: "test_user@example.com",
      profile: {
        name: "Example user",
      }
    },
    credentials: {
      token: "ABCDEF...",
    }
  })
end

RSpec.configure { |config| config.include OmniauthSignInHelper }
