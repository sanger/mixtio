class BatchSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :number, :consumable_type, :kitchen, :expiry_date, :ingredients, :consumables, :volume

  def consumable_type
    consumable_type = object.consumable_type
    { id: consumable_type.id, uri: scope.api_v1_consumable_type_url(consumable_type) }
  end

  def kitchen
    kitchen = object.kitchen
    { id: kitchen.id, type: kitchen.type, name: kitchen.name }
  end

end
