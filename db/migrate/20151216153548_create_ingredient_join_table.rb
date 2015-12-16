class CreateIngredientJoinTable < ActiveRecord::Migration
  def change
    create_join_table :consumables, :lots do |t|
      # t.index [:consumable_id, :lot_id]
      # t.index [:lot_id, :consumable_id]
    end
  end
end
