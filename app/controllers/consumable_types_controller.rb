class ConsumableTypesController < ApplicationController

  before_action :consumable_types, only: [:index]
  before_action :authenticate!, except: [:index]

  def index
  end

  def create
    @consumable_type = ConsumableType.new(consumable_type_params.merge(ingredient_ids: ingredient_id_params))
    if @consumable_type.save
      @consumable_type.create_audit(user: current_user, action: 'create')
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
    if @consumable_type.update_attributes(consumable_type_params.merge(ingredient_ids: ingredient_id_params))
      @consumable_type.create_audit(user: current_user, action: 'update')
      redirect_to consumable_types_path, notice: "Consumable type successfully updated"
    else
      render :edit
    end
  end


protected

  def consumable_types
    @consumable_types ||= ConsumableType.order_by_name.page(params[:page])
  end

  def consumable_type_params
    params.require(:consumable_type).permit(:name, :days_to_keep)
  end

  def ingredient_id_params
    params.require(:ingredient_ids)
  end

  def current_resource
    @current_resource ||= ConsumableType.find(params[:id]) if params[:id]
  end

  helper_method :consumable_types

end
