require 'rails_helper'

RSpec.describe TeamForm, type: :model do

  let(:team_form) { TeamForm.new }
  let(:attributes) { attributes_for(:team) }

  it "should create a team from valid attributes" do
    expect {
      team_form.submit(ActionController::Parameters.new(team: attributes))
    }.to change(Team, :count).by(1)
  end

  it "should report an error if the attributes are invalid" do
     expect {
      team_form.submit(ActionController::Parameters.new(team: attributes.merge(number: nil)))
    }.to_not change(Team, :count)
    expect(team_form).to_not be_valid
  end

  it "should update an existing team with valid attributes" do
    team = create(:team)
    new_team = build(:team)
    team_form = TeamForm.new(team)

    team_form.submit(ActionController::Parameters.new(team: {'number' => new_team.number}))

    expect(team.reload.number).to eq(new_team.number)
  end

end