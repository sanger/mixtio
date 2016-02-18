class Mixtio.Views.ScanConsumable extends Backbone.View

  events:
    "keydown input": "scan"

  initialize: () ->
    @input     = @$el.find('input')
    @helpBlock = @$el.find('.help-block')

    @on('scan', @findAndAddIngredient)

  scan: (e) ->
    @trigger 'keydown'
    return unless e.keyCode is 9 or e.keyCode is 13 # Tab or Return
    return if @input.val() is ""
    e.preventDefault()
    @trigger 'scan', @input.val()
    @input.val('')

  findAndAddIngredient: (barcode) ->
    new Mixtio.Collections.Consumables()
      .fetch(
        data: {barcode: barcode}
        success: (collection) =>
          if collection.length is 0
            @addError(JST['batches/consumable_not_found'](barcode: barcode))
            return

          collection.at(0)
            .batch()
            .fetch(
              success: (model) =>
                # Don't add the Ingredient if it's already in there
                if @collection.where(id: model.id).length is 0
                  @collection.add(model)
                else
                  @addError(JST['batches/ingredient_already_added'](batch: model))
            )
      )

  addError: (error) ->
    @helpBlock.html(error)
    @$el.addClass('has-error')
    @once('keydown', @removeError)

  removeError: () ->
    @helpBlock.html('')
    @$el.removeClass('has-error')



