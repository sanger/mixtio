require "rails_helper"

RSpec.describe "Authentication", type: :feature do

  let!(:user) { create(:user)}

  it "should sign in a user with a valid username and password" do
    allow_any_instance_of(ApplicationController).to receive(:authenticate?).and_return(true)
    visit sign_in_path
    fill_in "Username", with: user.username
    fill_in "Password", with: "password"
    click_button "Sign In"
    expect(page).to have_content("Signed In Successfully")
  end

  it "should not sign in a user without a valid password" do
    allow_any_instance_of(ApplicationController).to receive(:authenticate?).and_return(false)
    visit sign_in_path
    fill_in "Username", with: user.username
    fill_in "Password", with: "badpassword"
    click_button "Sign In"
    expect(page).to have_content("Invalid username or password")
  end

  it "should not sign in an invalid user" do
    invalid_user = build(:user)
    visit sign_in_path
    fill_in "Username", with: invalid_user.username
    fill_in "Password", with: "password"
    click_button "Sign In"
    expect(page).to have_content("Invalid username or password")
  end

end