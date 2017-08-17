class AddSubBatchIdToConsumables < ActiveRecord::Migration
  def change
    add_column :consumables, :sub_batch_id, :int
  end
end
