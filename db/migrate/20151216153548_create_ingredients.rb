class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.belongs_to :consumable_type, index: true, foreign_key: true
      t.belongs_to :kitchen, index: true, foreign_key: true
      t.string :number
      t.string :type
      t.date :expiry_date
      t.timestamps null: false
    end
  end
end
