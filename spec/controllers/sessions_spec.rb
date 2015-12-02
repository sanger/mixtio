require "rails_helper"

RSpec.describe SessionsController, type: :request do |variable|
  
  describe 'signing in' do

    let!(:user) { create(:administrator) }
    
    it "should be successful if the correct credentials are provided" do
      allow(Ldap).to receive(:authenticate).with(user.username, "goodpassword").and_return(true)
      post sessions_path, user: { username: user.username, password: "goodpassword"}
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Signed In Successfully")
      token = response.headers['X-Auth-Token'].to_s
      expect(Token.find_by_uuid(token)).to_not be_nil
    end

    it "should be unsuccessful if incorrect credentials are provided" do
      allow(Ldap).to receive(:authenticate).with(user.username, "badpassword").and_return(false)
      post sessions_path, user: { username: user.username, password: "badpassword"}
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Invalid Credentials")
      expect(request.headers['Authorization']).to be_nil
    end
  end

  describe 'signing out' do
    

  end


end