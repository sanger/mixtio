class AddSubBatchIdToConsumables < ActiveRecord::Migration[4.2]
  def change
    add_column :consumables, :sub_batch_id, :int
  end
end
