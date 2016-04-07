Dir[File.join(Rails.root, "lib", "consumables", "*.rb")].each { |f| require f }

namespace :consumables do
  desc "create some consumables"
  task :create => :environment do |t|
    consumable_creator = ConsumableCreator.new(
        params: YAML.load_file(File.expand_path(File.join(Rails.root, "lib", "consumables", "test_data.yml"))),
        consumables: true
    )
    consumable_creator.run!
  end

  desc "destroy all consumables, types, and suppliers"
  task destroy: :environment do |t|
    consumables_destroyer = ConsumableDestroyer.new
    consumables_destroyer.run!
  end

  desc "load in the initial production types without consumables"
  task load: :environment do |t|
    consumable_creator = ConsumableCreator.new(
        params: YAML.load_file(File.expand_path(File.join(Rails.root, "lib", "consumables", "initial_data.yml"))),
        consumables: false
    )
    consumable_creator.run!
  end

end