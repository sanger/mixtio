require "rails_helper"

RSpec.describe HasAncestry, type: :model do

  with_model :CakeMix do
    table do |t|
      t.string :name
    end

    model do
      include HasAncestry
    end
  end

  child_cake_mix = lambda { |n| CakeMix.create(name: "Child Model #{n}") }

  let!(:model) { CakeMix.create(name: "Test Model") }
  let!(:ancestors) { (1..3).collect { |n| child_cake_mix.call(n) } }
  let!(:different_ancestors) { (1..3).collect { |n| child_cake_mix.call(n) } }

  it "should have children" do
    expect(model.add_children(ancestors)).to eq(model)
    expect(model.children).to eq(ancestors)
    expect(ancestors.all? {|child| child.parents.include?(model)}).to be_truthy
  end

  it "should have parents" do
    expect(model.add_parents(ancestors)).to eq(model)
    expect(model.parents).to eq(ancestors)
    expect(ancestors.all? {|parent| parent.children.include?(model)}).to be_truthy

    expect(model.parent_ids).to eq([ancestors.first.id, ancestors[1].id, ancestors.last.id])

    model.parent_ids = "10,11,12"

    expect(model.parent_ids).to eq([10,11,12])
  end

  it "should be able to delete parents" do
    model.add_parents(ancestors)
    expect(model.delete_parents).to eq(model)
    expect(model.parents).to be_empty
  end

  it "should be able to set new parents" do
    model.add_parents(ancestors)
    expect(model.parents).to eq(ancestors)
    expect(model.set_parents(different_ancestors)).to eq(model)
    expect(model.parents).to eq(different_ancestors)
  end

end