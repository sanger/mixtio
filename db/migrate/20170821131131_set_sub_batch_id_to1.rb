class SetSubBatchIdTo1 < ActiveRecord::Migration
  def change
    Consumable.update_all(sub_batch_id: 1)
  end
end
