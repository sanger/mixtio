class CreateSubBatches < ActiveRecord::Migration
  def change
    create_table :sub_batches do |t|
      t.float :volume
      t.integer :unit
      t.references :ingredient, index: true, foreign_key: true

      t.timestamps null: false
    end

    Batch.all.each do |batch|
      consumable = Consumable.find_by(batch_id: batch.id)
      sub_batch = SubBatch.create(volume: consumable["volume"], unit: consumable["unit"], ingredient_id: batch.id)

      Consumable.where(batch_id: batch.id).each do |consumable|
        consumable.update_attribute(:sub_batch_id, sub_batch.id)
      end
    end

    # remove_column :consumables, :volume
    # remove_column :consumables, :unit

  end
end
