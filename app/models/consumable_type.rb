class ConsumableType < ActiveRecord::Base

  include HasOrderByName

  has_many :consumables
  has_many :lots

  has_many :recipes, :class_name => "Ingredient"
  has_many :ingredients, :through => :recipes

  has_many :inverse_recipe, :class_name => "Ingredient", :foreign_key => "ingredient_id"
  has_many :ingredient_of, :through => :inverse_recipe, :source => :consumable_type

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates_numericality_of :days_to_keep, greater_than: 0, if: Proc.new { |ct| ct.days_to_keep.present? }

  def expiry_date_from_today
    Date.today.advance(days: days_to_keep).to_s(:uk) if days_to_keep.present?
  end

  def latest_ingredients
    return unless ingredients
    ingredients.map{ |ingredient| Lot.where("consumable_type_id = ?", ingredient.id).order(:created_at).first }
  end

end