class ConsumableTypeSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :name, :days_to_keep, :expiry_date_from_today, :ingredients, :latest_ingredients

end
