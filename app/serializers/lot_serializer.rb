class LotSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :name, :consumable_type, :supplier

  def consumable_type
    consumable_type = object.consumable_type
    { id: consumable_type.id, uri: scope.api_v1_consumable_type_url(consumable_type) }
  end

  def supplier
    supplier = object.supplier
    { id: supplier.id, uri: scope.api_v1_supplier_url(supplier) }
  end

end
