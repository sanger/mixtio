$ ->
  for item in $("#calculated-batch-volume")

    aliquot_count_input = $('#batch_form_aliquots')
    aliquot_volume_input = $('#batch_form_aliquot_volume')
    aliquot_unit_input = $('#batch_form_aliquot_unit')

    calculate = () ->
      count = aliquot_count_input.val() or 0
      volume = aliquot_volume_input.val() or 0
      unit = aliquot_unit_input.val()

      total_volume = count * volume * 10 ** unit

      # Set precison to 12 to remove floating point errors
      item.value = Math.round(total_volume * 10 ** 12) * 10 ** -12

    aliquot_count_input.change(calculate)
    aliquot_volume_input.change(calculate)
    aliquot_unit_input.change(calculate)
    calculate()