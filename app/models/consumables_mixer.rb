class ConsumablesMixer

  def self.mix(args)
    ConsumablesMixer.new(args).mix
  end

  def initialize(parents: [], consumable: Consumable.new, limit: 1)
    @parents = parents
    @consumable = consumable
    @limit = limit
  end

  def mix
    (1..limit).collect do |n|
      Consumable.create(attributes).add_parents(parents)
    end
  end

  private

  attr_reader :parents, :consumable, :limit

  def attributes
    if parents.instance_of? Array
      consumable.attributes
    else
      parents.attributes.except('id', 'barcode').merge(consumable.attributes.select {|k,v| v.present?})
    end
  end

end