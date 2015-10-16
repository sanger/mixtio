require 'rails_helper'

RSpec.describe UserForm, type: :model do

  let(:controller_params)           { { controller: "teams", action: "create"} }
  let(:params)                      { ActionController::Parameters.new(controller_params) }
  let(:user_form)                   { UserForm.new }
  let!(:team)                       { create(:team) }
  let!(:administrator)              { create(:administrator)}
  let(:user_attributes)             { attributes_for(:user).merge('team_id' => team.id, 'current_user' => administrator.swipe_card_id) }

  it "should create a user from valid attributes" do
    expect {
      user_form.submit(params.merge(user: user_attributes))
    }.to change(User, :count).by(1)
  end

  it "should report an error if the attributes are invalid" do
     expect {
      user_form.submit(params.merge(user: user_attributes.except('team_id')))
    }.to_not change(User, :count)
    expect(user_form).to_not be_valid
  end

  it "should update an existing user with valid attributes" do
    user = create(:user)
    new_user = build(:user)
    user_form = UserForm.new(user)

    user_form.submit(params.merge(user: user_attributes.merge('login' => new_user.login)))

    expect(user.reload.login).to eq(new_user.login)
  end

end