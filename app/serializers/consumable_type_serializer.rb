class ConsumableTypeSerializer < ActiveModel::Serializer

  attributes :id, :name, :days_to_keep, :storage_condition

end
