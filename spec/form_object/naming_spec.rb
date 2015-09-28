require "rails_helper"

RSpec.describe FormObject::Naming, type: :model do |variable|

  class MyModelForm
  end

  class MyModel
  end
  
  subject { FormObject::Naming.new(MyModelForm) }

  it "should have the correct model name" do
    expect(subject.name).to eq("MyModel")
  end

  it "should have the correct model" do
    expect(subject.model).to eq(MyModel)
  end

  it "should have the correct params key" do
    expect(subject.params_key).to eq(:my_model)
  end

  it "should be able to assign some attributes" do
    subject.add_attributes :a, :b, :c
    expect(subject.attributes).to eq([:a, :b, :c])
  end
end