class Mixtio.Views.SubBatches extends Backbone.View

  initialize: () ->
    #@collection.on('change', () => @render())
    @collection.on('reset', () => @render())
    @collection.on('add', () => @add())


  render: () ->
    @$el.find("tr:gt(0)").remove()

    @collection.each (sub_batch) =>
      subBatchView = new Mixtio.Views.SubBatch(
        collection: @collection
        model: sub_batch
      )
      @$el.append(subBatchView.render().el)

    this

  add: () ->
    subBatchView = new Mixtio.Views.SubBatch(
      collection: @collection
      model: @collection.models[@collection.length - 1]
    )
    @$el.append(subBatchView.render().el)

  update: (sub_batches) ->
    @collection.reset()
    sub_batches.each (sub_batch) =>
      @collection.add(sub_batch)

  setUnit: (unit) ->
    # Don't alter units if the subbatches have numbers in already
    if (unit? and @collection.every (item) => not item.attributes.quantity and not item.attributes.volume)
      @collection.each (item) => item.attributes.unit = unit
      this.render()
