class ConsumableCreator

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def run!
    cts = params["consumable_types"].map { |consumable_type| create_consumable_type(consumable_type) }

    params["suppliers"].each { |supplier| create_supplier(supplier) }

    params["lots"].each do |lot|
      lot = create_lot(lot)
    end

    Team.create!(name: "TEST TEAM")

    cts.each { |consumable_type| create_batch(consumable_type) }
  end

  private

  def create_consumable_type(consumable_type)
    ConsumableType.create(name: consumable_type["name"], days_to_keep: consumable_type["days_to_keep"])
  end

  def create_supplier(supplier)
    Supplier.create!(name: supplier["name"])
  end

  def create_lot(lot)
    Lot.create(number: lot["number"],
               consumable_type: ConsumableType.find_by!(name: lot["consumable_type"]),
               kitchen: Supplier.find_by!(name: lot["supplier"]))
  end

  def create_batch(consumable_type)
    batch = consumable_type.batches.create!(
        expiry_date: Date.today.advance(days: consumable_type.days_to_keep).to_s(:uk),
        kitchen: Team.find_by!(name: "TEST TEAM")
    )
    recipe_ingredients = params["consumable_types"].select { |item| item['name'] == consumable_type.name }[0]["recipe_ingredients"]
    if recipe_ingredients
      recipe_ingredients.each do |recipe_ingredient|
        batch.ingredients << Lot.find_by(consumable_type: ConsumableType.find_by(name: recipe_ingredient))
      end
    end

    batch.consumables.create!(Array.new(rand(1..10), {volume: (1..100).step(0.1).to_a.sample, unit: Consumable.units.to_a.sample[0]}))
  end

end