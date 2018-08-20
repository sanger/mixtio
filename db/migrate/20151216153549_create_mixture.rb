class CreateMixture < ActiveRecord::Migration[4.2]
  def change
    create_table :mixtures do |t|
      t.belongs_to :batch, index: true
      t.belongs_to :ingredient, index: true
      t.timestamps null: false
    end
  end
end
