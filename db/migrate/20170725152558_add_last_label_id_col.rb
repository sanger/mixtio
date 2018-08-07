class AddLastLabelIdCol < ActiveRecord::Migration[4.2]
  def change
    add_column :consumable_types, :last_label_id, :int
  end
end
