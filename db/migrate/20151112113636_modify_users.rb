class ModifyUsers < ActiveRecord::Migration
  def change
    rename_column :users, :login, :username
    remove_column :users, :swipe_card_id
    remove_column :users, :barcode
  end
end
