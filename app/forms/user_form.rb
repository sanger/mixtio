class UserForm

  include FormObject

  set_attributes :username, :team_id, :status, :type

  delegate :becomes, to: :user
  
end