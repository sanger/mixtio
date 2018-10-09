namespace :recipes do

  desc "Update the recipes of all Consumable Types with their respective latest Batch's ingredients"
  task update: :environment do
    ActiveRecord::Base.transaction do
      ConsumableType.all.includes(:batches).each do |consumable_type|
        # Find the latest Batch
        latest_batch = consumable_type.batches.last

        # Do nothing if ConsumableType has not had any Batches created
        next if latest_batch.nil?

        # Destroy its current Mixtures
        consumable_type.mixtures.destroy_all

        # Duplicate the Mixture but without the id and timestamps
        # https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-dup
        consumable_type.mixtures = latest_batch.mixtures.map(&:dup)
      end
    end
  end

end