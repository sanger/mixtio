class @Navigation
  constructor: (item) ->
    @item = $(item)
    @setUp()

  setUp: =>
    @item.find('li ul').hide()
    @item.find('li').hover(
      -> $('ul', this).stop().slideDown(100),
      -> $('ul', this).stop().slideUp(100)
    )

jQuery ->
  for item in $("[data-behavior~=navigation]")
    new Navigation(item)
