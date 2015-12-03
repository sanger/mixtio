class TeamsController < ApplicationController

  before_action :teams, only: [:index]

  def index
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to teams_path, notice: "Team successfully created"
    else
      render :new
    end
  end

  def edit
    @team = current_resource
  end

  def update
    @team = current_resource
    if @team.update_attributes(team_params)
      redirect_to teams_path, notice: "Team successfully updated"
    else
      render :edit
    end
  end

protected

  def teams
    @teams ||= Team.all
  end

  def current_resource
    @current_resource ||= Team.find(params[:id]) if params[:id]
  end

  def team_params
    params.require(:team).permit(:name, :number)
  end

  helper_method :teams
end
