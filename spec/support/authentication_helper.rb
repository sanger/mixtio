module AuthenticationHelper

  def sign_in
    allow(Authentication::Ldap).to receive(:authenticate).and_return(true)
    visit sign_in_path
    fill_in "Username", with: "user1"
    fill_in "Password", with: "password"
    click_button "Sign In"
  end
end