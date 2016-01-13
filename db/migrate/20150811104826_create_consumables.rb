class CreateConsumables < ActiveRecord::Migration
  def change
    create_table :consumables do |t|
      t.belongs_to :batch, index: true, foreign_key: true

      t.timestamps null: false
      t.string :name
      t.string :barcode
      t.boolean :depleted, default: false
    end
  end
end
