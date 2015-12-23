require "rails_helper"

RSpec.describe Authentication::ControllerConcern, type: :controller do

  let!(:user)       { create(:user) }
  let(:controller)  { AnonymousController.new }

  before(:each) do
    allow(Authentication::Ldap).to receive(:authenticate).with(user.username, "password").and_return(true)
    allow(Authentication::Ldap).to receive(:authenticate).with(user.username, "badpassword").and_return(false)
  end

  it "should be able to authenticate the user" do
    expect(controller.authenticate?(user.username, "password")).to be_truthy
    expect(controller.authenticate?(user.username, "badpassword")).to be_falsey
  end

  it "should be able to check if the user is signed in" do
    controller.authenticate?(user.username, "password")
    expect(controller.current_user).to be_signed_in
    expect(controller.current_user.username).to eq(user.username)
    expect(controller.signed_in?).to be_truthy
  end

  it "should be able to sign a user out" do
    controller.authenticate?(user.username, "password")
    controller.sign_out!
    expect(controller.session[:username]).to be_nil
    expect(controller.current_user).to_not be_signed_in
  end

  it "should redirect to sign in path if not authenticated" do
    @controller = AnonymousController.new
    get :index
    expect(response).to be_redirect

    @controller = AnonymousController.new
    allow(@controller.current_user).to receive(:signed_in?).and_return(true)
    get :index
    expect(response).to be_success
  end

end