require "rails_helper"

RSpec.describe FormObject, type: :model do |variable|
  
  with_model :MyModel do
    table do |t|
      t.string :name
      t.timestamps null: false
    end

    model do
      validates_presence_of :name
    end
  end

  with_model :AnotherModel do
    table do |t|
      t.string :name
      t.timestamps null: false
    end

    model do
    end
  end

  class MyModelForm
    include FormObject

    set_attributes :name
  end

  class AnotherModelForm
    include FormObject

    set_attributes :name
  end

  it "allows creation of a new record with valid attributes" do
    expect{ 
      MyModelForm.new.submit(ActionController::Parameters.new(my_model: { name: "A name" }))
    }.to change(MyModel, :count).by(1)

    expect{ 
      AnotherModelForm.new.submit(ActionController::Parameters.new(another_model: { name: "A name"}))
    }.to change(AnotherModel, :count).by(1)
  end

  it "prevents creation of record with invalid attributes" do
    my_model_form = MyModelForm.new
    expect{ 
      my_model_form.submit(ActionController::Parameters.new(my_model: { name: nil}))
    }.to_not change(MyModel, :count)
    expect(my_model_form).to_not be_valid
    expect(my_model_form.errors.count).to eq(1)
  end

  it "allows updating of existing record with valid attributes" do
    my_model = MyModel.create(name: "A name")
    my_model_form = MyModelForm.new(my_model)
    expect(my_model_form.id).to eq(my_model.id)
    expect(my_model_form).to be_persisted
    expect{ 
      my_model_form.submit(ActionController::Parameters.new(my_model: { name: "Another name"}))
    }.to change{my_model.reload.name}.to("Another name")
  end

end