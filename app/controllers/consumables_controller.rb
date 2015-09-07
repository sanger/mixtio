class ConsumablesController < ApplicationController

  before_action :consumables, only: [:index]

  def index
  end

  def new
    @consumable = ConsumableForm.new
  end

  def create
    @consumable = ConsumableForm.new
    if @consumable.submit(params)
      redirect_to consumables_path, notice: "Consumable successfully created"
    else
      render :new
    end
  end

  def edit
    @consumable = ConsumableForm.new(current_resource)
  end

  def update
    @consumable = ConsumableForm.new(current_resource)
    if @consumable.submit(params)
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
    @consumables ||= Consumable.all
  end

  helper_method :consumables

end
