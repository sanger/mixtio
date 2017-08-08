class AddForeignKeyFromConsumableTypesToLabelTypes < ActiveRecord::Migration
  def change
    add_foreign_key :consumable_types, :label_types, column: :last_label_id
  end
end
