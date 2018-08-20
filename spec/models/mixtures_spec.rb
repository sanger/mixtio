require 'rails_helper'

RSpec.describe Mixture, type: :model do

  let(:unit) { create(:unit) }
  let(:ingredient) { create(:ingredient) }
  let(:batch) { create(:batch) }

  it "can have a unit and quantity" do
    expect(build(:mixture, ingredient: ingredient, batch: batch, quantity: 20, unit: unit)).to be_valid
  end

  it "can have no unit nor quantity" do
    expect(build(:mixture, ingredient: ingredient, batch: batch)).to be_valid
  end

end
