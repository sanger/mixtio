class CreateConsumableTypes < ActiveRecord::Migration
  def change
    create_table :consumable_types do |t|
      t.string :name
      t.integer :days_to_keep

      t.timestamps null: false
    end
  end
end
