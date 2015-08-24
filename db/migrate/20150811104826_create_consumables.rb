class CreateConsumables < ActiveRecord::Migration
  def change
    create_table :consumables do |t|

      t.belongs_to :consumable_type, index: true, foreign_key: true

      t.timestamps null: false
      t.string :name
      t.string :barcode
      t.date :expiry_date
      t.date :arrival_date
      t.boolean :depleted, default: false
      t.string :lot_number
      t.string :supplier
    end
  end
end
