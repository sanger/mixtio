class Mixtio.Views.Ingredient extends Backbone.View

  tagName: 'tr'

  events:
    'change select[name*="consumable_type_id"]': 'clear'
    'click a[data-behavior~=remove_row]': 'close'

  initialize: (options) ->
    @consumableTypes = options.consumableTypes
    @kitchens        = options.kitchens

    @on("render", () => @setSubviews())

  setSubviews: () ->
    @consumableTypeSelect = @$el.find('select[name*="consumable_type_id"]')
    @kitchenSelect        = @$el.find('select[name*="kitchen_id"]')

  render: () ->
    @$el.html(JST['batches/ingredient'](
      ingredient: @model
      consumableTypes: @consumableTypes
      kitchens: @kitchens
    ))

    @trigger("render")
    this

  clear: () ->
    @model.clear()
    @model.set("consumable_type", id: @consumableTypeSelect.val())
    @render()

  close: (e) ->
    e.preventDefault()
    @$el.fadeOut(400, () =>
      @el.remove()
      @collection.remove(@model)
    )