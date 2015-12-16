class Consumable::BatchSerializer < ActiveModel::Serializer

  attributes :id, :lot_id, :expiry_date, :arrival_date

end
