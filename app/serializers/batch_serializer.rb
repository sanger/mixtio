class BatchSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :lot_id, :expiry_date, :arrival_date, :ingredients, :consumables

end
