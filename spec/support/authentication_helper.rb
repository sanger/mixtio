module AuthenticationHelper

  def test_user
    @test_user ||= create(:user)
  end

  def sign_in
    allow(Authentication::Ldap).to receive(:authenticate).and_return(true)
    visit sign_in_path
    fill_in "Username", with: test_user.username
    fill_in "Password", with: "password"
    click_button "Sign In"
  end

  def sign_in_request
    allow(Authentication::Ldap).to receive(:authenticate).and_return(true)
    post '/sessions', :username => test_user.username, :password => 'password'
  end
end