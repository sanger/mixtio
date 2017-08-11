$(document).on("turbolinks:load", () ->
  for item in $("[data-behavior~=datepicker]")
    $(item).datepicker
      dateFormat: 'dd/mm/yy'
)
