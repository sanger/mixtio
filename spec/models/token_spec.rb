require 'rails_helper'

RSpec.describe Token, type: :model do
  it "should create a uuid" do
    expect(create(:token).uuid).to_not be_nil
  end

  it "should be expired if it is older than 30 minutes" do
    expect(create(:token)).to_not be_expired
    expect(create(:token, updated_at: DateTime.now - 1.day)).to be_expired
  end

  it "#generate should create a token and return the uuid" do
    token = Token.generate
    expect(Token.find_by_uuid(token).uuid).to eq(token)
  end

  describe "#get" do

    it "should return a new token if no token is passed" do
      token = Token.get
      expect(Token.find_by_uuid(token).uuid).to eq(token)
    end

    it "should return an updated token if a valid token is passed" do
      token = Token.generate
      expect(Token.find_by_uuid(token).uuid).to eq(token)
      updated_token = Token.get(token)
      expect(updated_token).to_not eq(token)
      expect(Token.find_by_uuid(updated_token).uuid).to eq(updated_token)
    end

    it "should return nothing if the token is invalid" do
      token = SecureRandom.uuid
      expect(Token.get(token)).to be_nil
    end

    it "should return nothing if the token is expired" do
      token = create(:token, updated_at: DateTime.now - 1.day).uuid
      expect(Token.get(token)).to be_nil
    end

  end

end
