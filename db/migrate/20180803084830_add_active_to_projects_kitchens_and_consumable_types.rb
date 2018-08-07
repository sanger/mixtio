class AddActiveToProjectsKitchensAndConsumableTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :active, :boolean, default: true
    add_column :kitchens, :active, :boolean, default: true
    add_column :consumable_types, :active, :boolean, default: true
  end
end
