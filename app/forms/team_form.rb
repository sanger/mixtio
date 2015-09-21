class TeamForm
  include ActiveModel::Model

   validate :check_team

   attr_reader :team

   ATTRIBUTES = [:name, :number]
   delegate *ATTRIBUTES, :id, to: :team

  def self.model_name
    ActiveModel::Name.new(Team, nil, nil)
  end

  def initialize(team = Team.new)
    @team = team
  end

  def submit(params)
    team.attributes = params[:team].slice(*ATTRIBUTES).permit!
    if valid?
      team.save
    else
      false
    end
  end

  def persisted?
    team.id?
  end

private

  def check_team
    unless team.valid?
      team.errors.each do |key, value|
        errors.add key, value
      end
    end
  end
  
end