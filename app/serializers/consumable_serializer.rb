class ConsumableSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :depleted, :barcode

  has_one :batch

  has_one :consumable_type

  def batch
    batch = object.batch
    {
      id: batch.id,
      uri: scope.api_v1_batch_url(batch)
    }
  end

  def consumable_type
    consumable_type = object.batch.consumable_type
    {
      id: consumable_type.id,
      name: consumable_type.name,
      uri: scope.api_v1_consumable_type_url(consumable_type)
    }
  end

end
