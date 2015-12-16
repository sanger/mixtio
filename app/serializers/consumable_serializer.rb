require_relative "consumable/batch_serializer"
require_relative "consumable/consumable_type_serializer"
require_relative "consumable/lot_serializer"

class ConsumableSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :name, :depleted

  has_one :batch, serializer: Consumable::BatchSerializer

  has_one :lot, serializer: Consumable::LotSerializer

  has_one :consumable_type, serializer: Consumable::ConsumableTypeSerializer

  def lot
    object.batch.lot
  end

  def consumable_type
    lot.consumable_type
  end

end
