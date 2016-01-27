class ConsumableSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :depleted

  has_one :batch

  has_one :lot

  has_one :consumable_type

  def batch
    batch = object.batch
    {
      id: batch.id,
      uri: scope.api_v1_batch_url(batch)
    }
  end

  def lot
    lot = object.batch.lot
    {
      id: lot.id,
      name: lot.name,
      uri: scope.api_v1_lot_url(lot)
    }
  end

  def consumable_type
    consumable_type = object.batch.lot.consumable_type
    {
      id: consumable_type.id,
      name: consumable_type.name,
      uri: scope.api_v1_consumable_type_url(consumable_type)
    }
  end

end
