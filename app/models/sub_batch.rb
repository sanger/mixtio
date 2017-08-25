class SubBatch < ActiveRecord::Base

  # following line causing batch volume calculation to fail as unit becomes e.g "mL" instead of -3
  include HasVolume

  has_many :consumables

  belongs_to :batch, foreign_key: "ingredients_id"

  validates :volume, presence: true
  validates :unit, presence: true

  # Returns a boolean indicating whether the current sub-batch consumables have the same barcode
  def single_barcode?
    if consumables.count == 0
      return false
    end
    consumables.first.barcode == consumables.last.barcode
  end

  # Returns an integer of the number of consumables belonging to the sub-batch
  def quantity
    consumables.size
  end

  # Returns the total volume of the sub-batch, as decimal or as string with unit symbol
  def total_volume(with_unit)
    if with_unit
      (quantity * volume.to_d).to_s + unit
    else
      quantity * volume.to_d
    end
  end

end
