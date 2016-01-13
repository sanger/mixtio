class ConsumableCreator

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def run!
    params["consumable_types"].each{ |consumable_type| create_consumable_type(consumable_type) }

    params["suppliers"].each{ |supplier| create_supplier(supplier) }

    params["lots"].each do |lot|
      lot = create_lot(lot)
      batch = lot.batches.create!(expiry_date: rand(1..999).days.from_now, arrival_date: rand(1..30).days.ago)
      batch.consumables.create!()
    end
  end

private

  def create_consumable_type(consumable_type)
    ct = ConsumableType.create(name: consumable_type["name"], days_to_keep: consumable_type["days_to_keep"])
    if consumable_type["ingredients"]
      ct.ingredients = consumable_type["ingredients"].map{ |ingredient| ConsumableType.find_by!(name: ingredient) }
    end
  end

  def create_supplier(supplier)
    Supplier.create(name: supplier["name"])
  end

  def create_lot(lot)
    Lot.create(name: lot["name"],
               consumable_type: ConsumableType.find_by!(name: lot["consumable_type"]),
               supplier: Supplier.find_by!(name: lot["supplier"]))
  end
end