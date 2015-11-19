class PasswordStrategy < ::Warden::Strategies::Base
  def valid?
    return false if request.get?
    user_data = params.fetch("user", {})
    !(user_data["username"].blank? || user_data["password"].blank?)
  end

  def authenticate!
    user = params["user"]
    unless User.authenticate(user["username"], user["password"])
      fail! message: "strategies.password.failed"
    else
      success! User.find_by_username(user["username"])
    end
  end
end

Warden::Strategies.add(:password, PasswordStrategy)