class Mixtio.Views.SubBatches extends Backbone.View

  initialize: () ->
    @collection.on('reset', () => @render())
    @collection.on('add', () => @add())

  render: () ->
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
