class ConsumableType < ActiveRecord::Base

  include Activatable
  include Auditable
  include HasOrderByName

  has_many :batches
  has_many :lots
  has_many :favourites
  has_many :users, through: :favourites

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :days_to_keep, numericality: {greater_than_or_equal_to: 0}, allow_blank: true

  enum storage_condition: {
      "37°C":  0,
      "RT":    1,
      "+4°C":  2,
      "-20°C": 3,
      "-80°C": 4,
      "LN2":   5
  }

  def latest_batch
    batches.last
  end

  def latest_ingredients
    latest_batch&.ingredients || []
  end

  def ingredients_prefill
    latest_batch&.mixtures&.map do |mixture|
      ing = mixture.ingredient
      type = ing.consumable_type
      latest_lot = type.latest_lot
      {
        consumable_type_id: type.id,
        number: latest_lot&.number,
        kitchen_id: latest_lot&.kitchen_id,
        quantity: mixture.quantity,
        unit_id: mixture.unit_id,
      }
    end || []
  end

  def latest_lot
    lots.last
  end

  def self.find_user_favourites(user)
    ConsumableType.joins(:favourites).where(favourites: {user_id: user.id}).order(:name)
  end

end