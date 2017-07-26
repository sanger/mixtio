class Mixtio.Views.Consumables extends Backbone.View

  initialize: () ->
    @setSubViews()
    @updateBatchVolume()

  setSubViews: () ->
    @aliquotsEl = $('#batch_form_aliquots')
    @aliquotVolumeEl = $('#batch_form_aliquot_volume')
    @aliquotUnitEl = $('#batch_form_aliquot_unit')
    @batchVolumeEl = $('#calculated_batch_volume')

    self = @
    @aliquotsEl.change(() -> self.updateBatchVolume.apply(self))
    @aliquotVolumeEl.change(() -> self.updateBatchVolume.apply(self))
    @aliquotUnitEl.change(() -> self.updateBatchVolume.apply(self))

  update: (model) ->
    @model = model

    @aliquotsEl.val(null)
    @aliquotVolumeEl.val(null)

    consumables = @model?.get('latest_batch')?.consumables
    if consumables? and consumables.length > 0
      consumable = consumables[0]
      @aliquotsEl.val(consumables.length)
      @aliquotVolumeEl.val(consumable.volume)
      @aliquotUnitEl.find('option').filter((index, element) -> element.text == consumable.unit).attr('selected', 'selected')

    @updateBatchVolume()

  updateBatchVolume: () ->
    count = @aliquotsEl.val() or 0
    volume = @aliquotVolumeEl.val() or 0
    unit = @aliquotUnitEl.val()

    total_volume = count * volume * 10 ** unit

    # Set precison to remove some floating point errors
    precision = 12
    #scaled_volume = Math.round(total_volume * (10 ** precision)) * (10 ** -precision)
    scaled_volume = Math.round(total_volume * 10**precision) / (10**precision)

    @batchVolumeEl.val(scaled_volume)
