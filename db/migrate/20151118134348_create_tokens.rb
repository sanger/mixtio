class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :uuid
      t.timestamps null: false
    end
    add_index :tokens, :uuid
  end
end