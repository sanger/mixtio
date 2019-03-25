class CreateKitchen < ActiveRecord::Migration[4.2]
  def change
    create_table :kitchens do |t|
      t.string :name
      t.string :type
    end
  end
end
