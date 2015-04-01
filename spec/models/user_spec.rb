require "spec_helper"
require_relative "../../app/models/user"
require "omniauth"

RSpec.describe User, ".build_from" do
  it "builds a user from the auth hash" do
    auth_hash = OmniAuth::AuthHash.new({
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

    user = User.build_from auth_hash

    expect(user.uid).to eq "123456789"
    expect(user.email).to eq "test_user@example.com"
    expect(user.name).to eq "Example user"
  end
end
