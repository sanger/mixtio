require "rails_helper"

RSpec.describe "Exceptions notification", type: :request do

  it "should send an email if an error is raised" do
    expect {
      begin
        get test_exception_notifier_path
      rescue
      end
    }.to change(ActionMailer::Base.deliveries, :count).by(1)
  end

end
