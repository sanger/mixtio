class LotSerializer < ActiveModel::Serializer

  attributes :id, :number

  has_one :consumable_type
  has_one :kitchen

end
