class Ingredient < ActiveRecord::Base
  belongs_to :consumable_type
  belongs_to :ingredient, class_name: "ConsumableType"
end
