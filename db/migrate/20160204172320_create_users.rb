class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :username
      t.belongs_to :team, index: true
      t.timestamps null: false
    end
  end
end
