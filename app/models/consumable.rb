class Consumable < ActiveRecord::Base

  belongs_to :sub_batch, optional: false, touch: true
  has_one :consumable_type, through: :sub_batch

  # Allows access the the volume and unit of a consumable, as well as the batch it belongs to
  delegate :batch, :volume, :display_volume, :unit, to: :sub_batch

  after_create :generate_barcode

  def as_json(options)
    super(options.merge(methods: [:volume, :unit]))
  end

private

  def generate_barcode
    update_column(:barcode, "#{Rails.configuration.barcode_prefix}#{id}") if barcode.nil?
  end

end
