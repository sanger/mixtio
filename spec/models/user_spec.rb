require 'rails_helper'

RSpec.describe User, type: :model do
  it "should not be valid without a login" do
    expect(build(:user, login: nil)).to_not be_valid
  end

  it "should be valid without a swipe card Id" do
    expect(build(:user, swipe_card_id: nil)).to be_valid
  end

  it "should allow blank or nil swipe card id" do
    create(:user, swipe_card_id: nil)
    expect(build(:user, swipe_card_id: nil)).to be_valid
  end

  it "should allow blank or nil barcode" do
    create(:user, barcode: nil)
    expect(build(:user, barcode: nil)).to be_valid
  end

  it "should be valid without a barcode" do
    expect(build(:user, barcode: nil)).to be_valid
  end

  it "should not be valid without a unique login" do
    user = create(:user)
    expect(build(:user, login: user.login)).to_not be_valid
  end

  it "should not be valid without a unique swipe card" do
    user = create(:user)
    expect(build(:user, swipe_card_id: user.swipe_card_id)).to_not be_valid
  end

  it "should not be valid without a unique barcode" do
    user = create(:user)
    expect(build(:user, barcode: user.barcode)).to_not be_valid
  end

  it "should not be valid without a team" do
    expect(build(:user, team: nil)).to_not be_valid
  end

  it "should not be valid without a swipe card id or barcode" do
    user = build(:user, swipe_card_id: nil, barcode: nil)
    expect(user).to_not be_valid
    expect(user.errors.full_messages).to include("Swipe card or Barcode must be completed")
  end

end
