class ConsumableForm

  include FormObject

  set_attributes :name, :expiry_date, :lot_number, :arrival_date, :supplier, :consumable_type_id, :parent_ids, :aliquots

  after_validate do
    @consumables = consumable.save_or_mix
  end

  def consumables
    @consumables ||= []
  end

end