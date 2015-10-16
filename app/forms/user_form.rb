class UserForm

  include AuthenticationForm

  set_attributes :login, :swipe_card_id, :barcode, :team_id, :status, :type

  delegate :becomes, to: :user
  
end