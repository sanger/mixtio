class Consumable < ActiveRecord::Base

  include HasOrderByName
  include HasVolume

  belongs_to :batch

  validates :batch, presence: true
  validates :volume, allow_nil: true,  numericality: {greater_than: 0}

  after_create :generate_barcode

  private

  def generate_barcode
    update_column(:barcode, Barcode.create(self))
  end

end