require "rails_helper"

RSpec.describe "Authentication", type: :feature do

  it "should sign in a user with a valid username and password" do
    allow(Authentication::Ldap).to receive(:authenticate).and_return(true)
    visit root_path
    click_link "Sign In"
    fill_in "Username", with: "user1"
    fill_in "Password", with: "password"
    click_button "Sign In"
    expect(page).to have_content("Signed In Successfully")
    expect(page).to have_content("You are signed in as user1")
  end

  it "should not sign in a user without a valid password" do
    allow(Authentication::Ldap).to receive(:authenticate).and_return(false)
    visit root_path
    click_link "Sign In"
    fill_in "Username", with: "user1"
    fill_in "Password", with: "badpassword"
    click_button "Sign In"
    expect(page).to have_content("Invalid username or password")
    expect(page).to have_content("You are not currently signed in")

  end

  it "should allow a user to sign out" do
    sign_in
    click_link "Sign Out"
    expect(page).to have_content("Signed Out Successfully")
  end

  it "should redirect user back to referrer after signing in" do
    allow(Authentication::Ldap).to receive(:authenticate).and_return(true)
    visit "/anonymous"
    fill_in "Username", with: "user1"
    fill_in "Password", with: "password"
    click_button "Sign In"
    expect(current_path).to eq("/anonymous")
  end

end