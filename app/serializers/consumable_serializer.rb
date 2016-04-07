class ConsumableSerializer < ActiveModel::Serializer

  attributes :created_at, :barcode, :volume, :unit, :depleted

  has_one :batch
  has_one :consumable_type

  def consumable_type
    object.batch.consumable_type
  end

end
