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