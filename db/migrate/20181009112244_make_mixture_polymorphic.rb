class MakeMixturePolymorphic < ActiveRecord::Migration[5.2]
  def change
    rename_column :mixtures, :batch_id, :mixable_id
    add_column :mixtures, :mixable_type, :string

    Mixture.update_all(mixable_type: 'Batch')
  end
end
