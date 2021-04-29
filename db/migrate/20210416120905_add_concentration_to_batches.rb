class AddConcentrationToBatches < ActiveRecord::Migration[6.1]
  def change
    add_column :ingredients, :concentration, :float
    add_column :ingredients, :concentration_unit, :string
  end
end
