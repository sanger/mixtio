require 'rails_helper'

RSpec.describe UserForm, type: :model do

  let(:user_form) { UserForm.new }
  let!(:team) { create(:team) }
  let(:attributes) { attributes_for(:user) }
  let(:valid_attributes) { attributes.merge('team_id' => team.id) }

  it "should create a user from valid attributes" do
    expect {
      user_form.submit(ActionController::Parameters.new(user: valid_attributes))
    }.to change(User, :count).by(1)
  end

  it "should report an error if the attributes are invalid" do
     expect {
      user_form.submit(ActionController::Parameters.new(user: attributes))
    }.to_not change(User, :count)
    expect(user_form).to_not be_valid
  end

  it "should update an existing user with valid attributes" do
    user = create(:user)
    new_user = build(:user)
    user_form = UserForm.new(user)

    user_form.submit(ActionController::Parameters.new(user: user.attributes.merge('login' => new_user.login)))

    expect(user.reload.login).to eq(new_user.login)
  end

end