class Recipe < ActiveRecord::Base
  belongs_to :consumable_type
  belongs_to :recipe_ingredient, class_name: "ConsumableType"
end
