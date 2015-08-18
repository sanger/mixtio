class ConsumablesController < ApplicationController

  before_action :consumables, only: [:index]

  def index
  end

  def new
    @consumable = Consumable.new
  end

  def create
    @consumable = Consumable.new(consumable_params)
    if @consumable.save
      redirect_to consumables_path, notice: "Consumable successfully created"
    else
      render :new
    end
  end

  def edit
    @consumable = current_resource
  end

  def update
    @consumable = current_resource
    if @consumable.update_attributes(consumable_params)
      redirect_to consumables_path, notice: "Consumable successfully updated"
    else
      render :edit
    end
  end

  protected

  def consumable_params
    params.require(:consumable).permit(:name, :expiry_date, :lot_number, :arrival_date, :supplier, :consumable_type_id)
  end

  def current_resource
    @current_resource = Consumable.find(params[:id]) if params[:id]
  end

  def consumables
    @consumables ||= Consumable.all
  end

  helper_method :consumables

end
