class AddProductCodeIndexToKitchen < ActiveRecord::Migration[5.2]
  def change
    add_index :kitchens, :product_code, unique: true
  end
end
