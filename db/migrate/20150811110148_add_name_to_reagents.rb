class AddNameToReagents < ActiveRecord::Migration
  def change
    add_column :reagents, :name, :string
  end
end
