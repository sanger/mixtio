class SetSubBatchIdTo1 < ActiveRecord::Migration[4.2]
  def change
    Consumable.update_all(sub_batch_id: 1)
  end
end
