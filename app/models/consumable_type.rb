class ConsumableType < ActiveRecord::Base

  include Auditable
  include HasOrderByName

  has_many :ingredients

  has_many :recipes
  has_many :recipe_ingredients, :through => :recipes

  has_many :favourites
  has_many :users, :through => :favourites

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates_numericality_of :days_to_keep, greater_than: 0, if: Proc.new { |ct| ct.days_to_keep.present? }

  enum freezer_temperature: {
    "37°C": 0,
    "RT": 1,
    "+4°C": 2,
    "-20°C": 3,
    "-80°C": 4,
    "LN2": 5
  }

  def simple_freezer_temperature
    freezer_temperature.gsub('°', '')
  end

  # TODO: Remove this
  def latest_ingredients
    return unless recipe_ingredients
    recipe_ingredients.map do |recipe_ingredient|
      Ingredient.where("consumable_type_id = ?", recipe_ingredient.id)
        .order(created_at: :desc)
        .first
    end
  end

  def self.find_user_favourites(user)
    ConsumableType.joins(:favourites).where(favourites: { user_id: user.id }).order(:name)
  end

end