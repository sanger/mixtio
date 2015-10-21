class @Model

  constructor: (attrs) ->
    @_set_attributes(attrs || {})

  id_attribute: 'id'

  base_uri: '/api/v1',

  id: () ->
    @get @id_attribute

  get: (name) ->
    @attributes[name]

  set: (name, value) ->
    @attributes[name] = value

  fetch: () ->
    url = [@base_uri, @endpoint, @id()].join('/')
    $.get(url).then((response) => @parse(response))

  parse: (response) ->
    @_set_attributes(response)

  _set_attributes: (attrs) ->
    @attributes = attrs

class @Consumable extends @Model

  endpoint: 'consumables'

  id_attribute: 'barcode'