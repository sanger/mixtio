class ConsumableCreator

  attr_reader :consumables

  def initialize(consumables)
    @consumables = consumables
  end

  def run!
    consumables.each do |k,v|
      create_consumable_type(v)
    end
  end

private

  def create_consumable_type(attributes)
    consumable_type = ConsumableType.create(attributes.except("ingredients"))
    attributes["ingredients"].each do |k,v|
      ingredient = ConsumableType.create(v.slice("name"))
      consumable_type.add_parents(ingredient)
      create_consumables(v, ingredient)
    end
  end

  def create_consumables(attributes, ingredient)
    (0..2).each do |i|
      Consumable.create(attributes.merge(name: ingredient.name, consumable_type_id: ingredient.id, expiry_date: Date.today+30.days, created_at: Date.today-i.months))
    end
  end

end