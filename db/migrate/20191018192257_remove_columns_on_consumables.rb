class RemoveColumnsOnConsumables < ActiveRecord::Migration[5.2]
  def change
    remove_columns :consumables, :batch_id, :volume, :unit
  end
end
