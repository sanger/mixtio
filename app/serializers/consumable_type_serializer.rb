class ConsumableTypeSerializer < ActiveModel::Serializer

  attributes :name, :days_to_keep, :storage_condition

end
