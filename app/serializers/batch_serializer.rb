class BatchSerializer < ActiveModel::Serializer

  attributes :number, :created_at, :expiry_date, :volume, :unit

  has_one :consumable_type
  has_one :kitchen
  has_one :user

  has_many :ingredients
  has_many :consumables

end
