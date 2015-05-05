require "rails_helper"

RSpec.feature "User signs in" do
  background { set_data_api_to FakeDataApi }

  scenario "and is redirected to the dashboard" do
    admin_user = create :admin_user
    login_with admin_user

    expect(current_path).to eq "/dashboard"
  end
end
