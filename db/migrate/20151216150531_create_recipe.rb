class CreateRecipe < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer :consumable_type_id
      t.integer :recipe_ingredient_id

      t.timestamps null: false
    end
  end
end
