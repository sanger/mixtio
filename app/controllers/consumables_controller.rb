class ConsumablesController < ApplicationController

  before_action :consumables, only: [:index]
  # before_action :authenticate!, except: [:index]

  def index
  end

  def new
    @consumable = Consumable.new
  end

  def create
    @consumable = Consumable.new(consumable_params)
    if @consumable.valid?
      @consumable.save_or_mix
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
    @consumable.attributes = consumable_params
    if @consumable.valid?
      @consumable.save_or_mix
      redirect_to consumables_path, notice: "Consumable successfully updated"
    else
      render :edit
    end
  end

  protected

  def current_resource
    @current_resource = Consumable.find(params[:id]) if params[:id]
  end

  def consumables
    @consumables ||= Consumable.order_by_name
  end

  def consumable_params
    params.require(:consumable).permit(:name, :expiry_date, :lot_number, :arrival_date, :supplier, :consumable_type_id, :aliquots, ingredients: [:name, :lot_number, :supplier])
  end

  helper_method :consumables

end
