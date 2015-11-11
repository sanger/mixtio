class ConsumableSerializer < ActiveModel::Serializer

  self.root = false
  
  attributes :id, :name, :expiry_date, :arrival_date, :depleted, :lot_number, :supplier, :batch_number

end
