class AddLastLabelIdCol < ActiveRecord::Migration
  def change
    add_column :consumable_types, :last_label_id, :int
  end
end
