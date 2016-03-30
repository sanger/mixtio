class Consumable < ActiveRecord::Base

  include HasOrderByName
  include HasVolume

  belongs_to :batch
  belongs_to :consumable_type

  validates :batch, :volume, :unit, presence: true
  validates :volume, numericality: {greater_than: 0}

  after_create :generate_barcode

  private

  def generate_barcode
    update_column(:barcode, Barcode.create(self))
  end

end