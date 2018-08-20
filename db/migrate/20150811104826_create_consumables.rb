class CreateConsumables < ActiveRecord::Migration[4.2]
  def change
    create_table :consumables do |t|
      t.belongs_to :batch, index: true, foreign_key: true

      t.timestamps null: false
      t.string :barcode
      t.boolean :depleted, default: false
      t.decimal :volume, precision: 10, scale: 3
      t.integer :unit
    end
  end
end
