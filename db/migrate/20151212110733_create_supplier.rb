class CreateSupplier < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
    end
  end
end
