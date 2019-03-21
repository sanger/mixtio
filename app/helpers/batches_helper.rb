module BatchesHelper

  def supplier_with_product_code(ingredient)
    text = ingredient.kitchen.name
    text += " (#{ingredient.kitchen.product_code})" if ingredient.kitchen.product_code?
    text
  end

end
