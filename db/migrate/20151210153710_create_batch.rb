class CreateBatch < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.belongs_to :lot, index: true, foreign_key: true
      t.date :expiry_date
      t.date :arrival_date

      t.timestamps null: false
    end
  end
end
