class AddActiveToProjectsKitchensAndConsumableTypes < ActiveRecord::Migration[5.0]
  def change
    [ :projects, :kitchens, :consumable_types].each do |table|
      add_column table, :active, :boolean, null: false, default: true
    end
  end
end
