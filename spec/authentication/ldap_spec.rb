require "rails_helper"

RSpec.describe Authentication::Ldap, type: :model do |variable|
  
  before(:each) do
    Authentication::Ldap.setup(port: 999, 
      host: "ldap.example.company.co.uk",
      dn_attribute: "oh",
      prefix: "ou=pepper",
      dc:["company","co","uk"],
      sangerbomarea: "Scientific Operations"
    )
  end

  it "should provide the correct configuration" do
    ldap = Authentication::Ldap.new("user1")
    expect(ldap.settings.port).to eq(999)
    expect(ldap.settings.host).to eq("ldap.example.company.co.uk")
    expect(ldap.settings.prefix).to eq("ou=pepper")
    expect(ldap.settings.dc).to eq(["company","co","uk"])
    expect(ldap.settings.sangerbomarea).to eq("Scientific Operations")
    expect(ldap.username).to eq("oh=user1,ou=pepper,dc=company,dc=co,dc=uk")
  end

  it "should authenticate the user" do
    allow_any_instance_of(Net::LDAP).to receive(:bind).and_return(true)
    expect(Authentication::Ldap.authenticate("user1", "password")).to be_truthy

    allow_any_instance_of(Net::LDAP).to receive(:bind).and_return(false)
    expect(Authentication::Ldap.authenticate("user1", "password")).to be_falsey
  end

end