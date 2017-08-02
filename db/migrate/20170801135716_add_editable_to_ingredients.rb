class AddEditableToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :editable, :boolean, default: true
  end
end
