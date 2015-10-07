class AddNumberOfChildrenToConsumables < ActiveRecord::Migration
  def change
    add_column :consumables, :number_of_children, :integer, default: 1
  end
end
