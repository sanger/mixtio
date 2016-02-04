require 'rails_helper'

RSpec.describe User, type: :model do

  it "should not be valid without a username" do
    expect(build(:user, username: nil)).to_not be_valid
  end

  it "should assign consumable types through favourites correctly" do
    user = create(:user)
    consumable_types = create_list(:consumable_type, 3)

    user.consumable_types = consumable_types

    expect(user.consumable_types).to eq(consumable_types)
  end
end