require 'rails_helper'

RSpec.describe Consumable, type: :model do

  it "should not be valid without a name" do
    expect(build(:consumable, name: nil)).to_not be_valid
  end

  it "should not be valid without an expiry date" do
    expect(build(:consumable, expiry_date: nil)).to_not be_valid
  end

  it "should not be valid with an expiry date in the past" do
    consumable = build(:consumable, expiry_date: 1.day.ago)
    expect(consumable).to_not be_valid
    expect(consumable.errors.messages[:expiry_date]).to include(I18n.t('errors.future_date'))
  end

  it "should not be valid without a lot number" do
    expect(build(:consumable, lot_number: nil)).to_not be_valid
  end

  it "should not be valid without a consumable Type" do
    expect(build(:consumable, consumable_type: nil)).to_not be_valid
    expect(build(:consumable, consumable_type_id: nil)).to_not be_valid
  end

  it "should generate a barcode after creation" do
    consumable = create(:consumable, name: 'My consumable')
    expect(consumable.barcode).to eq("mx-my-consumable-#{consumable.id}")
  end

end
