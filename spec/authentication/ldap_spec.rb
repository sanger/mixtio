require "rails_helper"

RSpec.describe Authentication::Ldap, type: :model do |variable|
  
  before(:each) do
    Authentication::Ldap.setup do |config|
      config.port = 999
      config.host = "ldap.example.company.co.uk"
      config.dn_attribute = "uid"
      config.prefix = "ou=people" 
      config.dc = ["company","co","uk"]
    end
  end

  it "should provide the correct configuration" do
    ldap = Authentication::Ldap.new("user1")
    expect(ldap.port).to eq(999)
    expect(ldap.host).to eq("ldap.example.company.co.uk")
    expect(ldap.username).to eq("uid=user1,ou=people,dc=company,dc=co,dc=uk")
  end

  it "should authenticate the user" do
    allow_any_instance_of(Net::LDAP).to receive(:bind).and_return(true)
    expect(Authentication::Ldap.authenticate("user1", "password")).to be_truthy

    allow_any_instance_of(Net::LDAP).to receive(:bind).and_return(false)
    expect(Authentication::Ldap.authenticate("user1", "password")).to be_falsey
  end

  it "should allow options to be set through a hash" do
    Authentication::Ldap.setup("port" => 1234, "dn_attribute" => "oh", prefix: "ou=pepper")
    expect(Authentication::Ldap.port).to eq(1234)
    expect(Authentication::Ldap.host).to eq("ldap.example.company.co.uk")
    expect(Authentication::Ldap.dn_attribute).to eq("oh")
    expect(Authentication::Ldap.prefix).to eq("ou=pepper")
  end
end