class ConsumableTypesController < ApplicationController

  before_action :consumable_types, only: [:index]

  def index
  end

  def create
    @consumable_type = ConsumableType.new(consumable_type_params)
    if @consumable_type.save
      redirect_to consumable_types_path, notice: "Consumable type successfully created"
    else
      render :new
    end
  end

  def new
    @consumable_type = ConsumableType.new
  end

  def edit
    @consumable_type = current_resource
  end

  def update
    @consumable_type = current_resource
    if @consumable_type.update_attributes(consumable_type_params)
      redirect_to consumable_types_path, notice: "Consumable type successfully updated"
    else
      render :edit
    end
  end


protected

  def consumable_types
    @consumable_types ||= ConsumableType.all
  end

  def consumable_type_params
    params.require(:consumable_type).permit(:name)
  end

  def current_resource
    @current_resource ||= ConsumableType.find(params[:id]) if params[:id]
  end

  helper_method :consumable_types

end
