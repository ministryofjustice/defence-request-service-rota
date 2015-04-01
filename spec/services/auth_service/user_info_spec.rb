require "spec_helper"
require_relative "../../../app/services/auth_service/user_info"

RSpec.describe AuthService::UserInfo, "#get_user_info" do
  it "retrieves user info through the passed in strategy" do
    strategy = double(:strategy).as_null_object

    AuthService::UserInfo.new(strategy).get_user_info

    expect(strategy).to have_received(:raw_info)
  end
end
