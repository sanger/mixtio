class SubBatch < ActiveRecord::Base
  include HasVolume

  # How the consumables get barcoded. Either per aliquot, or with a single barcode
  attr_accessor :barcode_type

  # Quantity is the number of consumables that are to be created.
  # Its value is used in the build_consumables callback
  attr_accessor :quantity

  has_many :consumables, dependent: :destroy

  belongs_to :batch, foreign_key: "ingredient_id", touch: true, inverse_of: :sub_batches
  belongs_to :project, optional: false

  has_one :consumable_type, through: :batch

  validates :volume, :unit, presence: true
  validates :volume, numericality: { greater_than: 0 }

  # Quantity is only needed for new SubBatches to create the required number of Consumables
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }, if: -> { new_record? }

  # SubBatch will build the consumables itself based on the quantity, as long as
  # it does not already have consumables
  before_save :build_consumables, if: -> { new_record? }

  # TODO Change barcode_type to some sort of enum
  # Set the Consumables' barcodes to all be the same if the barcode_type is "single"
  after_create :unify_consumables_barcodes, if: -> { barcode_type == "single" }

  delegate :size, to: :consumables

  # Returns a boolean indicating whether the current sub-batch consumables have the same barcode
  def single_barcode?
    consumables.map(&:barcode).uniq.size == 1
  end

  # Returns the total volume of the sub-batch, as decimal or as string with unit symbol
  def total_volume(with_unit)
    if with_unit
      (size * volume.to_d).to_s + unit
    else
      size * volume.to_d
    end
  end

private

  def build_consumables
    consumables.build(Array.new(quantity.to_i, {}))
  end

  def unify_consumables_barcodes
    consumables.update(barcode: consumables.first.barcode)
  end

end
