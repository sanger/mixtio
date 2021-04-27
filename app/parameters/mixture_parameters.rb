# Class to encapsulate the parameters needed to create a new Mixture
#
class MixtureParameters
  include ActiveModel::Model

  attr_accessor :consumable_type_id, :number, :kitchen_id, :unit_id, :quantity

  validates :consumable_type_id, :kitchen_id, presence: true
  validates :unit_id, presence: true, unless: -> { !quantity.present? }
  validates :quantity, presence: true, unless: -> { !unit_id.present? }
  validates :quantity, numericality: { greater_than: 0 }, allow_blank: true

  validate do
    if Team.exists?(kitchen_id) && !Batch.exists?(number: number, kitchen_id: kitchen_id)
      errors.add(:ingredient, "with number #{number} could not be found")
    end
  end

end
