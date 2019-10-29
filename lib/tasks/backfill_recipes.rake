namespace :batches do

  desc "Backfill batches' recipes between 26th July and 23rd August"
  task backfill_recipes: :environment do
    count = 0

    ActiveRecord::Base.transaction do

      batches = Batch.where("created_at BETWEEN ? AND ?", Date.parse("2019-07-26"), Date.parse("2019-08-24"))

      batches.each do |batch|
        next if batch.ingredients.none? { |ing| ing.kitchen.name == "CGAP MEDIA" && ing.kitchen.product_code.nil? }

        batch.ingredients.each do |ingredient|
          next if ingredient.kitchen.name != "CGAP MEDIA"
          ct_mixture = batch.consumable_type.mixtures.find {|mixture| mixture.ingredient.consumable_type_id == ingredient.consumable_type_id }
          ingredient.update_attribute(:kitchen_id, ct_mixture.ingredient.kitchen_id)
        end

        count += 1
      end

    end

    p "#{count} Batches have been updated"
  end

end