class AddMoreAttrsToReagents < ActiveRecord::Migration
  def change
    add_column :reagents, :expiry_date, :date
    add_column :reagents, :arrival_date, :date
    add_column :reagents, :depleted, :boolean, :default, false
    add_column :reagents, :lot_number, :string
    add_column :reagents, :supplier, :string
  end
end
