class AddUserToIngredients < ActiveRecord::Migration
  def change
    add_reference :ingredients, :user, index: true, foreign_key: true
  end
end
