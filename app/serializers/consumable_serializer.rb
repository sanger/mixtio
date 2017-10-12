class ConsumableSerializer < ActiveModel::Serializer

  attributes :id, :created_at, :barcode, :depleted, :unit, :volume

  has_one :batch
  has_one :consumable_type

  def consumable_type
    object.batch.consumable_type
  end

  def volume
    object.sub_batch.volume.to_s
  end

  def unit
    object.sub_batch.unit
  end
end
