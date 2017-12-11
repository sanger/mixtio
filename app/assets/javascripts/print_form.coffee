$(document).on("turbolinks:load", () ->
  for item in $("form[data-behavior~=print_form]")
    # Create Views
    printFormView = new Mixtio.Views.PrintForm(
      el: $(item)
    )
    printFormView.render()
)
