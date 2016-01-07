class CreateRecipeIngredients < ActiveRecord::Migration
  def change
    create_table :recipe_ingredients do |t|
      t.string :consumable_type_id
      t.string :ingredient_id

      t.timestamps null: false
    end
  end
end
