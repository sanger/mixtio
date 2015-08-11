class CreateReagents < ActiveRecord::Migration
  def change
    create_table :reagents do |t|

      t.timestamps null: false
    end
  end
end
