require "rails_helper"

RSpec.describe Authentication, type: :controller do

  class AnonymousController < ApplicationController
    include Authentication
    def session
      @session ||= {}
    end
  end

  let(:controller)  { AnonymousController.new }
  let!(:user)       { create(:user) }

  before(:each) do
    allow(Ldap).to receive(:authenticate).with(user.username, "password").and_return(true)
    allow(Ldap).to receive(:authenticate).with(user.username, "badpassword").and_return(false)
  end

  it "should be able to authenticate the user" do
    expect(controller.authenticate?(user.username, "password")).to be_truthy
    expect(controller.authenticate?(user.username, "badpassword")).to be_falsey
  end

  it "should be able to check if the user is signed in" do
    controller.authenticate?(user.username, "password")
    expect(controller.current_user).to be_signed_in
    expect(controller.signed_in?).to be_truthy
  end

  it "should be able to sign a user out" do
    controller.authenticate?(user.username, "password")
    controller.sign_out!
    expect(controller.session[:username]).to be_nil
    expect(controller.current_user).to_not be_signed_in
  end

end