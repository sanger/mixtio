class AddEditableToIngredients < ActiveRecord::Migration[4.2]
  def change
    add_column :ingredients, :editable, :boolean, default: true
  end
end
