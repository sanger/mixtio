class UserForm
  include ActiveModel::Model

  validate :check_user

  attr_reader :user

  ATTRIBUTES = [:login, :swipe_card_id, :barcode, :team_id, :status, :type]
  delegate *ATTRIBUTES, :id, :becomes, to: :user

  def self.model_name
    ActiveModel::Name.new(User, nil, nil)
  end

  def initialize(user = User.new)
    @user = user
  end

  def submit(params)
    user.attributes = remove_password_fields(params)[:user].slice(*ATTRIBUTES).permit!
    if valid?
      user.save
    else
      false
    end
  end

  def persisted?
    user.id?
  end

private

  def check_user
    unless user.valid?
      user.errors.each do |key, value|
        errors.add key, value
      end
    end
  end

  def remove_password_fields(params)
    return params unless persisted?
    params.tap do |p|
      [:swipe_card_id, :barcode].each do |field|
        p[:user] = p[:user].slice!(field) unless p[:user][field].present?
      end
    end
  end
end