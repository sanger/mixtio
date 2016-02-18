require 'rails_helper'

RSpec.describe Ingredient, type: :model do

  it "is not valid without a Consumable Type" do
    expect(build(:ingredient, consumable_type: nil)).to_not be_valid
  end

  it "is not valid without a Kitchen" do
    expect(build(:ingredient, kitchen: nil)).to_not be_valid
  end

end
