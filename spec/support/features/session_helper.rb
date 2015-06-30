module SessionHelpers
  def login_with(user)
    visit "/users/sign_in"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password

    click_button "Sign in"
  end

  def stub_current_user_with(user)
    mock_profile(
      options: {
        uid: user.uid,
        name: user.name,
        email: user.email,
        organisations: user.organisations
      }
    )
  end

  def sign_out
    click_link("Sign out")
  end
end
