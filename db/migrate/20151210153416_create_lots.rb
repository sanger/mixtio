class CreateLots < ActiveRecord::Migration
  def change
    create_table :lots do |t|
      t.belongs_to :consumable_type, index: true, foreign_key: true
      t.belongs_to :supplier, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
