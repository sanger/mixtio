class SubBatch < ActiveRecord::Base
  include HasVolume

  has_many :consumables

  belongs_to :batch, foreign_key: "ingredient_id", touch: true
  belongs_to :project

  validates :volume, presence: true
  validates :project, presence: true
  validates :unit, presence: true

  after_touch :touch_batch

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

  private

    def touch_batch
      batch.touch
    end

end
