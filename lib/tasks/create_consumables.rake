Dir[File.join(Rails.root,"lib","consumable_creator","*.rb")].each { |f| require f }

namespace :consumables do

  desc "create some consumables"
  task :create => :environment do |t|
    consumable_creator = ConsumableCreator.new(YAML.load_file(File.expand_path(File.join(Rails.root,"lib","consumable_creator","data.yml"))))
    consumable_creator.run!
  end
  
end