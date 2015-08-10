class ReagentTypesController < ApplicationController

  before_action :reagent_types, only: [:index]
  
  def index
  end

  def create
    @reagent_type = ReagentType.new(reagent_type_params)
    if @reagent_type.save
      redirect_to reagent_types_path, notice: "Reagent type successfully created"
    else
      render :new
    end
  end

  def new
    @reagent_type = ReagentType.new
  end

  def edit
    @reagent_type = current_resource
  end

  def update
    @reagent_type = current_resource
    if @reagent_type.update_attributes(reagent_type_params)
      redirect_to reagent_types_path, notice: "Reagent type successfully updated"
    else
      render :edit
    end
  end


protected

  def reagent_types
    @reagent_types ||= ReagentType.all
  end

  def reagent_type_params
    params.require(:reagent_type).permit(:name)
  end

  def current_resource
    @current_resource ||= ReagentType.find(params[:id]) if params[:id]
  end

  helper_method :reagent_types

end
