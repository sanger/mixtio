class CreateKitchen < ActiveRecord::Migration
  def change
    create_table :kitchens do |t|
      t.string :name
      t.string :type
    end
  end
end
