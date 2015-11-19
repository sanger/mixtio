class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def warden
    request.env['warden']
  end

  def authenticate!
    warden.authenticate!
  end
  
end
