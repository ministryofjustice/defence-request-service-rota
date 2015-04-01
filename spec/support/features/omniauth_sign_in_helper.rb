module Features
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

  def sign_in_using_dsds_auth
    visit root_path
  end
end
