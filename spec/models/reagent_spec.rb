require 'rails_helper'

RSpec.describe Reagent, type: :model do

  it "should not be valid without a name" do
    expect(build(:reagent, name: nil)).to_not be_valid
  end

  it "should not be valid without an expiry date" do
    expect(build(:reagent, expiry_date: nil)).to_not be_valid
  end

  it "should not be valid with an expiry date in the past" do
    reagent = build(:reagent, expiry_date: 1.day.ago)
    expect(reagent).to_not be_valid
    expect(reagent.errors.messages[:expiry_date]).to include(I18n.t('errors.future_date'))
  end

  it "should not be valid without a lot number" do
    expect(build(:reagent, lot_number: nil)).to_not be_valid
  end

  it "should not be valid without a Reagent Type" do
    expect(build(:reagent, reagent_type: nil)).to_not be_valid
    expect(build(:reagent, reagent_type_id: nil)).to_not be_valid
  end

  it "should generate a barcode after creation" do
    reagent = create(:reagent, name: 'My Reagent')
    expect(reagent.barcode).to eq("mx-my-reagent-#{reagent.id}")
  end

end
