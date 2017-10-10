class Consumable < ActiveRecord::Base

  include HasOrderByName
  include HasVolume

  belongs_to :sub_batch, touch: true
  has_one :consumable_type, through: :sub_batch

  # Allows access the the volume and unit of a consumable, as well as the batch it belongs to
  delegate :batch, :volume, :unit, to: :sub_batch

  after_create :generate_barcode

  # Every consumable must have a sub-batch
  validates :sub_batch, presence: true


  private

    def generate_barcode
      if barcode.nil?
        update_column(:barcode, "#{Rails.configuration.barcode_prefix}#{id}")
      end
    end

end
