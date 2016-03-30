class ConsumableTypeSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :name, :days_to_keep

end
