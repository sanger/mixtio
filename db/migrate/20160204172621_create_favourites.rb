class CreateFavourites < ActiveRecord::Migration[4.2]
  def change
    create_table :favourites do |t|
      t.references :user, index: true, foreign_key: true
      t.references :consumable_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
