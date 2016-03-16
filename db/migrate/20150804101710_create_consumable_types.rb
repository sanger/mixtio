class CreateConsumableTypes < ActiveRecord::Migration
  def change
    create_table :consumable_types do |t|
      t.string :name
      t.integer :days_to_keep
      t.integer :storage_condition, default: 0

      t.timestamps null: false
    end
  end
end
