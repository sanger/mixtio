class LotSerializer < ActiveModel::Serializer

  attributes :number

  has_one :consumable_type
  has_one :kitchen

end
