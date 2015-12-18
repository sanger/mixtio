module AuthenticationHelper
  def sign_in(user = nil)
    current_user = user || create(:user)
    allow(Authentication::Ldap).to receive(:authenticate).and_return(true)
    visit sign_in_path
    fill_in "Username", with: current_user.username 
    fill_in "Password", with: "password"
    click_button "Sign In"
  end
end