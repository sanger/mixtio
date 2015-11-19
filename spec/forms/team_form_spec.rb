require 'rails_helper'

RSpec.describe TeamForm, type: :model do

  let(:controller_params)           { { controller: "teams", action: "create"} }
  let(:params)                      { ActionController::Parameters.new(controller_params) }
  let(:team_form)                   { TeamForm.new }
  let(:team_params)                 { attributes_for(:team) }

  it "should create a team from valid attributes" do
    expect {
      team_form.submit(params.merge(team: team_params))
    }.to change(Team, :count).by(1)
  end

  it "should report an error if the attributes are invalid" do
     expect {
      team_form.submit(params.merge(team: team_params.merge(number: nil)))
    }.to_not change(Team, :count)
    expect(team_form).to_not be_valid
  end

  it "should update an existing team with valid attributes" do
    team = create(:team)
    new_team = build(:team)
    team_form = TeamForm.new(team)

    team_form.submit(params.merge(team: team_params.merge('number' => new_team.number)))

    expect(team.reload.number).to eq(new_team.number)
  end

end