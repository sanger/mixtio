require 'rails_helper'

RSpec.describe Unit, type: :model do
  it "can be valid" do
    expect(build(:unit)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:unit, name: "")).not_to be_valid
    expect(build(:unit, name: nil)).not_to be_valid
  end

  it "is invalid without a unique name" do
    create(:unit, name: 'handful')
    expect(build(:unit, name: 'handful')).not_to be_valid
  end
end
