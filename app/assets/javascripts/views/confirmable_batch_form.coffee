class Mixtio.Views.ConfirmableBatchForm extends Backbone.View

  events:
    'submit': 'onSubmit'

  initialize: (options) ->
    # Our 2 collections
    @currentIngredients = options.currentIngredients
    @currentRecipe      = options.currentRecipe

    # Append the (hidden) modal to the form
    @$el.append(JST["batches/confirm_modal"]())

    # Find any DOM elements we're interested in
    @setSubViews()

    # Listen for certain events on the modal
    @modalEvents()

    # Setup other useful attributes
    @initialSubmitText  = @$submitButton.val();
    @hadConfirmation    = false

  setSubViews: () ->
    @$submitButton      = $('input[type="submit"]', @$el)
    @$confirmModal      = $('#confirmModal')
    @$modalSubmitButton = $('button.btn-primary', @$confirmModal)

  modalEvents: () ->
    # Re-enable the form submit button if user closes the modal
    @$confirmModal.on('hidden.bs.modal', () => @enableSubmitButton())

    # Set hadConfirmation to true and re-submit the form if user clicks 'Continue'
    @$modalSubmitButton.on('click', () =>
      @hadConfirmation = true
      @$el.submit()
    )

  onSubmit: (e) ->
    @disableSubmitButton()

    if (@divergedFromRecipe() && !@hadConfirmation)
      e.preventDefault()
      @$confirmModal.modal('show')

  disableSubmitButton: () ->
    @$submitButton.prop({ disabled: true });
    @$submitButton.val('Saving...');

  divergedFromRecipe: () ->
    !@currentIngredients.equalTo(@currentRecipe)

  enableSubmitButton: () ->
    @$submitButton.prop({ disabled: false });
    @$submitButton.val(@initialSubmitText);