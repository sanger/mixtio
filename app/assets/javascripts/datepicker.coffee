$(document).on("turbolinks:load", () ->
  for item in $("[data-behavior~=datepicker]")

    defaults = dateFormat: 'dd/mm/yy'
    params = $.extend({}, defaults, $(item).data('params') || {})

    $(item).datepicker params
)
