class ConsumableType < ActiveRecord::Base

  include Activatable
  include Auditable
  include HasOrderByName
  include Mixable

  belongs_to :team, optional: false

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

  def prefill_data
    {
      ingredients: mixture_criteria,
      sub_batch_unit: batches&.last&.sub_batches&.first&.unit,
    }
  end

  def latest_lot
    lots.last
  end

  def self.find_user_favourites(user)
    ConsumableType.joins(:favourites).where(favourites: {user_id: user.id}).order(:name)
  end

end
