require 'rails_helper'

RSpec.describe ConsumableType, type: :model do

  it "should not be valid without a name" do
    expect(build(:consumable_type, name: nil)).to_not be_valid
  end

  it "should not be valid without a unique name" do
    consumable_type = create(:consumable_type)
    expect(build(:consumable_type, name: consumable_type.name)).to_not be_valid
  end

  it "should not be valid without a number greater than zero" do
    expect(build(:consumable_type, days_to_keep: 0)).to_not be_valid
    expect(build(:consumable_type, days_to_keep: 'abc')).to_not be_valid
    expect(build(:consumable_type, days_to_keep: '')).to be_valid
  end

  it "should give the expiry date from today" do
    consumable_type = build(:consumable_type, days_to_keep: nil)
    expect(consumable_type.expiry_date_from_today).to be_nil

    consumable_type = build(:consumable_type)
    expect(consumable_type.expiry_date_from_today).to eq(consumable_type.days_to_keep.days_from_today)
  end

end
