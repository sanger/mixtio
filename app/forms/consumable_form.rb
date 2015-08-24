class ConsumableForm
  include ActiveModel::Model

  validate :check_consumable

  ATTRIBUTES = [:name, :expiry_date, :lot_number, :arrival_date, :supplier, :consumable_type_id, :parent_ids]
  delegate *ATTRIBUTES, to: :consumable

  def submit(params)
    consumable.attributes = params[:consumable].slice(*ATTRIBUTES).permit!
    if valid?
      @consumables = consumable.save_or_mix(params[:consumable][:limit] || 1)
    else
      false
    end
  end

  def consumable
    @consumable ||= Consumable.new
  end

  def consumables
    @consumables ||= []
  end

  private

  def check_consumable
    unless consumable.valid?
      consumable.errors.each do |key, value|
        errors.add key, value
      end
    end
  end
end