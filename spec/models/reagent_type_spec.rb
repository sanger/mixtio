require 'rails_helper'

RSpec.describe ReagentType, type: :model do

  it "should not be valid without a name" do
    expect(build(:reagent_type, name: nil)).to_not be_valid
  end

  it "should not be valid without a unique name" do
    reagent_type = create(:reagent_type)
    expect(build(:reagent_type, name: reagent_type.name)).to_not be_valid
  end
end
