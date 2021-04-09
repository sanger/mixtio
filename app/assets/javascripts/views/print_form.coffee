class Mixtio.Views.PrintForm extends Backbone.View

  events:
    'change select[name*="label_type_id"]': 'update'

  initialize: () ->
    @label_type_select = $(@el).find('#label_type_id')
    @printer_select = $(@el).find('#printer')

    @update()

  update: (event) ->
    # Get list of valid printers
    selected_label_type = @label_type_select.val()
    printers = Mixtio.Bootstrap.Printers[selected_label_type] or []

    # Clear current options
    @printer_select.find('option').remove()
    # Add new options
    for printer in printers
      @printer_select[0].add(new Option(printer, printer))
