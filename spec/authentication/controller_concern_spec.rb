require "rails_helper"

RSpec.describe Authentication::ControllerConcern, type: :controller do

  test_routes = Proc.new do
    get '/anonymous' => 'anonymous#index'
  end
  Rails.application.routes.send(:eval_block, test_routes)

  class AnonymousController < ActionController::Base

   include Authentication::ControllerConcern

   before_filter :authenticate!

    def session
      @session ||= {}
    end

    def index
      render text: "success!"
    end

  end

  let(:controller)  { AnonymousController.new }

  before(:each) do
    allow(Authentication::Ldap).to receive(:authenticate).with("user1", "password").and_return(true)
    allow(Authentication::Ldap).to receive(:authenticate).with("user1", "badpassword").and_return(false)
  end

  it "should be able to authenticate the user" do
    expect(controller.authenticate?("user1", "password")).to be_truthy
    expect(controller.authenticate?("user1", "badpassword")).to be_falsey
  end

  it "should be able to check if the user is signed in" do
    controller.authenticate?("user1", "password")
    expect(controller.current_user).to be_signed_in
    expect(controller.current_user.name).to eq("user1")
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