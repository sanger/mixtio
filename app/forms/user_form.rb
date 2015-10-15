class UserForm

  include FormObject

  set_attributes :login, :swipe_card_id, :barcode, :team_id, :status
  
end