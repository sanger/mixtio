class AddForeignKeyFromConsumableTypesToLabelTypes < ActiveRecord::Migration[4.2]
  def change
    add_foreign_key :consumable_types, :label_types, column: :last_label_id
  end
end
