class CreateMixtureTable < ActiveRecord::Migration
  def change
    create_table :mixtures do |t|
      t.belongs_to :lot, index: true
      t.belongs_to :batch, index: true
      t.timestamps null: false
    end
  end
end
