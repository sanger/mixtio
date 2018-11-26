class AddProductCodeToKitchens < ActiveRecord::Migration[5.2]
  def change
    add_column :kitchens, :product_code, :string
  end
end
