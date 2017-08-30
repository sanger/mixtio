class ConsumableCreator

  attr_reader :params

  def initialize(options)
    @params             = options[:params]
    @create_consumables = options[:consumables]
  end

  def run!
    cts = params["consumable_types"].map { |consumable_type| create_consumable_type(consumable_type) }

    params["suppliers"].each { |supplier| create_supplier(supplier) }

    if params['lots']
      params["lots"].each do |lot|
        lot = create_lot(lot)
      end
    end

    if @create_consumables
      @test_team = Team.find_or_create_by!(name: "TEST TEAM")
      @test_user = User.find_or_create_by!(username: 'test', team: @test_team)

      cts.each { |consumable_type| create_batch(consumable_type) }
    end

    params["teams"].each { |team| create_team(team) } if params['teams']
    params["users"].each { |user| create_user(user) } if params['users']
    params["label_types"].each { |label_type| create_label_type(label_type) } if params['label_types']
    params["printers"].each { |printer| create_printer(printer) } if params['printers']
  end

  private

  def create_consumable_type(consumable_type)
    ConsumableType.create!(
        name:              consumable_type["name"],
        days_to_keep:      consumable_type["days_to_keep"],
        storage_condition: consumable_type['storage_conditions']
    )
  end

  def create_supplier(supplier)
    Supplier.create!(name: supplier["name"])
  end

  def create_lot(lot)
    Lot.create!(
        number:          lot["number"],
        consumable_type: ConsumableType.find_by!(name: lot["consumable_type"]),
        kitchen:         Supplier.find_by!(name: lot["supplier"])
    )
  end

  def create_batch(consumable_type)
    batch = consumable_type.batches.create!(
        expiry_date: Date.today.advance(days: consumable_type.days_to_keep),
        kitchen:     @test_team,
        user:        @test_user)

    recipe_ingredients = params["consumable_types"].select { |item| item['name'] == consumable_type.name }[0]["recipe_ingredients"]
    if recipe_ingredients
      recipe_ingredients.each do |recipe_ingredient|
        batch.ingredients << Lot.find_by(consumable_type: ConsumableType.find_by(name: recipe_ingredient))
      end
    end

    batch.sub_batches.create!(volume: (1..100).step(0.1).to_a.sample, unit: Consumable.units.to_a.sample[0])
    batch.sub_batches.first.consumables.create!(Array.new(rand(1..10)))
  end

  def create_team(team)
    Team.create!(
        name: team['name']
    )
  end

  def create_user(user)
    User.create!(
        username: user['username'],
        team:     Team.find_by(name: user['team'])
    )
  end

  def create_label_type(label_type)
    LabelType.create!(
        name:        label_type['name'],
        external_id: label_type['external_id']
    )
  end

  def create_printer(printer)
    Printer.create!(
        name:       printer['name'],
        label_type: LabelType.find_by(name: printer['label_type'])
    )
  end
end
