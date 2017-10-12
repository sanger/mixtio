class CreateSubBatches < ActiveRecord::Migration
  def change
    create_table :sub_batches do |t|
      t.float :volume
      t.integer :unit
      t.references :ingredients, index: true, foreign_key: true

      t.timestamps null: false
    end

    Batch.all.each do |batch|
      sub_batch = SubBatch.create(volume: batch.consumables.first.volume, unit: batch.consumables.first.unit, ingredients_id: batch.id)
      batch.consumables.each do |consumable|
        consumable.update_attribute(:sub_batch_id, sub_batch.id)
      end
    end

    remove_column :consumables, :volume
    remove_column :consumables, :unit

  end
end
