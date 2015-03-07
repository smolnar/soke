module AuthenticationHelper
  def login_as(user, password: nil)
    visit new_user_session_path

    fill_in 'email', with: user.email
    fill_in 'password', with: password || user.password

    click_button 'Sign me in!'
  end
end
