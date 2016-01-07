class SupplierSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :name

end
