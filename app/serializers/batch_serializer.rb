class BatchSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :number, :consumable_type, :kitchen, :user, :created_at, :expiry_date, :ingredients, :consumables, :volume, :unit

  def consumable_type
    consumable_type = object.consumable_type
    { id: consumable_type.id, uri: scope.api_v1_consumable_type_url(consumable_type) }
  end

  def kitchen
    kitchen = object.kitchen
    { id: kitchen.id, type: kitchen.type, name: kitchen.name }
  end

  def user
    user = object.user
    { id: user.id, username: user.username }
  end

  def consumables
    consumables = object.consumables
    consumables.map { |consumable| { id: consumable.id, barcode: consumable.barcode, uri: scope.api_v1_consumable_url(consumable) } }
  end

  def ingredients
    ingredients = object.ingredients
    ingredients.map { |ingredient| { id: ingredient.id, number: ingredient.number, uri: scope.api_v1_ingredient_url(ingredient) } }
  end

end
