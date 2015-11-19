class Token < ActiveRecord::Base

  has_secure_token :uuid

  def expired?
    updated_at < DateTime.now - 30.minutes
  end

  def current?
    !expired?
  end

  def self.generate
    create.uuid
  end

  def regenerate
    regenerate_uuid
    uuid
  end

  def self.get(token = nil)
    return Token.generate unless token
    token = Token.find_by_uuid(token)
    return unless token 
    return unless token.current?
    token.regenerate
  end

end
