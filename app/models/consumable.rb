class Consumable < ActiveRecord::Base

  include HasOrderByName
  include HasVolume

  belongs_to :batch, touch: true
  has_one :consumable_type, through: :batch

  validates :batch, :volume, :unit, presence: true
  validates :volume, numericality: {greater_than: 0}

  after_create :generate_barcode

  private

  def generate_barcode
    if barcode.nil?
      update_column(:barcode, "#{Rails.configuration.barcode_prefix}#{id}")
    end
  end

end
