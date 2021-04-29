class AddKitchenToConsumableTypes < ActiveRecord::Migration[6.1]
  def up
    add_reference :consumable_types, :team, name: :team_id, type: :integer, null: true, foreign_key: { to_table: :kitchens }
    team = Team.find_by(name: 'CGAP')
    if team
        ConsumableType.update_all(team_id: team.id)
    end
    change_column_null :consumable_types, :team_id, false
  end

  def down
    remove_reference :consumable_types, :team
  end
end
