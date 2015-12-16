class LotSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :name, :consumable_type_id, :supplier_id

end
