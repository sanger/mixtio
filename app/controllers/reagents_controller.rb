class ReagentsController < ApplicationController

  before_action :reagents, only: [:index]

  def index
  end

  def new
    @reagent = Reagent.new
  end

  def create
    @reagent = Reagent.new(reagent_params)
    if @reagent.save
      redirect_to reagents_path, notice: "Reagent successfully created"
    else
      render :new
    end
  end

  def edit
    @reagent = current_resource
  end

  def update
    @reagent = current_resource
    if @reagent.update_attributes(reagent_params)
      redirect_to reagents_path, notice: "Reagent successfully updated"
    else
      render :edit
    end
  end

  protected

  def reagent_params
    params.require(:reagent).permit(:name, :expiry_date, :lot_number, :arrival_date, :supplier, :reagent_type_id)
  end

  def current_resource
    @current_resource = Reagent.find(params[:id]) if params[:id]
  end

  def reagents
    @reagents ||= Reagent.all
  end

  helper_method :reagents

end
