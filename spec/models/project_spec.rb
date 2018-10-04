require 'rails_helper'
require Rails.root.join 'spec/models/concerns/activatable.rb'

RSpec.describe Project, type: :model do
  it "should not be valid without a name" do
    expect(build(:project, name: nil)).to_not be_valid
  end

  it "should not allow duplicate names" do
    project = create(:project)
    expect(build(:project, name: project.name)).to_not be_valid
  end

  it "should not allow duplicate names with differing case" do
    project = create(:project)
    expect(build(:project, name: project.name.upcase)).to_not be_valid
    expect(build(:project, name: project.name.downcase)).to_not be_valid
  end

  it_behaves_like "activatable"
end
