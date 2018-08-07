class AddQuantityToMixture < ActiveRecord::Migration[5.2]
  def change
    add_column :mixtures, :quantity, :int
    add_reference :mixtures, :unit, index: true, foreign_key: true
  end
end
