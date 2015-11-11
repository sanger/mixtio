class ChangeNumberOfChildrenToAliquotsForConsumables < ActiveRecord::Migration
  def change
    rename_column :consumables, :number_of_children, :aliquots
  end
end
